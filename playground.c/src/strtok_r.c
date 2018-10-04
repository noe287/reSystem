#include <stdio.h>
#include <string.h>
#include <net/if.h>
#include <netinet/ether.h>
#include <netinet/in.h>

#define PEERS "../txt/air_mesh_peers.txt"

int main(void)
{
    /* char str[] = "1,22,333,4444,55555"; */
    char *rest = NULL;
    char *token;
    char *saveptr;
    FILE *fds = NULL;
    int i = 0;
    char *line = NULL;
    char buf[128] = {0};
    const unsigned char zero_mac[ETH_ALEN] = {0};
    struct ether_addr mac;

    fds = fopen(PEERS, "r");
    if(fds == NULL) {
    	printf("Cannot find the file...\n");
    	return -1;
    }

    while((line = fgets(buf, sizeof(buf), fds)) != NULL)
    {
	if(strstr(line,"Name"))
		continue;

	if(strstr(line,"===="))
		continue;

    	for (token = strtok_r(line, " ", &saveptr); token != NULL; token = strtok_r(NULL, " ", &saveptr)) {
		get_bridge_mac = 0;
		if(strstr(token,":") && !strstr(token, ".") && !strstr(token,"00:"))
			if(get_bridge_mac == 0) {
				get_bridge_mac = 1;
				continue;
			}
			/* if(ether_aton_r(token, &mac)) */
				/* if(memcmp(mac.ether_addr_octet, zero_mac, ETH_ALEN)) */
					printf("token:%s\n", token);
	}

    }

    return 0;
}

/*   Name        Peer MAC        Peer Bridge MAC    Metric */
/* ========  =================  ================= ========== */
/*   wds1.2: 00:00:00:00:00:00  00:00:00:00:00:00       2941 */
/*   wds1.1: 78:3e:53:ff:72:60  78:3e:53:ff:72:62       2500 */
