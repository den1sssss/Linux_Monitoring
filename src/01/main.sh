# !/bin/bash

# Проверка количества параметров
if [ $# -ne 6 ]; then
  echo "Usage: $0 <absolute_path> <number_of_folders> <folder_name_letters> <number_of_files> <file_name_letters> <file_size_in_kb>"
  exit 1
fi

# Проверка существования указанного пути
if [ ! -d "$1" ]; then
  echo "Error: specified path does not exist!!!"
  exit 1
fi

# Получение текущей даты в формате DDMMYY
current_date=$(date +"%d%m%y")

# Создание списка букв для имен папок и файлов
folder_name_letters=$3
file_name_letters=$5

# Проверка наличия символов az в списке букв
if [[ "$folder_name_letters" == *"az"* ]] || [[ "$file_name_letters" == *"az"* ]]; then
  echo "Error: characters 'az' cannot be used for folder or file names"
  exit 1
fi

# Создание папок
for ((i=1; i<=$2; i++))
do
  folder_name=$(echo "$folder_name_letters" | fold -w1 | shuf | tr -d '\n' | head -c 4)
  folder_name="${folder_name}_${current_date}"
  mkdir -p "$1/$folder_name"
  
  # Создание файлов в папке
  for ((j=1; j<=$4; j++))
  do
    file_name=$(echo "$file_name_letters" | fold -w1 | shuf | tr -d '\n' | head -c 7)
    file_ext=$(echo "$file_name_letters" | fold -w1 | shuf | tr -d '\n' | head -c 3)
    file_name="${file_name}.${file_ext}"
    dd if=/dev/urandom of="$1/$folder_name/$file_name" bs=1024 count=$6
  done
done

# Создание лог-файла
log_file="${1}/log_$(date +%Y%m%d_%H%M%S).txt"
echo "Created folders and files:" > "$log_file"
find "$1" -type f -printf "%p\t%TF %TT\t%s\n" >> "$log_file"

# Проверка свободного места
free_space=$(df -B 1G / | awk '{print $4}' | tail -n 1)
if (( $free_space <= 1 )); then
  echo "Error: not enough free space"
  exit 1
fi

echo "Success"
