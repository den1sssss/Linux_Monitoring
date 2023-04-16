# Проверка на количество аргументов
if [ "$#" -ne 3 ]; then
    echo "Требуется 3 аргумента"
    exit 1
fi

letters_dir=$1
letters_file_ext=$2
file_size=$3

# Валидация аргументов
if [ "${#letters_dir}" -gt 7 ] || [ "${#letters_file_ext}" -gt 10 ] || [ "$(echo $file_size | tr -d '0-9')" != "Mb" ] || [ "$(echo $file_size | tr -d 'Mb')" -gt 100 ]; then
    echo "Неверные аргументы"
    exit 1
fi

logfile="log_$(date '+%d%m%y_%H%M%S').txt"
start_time=$(date '+%d/%m/%Y %H:%M:%S')
echo "Начало работы: $start_time" | tee -a $logfile

function create_files() {
    local path=$1
    local n_files=$2

    for i in $(seq 1 $n_files); do
        file_name="${letters_file_ext:0:7}_$(date '+%d%m%y').${letters_file_ext:8:3}"
        full_path="${path}/${file_name}"
        dd if=/dev/zero of="$full_path" bs=1M count=$(echo $file_size | tr -d 'Mb') 2>/dev/null
        file_creation_date=$(date '+%d/%m/%Y %H:%M:%S')
        echo "Файл: $full_path, дата создания: $file_creation_date, размер: $file_size" | tee -a $logfile
    done
}

function check_free_space() {
    local free_space=$(df -h / | awk 'NR==2{print int($4)}')
    if [ $free_space -le 1024 ]; then
        return 1
    else
        return 0
    fi
}

while true; do
    random_folder=$(find / -maxdepth 3 -type d ! -regex ".*\(bin\|sbin\).*" 2>/dev/null | shuf -n 1)
    new_folder="${random_folder}/${letters_dir}_$(date '+%d%m%y')"

    if [[ $random_folder == /bin* ]] || [[ $random_folder == /sbin* ]]; then
        continue
    fi

    mkdir -p "$new_folder"
    echo "Папка: $new_folder" | tee -a $logfile

    n_files=$((RANDOM % 101))
    create_files "$new_folder" $n_files

    check_free_space
    if [ $? -eq 1 ]; then
        break
    fi
done

end_time=$(date '+%d/%m/%Y %H:%M:%S')
echo "Окончание работы: $end_time" | tee -a $logfile

start_sec=$(date -d "$start_time" +%s)
end_sec=$(date -d "$end_time" +%s)
elapsed_time=$((end_sec - start_sec))

echo "Общее время работы: ${elapsed_time} секунд" | tee -a $logfile