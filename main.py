import os
import re
import shutil
import subprocess
import tkinter as tk
from tkinter.scrolledtext import ScrolledText
from pathlib import Path

# Arquivos/pastas protegidas do sistema que devem ser ignoradas
PROTECTED_ITEMS = {
    'com.apple.HomeKit',
    'com.apple.Safari',
    'com.apple.findmy.imagecache',
    'com.apple.findmy.fmfcore',
    'com.apple.findmy.fmipcore',
    'com.apple.containermanagerd',
    'com.apple.homed',
    'com.apple.ap.adprivacyd',
    'FamilyCircle',
    'CloudKit',
}

CLEAN_PATHS = [
    (str(Path.home() / "Library" / "Caches"), False),
    (str(Path.home() / "Library" / "Logs"), False),
    (str(Path.home() / ".Trash"), False),
    ("/Library/Caches", True),
    ("/private/var/folders", True),
]

def run_command(command):
    print(f"[DEBUG] Executando comando: {command}")
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            check=True, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE,
            timeout=30
        )
        print(f"[DEBUG] Comando executado com sucesso: {command}")
        return True
    except subprocess.TimeoutExpired:
        print(f"[ERRO] Timeout ao executar comando: {command}")
        return False
    except subprocess.CalledProcessError as e:
        # Ignorar erros de permissão e arquivos não encontrados
        stderr = e.stderr.decode('utf-8', errors='ignore') if e.stderr else ''
        if 'Operation not permitted' in stderr or 'Permission denied' in stderr:
            print(f"[AVISO] Permissão negada (protegido pelo sistema): {command}")
            return False
        elif 'No such file' in stderr:
            print(f"[AVISO] Arquivo já removido: {command}")
            return True  # Considera sucesso se já foi removido
        else:
            print(f"[ERRO] Falha ao executar comando: {command} - {stderr}")
            return False

def is_protected(item_name):
    """Verifica se o item está na lista de protegidos"""
    return item_name in PROTECTED_ITEMS

def safe_remove(item_path, requires_sudo=False):
    """Remove um arquivo ou diretório de forma segura"""
    if not os.path.exists(item_path):
        return True, "já removido"
    
    try:
        if requires_sudo:
            return run_command(f"sudo rm -rf '{item_path}'"), "sudo"
        else:
            if os.path.isdir(item_path):
                shutil.rmtree(item_path, ignore_errors=True)
            else:
                os.remove(item_path)
            return True, "removido"
    except PermissionError:
        return False, "permissão negada"
    except FileNotFoundError:
        return True, "já removido"
    except OSError as e:
        if e.errno == 66:  # Directory not empty - tenta forçar remoção
            try:
                shutil.rmtree(item_path, ignore_errors=True)
                return True, "removido (forçado)"
            except:
                return False, f"erro: {e}"
        return False, f"erro: {e}"
    except Exception as e:
        return False, f"erro: {e}"

def clean_path(path, requires_sudo=False):
    print(f"[DEBUG] Iniciando limpeza do caminho: {path} {'(sudo)' if requires_sudo else ''}")
    log = f"[INFO] Limpando: {path} {'(sudo)' if requires_sudo else ''}\n"
    deleted = 0
    failed = 0
    skipped = 0
    
    if not os.path.exists(path):
        print(f"[SKIP] Caminho inexistente: {path}")
        return f"[SKIP] Caminho inexistente: {path}\n"

    try:
        items = os.listdir(path)
        for item in items:
            item_path = os.path.join(path, item)
            item_name = os.path.basename(item_path)
            
            # Pular itens protegidos do sistema
            if is_protected(item_name):
                print(f"[SKIP] Item protegido pelo sistema: {item_name}")
                log += f"[SKIP] Item protegido: {item_name}\n"
                skipped += 1
                continue
            
            print(f"[DEBUG] Removendo: {item_path}")
            success, reason = safe_remove(item_path, requires_sudo)
            
            if success:
                log += f"[OK] Removido: {item_name} ({reason})\n"
                deleted += 1
            else:
                # Verificar se é erro de permissão esperado
                if 'permissão' in reason.lower() or 'permission' in reason.lower():
                    log += f"[AVISO] Protegido pelo sistema: {item_name}\n"
                    skipped += 1
                else:
                    log += f"[ERRO] Falha ao remover {item_name}: {reason}\n"
                    failed += 1
                    
    except PermissionError:
        print(f"[ERRO] Sem permissão para acessar: {path}")
        log += f"[ERRO] Sem permissão para acessar: {path}\n"
    except Exception as e:
        print(f"[ERRO] Falha inesperada ao acessar {path}: {e}")
        log += f"[ERRO] Falha inesperada ao acessar {path}: {e}\n"

    # Resumo
    log += f"\n[RESUMO] Removidos: {deleted} | Falhas: {failed} | Ignorados: {skipped}\n"
    return log

def run_cleaner():
    print("[FLOW CLEANER] Iniciando limpeza...")
    total_log = "[FLOW CLEANER] Iniciando limpeza...\n"
    total_log += "=" * 50 + "\n\n"
    
    total_deleted = 0
    total_failed = 0
    total_skipped = 0
    
    for path, is_sudo in CLEAN_PATHS:
        print(f"[DEBUG] Limpando caminho: {path}")
        path_log = clean_path(path, requires_sudo=is_sudo)
        total_log += path_log
        total_log += "\n"
        
        # Extrair estatísticas do log
        if "[RESUMO]" in path_log:
            lines = path_log.split("\n")
            for line in lines:
                if "[RESUMO]" in line:
                    # Tentar extrair números (formato: Removidos: X | Falhas: Y | Ignorados: Z)
                    nums = re.findall(r'\d+', line)
                    if len(nums) >= 3:
                        total_deleted += int(nums[0])
                        total_failed += int(nums[1])
                        total_skipped += int(nums[2])

    print("[DEBUG] Esvaziando lixeira...")
    total_log += "[INFO] Esvaziando lixeira...\n"
    trash_emptied = False
    try:
        subprocess.run(
            ["osascript", "-e", 'tell app "Finder" to empty trash'], 
            check=True,
            timeout=60,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print("[DEBUG] Lixeira esvaziada com sucesso.")
        total_log += "[OK] Lixeira esvaziada com sucesso.\n"
        trash_emptied = True
    except subprocess.TimeoutExpired:
        print("[ERRO] Timeout ao esvaziar lixeira")
        total_log += "[ERRO] Timeout ao esvaziar lixeira\n"
    except subprocess.CalledProcessError as e:
        print(f"[ERRO] Falha ao esvaziar lixeira via Finder: {e}")
        total_log += f"[ERRO] Falha ao esvaziar lixeira via Finder: {e}\n"
    except Exception as e:
        print(f"[ERRO] Falha inesperada ao esvaziar lixeira: {e}")
        total_log += f"[ERRO] Falha inesperada ao esvaziar lixeira: {e}\n"

    # Resumo final
    total_log += "\n" + "=" * 50 + "\n"
    total_log += "[RESUMO FINAL]\n"
    total_log += f"✅ Arquivos removidos: {total_deleted}\n"
    total_log += f"⚠️  Falhas: {total_failed}\n"
    total_log += f"🔒 Ignorados (protegidos): {total_skipped}\n"
    total_log += f"🗑️  Lixeira: {'Esvaziada' if trash_emptied else 'Falha ao esvaziar'}\n"
    total_log += "=" * 50 + "\n"
    total_log += "\n[FINALIZADO] Limpeza concluída.\n"
    
    print("[FLOW CLEANER] Limpeza concluída.")
    print(f"[RESUMO] Removidos: {total_deleted} | Falhas: {total_failed} | Ignorados: {total_skipped}")
    return total_log

def show_log_window(log_text):
    print("[DEBUG] Exibindo janela de log.")
    window = tk.Tk()
    window.title("Flow Cleaner - Log de Limpeza")
    window.geometry("700x500")

    text_area = ScrolledText(window, wrap=tk.WORD, font=("Courier", 10))
    text_area.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)
    text_area.insert(tk.END, log_text)
    text_area.configure(state="disabled")

    btn_close = tk.Button(window, text="Fechar", command=window.destroy)
    btn_close.pack(pady=10)

    window.mainloop()

if __name__ == "__main__":
    log = run_cleaner()
    show_log_window(log)
