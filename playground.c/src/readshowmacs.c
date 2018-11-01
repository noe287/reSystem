#include <stdio.h>
#include <string.h>

#define BR0 "../txt/showmacs.txt"

int main()
{
        int error = 0 , ret = 0;
        char *line;
        char buf[128];
        FILE *fds = NULL;
	char gwMac[18] = "18:28:61:5b:f6:21";
	int len = 0;
	char *token;
	char *saveptr;

        fds = fopen(BR0, "r");

        if (fds == NULL) {
                printf("Cannot open %s file error: %s", BR0, strerror(error));
                ret = -1;
                goto out;
        }

        while ((line = fgets(buf, sizeof(buf), fds)) != NULL) {
                /* if (strstr(line, "SERIAL_NUMBER") == NULL) { */
                if (strstr(line, gwMac) == NULL) {
			continue;
                } else {
			len = strlen (line) - 1;
			if (line[len] == '\n')
		                line[len] = '\0';
			printf("%s\n", line);
                        /* printf(" %s : %lu :%lu \n", line, sizeof(buf), strlen(line)); */
                        /* strncpy(serial_number, line + strlen("MAC_BR_0") + 1, 18); */
                        /* printf("%s\n", serial_number); */
                }
        }

out:
        if (fds != NULL) {
                fclose(fds);
        }
}
