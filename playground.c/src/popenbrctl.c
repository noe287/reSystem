#include <stdio.h>
#include <string.h>


int get_gw_ip(FILE *fptr, char *ifname, char *gw_ip);

int main()
{

	FILE *fptr = NULL;
	char gw_ip[16] = {"0.0.0.0"};
	char *ifname ="enp5s0";
	int ret = 0;
	char cmd[1024];

	sprintf(cmd, "brctl show");
	fptr = popen(cmd, "r");
	ret = get_gw_ip(fptr, ifname, gw_ip);

	if(gw_ip != NULL)
		printf("GWIP:%s\n",gw_ip);
	return 0;
}

int get_gw_ip(FILE *fptr, char *ifname, char *gw_ip)
{
  char line[1024] = {0};
  char *read = NULL;

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
