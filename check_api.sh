# Проверка доступности API через аргумент URL. Код возврата: 0 — успех, 1 — ошибка, 2 — неверный вызов.

set -u

usage() {
    echo "Usage: $0 <URL>"
    echo "Example: $0 https://httpbin.org/status/200"
    exit 2
}

if [[ $# -ne 1 ]]; then
    usage
fi

URL="$1"

# Проверка передачи http(s) URL
if ! [[ "$URL" =~ ^https?:// ]]; then
    echo "Ошибка: URL должен начинаться с http:// или https://"
    exit 2
fi

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$URL" 2>/dev/null)
CURL_EXIT=$?

if [[ $CURL_EXIT -ne 0 ]]; then
    echo "API недоступен, код ответа: N/A (ошибка соединения, curl exit=$CURL_EXIT)"
    exit 1
fi

if [[ "$HTTP_CODE" == "200" ]]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $HTTP_CODE"
    exit 1
fi