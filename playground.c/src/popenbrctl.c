#include <stdio.h>
#include <string.h>


int dumpinfo(FILE *fptr);

int main()
{
	FILE *fptr = NULL;
	char gw_ip[16] = {"0.0.0.0"};
	int ret = 0;
	char cmd[1024];

	sprintf(cmd, "brctl show");
	fptr = popen(cmd, "r");
	ret = dumpinfo(fptr);

	return 0;
}

int dumpinfo(FILE *fptr)
{
  char line[1024] = {0};
  char *read = NULL;

  while ((read = fgets(line, sizeof(line), fptr)) != NULL) {
	strstr("",);
	printf("%s", line);


  }

  return 0;
}
