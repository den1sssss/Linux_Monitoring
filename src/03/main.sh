# #!/bin/bash

# # Проверяем, что был передан один параметр - способ очистки
# if [[ $# -ne 1 ]]; then
#     echo "Usage: $0 <cleanup_method>"
#     echo "    cleanup_method: 1 - by log file, 2 - by creation date/time, 3 - by name mask"
#     exit 1
# fi

# # Определяем переменные для временного интервала, если методом выбрана очистка по дате/времени
# if [[ $1 -eq 2 ]]; then
#     echo -n "Enter start time (format: YYYY-MM-DD HH:mm): "
#     read start_time
#     start_timestamp=$(date -d "$start_time" +%s)
#     if [[ $? -ne 0 ]]; then
#         echo "Invalid start time format. Use format: YYYY-MM-DD HH:mm"
#         exit 1
#     fi

#     echo -n "Enter end time (format: YYYY-MM-DD HH:mm): "
#     read end_time
#     end_timestamp=$(date -d "$end_time" +%s)
#     if [[ $? -ne 0 ]]; then
#         echo "Invalid end time format. Use format: YYYY-MM-DD HH:mm"
#         exit 1
#     fi
# fi

# # Определяем функцию удаления файла или директории
# function delete_file_or_dir {
#     local path=$1
#     if [[ -d $path ]]; then
#         rm -rf "$path"
#     elif [[ -f $path ]]; then
#         rm -f "$path"
#     fi
# }

# # Определяем функцию для очистки по лог файлу
# function cleanup_by_log {
#     if [[ ! -f "./cleanup.log" ]]; then
#         echo "Cleanup log file not found."
#         exit 1
#     fi

#     # Читаем лог файл построчно и удаляем каждую папку или файл, указанные в логе
#     while read line; do
#         delete_file_or_dir "$line"
#     done < "./cleanup.log"
# }

# # Определяем функцию для очистки по дате/времени создания
# function cleanup_by_date {
#     # Ищем все папки и файлы в текущей директории и ее поддиректориях
#     # и фильтруем по времени создания в указанном интервале
#     find . -mindepth 1 -printf "%T@ %p\n" | \
#         awk -v start_timestamp="$start_timestamp" -v end_timestamp="$end_timestamp" \
#             '{if ($1 >= start_timestamp && $1 <= end_timestamp) print $2}' | \
#         while read file; do
#             delete_file_or_dir "$file"
#         done
# }

# # Определяем функцию для очистки по маске имени
# function cleanup_by_name_mask {
#     echo -n "Enter name mask (e.g. aaazz_021121): "
#     read name_mask
#     if [[ ! "$name_mask" =~ ^[a-zA-Z]{5,7}_[0-9]{6}$ ]]; then
#         echo "Invalid"



#!/bin/bash

# Получаем выбранный способ очистки и параметры
clear_method=$1
clear_param=$2

# Функция для удаления файлов и папок по маске имени
clear_by_mask() {
  # Ищем все папки и файлы по маске имени и удаляем их
  find / -name "*${clear_param}*" -exec rm -rf {} \;
}

# Функция для удаления файлов и папок по дате и времени создания
clear_by_date() {
  # Проверяем, что даты указаны корректно
  if ! date -d "$1" >/dev/null 2>&1; then
    echo "Некорректная дата начала. Пример: 2022-01-01 00:00"
    exit 1
  fi
  if ! date -d "$2" >/dev/null 2>&1; then
    echo "Некорректная дата конца. Пример: 2022-01-02 00:00"
    exit 1
  fi

  # Преобразуем даты в формат UNIX timestamp
  start=$(date -d "$1" +"%s")
  end=$(date -d "$2" +"%s")

  # Ищем все файлы и папки, созданные в указанный период и удаляем их
  find / -type f -newermt "$1" ! -newermt "$2" -exec rm -rf {} \;
  find / -type d -newermt "$1" ! -newermt "$2" -exec rm -rf {} \;
}

# Функция для удаления файлов и папок по лог файлу
clear_by_log() {
  # Проверяем, что файл существует
  if [ ! -f "$clear_param" ]; then
    echo "Файл $clear_param не найден"
    exit 1
  fi

  # Читаем файл построчно и удаляем каждый файл и папку
  while read line; do
    rm -rf "$line"
  done < "$clear_param"
}

# Выполняем очистку в зависимости от выбранного способа
case "$clear_method" in
  "1")
    clear_by_log
    ;;
  "2")
    # Если параметры не заданы, запрашиваем у пользователя
    if [ -z "$clear_param" ]; then
      echo "Введите дату начала в формате YYYY-MM-DD HH:MM"
      read start_date
      echo "Введите дату конца в формате YYYY-MM-DD HH:MM"
      read end_date
    fi
    clear_by_date "$start_date" "$end_date"
    ;;
 
