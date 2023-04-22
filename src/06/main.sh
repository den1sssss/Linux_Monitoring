sudo apt-get install goaccess

# Для вывода информации о посетителях и кодах ответа, можно использовать следующую команду:
goaccess /path/to/nginx/access.log -a -c

# Для вывода информации об уникальных IP-адресах:
goaccess /path/to/nginx/access.log -a -c --log-format=COMBINED -o /dev/null --real-os

# Для вывода информации об ошибках (код ответа - 4хх или 5хх):
goaccess /path/to/nginx/access.log -a -c --log-format=COMBINED -o /dev/null --http-err

# Для вывода информации об уникальных IP-адресах, которые встречаются среди ошибочных запросов:
goaccess /path/to/nginx/access.log -a -c --log-format=COMBINED -o /dev/null --http-err --real-os
