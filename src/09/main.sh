#!/bin/bash

# Функция для получения значения ЦПУ
function get_cpu_usage() {
  # Получаем значение загрузки ЦПУ за последнюю секунду
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

  # Возвращаем значение загрузки ЦПУ
  echo "${CPU_USAGE}"
}

# Функция для получения значения оперативной памяти
function get_memory_usage() {
  # Получаем значения памяти из вывода команды free
  MEMORY_TOTAL=$(free -m | grep Mem | awk '{print $2}')
  MEMORY_USED=$(free -m | grep Mem | awk '{print $3}')
  MEMORY_FREE=$(free -m | grep Mem | awk '{print $4}')

  # Вычисляем процент использования оперативной памяти
  MEMORY_USAGE=$(echo "scale=2; ${MEMORY_USED}/${MEMORY_TOTAL} * 100" | bc)

  # Возвращаем значение процента использования оперативной памяти
  echo "${MEMORY_USAGE}"
}

# Функция для получения значения объема жесткого диска
function get_disk_usage() {
  # Получаем значения объема жесткого диска из вывода команды df
  DISK_TOTAL=$(df -BM / | tail -n 1 | awk '{print $2}' | sed 's/M//')
  DISK_USED=$(df -BM / | tail -n 1 | awk '{print $3}' | sed 's/M//')

  # Вычисляем процент использования жесткого диска
  DISK_USAGE=$(echo "scale=2; ${DISK_USED}/${DISK_TOTAL} * 100" | bc)

  # Возвращаем значение процента использования жесткого диска
  echo "${DISK_USAGE}"
}

# Формируем html-страницу по формату Prometheus
while true; do
  # Получаем значения метрик
  CPU_USAGE=$(get_cpu_usage)
  MEMORY_USAGE=$(get_memory_usage)
  DISK_USAGE=$(get_disk_usage)

  # Формируем html-страницу
  cat <<EOF > /var/www/html/metrics
# TYPE system_cpu_usage gauge
system_cpu_usage ${CPU_USAGE}
# TYPE system_memory_usage gauge
system_memory_usage ${MEMORY_USAGE}
# TYPE system_disk_usage gauge
system_disk_usage ${DISK_USAGE}
EOF

  # Ждем 3 секунды перед обновлением страницы
  sleep 3
done
