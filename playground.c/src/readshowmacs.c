#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MACS "../txt/showmacs.txt"
#define STP "../txt/showstp.txt"

int main()
{
        int error = 0 , ret = 0;
        char *line;
        char buf[128];
        char iface[10];

        FILE *fds, *fds2 = NULL;
	char gwMac[18] = "18:28:61:5b:f6:21";
	int len = 0;
	char *portID;
        char portIDstr[10];
	char *saveptr;

        fds = fopen(MACS, "r");

        if (fds == NULL) {
                printf("Cannot open %s file error: %s", MACS, strerror(error));
                ret = -1;
                goto out;
        }

        while ((line = fgets(buf, sizeof(buf), fds)) != NULL) {
                if (strstr(line, gwMac) == NULL) {
			continue;
                }
		else
		{
			len = strlen (line) - 1;
			if (line[len] == '\n')
		                line[len] = '\0';
			printf("%s\n", line);

			portID = strtok_r(line, " ", &saveptr);// a single token will do it for the portID
			printf("%s\n", portID);
			sprintf(portIDstr,"(%s)", portID);
			printf("%s\n", portIDstr);

			fds2 = fopen(STP, "r");
        		if (fds2 == NULL) {
		                printf("Cannot open %s file error: %s", STP, strerror(error));
		                ret = -1;
		                goto out;
		        }

		        while ((line = fgets(buf, sizeof(buf), fds)) != NULL) {
                		if (strstr(line, portIDstr) == NULL) {
					continue;
				}
				else
				{
					len = strlen (line) - 1;
					if (line[len] == '\n')
						line[len] = '\0';
					printf("%s\n", line);
				}
			}
		}
	}
out:
        if (line) {
                free(line);
        }

        if (fds != NULL) {
                fclose(fds);
        }

        if (fds2 != NULL) {
                fclose(fds2);
        }
}
