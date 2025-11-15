#!/bin/bash

echo "🎨 REDUZINDO TRANSPARÊNCIAS DO SISTEMA"
echo "======================================"
echo ""

# Cores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Verificar estado atual
current_state=$(defaults read -g AppleReduceTransparency 2>/dev/null)

if [ "$current_state" == "1" ]; then
    echo -e "${GREEN}✅ Transparências já estão reduzidas${NC}"
    echo ""
    echo "Deseja reativar as transparências? (s/N)"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
        defaults write -g AppleReduceTransparency -bool false
        echo -e "${GREEN}✅ Transparências reativadas${NC}"
        echo "Reinicie os aplicativos ou faça logout/login para aplicar"
    else
        echo "Mantendo transparências reduzidas"
    fi
else
    echo "Reduzindo transparências do sistema..."
    defaults write -g AppleReduceTransparency -bool true
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Transparências reduzidas com sucesso!${NC}"
        echo ""
        echo "⚠️  IMPORTANTE:"
        echo "   - Faça logout e login novamente para aplicar as mudanças"
        echo "   - Ou reinicie o Mac"
        echo "   - Isso reduzirá o uso de CPU do WindowServer"
    else
        echo -e "${RED}❌ Erro ao reduzir transparências${NC}"
        exit 1
    fi
fi

echo ""
echo "💡 Outras otimizações relacionadas:"
echo "   - Reduzir animações: defaults write -g NSAutomaticWindowAnimationsEnabled -bool false"
echo "   - Reduzir movimento: defaults write -g reduceMotion -bool true"

