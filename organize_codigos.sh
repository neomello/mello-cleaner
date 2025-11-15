#!/bin/bash

# 🎯 Organizador de Projetos CODIGOS
# Organiza projetos por categoria e tipo

CODIGOS_DIR="/Users/nettomello/CODIGOS"
LOG_FILE="$CODIGOS_DIR/organize_log.txt"

echo "🎯 Iniciando organização da pasta CODIGOS..." | tee "$LOG_FILE"
echo "📅 $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Criar estrutura de pastas organizadas
mkdir -p "$CODIGOS_DIR/📁 WEB_APPS"
mkdir -p "$CODIGOS_DIR/📁 MOBILE_APPS" 
mkdir -p "$CODIGOS_DIR/📁 BOTS_IA"
mkdir -p "$CODIGOS_DIR/📁 BLOCKCHAIN"
mkdir -p "$CODIGOS_DIR/📁 MARKETING"
mkdir -p "$CODIGOS_DIR/📁 GAMES"
mkdir -p "$CODIGOS_DIR/📁 UTILITARIOS"
mkdir -p "$CODIGOS_DIR/📁 BACKUPS"
mkdir -p "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS"
mkdir -p "$CODIGOS_DIR/📁 PROJETOS_INTERBOX"
mkdir -p "$CODIGOS_DIR/📁 PROJETOS_FLOWPAY"

echo "📁 Estrutura de pastas criada!" | tee -a "$LOG_FILE"

# Função para mover e logar
move_project() {
    local source="$1"
    local dest="$2"
    local category="$3"
    
    if [ -d "$CODIGOS_DIR/$source" ]; then
        mv "$CODIGOS_DIR/$source" "$CODIGOS_DIR/$dest/"
        echo "✅ $source → $category" | tee -a "$LOG_FILE"
    fi
}

# WEB APPS
echo "" | tee -a "$LOG_FILE"
echo "🌐 Organizando WEB APPS..." | tee -a "$LOG_FILE"
move_project "blindaphone_webapp" "📁 WEB_APPS/blindaphone_webapp" "WEB_APPS"
move_project "blindaphone_webapp_oficial" "📁 WEB_APPS/blindaphone_webapp_oficial" "WEB_APPS"
move_project "alma-goiana-webapp" "📁 WEB_APPS/alma-goiana-webapp" "WEB_APPS"
move_project "alma-gyn-1" "📁 WEB_APPS/alma-gyn-1" "WEB_APPS"
move_project "neo-flowoff-pwa" "📁 WEB_APPS/neo-flowoff-pwa" "WEB_APPS"
move_project "ritual-ink-landing-main" "📁 WEB_APPS/ritual-ink-landing-main" "WEB_APPS"
move_project "ritual-ink-landing-main-1" "📁 WEB_APPS/ritual-ink-landing-main-1" "WEB_APPS"
move_project "pro-ia-landing" "📁 WEB_APPS/pro-ia-landing" "WEB_APPS"
move_project "landing_flowpay" "📁 WEB_APPS/landing_flowpay" "WEB_APPS"
move_project "plataforma-flowhub" "📁 WEB_APPS/plataforma-flowhub" "WEB_APPS"

# BOTS E IA
echo "" | tee -a "$LOG_FILE"
echo "🤖 Organizando BOTS E IA..." | tee -a "$LOG_FILE"
move_project "AGENTE SECRETÁRIA" "📁 BOTS_IA/AGENTE_SECRETARIA" "BOTS_IA"
move_project "Agente-assistente-de-conteudos" "📁 BOTS_IA/Agente-assistente-de-conteudos" "BOTS_IA"
move_project "BOT MODERADOR PARA WHATSAPP" "📁 BOTS_IA/BOT_MODERADOR_WHATSAPP" "BOTS_IA"
move_project "clickfarm_bot" "📁 BOTS_IA/clickfarm_bot" "BOTS_IA"
move_project "crypto-pay-bot" "📁 BOTS_IA/crypto-pay-bot" "BOTS_IA"
move_project "projeto_whatsapp_bot" "📁 BOTS_IA/projeto_whatsapp_bot" "BOTS_IA"
move_project "agent-neo-flowoff" "📁 BOTS_IA/agent-neo-flowoff" "BOTS_IA"
move_project "REDE NEURAL NEO" "📁 BOTS_IA/REDE_NEURAL_NEO" "BOTS_IA"
move_project "neo-prompts" "📁 BOTS_IA/neo-prompts" "BOTS_IA"
move_project "pro-ia" "📁 BOTS_IA/pro-ia" "BOTS_IA"
move_project "proia_" "📁 BOTS_IA/proia" "BOTS_IA"
move_project "hacksider_Deep-Live-Cam" "📁 BOTS_IA/hacksider_Deep-Live-Cam" "BOTS_IA"
move_project "comfyui-launcher" "📁 BOTS_IA/comfyui-launcher" "BOTS_IA"
move_project "ollama-core" "📁 BOTS_IA/ollama-core" "BOTS_IA"
move_project "ollama-neo-protocol" "📁 BOTS_IA/ollama-neo-protocol" "BOTS_IA"

# BLOCKCHAIN
echo "" | tee -a "$LOG_FILE"
echo "⛓️ Organizando BLOCKCHAIN..." | tee -a "$LOG_FILE"
move_project "InterboxSol" "📁 BLOCKCHAIN/InterboxSol" "BLOCKCHAIN"
move_project "sol-FLWFF" "📁 BLOCKCHAIN/sol-FLWFF" "BLOCKCHAIN"
move_project "sol-FLWFF_BKP15_MAI" "📁 BLOCKCHAIN/sol-FLWFF_BKP15_MAI" "BLOCKCHAIN"
move_project "usd-go-project" "📁 BLOCKCHAIN/usd-go-project" "BLOCKCHAIN"
move_project "usdgo-token-contracts" "📁 BLOCKCHAIN/usdgo-token-contracts" "BLOCKCHAIN"
move_project "gerador_wallet_cli" "📁 BLOCKCHAIN/gerador_wallet_cli" "BLOCKCHAIN"
move_project "cryptomus_project" "📁 BLOCKCHAIN/cryptomus_project" "BLOCKCHAIN"
move_project "trading_bybit_api" "📁 BLOCKCHAIN/trading_bybit_api" "BLOCKCHAIN"
move_project "interbox-vault" "📁 BLOCKCHAIN/interbox-vault" "BLOCKCHAIN"

# PROJETOS INTERBOX
echo "" | tee -a "$LOG_FILE"
echo "🎮 Organizando PROJETOS INTERBOX..." | tee -a "$LOG_FILE"
move_project "interbox-captacao" "📁 PROJETOS_INTERBOX/interbox-captacao" "PROJETOS_INTERBOX"
move_project "interbox-core" "📁 PROJETOS_INTERBOX/interbox-core" "PROJETOS_INTERBOX"
move_project "interbox-links" "📁 PROJETOS_INTERBOX/interbox-links" "PROJETOS_INTERBOX"
move_project "interbox-links-1" "📁 PROJETOS_INTERBOX/interbox-links-1" "PROJETOS_INTERBOX"
move_project "interbox-v2" "📁 PROJETOS_INTERBOX/interbox-v2" "PROJETOS_INTERBOX"
move_project "portal-games-interbox" "📁 PROJETOS_INTERBOX/portal-games-interbox" "PROJETOS_INTERBOX"
move_project "portal-games-interbox-1" "📁 PROJETOS_INTERBOX/portal-games-interbox-1" "PROJETOS_INTERBOX"
move_project "arena-\$box" "📁 PROJETOS_INTERBOX/arena-box" "PROJETOS_INTERBOX"

# PROJETOS FLOWPAY
echo "" | tee -a "$LOG_FILE"
echo "💳 Organizando PROJETOS FLOWPAY..." | tee -a "$LOG_FILE"
move_project "FlowPAY" "📁 PROJETOS_FLOWPAY/FlowPAY" "PROJETOS_FLOWPAY"
move_project "FlowPAY - bkp 06_05" "📁 PROJETOS_FLOWPAY/FlowPAY_bkp_06_05" "PROJETOS_FLOWPAY"
move_project "FlowPAY 2" "📁 PROJETOS_FLOWPAY/FlowPAY_2" "PROJETOS_FLOWPAY"
move_project "flowpay_lite" "📁 PROJETOS_FLOWPAY/flowpay_lite" "PROJETOS_FLOWPAY"

# GAMES
echo "" | tee -a "$LOG_FILE"
echo "🎮 Organizando GAMES..." | tee -a "$LOG_FILE"
move_project "MINIAPP_REBORN" "📁 GAMES/MINIAPP_REBORN" "GAMES"
move_project "MELLO REBURN MVP" "📁 GAMES/MELLO_REBURN_MVP" "GAMES"
move_project "reborn_clone_ok" "📁 GAMES/reborn_clone_ok" "GAMES"
move_project "SOON-REBORN-1" "📁 GAMES/SOON-REBORN-1" "GAMES"

# MARKETING
echo "" | tee -a "$LOG_FILE"
echo "📈 Organizando MARKETING..." | tee -a "$LOG_FILE"
move_project "marketing-mini-hub" "📁 MARKETING/marketing-mini-hub" "MARKETING"
move_project "projeto_ads" "📁 MARKETING/projeto_ads" "MARKETING"
move_project "ADS SHARE" "📁 MARKETING/ADS_SHARE" "MARKETING"
move_project "mello-instagram-cms" "📁 MARKETING/mello-instagram-cms" "MARKETING"
move_project "PAULA_FEED" "📁 MARKETING/PAULA_FEED" "MARKETING"
move_project "mentoria-ikigai-mvp" "📁 MARKETING/mentoria-ikigai-mvp" "MARKETING"

# UTILITARIOS
echo "" | tee -a "$LOG_FILE"
echo "🔧 Organizando UTILITARIOS..." | tee -a "$LOG_FILE"
move_project "flow_cleaner" "📁 UTILITARIOS/flow_cleaner" "UTILITARIOS"
move_project "mello-cleaner" "📁 UTILITARIOS/mello-cleaner" "UTILITARIOS"
move_project "converter-webp" "📁 UTILITARIOS/converter-webp" "UTILITARIOS"
move_project "ENCURTADOR_de_LINKS" "📁 UTILITARIOS/ENCURTADOR_de_LINKS" "UTILITARIOS"
move_project "skiptracer" "📁 UTILITARIOS/skiptracer" "UTILITARIOS"
move_project "canary_token" "📁 UTILITARIOS/canary_token" "UTILITARIOS"
move_project "tef-terminal" "📁 UTILITARIOS/tef-terminal" "UTILITARIOS"
move_project "Scriptzao pra calar o Mac" "📁 UTILITARIOS/Scriptzao_pra_calar_o_Mac" "UTILITARIOS"

# BACKUPS
echo "" | tee -a "$LOG_FILE"
echo "💾 Organizando BACKUPS..." | tee -a "$LOG_FILE"
move_project "backups" "📁 BACKUPS/backups" "BACKUPS"
move_project "ECOSSISTEMA STRONGER FITNESS BKP" "📁 BACKUPS/ECOSSISTEMA_STRONGER_FITNESS_BKP" "BACKUPS"
move_project "bruxa-mvp-2025-07-10" "📁 BACKUPS/bruxa-mvp-2025-07-10" "BACKUPS"
move_project "old POSTON_checar se melhor___assistente-digital-neo" "📁 BACKUPS/old_POSTON_assistente-digital-neo" "BACKUPS"

# MOBILE APPS
echo "" | tee -a "$LOG_FILE"
echo "📱 Organizando MOBILE APPS..." | tee -a "$LOG_FILE"
move_project "MINIAPP_REBORN" "📁 MOBILE_APPS/MINIAPP_REBORN" "MOBILE_APPS"
move_project "META-Graph_API" "📁 MOBILE_APPS/META-Graph_API" "MOBILE_APPS"

# Projetos diversos que não se encaixam nas categorias acima
echo "" | tee -a "$LOG_FILE"
echo "📁 Organizando PROJETOS DIVERSOS..." | tee -a "$LOG_FILE"
move_project "stronger-fitness" "📁 UTILITARIOS/stronger-fitness" "UTILITARIOS"
move_project "Stronger_FT" "📁 UTILITARIOS/Stronger_FT" "UTILITARIOS"
move_project "mg-riscos-seguro" "📁 UTILITARIOS/mg-riscos-seguro" "UTILITARIOS"
move_project "mg-riscos-seguro-new" "📁 UTILITARIOS/mg-riscos-seguro-new" "UTILITARIOS"
move_project "bruxa-mvp" "📁 UTILITARIOS/bruxa-mvp" "UTILITARIOS"
move_project "ju tattoo_replit" "📁 UTILITARIOS/ju_tattoo_replit" "UTILITARIOS"
move_project "projeto_5sim_rent" "📁 UTILITARIOS/projeto_5sim_rent" "UTILITARIOS"
move_project "iadojob" "📁 UTILITARIOS/iadojob" "UTILITARIOS"
move_project "VEO_" "📁 UTILITARIOS/VEO" "UTILITARIOS"
move_project "Paulinha" "📁 UTILITARIOS/Paulinha" "UTILITARIOS"
move_project "POSTON" "📁 UTILITARIOS/POSTON" "UTILITARIOS"
move_project "POSTON-Frontend" "📁 UTILITARIOS/POSTON-Frontend" "UTILITARIOS"
move_project "PROTON" "📁 UTILITARIOS/PROTON" "UTILITARIOS"
move_project "MKSproject-bolt" "📁 UTILITARIOS/MKSproject-bolt" "UTILITARIOS"
move_project "MKS-cookbookdev" "📁 UTILITARIOS/MKS-cookbookdev" "UTILITARIOS"
move_project "Dw_YT_videos" "📁 UTILITARIOS/Dw_YT_videos" "UTILITARIOS"
move_project "ENS_23_04" "📁 UTILITARIOS/ENS_23_04" "UTILITARIOS"
move_project "FIGMA PROJECTS" "📁 UTILITARIOS/FIGMA_PROJECTS" "UTILITARIOS"
move_project "CERTIFICATE_DNS" "📁 UTILITARIOS/CERTIFICATE_DNS" "UTILITARIOS"
move_project "Construção de IA para consultorias de marketing digital" "📁 UTILITARIOS/Construcao_IA_consultorias_marketing" "UTILITARIOS"
move_project "agente particular do netto gato e lindo IA para consultorias marketing digital (1)" "📁 UTILITARIOS/agente_particular_netto_IA_consultorias" "UTILITARIOS"
move_project "nettomello-ens" "📁 UTILITARIOS/nettomello-ens" "UTILITARIOS"
move_project "pl_fine" "📁 UTILITARIOS/pl_fine" "UTILITARIOS"
move_project "salvy-botpress-integration" "📁 UTILITARIOS/salvy-botpress-integration" "UTILITARIOS"

# Mover arquivos soltos
echo "" | tee -a "$LOG_FILE"
echo "📄 Organizando ARQUIVOS SOLTOS..." | tee -a "$LOG_FILE"
if [ -f "$CODIGOS_DIR/favicon.ico" ]; then
    mv "$CODIGOS_DIR/favicon.ico" "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS/"
    echo "✅ favicon.ico → ARQUIVOS_SOLTOS" | tee -a "$LOG_FILE"
fi

if [ -f "$CODIGOS_DIR/denoland.vscode-deno-3.45.2.vsix" ]; then
    mv "$CODIGOS_DIR/denoland.vscode-deno-3.45.2.vsix" "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS/"
    echo "✅ denoland.vscode-deno-3.45.2.vsix → ARQUIVOS_SOLTOS" | tee -a "$LOG_FILE"
fi

if [ -f "$CODIGOS_DIR/InterboxCoin_Flattened.sol" ]; then
    mv "$CODIGOS_DIR/InterboxCoin_Flattened.sol" "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS/"
    echo "✅ InterboxCoin_Flattened.sol → ARQUIVOS_SOLTOS" | tee -a "$LOG_FILE"
fi

if [ -f "$CODIGOS_DIR/plugin-redoc-2.yaml" ]; then
    mv "$CODIGOS_DIR/plugin-redoc-2.yaml" "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS/"
    echo "✅ plugin-redoc-2.yaml → ARQUIVOS_SOLTOS" | tee -a "$LOG_FILE"
fi

if [ -f "$CODIGOS_DIR/ml-llm-253.22441.1.zip" ]; then
    mv "$CODIGOS_DIR/ml-llm-253.22441.1.zip" "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS/"
    echo "✅ ml-llm-253.22441.1.zip → ARQUIVOS_SOLTOS" | tee -a "$LOG_FILE"
fi

# Remover .DS_Store
if [ -f "$CODIGOS_DIR/.DS_Store" ]; then
    rm "$CODIGOS_DIR/.DS_Store"
    echo "🗑️ .DS_Store removido" | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"
echo "🎉 Organização concluída!" | tee -a "$LOG_FILE"
echo "📊 Resumo:" | tee -a "$LOG_FILE"
echo "📁 WEB_APPS: $(ls -1 "$CODIGOS_DIR/📁 WEB_APPS" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "🤖 BOTS_IA: $(ls -1 "$CODIGOS_DIR/📁 BOTS_IA" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "⛓️ BLOCKCHAIN: $(ls -1 "$CODIGOS_DIR/📁 BLOCKCHAIN" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "🎮 PROJETOS_INTERBOX: $(ls -1 "$CODIGOS_DIR/📁 PROJETOS_INTERBOX" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "💳 PROJETOS_FLOWPAY: $(ls -1 "$CODIGOS_DIR/📁 PROJETOS_FLOWPAY" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "🎮 GAMES: $(ls -1 "$CODIGOS_DIR/📁 GAMES" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "📈 MARKETING: $(ls -1 "$CODIGOS_DIR/📁 MARKETING" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "🔧 UTILITARIOS: $(ls -1 "$CODIGOS_DIR/📁 UTILITARIOS" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "💾 BACKUPS: $(ls -1 "$CODIGOS_DIR/📁 BACKUPS" 2>/dev/null | wc -l) projetos" | tee -a "$LOG_FILE"
echo "📄 ARQUIVOS_SOLTOS: $(ls -1 "$CODIGOS_DIR/📁 ARQUIVOS_SOLTOS" 2>/dev/null | wc -l) arquivos" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "✅ Organização da pasta CODIGOS finalizada com sucesso!" | tee -a "$LOG_FILE"
