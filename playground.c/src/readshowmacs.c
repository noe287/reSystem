#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MACS "../txt/showmacs.txt"
#define STP "../txt/showstp.txt"

char *trim(char *totrim);
char *WlCommonCheckDefGwIface(char *defGwMac);


int main()
{
	char iface[10] = {0};
	char gwMac[18] = "18:28:61:5b:f6:21";
	iface = WlCommonCheckDefGwIface(gwMac);
	printf("%s\n", iface);

	return 0;
}
        int error = 0 , ret = 0;
        char *line;
        char buf[128];
        /* char iface[10]; */

        FILE *fds, *fds2 = NULL;
	char gwMac[18] = "18:28:61:5b:f6:21";
	int len = 0;
	char *portID;
	char *iface;
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
			line = trim(line);
			printf("%s\n", line);

			portID = strtok_r(line, " ", &saveptr);// a single token will do it for the portID
			portID = trim(portID);

			sprintf(portIDstr,"(%s)", portID);
			printf("%s\n", portIDstr);

			fds2 = fopen(STP, "r");
        		if (fds2 == NULL) {
		                printf("Cannot open %s file error: %s", STP, strerror(error));
		                ret = -1;
		                goto out;
		        }

		        while ((line = fgets(buf, sizeof(buf), fds2)) != NULL) {
                		if (strstr(line, portIDstr) == NULL) {
					continue;
				}
				else
				{
					line = trim(line);
					printf("%s\n", line);

					iface = strtok_r(line, " ", &saveptr);// a single token will do it for the portID
					iface = trim(iface);

					printf("%s\n", iface);
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

char *trim(char *totrim)
{
	int len;

	len = strlen (totrim) - 1;
	if (totrim[len] == '\n')
		totrim[len] = '\0';

	return totrim;
}

