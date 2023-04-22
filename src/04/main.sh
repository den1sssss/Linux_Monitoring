#!/bin/bash

# Массив возможных кодов ответа
status_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")

# Массив возможных методов
methods=("GET" "POST" "PUT" "PATCH" "DELETE")

# Массив возможных агентов
user_agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")

# Функция для генерации случайной даты
function random_date {
    local day=$1
    local month=$2
    local year=$3
    local hour=$((RANDOM%24))
    local minute=$((RANDOM%60))
    local second=$((RANDOM%60))
    echo "$(date -d "$year-$month-$day $hour:$minute:$second" "+[%d/%b/%Y:%H:%M:%S %z]")"
}

# Создаем директорию для логов, если ее еще нет
if [ ! -d "logs" ]; then
    mkdir logs
fi

# Генерируем 5 логов
for i in {1..5}; do
    # Генерируем случайное число записей от 100 до 1000
    num_entries=$((RANDOM%901+100))
    # Генерируем случайные записи для каждого лога
    for j in $(seq 1 $num_entries); do
        # Генерируем случайный IP
        ip=$(echo $((RANDOM%255+1)).$((RANDOM%255+1)).$((RANDOM%255+1)).$((RANDOM%255+1)))
        # Выбираем случайный код ответа
        status=${status_codes[$((RANDOM%10))]}
        # Выбираем случайный метод
        method=${methods[$((RANDOM%5))]}
        # Генерируем случайную дату для данного лога
        date=$(random_date $i 4 2023)
        # Генерируем случайный URL запроса
        url="/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $((RANDOM%20+1)) | head -n 1)"
        # Выбираем случайный агент
        user_agent=${user_agents[$((RANDOM%8))]}

        # Собираем строку лога
        log="$ip - - $date \"$method $url HTTP/1.1\" $status $((RANDOM%1000)) \"$user_agent\""

        # Записываем лог в файл
        echo $log >> logs/access.log.$i
    done
done
