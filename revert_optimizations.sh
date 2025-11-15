#!/bin/bash

echo "↩️  REVERTENDO OTIMIZAÇÕES DE PERFORMANCE"
echo "========================================"
echo ""

# Cores
GREEN='\033[0;32m'
NC='\033[0m'

echo "Revertendo todas as otimizações aplicadas..."
echo ""

# Reverter transparências
defaults write -g AppleReduceTransparency -bool false

# Reverter animações de janelas
defaults write -g NSAutomaticWindowAnimationsEnabled -bool true

# Reverter movimento
defaults write -g reduceMotion -bool false

# Reverter Dock
defaults delete com.apple.dock expose-animation-duration 2>/dev/null
defaults write com.apple.dock launchanim -bool true
defaults delete com.apple.dock autohide-delay 2>/dev/null
defaults write com.apple.dock no-bouncing -bool false

# Reverter Mission Control
defaults delete com.apple.dock mru-spaces 2>/dev/null

# Reverter Launchpad
defaults delete com.apple.dock springboard-show-duration 2>/dev/null
defaults delete com.apple.dock springboard-hide-duration 2>/dev/null

# Reverter transições
defaults delete -g NSWindowResizeTime 2>/dev/null

# Reativar Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool true

# Reiniciar Dock
killall Dock 2>/dev/null

echo -e "${GREEN}✅ Todas as otimizações foram revertidas${NC}"
echo ""
echo "Faça logout e login para aplicar as mudanças."

