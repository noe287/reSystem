#include <stdio.h>
#include <string.h>

#define NVRAM_FILE "nvram.txt"

int main()
{
        int error = 0 , ret = 0;
        char* line;
        char buf[128];
        FILE* fds = NULL;
	char serial_number[128] = {0};	
	int len = 0;

        fds = fopen(NVRAM_FILE, "r");


        if (fds == NULL) {
                printf("Cannot open nvram.txt file error: %s", strerror(error));
                ret = -1;
                goto out;
        }

        while ((line = fgets(buf, sizeof(buf), fds)) != NULL) {
                /* if (strstr(line, "SERIAL_NUMBER") == NULL) { */
                if (strstr(line, "MAC_BR_0") == NULL) {
                        continue;
                } else {
			len = strlen (line) - 1;
			if (line[len] == '\n')
		                line[len] = '\0';
                        printf("%s : %lu :%d\n", line, sizeof(buf), strlen(line));
                        strncpy(serial_number, line + strlen("MAC_BR_0") + 1, 18);
                        printf("%s\n", serial_number);
                        break;
                }
        }

out:
        if (fds != NULL) {
                fclose(fds);
        }
}
