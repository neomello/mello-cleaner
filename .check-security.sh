#!/bin/bash

# 🔒 Script de Verificação de Segurança
# Verifica se há arquivos sensíveis sendo commitados ou expostos

echo "🔒 VERIFICAÇÃO DE SEGURANÇA DO REPOSITÓRIO"
echo "=========================================="
echo ""

ERRORS=0
WARNINGS=0

# Cores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# 1. Verificar se há arquivos sensíveis no staging
echo "1️⃣ Verificando arquivos no staging..."
SENSITIVE_FILES=$(git diff --cached --name-only | grep -E '\.(env|key|pem|secret|cert|mnemonic|seed)$|private-key|wallet\.json|keystore' || true)

if [ -n "$SENSITIVE_FILES" ]; then
    echo -e "${RED}❌ ERRO: Arquivos sensíveis encontrados no staging:${NC}"
    echo "$SENSITIVE_FILES"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ Nenhum arquivo sensível no staging${NC}"
fi
echo ""

# 2. Verificar se há credenciais hardcoded
echo "2️⃣ Verificando credenciais hardcoded..."
CREDENTIALS=$(grep -r -E "(password|secret|api_key|private_key|token)\s*[:=]\s*['\"][^'\"]+['\"]" --include="*.py" --include="*.js" --include="*.ts" --include="*.sol" . 2>/dev/null | grep -v ".git" | grep -v "venv" | grep -v "node_modules" || true)

if [ -n "$CREDENTIALS" ]; then
    echo -e "${YELLOW}⚠️  AVISO: Possíveis credenciais hardcoded encontradas:${NC}"
    echo "$CREDENTIALS" | head -10
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ Nenhuma credencial hardcoded encontrada${NC}"
fi
echo ""

# 3. Verificar se .env está sendo rastreado
echo "3️⃣ Verificando arquivos .env..."
ENV_FILES=$(git ls-files | grep -E "^\.env" || true)

if [ -n "$ENV_FILES" ]; then
    echo -e "${RED}❌ ERRO: Arquivos .env estão sendo rastreados pelo Git:${NC}"
    echo "$ENV_FILES"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ Nenhum arquivo .env está sendo rastreado${NC}"
fi
echo ""

# 4. Verificar arquivos não commitados importantes
echo "4️⃣ Verificando arquivos não commitados importantes..."
UNTRACKED_IMPORTANT=$(git ls-files --others --exclude-standard | grep -E "\.(env|key|pem|secret|mnemonic|seed)$|private-key|wallet\.json" || true)

if [ -n "$UNTRACKED_IMPORTANT" ]; then
    echo -e "${YELLOW}⚠️  AVISO: Arquivos sensíveis não rastreados encontrados:${NC}"
    echo "$UNTRACKED_IMPORTANT"
    echo -e "${YELLOW}   Certifique-se de que estão no .gitignore${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ Nenhum arquivo sensível não rastreado encontrado${NC}"
fi
echo ""

# 5. Verificar histórico recente por arquivos deletados
echo "5️⃣ Verificando arquivos deletados recentemente..."
DELETED_FILES=$(git log --all --since="7 days ago" --diff-filter=D --summary --name-only | grep -E "\.(py|js|ts|sol|json|yaml|yml)$" | sort -u | head -20 || true)

if [ -n "$DELETED_FILES" ]; then
    echo -e "${YELLOW}⚠️  AVISO: Arquivos deletados nos últimos 7 dias:${NC}"
    echo "$DELETED_FILES"
    echo -e "${YELLOW}   Verifique se foram deletados intencionalmente${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}✅ Nenhum arquivo importante deletado recentemente${NC}"
fi
echo ""

# 6. Verificar se .gitignore está atualizado
echo "6️⃣ Verificando .gitignore..."
if grep -q "\.env" .gitignore && grep -q "\.key" .gitignore && grep -q "\.secret" .gitignore; then
    echo -e "${GREEN}✅ .gitignore parece estar configurado corretamente${NC}"
else
    echo -e "${YELLOW}⚠️  AVISO: .gitignore pode não estar completo${NC}"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Resumo
echo "=========================================="
echo "📊 RESUMO DA VERIFICAÇÃO"
echo "=========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ Tudo seguro! Nenhum problema encontrado.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Verificação concluída com $WARNINGS aviso(s)${NC}"
    echo -e "${YELLOW}   Revise os avisos acima${NC}"
    exit 0
else
    echo -e "${RED}❌ ERRO: $ERRORS erro(s) e $WARNINGS aviso(s) encontrados${NC}"
    echo -e "${RED}   CORRIJA OS ERROS ANTES DE FAZER COMMIT!${NC}"
    exit 1
fi

