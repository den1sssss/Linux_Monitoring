#!/bin/bash

log_files=("access.log.1" "access.log.2" "access.log.3" "access.log.4")

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [1|2|3|4]"
    exit 1
fi

if ! [[ "$1" =~ ^[1-4]$ ]]; then
    echo "Error: parameter must be 1, 2, 3 or 4"
    exit 1
fi

case "$1" in
    1)
        awk '{print $9, $7}' "${log_files[@]}" | sort -n
        ;;
    2)
        awk '{print $1}' "${log_files[@]}" | sort -u
        ;;
    3)
        awk '$9 ~ /^[45]/ {print}' "${log_files[@]}"
        ;;
    4)
        awk '$9 ~ /^[45]/ {print $1}' "${log_files[@]}" | sort -u
        ;;
    *)
        echo "Error: invalid parameter value"
        exit 1
esac


# Описание скрипта:
# 
# В начале скрипта задается массив с именами файлов логов.
# Скрипт проверяет, что количество переданных параметров равно 1 и параметр является числом 1, 2, 3 или 4.
# В зависимости от значения параметра выполняется определенный блок кода:
# Параметр 1 - выводятся все записи из всех файлов, отсортированные по коду ответа.
# Параметр 2 - выводятся все уникальные IP-адреса, встречающиеся в записях из всех файлов.
# Параметр 3 - выводятся все запросы с ошибками (код ответа - 4xx или 5xx) из всех файлов.
# Параметр 4 - выводятся все уникальные IP-адреса, которые встречаются среди ошибочных запросов из всех файлов.
# В блоках кода используются команды awk для обработки файлов логов.
# Для вывода результатов используются команды sort и uniq.