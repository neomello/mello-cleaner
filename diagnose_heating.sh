#!/bin/bash

echo "🌡️ DIAGNÓSTICO DE AQUECIMENTO DO MAC"
echo "===================================="
echo ""

# Cores para output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "📊 COLETANDO DADOS DO SISTEMA..."
echo "================================"
echo ""

# 1. Informações do Sistema
echo "💻 INFORMAÇÕES DO SISTEMA:"
echo "-------------------------"
sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "CPU: Não detectado"
sysctl -n hw.ncpu 2>/dev/null | xargs echo "Núcleos:"
sysctl -n hw.physicalcpu 2>/dev/null | xargs echo "Núcleos físicos:"
sysctl -n hw.memsize 2>/dev/null | awk '{printf "Memória RAM: %.2f GB\n", $1/1024/1024/1024}'
echo ""

# 2. Temperatura (se disponível)
echo "🌡️ TEMPERATURA DO SISTEMA:"
echo "-------------------------"
if command_exists powermetrics; then
    echo "Coletando temperatura (aguarde 5 segundos)..."
    sudo powermetrics -i 1000 -n 1 --samplers smc 2>/dev/null | grep -i "temperature\|temp" | head -10 || echo "Temperatura não disponível via powermetrics"
else
    echo "⚠️ powermetrics não disponível. Instale Xcode Command Line Tools:"
    echo "   xcode-select --install"
fi
echo ""

# 3. Uso de CPU por Processo (Top 15)
echo "🔥 PROCESSOS CONSUMINDO MAIS CPU:"
echo "--------------------------------"
ps aux | sort -nrk 3,3 | head -16 | awk 'NR==1 {printf "%-20s %6s %6s %10s %s\n", "PROCESSO", "CPU%", "MEM%", "PID", "COMANDO"} NR>1 {printf "%-20s %6.1f %6.1f %10s %s\n", $11, $3, $4, $2, substr($0, index($0,$11))}'
echo ""

# 4. Uso de Memória por Processo (Top 15)
echo "💾 PROCESSOS CONSUMINDO MAIS MEMÓRIA:"
echo "-----------------------------------"
ps aux | sort -nrk 4,4 | head -16 | awk 'NR==1 {printf "%-20s %6s %6s %10s %s\n", "PROCESSO", "CPU%", "MEM%", "PID", "COMANDO"} NR>1 {printf "%-20s %6.1f %6.1f %10s %s\n", $11, $3, $4, $2, substr($0, index($0,$11))}'
echo ""

# 5. Uso Geral de CPU
echo "⚡ USO GERAL DE CPU:"
echo "-------------------"
top -l 1 | grep "CPU usage" | sed 's/CPU usage: //'
echo ""

# 6. Uso de Memória
echo "📊 USO DE MEMÓRIA:"
echo "-----------------"
vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
echo ""

# 7. Atividade de Disco
echo "💿 ATIVIDADE DE DISCO:"
echo "---------------------"
iostat -w 1 -c 2 2>/dev/null | tail -1 | awk '{printf "Leitura: %s KB/s | Escrita: %s KB/s\n", $3, $4}' || echo "iostat não disponível"
echo ""

# 8. Processos em Execução
echo "🔄 TOTAL DE PROCESSOS:"
echo "--------------------"
echo "Total: $(ps aux | wc -l | xargs) processos"
echo ""

# 9. Processos com Alto Uso de CPU (>50%)
echo "⚠️ PROCESSOS COM ALTO USO DE CPU (>50%):"
echo "---------------------------------------"
high_cpu=$(ps aux | awk 'NR>1 && $3 > 50.0 {printf "%-20s %6.1f%% (PID: %s)\n", $11, $3, $2}')
if [ -z "$high_cpu" ]; then
    echo "✅ Nenhum processo com uso de CPU > 50%"
else
    echo -e "${RED}$high_cpu${NC}"
fi
echo ""

# 10. Processos com Alto Uso de Memória (>10%)
echo "⚠️ PROCESSOS COM ALTO USO DE MEMÓRIA (>10%):"
echo "-------------------------------------------"
high_mem=$(ps aux | awk 'NR>1 && $4 > 10.0 {printf "%-20s %6.1f%% (PID: %s)\n", $11, $4, $2}')
if [ -z "$high_mem" ]; then
    echo "✅ Nenhum processo com uso de memória > 10%"
else
    echo -e "${YELLOW}$high_mem${NC}"
fi
echo ""

# 11. Verificar processos suspeitos comuns
echo "🔍 VERIFICANDO PROCESSOS COMUNS QUE CAUSAM AQUECIMENTO:"
echo "------------------------------------------------------"
suspicious_processes=("Google Chrome" "Google Chrome Helper" "Slack" "Spotify" "Zoom" "Teams" "Docker" "node" "python" "java" "Xcode" "Photoshop" "Final Cut" "HandBrake" "ffmpeg")

for proc in "${suspicious_processes[@]}"; do
    count=$(ps aux | grep -i "$proc" | grep -v grep | wc -l | xargs)
    if [ "$count" -gt 0 ]; then
        cpu_usage=$(ps aux | grep -i "$proc" | grep -v grep | awk '{sum+=$3} END {printf "%.1f", sum}')
        mem_usage=$(ps aux | grep -i "$proc" | grep -v grep | awk '{sum+=$4} END {printf "%.1f", sum}')
        if [ -n "$cpu_usage" ] && [ "$cpu_usage" != "0" ]; then
            echo "  ⚠️ $proc: $count processo(s) | CPU: ${cpu_usage}% | Mem: ${mem_usage}%"
        fi
    fi
done
echo ""

# 12. Verificar atividade de rede
echo "🌐 ATIVIDADE DE REDE:"
echo "--------------------"
if command_exists netstat; then
    connections=$(netstat -an | grep ESTABLISHED | wc -l | xargs)
    echo "Conexões estabelecidas: $connections"
fi
echo ""

# 13. Verificar processos do sistema
echo "⚙️ PROCESSOS DO SISTEMA (kernel_task, WindowServer, etc.):"
echo "--------------------------------------------------------"
system_procs=("kernel_task" "WindowServer" "launchd" "mds" "mdworker")
for proc in "${system_procs[@]}"; do
    cpu=$(ps aux | grep "$proc" | grep -v grep | awk '{sum+=$3} END {printf "%.1f", sum}')
    mem=$(ps aux | grep "$proc" | grep -v grep | awk '{sum+=$4} END {printf "%.1f", sum}')
    if [ -n "$cpu" ] && [ "$cpu" != "0" ]; then
        echo "  $proc: CPU ${cpu}% | Mem ${mem}%"
    fi
done
echo ""

# 14. Recomendações
echo "💡 RECOMENDAÇÕES:"
echo "----------------"
echo "1. Feche aplicativos que não estão em uso"
echo "2. Verifique processos com alto uso de CPU/Memória acima"
echo "3. Reinicie o Mac se o problema persistir"
echo "4. Verifique se há atualizações pendentes"
echo "5. Limpe caches e arquivos temporários (use: make organize)"
echo "6. Verifique se há malware ou processos suspeitos"
echo ""

# 15. Salvar relatório
REPORT_FILE="$HOME/Desktop/diagnostico_aquecimento_$(date +%Y%m%d_%H%M%S).txt"
{
    echo "RELATÓRIO DE DIAGNÓSTICO DE AQUECIMENTO"
    echo "Gerado em: $(date)"
    echo "========================================"
    echo ""
    ps aux | sort -nrk 3,3 | head -20
    echo ""
    echo "--- Uso de Memória ---"
    vm_stat
} > "$REPORT_FILE" 2>/dev/null

echo "📄 Relatório completo salvo em: $REPORT_FILE"
echo ""
echo "✅ Diagnóstico concluído!"

