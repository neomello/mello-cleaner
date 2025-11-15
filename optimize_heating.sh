#!/bin/bash

echo "🔧 OTIMIZAÇÃO PARA REDUZIR AQUECIMENTO"
echo "======================================"
echo ""

# Cores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "📋 AÇÕES RECOMENDADAS:"
echo "====================="
echo ""

# 1. Verificar processos pesados
echo "1️⃣ Verificando processos pesados..."
high_cpu=$(ps aux | awk 'NR>1 && $3 > 30.0 {print $2, $3, $11}' | head -5)
if [ -n "$high_cpu" ]; then
    echo -e "${YELLOW}⚠️ Processos com alto uso de CPU (>30%):${NC}"
    echo "$high_cpu" | while read pid cpu name; do
        echo "   PID: $pid | CPU: ${cpu}% | $name"
    done
else
    echo -e "${GREEN}✅ Nenhum processo com uso extremo de CPU${NC}"
fi
echo ""

# 2. Verificar WindowServer
echo "2️⃣ Verificando WindowServer..."
windowserver_cpu=$(ps aux | grep -i WindowServer | grep -v grep | awk '{print $3}')
if [ -n "$windowserver_cpu" ]; then
    cpu_val=$(echo "$windowserver_cpu" | head -1 | awk '{print int($1)}')
    if [ "$cpu_val" -gt 20 ]; then
        echo -e "${RED}⚠️ WindowServer usando ${cpu_val}% de CPU${NC}"
        echo "   💡 Dicas para reduzir:"
        echo "      - Feche janelas desnecessárias"
        echo "      - Reduza transparências (System Preferences > Accessibility > Display)"
        echo "      - Desative animações desnecessárias"
        echo "      - Verifique se há apps com muitas janelas abertas"
    else
        echo -e "${GREEN}✅ WindowServer está normal (${cpu_val}%)${NC}"
    fi
fi
echo ""

# 3. Verificar navegadores
echo "3️⃣ Verificando navegadores..."
chrome_count=$(ps aux | grep -i "Google Chrome" | grep -v grep | wc -l | xargs)
brave_count=$(ps aux | grep -i "Brave Browser" | grep -v grep | wc -l | xargs)

if [ "$chrome_count" -gt 15 ]; then
    echo -e "${YELLOW}⚠️ Google Chrome: $chrome_count processos ativos${NC}"
    echo "   💡 Considere fechar abas não utilizadas"
fi

if [ "$brave_count" -gt 10 ]; then
    echo -e "${YELLOW}⚠️ Brave Browser: $brave_count processos ativos${NC}"
    echo "   💡 Considere fechar abas não utilizadas"
fi

if [ "$chrome_count" -le 15 ] && [ "$brave_count" -le 10 ]; then
    echo -e "${GREEN}✅ Navegadores com uso normal${NC}"
fi
echo ""

# 4. Verificar memória
echo "4️⃣ Verificando uso de memória..."
mem_pressure=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print $5}' | sed 's/%//')
if [ -n "$mem_pressure" ]; then
    mem_val=$(echo "$mem_pressure" | awk '{print int($1)}')
    if [ "$mem_val" -lt 20 ]; then
        echo -e "${RED}⚠️ Memória livre: ${mem_val}% (baixa)${NC}"
        echo "   💡 Considere fechar aplicativos pesados"
    else
        echo -e "${GREEN}✅ Memória livre: ${mem_val}%${NC}"
    fi
fi
echo ""

# 5. Recomendações específicas
echo "💡 RECOMENDAÇÕES ESPECÍFICAS PARA SEU SISTEMA:"
echo "============================================="
echo ""

# Verificar se há muitos processos do Cursor
cursor_count=$(ps aux | grep -i Cursor | grep -v grep | wc -l | xargs)
if [ "$cursor_count" -gt 10 ]; then
    echo "📝 CURSOR:"
    echo "   - Você tem $cursor_count processos do Cursor ativos"
    echo "   - Feche extensões ou janelas não utilizadas"
    echo "   - Reinicie o Cursor se necessário"
    echo ""
fi

# Verificar Zoom
zoom_count=$(ps aux | grep -i Zoom | grep -v grep | wc -l | xargs)
if [ "$zoom_count" -gt 0 ]; then
    zoom_cpu=$(ps aux | grep -i Zoom | grep -v grep | awk '{sum+=$3} END {printf "%.1f", sum}')
    if [ -n "$zoom_cpu" ] && [ "$zoom_cpu" != "0" ]; then
        echo "📹 ZOOM:"
        echo "   - Zoom está usando ${zoom_cpu}% de CPU"
        echo "   - Feche o Zoom se não estiver em uso"
        echo ""
    fi
fi

# 6. Ações rápidas
echo "⚡ AÇÕES RÁPIDAS DISPONÍVEIS:"
echo "============================"
echo ""
echo "Para reduzir aquecimento imediatamente:"
echo ""
echo "1. Limpar caches:"
echo "   make organize"
echo ""
echo "2. Ver processos em tempo real:"
echo "   top -o cpu"
echo ""
echo "3. Matar processo específico (substitua PID):"
echo "   kill -9 <PID>"
echo ""
echo "4. Reiniciar serviços do sistema:"
echo "   sudo killall -HUP WindowServer  # CUIDADO: pode fazer logout"
echo ""
echo "5. Verificar temperatura contínua:"
echo "   sudo powermetrics -i 1000 -n 10 --samplers smc | grep -i temp"
echo ""

# 7. Verificar atividade de disco
echo "💿 Verificando atividade de disco..."
disk_activity=$(iostat -w 1 -c 2 2>/dev/null | tail -1 | awk '{print $3+$4}')
if [ -n "$disk_activity" ]; then
    disk_val=$(echo "$disk_activity" | awk '{print int($1)}')
    if [ "$disk_val" -gt 1000 ]; then
        echo -e "${YELLOW}⚠️ Alta atividade de disco detectada${NC}"
        echo "   Isso pode contribuir para o aquecimento"
    else
        echo -e "${GREEN}✅ Atividade de disco normal${NC}"
    fi
fi
echo ""

echo "✅ Análise concluída!"
echo ""
echo "📊 Para diagnóstico completo, execute:"
echo "   ./diagnose_heating.sh"

