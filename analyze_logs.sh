# Генерирует тестовый access.log и анализирует его (grep/awk/sort/uniq/regexp).

set -euo pipefail

LOG_FILE="access.log"
LINES=${LINES:-300}

generate_log() {
    local methods=("GET" "POST" "PUT" "DELETE")
    local paths=("/api/users" "/api/login" "/api/orders" "/api/health" "/api/products")
    local codes=(200 200 200 200 201 301 400 401 403 404 500 502)
    local ips=(
        "192.168.1.10" "192.168.1.11" "192.168.1.12"
        "10.0.0.5" "10.0.0.6" "172.16.0.20" "172.16.0.21"
        "8.8.8.8" "1.1.1.1"
    )

    : > "$LOG_FILE"
    for ((i = 0; i < LINES; i++)); do
        local ip="${ips[RANDOM % ${#ips[@]}]}"
        local method="${methods[RANDOM % ${#methods[@]}]}"
        local path="${paths[RANDOM % ${#paths[@]}]}"
        local code="${codes[RANDOM % ${#codes[@]}]}"
        # Формируем дату
        local ts
        ts=$(date -u -d "-$((RANDOM % 86400)) seconds" +'%d/%b/%Y:%H:%M:%S' 2>/dev/null \
             || date -u -v-"$((RANDOM % 86400))"S +'%d/%b/%Y:%H:%M:%S')
        printf '%s - - [%s +0000] "%s %s HTTP/1.1" %s\n' \
            "$ip" "$ts" "$method" "$path" "$code" >> "$LOG_FILE"
    done
    echo "Сгенерирован $LOG_FILE ($LINES строк)."
}

if [[ ! -f "$LOG_FILE" ]]; then
    generate_log
fi

echo "       Анализ $LOG_FILE       "

# 1) Общее число запросов
TOTAL=$(wc -l < "$LOG_FILE")
echo "Всего запросов: $TOTAL"

# 2) Топ-3 IP с наибольшим числом запросов
#    Регулярное выражение для IPv4:
IP_REGEX='^([0-9]{1,3}\.){3}[0-9]{1,3}'
echo
echo "Топ-3 IP по числу запросов:"
grep -Eo "$IP_REGEX" "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -n 3 \
    | awk '{ printf "  %s — %s запросов\n", $2, $1 }'

# 3) Количество 4xx и 5xx
echo
ERR4=$(awk '$9 ~ /^4[0-9][0-9]$/ { c++ } END { print c+0 }' "$LOG_FILE")
ERR5=$(awk '$9 ~ /^5[0-9][0-9]$/ { c++ } END { print c+0 }' "$LOG_FILE")
echo "Запросы 4xx: $ERR4"
echo "Запросы 5xx: $ERR5"