#!/bin/bash

# 🆙 GERENCIADOR DE ATUALIZAÇÕES DO macOS
# ======================================

echo "🆙 GERENCIADOR DE ATUALIZAÇÕES DO macOS"
echo "========================================"
echo ""

# Cores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Função para verificar espaço em disco
check_disk_space() {
    echo -e "${BLUE}💾 ESPAÇO EM DISCO${NC}"
    echo "=================="
    
    # Espaço total e disponível
    disk_info=$(df -h / | tail -1)
    total=$(echo $disk_info | awk '{print $2}')
    used=$(echo $disk_info | awk '{print $3}')
    available=$(echo $disk_info | awk '{print $4}')
    percent=$(echo $disk_info | awk '{print $5}')
    
    echo "📊 Total: $total"
    echo "📊 Usado: $used ($percent)"
    echo -e "📊 Disponível: ${GREEN}$available${NC}"
    echo ""
    
    # Converter para bytes para comparação
    available_bytes=$(df / | tail -1 | awk '{print $4}')
    update_size_gb=18
    update_size_bytes=$((update_size_gb * 1024 * 1024 * 1024))
    
    if [ $available_bytes -lt $update_size_bytes ]; then
        echo -e "${RED}⚠️  ATENÇÃO: Espaço insuficiente para atualização de 18GB${NC}"
        echo "   Você precisa de pelo menos ${update_size_gb}GB livres"
        echo ""
        return 1
    else
        echo -e "${GREEN}✅ Espaço suficiente para atualização${NC}"
        echo ""
        return 0
    fi
}

# Função para verificar atualizações agendadas
check_scheduled_updates() {
    echo -e "${BLUE}📅 ATUALIZAÇÕES AGENDADAS${NC}"
    echo "========================"
    
    # Verificar se há atualizações agendadas
    scheduled=$(softwareupdate --list 2>/dev/null | grep -i "scheduled\|agendada" || echo "")
    
    if [ -n "$scheduled" ]; then
        echo -e "${YELLOW}⚠️  Há atualizações agendadas:${NC}"
        softwareupdate --list 2>/dev/null | grep -A 5 -i "scheduled\|agendada" || true
        echo ""
        return 0
    else
        echo -e "${GREEN}✅ Nenhuma atualização agendada${NC}"
        echo ""
        return 1
    fi
}

# Função para cancelar atualizações agendadas
cancel_scheduled_updates() {
    echo -e "${YELLOW}🛑 CANCELANDO ATUALIZAÇÕES AGENDADAS${NC}"
    echo "===================================="
    echo ""
    
    read -p "Tem certeza que deseja cancelar todas as atualizações agendadas? (s/N): " confirm
    
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        echo "🔄 Cancelando atualizações agendadas..."
        
        # Cancelar via softwareupdate
        sudo softwareupdate --reset-ignored 2>/dev/null || true
        
        # Cancelar via defaults
        sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload 2>/dev/null || true
        sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled 2>/dev/null || true
        
        # Desabilitar atualizações automáticas
        sudo softwareupdate --schedule off 2>/dev/null || true
        
        echo -e "${GREEN}✅ Atualizações agendadas canceladas${NC}"
        echo ""
    else
        echo "❌ Operação cancelada"
        echo ""
    fi
}

# Função para limpar arquivos de atualização
clean_update_files() {
    echo -e "${BLUE}🧹 LIMPANDO ARQUIVOS DE ATUALIZAÇÃO${NC}"
    echo "===================================="
    echo ""
    
    update_paths=(
        "$HOME/Library/Updates"
        "/Library/Updates"
        "/private/var/folders/*/C/com.apple.SoftwareUpdate"
        "/System/Library/Caches/com.apple.SoftwareUpdate"
    )
    
    total_freed=0
    
    for path in "${update_paths[@]}"; do
        # Expandir wildcards
        for expanded_path in $path; do
            if [ -d "$expanded_path" ] || [ -f "$expanded_path" ]; then
                size=$(du -sk "$expanded_path" 2>/dev/null | awk '{print $1}')
                size_mb=$((size / 1024))
                
                if [ $size_mb -gt 0 ]; then
                    echo "📁 Encontrado: $expanded_path"
                    echo "   Tamanho: ${size_mb}MB"
                    
                    read -p "   Deseja remover? (s/N): " confirm
                    if [[ "$confirm" =~ ^[Ss]$ ]]; then
                        rm -rf "$expanded_path" 2>/dev/null
                        if [ $? -eq 0 ]; then
                            echo -e "   ${GREEN}✅ Removido${NC}"
                            total_freed=$((total_freed + size_mb))
                        else
                            echo -e "   ${RED}❌ Erro ao remover (pode precisar de sudo)${NC}"
                        fi
                    fi
                    echo ""
                fi
            fi
        done
    done
    
    if [ $total_freed -gt 0 ]; then
        echo -e "${GREEN}✅ Espaço liberado: ${total_freed}MB${NC}"
    else
        echo "ℹ️  Nenhum arquivo de atualização encontrado ou removido"
    fi
    echo ""
}

# Função para verificar instaladores antigos
check_old_installers() {
    echo -e "${BLUE}📦 INSTALADORES ANTIGOS${NC}"
    echo "======================"
    
    installer_paths=(
        "/Applications/Install macOS*.app"
        "/Applications/Install OS X*.app"
    )
    
    found_any=false
    
    for pattern in "${installer_paths[@]}"; do
        for installer in $pattern; do
            if [ -d "$installer" ]; then
                found_any=true
                size=$(du -sh "$installer" 2>/dev/null | awk '{print $1}')
                echo "📦 $installer"
                echo "   Tamanho: $size"
                echo ""
            fi
        done
    done
    
    if [ "$found_any" = false ]; then
        echo -e "${GREEN}✅ Nenhum instalador antigo encontrado${NC}"
    else
        echo -e "${YELLOW}💡 DICA: Você pode remover instaladores antigos para liberar espaço${NC}"
        echo "   Eles estão em /Applications/"
    fi
    echo ""
}

# Função para desabilitar atualizações automáticas
disable_auto_updates() {
    echo -e "${YELLOW}⚙️  CONFIGURANDO ATUALIZAÇÕES AUTOMÁTICAS${NC}"
    echo "========================================"
    echo ""
    echo "Escolha uma opção:"
    echo "1. Desabilitar atualizações automáticas"
    echo "2. Habilitar atualizações automáticas"
    echo "3. Voltar"
    echo ""
    
    read -p "Digite sua escolha (1-3): " choice
    
    case $choice in
        1)
            echo "🔄 Desabilitando atualizações automáticas..."
            sudo softwareupdate --schedule off 2>/dev/null || true
            sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false 2>/dev/null || true
            sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false 2>/dev/null || true
            echo -e "${GREEN}✅ Atualizações automáticas desabilitadas${NC}"
            ;;
        2)
            echo "🔄 Habilitando atualizações automáticas..."
            sudo softwareupdate --schedule on 2>/dev/null || true
            sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true 2>/dev/null || true
            sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true 2>/dev/null || true
            echo -e "${GREEN}✅ Atualizações automáticas habilitadas${NC}"
            ;;
        3)
            return
            ;;
        *)
            echo "❌ Opção inválida"
            ;;
    esac
    echo ""
}

# Menu principal
show_menu() {
    echo -e "${CYAN}📋 MENU PRINCIPAL${NC}"
    echo "================"
    echo ""
    echo "1. 💾 Verificar espaço em disco"
    echo "2. 📅 Verificar atualizações agendadas"
    echo "3. 🛑 Cancelar atualizações agendadas"
    echo "4. 🧹 Limpar arquivos de atualização"
    echo "5. 📦 Verificar instaladores antigos"
    echo "6. ⚙️  Configurar atualizações automáticas"
    echo "7. 🔍 Ver todas as atualizações disponíveis"
    echo "8. ❌ Sair"
    echo ""
}

# Main
while true; do
    show_menu
    read -p "Digite sua escolha (1-8): " choice
    echo ""
    
    case $choice in
        1)
            check_disk_space
            ;;
        2)
            check_scheduled_updates
            ;;
        3)
            cancel_scheduled_updates
            ;;
        4)
            clean_update_files
            ;;
        5)
            check_old_installers
            ;;
        6)
            disable_auto_updates
            ;;
        7)
            echo -e "${BLUE}🔍 ATUALIZAÇÕES DISPONÍVEIS${NC}"
            echo "========================"
            softwareupdate --list 2>/dev/null || echo "Erro ao verificar atualizações"
            echo ""
            ;;
        8)
            echo "👋 Até logo!"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opção inválida${NC}"
            echo ""
            ;;
    esac
    
    read -p "Pressione Enter para continuar..."
    clear
done

