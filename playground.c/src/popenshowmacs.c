#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MACS "brctl showmacs br0"
#define STP "brctl showstp br0"

char *trim(char *s);
char *trimr(char *s);
char *triml(char *s);


int WlCommonCheckDefGwIface(char *defGwMac, char *gwIface);

int main()
{
	char iface[10] = {0};
	char gwMac[18] = "bc:ee:7b:8c:d9:33";
	int len = 0;

	WlCommonCheckDefGwIface(gwMac, iface);
	printf("RETURN:%s\n", iface);

	if(strcmp(iface, "eth0") == 0 || strcmp(iface, "wl0") == 0)
		printf("RETURN2:%s\n", iface);
	else
		printf("NULL***\n");

	return 0;
}

int WlCommonCheckDefGwIface(char *defGwMac, char *gwIface)
{
        int error = 0 , ret = 0;
        char *line = NULL;
        char buf[128];

        FILE *fds, *fds2 = NULL;
	/* char gwMac[18] = "18:28:61:5b:f6:21"; */
	int len = 0;
	char *portID = NULL;
	char *iface = NULL;
        char portIDstr[10];
	char *saveptr = NULL;

        fds = popen(MACS, "r");

        if (fds == NULL) {
                printf("Cannot open %s file error: %s", MACS, strerror(error));
                ret = -1;
                goto out;
        }

        while ((line = fgets(buf, sizeof(buf), fds)) != NULL) {
                if (strstr(line, defGwMac) == NULL) {
			continue;
                }
		else
		{
			line = trim(line);
			/* printf("%s\n", line); */
			/* for (portID = strtok_r(line, "\t", &saveptr); portID != NULL; portID = strtok_r(NULL, "\t", &saveptr)) { */
			/*  */
				/* printf("%s\n", portID); */
                        /*  */
			/* } */
			portID = strtok_r(line, "\t", &saveptr);// a single token will do it for the portID
			portID = trim(portID);

			sprintf(portIDstr,"(%s)", portID);

			printf("%s\n", portIDstr);

			fds2 = popen(STP, "r");
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
					strncpy(gwIface, iface, strlen(iface));
				}
			}
		}
	}
out:
        if (line) {
                free(line);
        }

        if (fds != NULL) {
                pclose(fds);
        }

        if (fds2 != NULL) {
                pclose(fds2);
        }

	return 0;
}

/* char *trim(char *totrim) */
/* { */
/* 	int len; */
/*  */
/* 	len = strlen (totrim) - 1; */
/* 	if (totrim[len] == '\n') */
/* 		totrim[len] = '\0'; */
/*  */
/* 	return totrim; */
/* } */

char *trimr(char *s)
{
        int i=0;
        while(s[i] != '\0') {
                i++;
        }
        i--;

        while(i>-1 && (s[i] == '\n' || s[i] == '\r' || s[i] == ' ' || s[i] == '\t')) {
                s[i--]='\0';
        }

        return s;
}


char *triml(char *s)
{
        int i=0, j=0;

        while((s[i] == ' ' || s[i] == '\t') && s[i] != '\0') {
                i++;
        }

        if (i==0) {
                return s;
        }

        do {
                s[j++]=s[i];
        } while(s[i++]!='\0');

        return s;
}


char *trim(char *s)
{
        return trimr(triml(s));
}

