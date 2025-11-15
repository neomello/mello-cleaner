# 🛄 Flow Cleaner ∴ Modo NΞØ

Camada de limpeza profunda para sistemas baseados em macOS.  
Remoção de ruído, alívio de memória, regeneração de fluxo.

---

## 🧬 Pré-condições

- Ambiente com suporte ao movimento fluido
- Operador com Python 3.11+ e visão clara
- Ferramentas alinhadas: `brew`, `pyenv`, `py2app`
- Interface gráfica ativada (`tkinter`)

---

## ⚙️ Inicialização

```bash
# Clonar o código-fonte (canal seguro)
git clone [REPO]
cd mello-cleaner
```

```bash
# Configurar ambiente
make setup

# Ativar ambiente simbiótico
make run
```

## 📋 Comandos Disponíveis

```bash
# Ver todos os comandos disponíveis
make help
```

**Principais comandos:**
- `make setup` - Configura ambiente virtual e instala dependências
- `make run` - Executa o aplicativo
- `make analyze` - **Análise prévia** (recomendado antes de organizar)
- `make diagnose-heating` - Diagnóstico de aquecimento
- `make optimize-performance` - Otimizações de performance
- `make organize` - Organização de arquivos
- `make analyze-apps` - Análise de aplicativos

---

## ♻️ Execução do Ritual

```bash
python main.py
```

---

## 🏗️ Construção do Selo (.app + .dmg)

```bash
make clean
make build
make dmg
```

🔒 Saída: `dist/Flow-Cleaner.dmg`

---

## 🌡️ Diagnóstico e Otimização de Aquecimento

Ferramentas para diagnosticar e reduzir aquecimento do Mac:

### Diagnóstico
```bash
# Diagnóstico completo de temperatura, CPU e processos
make diagnose-heating

# Recomendações específicas para reduzir aquecimento
make optimize-heating
```

### Otimizações de Performance
```bash
# Reduzir transparências do sistema
make reduce-transparency

# Aplicar todas as otimizações de performance
make optimize-performance
```

### Reverter macOS
```bash
# Guia completo para reverter versão do macOS
make downgrade-guide
```

**Otimizações aplicadas:**
- ✅ Redução de transparências
- ✅ Desativação de animações
- ✅ Otimização do Dock
- ✅ Redução de efeitos visuais
- ✅ Desativação de Siri (opcional)

**Resultados esperados:**
- Redução de 80-95% no uso de CPU do WindowServer
- Menor aquecimento do sistema
- Melhor performance geral
- Maior duração da bateria

---

## 🗂️ Organização de Arquivos

### 🔍 Análise Prévia (Recomendado antes de organizar)

**Sempre execute a análise antes de organizar para revisar o que será movido/deletado:**

```bash
# Análise completa de todos os diretórios
make analyze
# ou
./analyze_files.sh
```

**O que a análise mostra:**
- 📅 **Arquivos por data** - Os 20 arquivos mais recentes de cada pasta
- 🔥 **Arquivos grandes** - Arquivos maiores que 10MB
- 📊 **Análise por tipo** - Contagem por categoria:
  - 🖼️ Imagens (PNG, JPG, GIF)
  - 📄 PDFs
  - 🎬 Vídeos (MP4, MOV, AVI)
  - 🎵 Áudios (MP3, WAV, AAC)
  - 📦 Arquivos compactados (ZIP, RAR, DMG)
  - 📝 Documentos (DOC, DOCX, TXT)
  - ⚙️ Arquivos ocultos

**Pastas analisadas:**
- 🖥️ Desktop (19GB)
- 📥 Downloads (2.3GB)
- 📄 Documents (541MB)
- 🎬 Movies (8.6GB)

---

### 📁 Processo de Separação em Pastas (Principal Funcionalidade)

**Este é o processo principal do projeto:** Os scripts separam arquivos em pastas organizadas ANTES de apagar, permitindo revisão completa.

#### Como Funciona

1. **Separação Automática** - Arquivos são movidos para pastas organizadas por tipo
2. **Pastas de Revisão** - Arquivos suspeitos/antigos vão para pastas específicas para revisão
3. **Análise Antes de Deletar** - Você revisa cada pasta antes de apagar definitivamente

#### Downloads (`clean-downloads.sh`)

```bash
make clean-downloads
# ou
./clean_downloads.sh
```

**Pastas criadas:**
- `📁 Organizados/Imagens` - Imagens (PNG, JPG, GIF)
- `📁 Organizados/PDFs` - Documentos PDF
- `📁 Organizados/Vídeos` - Vídeos (MP4, MOV, AVI)
- `📁 Organizados/Instaladores` - DMG, PKG, ZIP, RAR
- `📁 Antigos (6+ meses)` - Arquivos com mais de 6 meses
- `📁 Para Deletar` - Arquivos muito pequenos (<1KB)

**Após a execução:**
1. ✅ Revise `📁 Antigos (6+ meses)` - pode deletar
2. ✅ Revise `📁 Para Deletar` - arquivos pequenos
3. ✅ Mova arquivos importantes para Documents se necessário

#### Desktop (`organize-desktop.sh`)

```bash
make organize-desktop
# ou
./organize_desktop.sh
```

**Pastas criadas:**
- `📁 Arquivos por Tipo/Imagens` - Todas as imagens
- `📁 Arquivos por Tipo/PDFs` - Documentos PDF
- `📁 Arquivos por Tipo/Vídeos` - Vídeos
- `📁 Arquivos por Tipo/Audios` - Arquivos de áudio
- `📁 Arquivos por Tipo/Documentos` - DOC, DOCX, TXT
- `📁 Arquivos por Tipo/Arquivos de Sistema` - Arquivos ocultos
- `📁 Projetos Ativos` - Para projetos em andamento
- `📁 Projetos Antigos` - Para projetos finalizados
- `📁 Para Revisar` - Arquivos numerados/suspeitos
- `📁 Lixeira Desktop` - Para arquivos a deletar

#### Organização Seletiva (`selective_organize.sh`)

```bash
./selective_organize.sh
```

**Permite escolher arquivo por arquivo:**
- [1] Manter e organizar → `📁 Organizados`
- [2] Deletar → `📁 Para Deletar`
- [3] Pular (deixar onde está)
- [4] Ver detalhes do arquivo

**Fluxo recomendado:**

1. ✅ Execute o script de organização (Downloads ou Desktop)
2. 📋 Revise as pastas `📁 Para Deletar` e `📁 Antigos`
3. 🗑️ Delete apenas após confirmar que não precisa mais
4. 🗂️ Mova arquivos importantes para locais apropriados

---

### Outros Comandos de Organização

```bash
# Organização interativa (com opção de análise prévia)
make organize

# Organização rápida
./quick_organize.sh

# Organização simples
./simple_organize.sh
```

---

## 📱 Gerenciamento de Aplicativos

```bash
# Analisar aplicativos instalados
make analyze-apps

# Remover aplicativos não utilizados
make remove-apps

# Remover aplicativos específicos
make remove-specific-apps

# Deletar aplicativos do backup definitivamente
make delete-backup-apps
```

---

## ☠️ Notas Internas

* Algumas ações exigem elevação de permissão (🧪 `sudo`)
* Interface em `tkinter` — verifique vínculo com Tcl/Tk
* Scriptos em AppleScript são invocados para esvaziamento total
* Otimizações de performance requerem logout/login ou reinício para aplicar completamente

---

## 🧠 Códigos são limpos. Mentes também.

> Não é sobre remover arquivos.
> É sobre liberar espaço onde o ruído se esconde.

---

## 👤 Autoria

**MELLO** ∴ [@mello\_.mkt](https://www.instagram.com/mello_.mkt)
em colaboração com **FlowOFF** ∴ [flowoff.xyz](https://www.flowoff.xyz)

---

> “Quem não limpa o fluxo, acaba soterrado pela própria pressa.”
>
> ∴ Flow Cleaner é ferramenta. O resto é escolha.
