#!/bin/bash

echo "⚡ OTIMIZAÇÕES DE PERFORMANCE PARA REDUZIR AQUECIMENTO"
echo "====================================================="
echo ""

# Cores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "Este script aplicará várias otimizações para reduzir aquecimento:"
echo ""
echo "1. Reduzir transparências"
echo "2. Reduzir animações"
echo "3. Reduzir movimento"
echo "4. Otimizar Dock"
echo "5. Reduzir efeitos visuais"
echo ""
echo "Deseja continuar? (s/N)"
read -r confirm

if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
    echo "Operação cancelada."
    exit 0
fi

echo ""
echo "🔧 Aplicando otimizações..."
echo ""

# 1. Reduzir transparências
echo "1️⃣ Reduzindo transparências..."
defaults write -g AppleReduceTransparency -bool true
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Transparências reduzidas${NC}"
else
    echo -e "${RED}   ❌ Erro ao reduzir transparências${NC}"
fi

# 2. Reduzir animações de janelas
echo "2️⃣ Reduzindo animações de janelas..."
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Animações de janelas desativadas${NC}"
else
    echo -e "${RED}   ❌ Erro ao desativar animações${NC}"
fi

# 3. Reduzir movimento (acessibilidade)
echo "3️⃣ Reduzindo movimento..."
defaults write -g reduceMotion -bool true
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Movimento reduzido${NC}"
else
    echo -e "${RED}   ❌ Erro ao reduzir movimento${NC}"
fi

# 4. Otimizar Dock
echo "4️⃣ Otimizando Dock..."
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock no-bouncing -bool true
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Dock otimizado${NC}"
else
    echo -e "${RED}   ❌ Erro ao otimizar Dock${NC}"
fi

# 5. Reduzir efeitos visuais do Mission Control
echo "5️⃣ Reduzindo efeitos do Mission Control..."
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock mru-spaces -bool false
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Mission Control otimizado${NC}"
else
    echo -e "${RED}   ❌ Erro ao otimizar Mission Control${NC}"
fi

# 6. Desativar animações do Launchpad
echo "6️⃣ Desativando animações do Launchpad..."
defaults write com.apple.dock springboard-show-duration -float 0.1
defaults write com.apple.dock springboard-hide-duration -float 0.1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Launchpad otimizado${NC}"
else
    echo -e "${RED}   ❌ Erro ao otimizar Launchpad${NC}"
fi

# 7. Reduzir efeitos de transição
echo "7️⃣ Reduzindo efeitos de transição..."
defaults write -g NSWindowResizeTime -float 0.001
if [ $? -eq 0 ]; then
    echo -e "${GREEN}   ✅ Efeitos de transição reduzidos${NC}"
else
    echo -e "${RED}   ❌ Erro ao reduzir transições${NC}"
fi

# 8. Desativar Siri (se não usado)
echo ""
echo "8️⃣ Deseja desativar Siri? (pode reduzir uso de CPU) (s/N)"
read -r siri_confirm
if [[ "$siri_confirm" =~ ^[Ss]$ ]]; then
    defaults write com.apple.assistant.support "Assistant Enabled" -bool false
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}   ✅ Siri desativado${NC}"
    else
        echo -e "${RED}   ❌ Erro ao desativar Siri${NC}"
    fi
fi

# 9. Reiniciar Dock
echo ""
echo "🔄 Reiniciando Dock para aplicar mudanças..."
killall Dock 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dock reiniciado${NC}"
else
    echo -e "${YELLOW}⚠️  Reinicie o Dock manualmente${NC}"
fi

echo ""
echo -e "${GREEN}✅ Otimizações aplicadas!${NC}"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   - Faça logout e login novamente para aplicar todas as mudanças"
echo "   - Ou reinicie o Mac para melhor resultado"
echo "   - Isso reduzirá significativamente o uso de CPU do WindowServer"
echo ""
echo "💡 Para reverter todas as mudanças:"
echo "   ./revert_optimizations.sh"
echo ""

