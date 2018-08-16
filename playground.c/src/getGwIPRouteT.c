#include <stdio.h>
#include <string.h>

/* # route -n */
/* Kernel IP routing table */
/* Destination     Gateway         Genmask         Flags Metric Ref    Use Iface */
/* 0.0.0.0         172.16.0.1      0.0.0.0         UG    0      0        0 br0 */
/* 172.16.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br0 */

int get_gw_ip(FILE *fptr, char *ifname, char *gw_ip);

int main(){
	FILE *fptr = NULL;
	char gw_ip[16] = {"0.0.0.0"};
	char line[1024] = {0};
	char *read = NULL;
	char *ifname ="enp5s0";
	int ret = 0;

	fptr = popen("route -n", "r");
	ret = get_gw_ip(fptr, ifname, gw_ip);

	/* while ((read = fgets(line, sizeof(line), fptr)) != NULL) { */
	/* 	printf("rEAD:%s\n",read); */
	/* 	if (strstr(read, "UG") != NULL)  */
	/* 		if (strstr(read, "enp5s0") != NULL) { */
	/* 			sscanf(read,"%*s %s", gw_ip); */
	/* 			break; */
	/* 		}	 */
	/* } */
	if(gw_ip != NULL)
		printf("GWIP:%s\n",gw_ip);
	return 0;
}

int get_gw_ip(FILE *fptr, char *ifname, char *gw_ip)
{
  char line[1024] = {0};
  char *read = NULL;

  fptr = popen("route -n", "r");

  while ((read = fgets(line, sizeof(line), fptr)) != NULL) {
	  if (strstr(read, "UG") != NULL) {
			if (strstr(read, ifname) != NULL) {
			  sscanf(read,"%*s %s", gw_ip);
			  break;
			}
	  }
  }

  return 0;
}
