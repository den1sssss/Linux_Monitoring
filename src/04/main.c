// #include <stdio.h>
// #include <stdlib.h>
// #include <time.h>
// #include <string.h>

// #define NUM_FILES 5
// #define MIN_ENTRIES 100
// #define MAX_ENTRIES 1000
// #define MAX_IP_LEN 16
// #define MAX_DATE_LEN 64
// #define MAX_URL_LEN 1024
// #define MAX_AGENT_LEN 256
// #define NUM_RESPONSE_CODES 10
// #define NUM_METHODS 5
// #define NUM_AGENTS 9

// char *agents[NUM_AGENTS] = {
//     "Mozilla",
//     "Google Chrome",
//     "Opera",
//     "Safari",
//     "Internet Explorer",
//     "Microsoft Edge",
//     "Crawler and bot",
//     "Library and net tool",
//     "Other"
// };

// char *response_codes[NUM_RESPONSE_CODES] = {
//     "200",
//     "201",
//     "400",
//     "401",
//     "403",
//     "404",
//     "500",
//     "501",
//     "502",
//     "503"
// };

// char *methods[NUM_METHODS] = {
//     "GET",
//     "POST",
//     "PUT",
//     "PATCH",
//     "DELETE"
// };

// char *generate_ip() {
//     char *ip = (char *)malloc(MAX_IP_LEN);
//     sprintf(ip, "%d.%d.%d.%d", rand() % 255, rand() % 255, rand() % 255, rand() % 255);
//     return ip;
// }

// char *generate_date(int day) {
//     char *date = (char *)malloc(MAX_DATE_LEN);
//     time_t t = time(NULL);
//     struct tm *tm = localtime(&t);
//     sprintf(date, "[%02d/%s/%d:%02d:%02d:%02d +0000]", day, (tm->tm_mon + 1 == 1) ? "Jan" :
//      (tm->tm_mon + 1 == 2) ? "Feb" : (tm->tm_mon + 1 == 3) ? "Mar" :
//      (tm->tm_mon + 1 == 4) ? "Apr" : (tm->tm_mon + 1 == 5) ? "May" :
//      (tm->tm_mon + 1 == 6) ? "Jun" : (tm->tm_mon + 1 == 7) ? "Jul" :
//      (tm->tm_mon + 1 == 8) ? "Aug" : (tm->tm_mon + 1 == 9) ? "Sep" :
//      (tm->tm_mon + 1 == 10) ? "Oct" : (tm->tm_mon + 1 == 11) ? "Nov" : "Dec",
//      tm->tm_year + 1900, tm->tm_hour, tm->tm_min, tm->


