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
			for (token = strtok_r(line, " ", &saveptr); token != NULL; token = strtok_r(NULL, " ", &saveptr)) {
		                if(strstr(token,":") && !strstr(token, ".") && !strstr(token,"00:")){
                		        if(get_bridge_mac == 0) {
                                		get_bridge_mac = 1;
		                                continue;
                		        }
	        	                get_bridge_mac = 0;
        	        	        if(ether_aton_r(token, &mac)){
                               		/* if(memcmp(mac.ether_addr_octet, zero_mac, ETH_ALEN)) */
	                                        printf("token:%s: MAC:"MACSTR"\n", token, MAC2STR(mac.ether_addr_octet));
        	                                /* printf("token:%s: MAC:%02x\n", token, mac.ether_addr_octet[0]); */
                        		}
                		}
        		}


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
