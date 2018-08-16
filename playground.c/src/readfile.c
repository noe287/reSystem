#include <stdio.h>
#include <string.h>

#define FILED "wl_wps_configuuid_1"




int main(){
	FILE *fptr = NULL;
	char line[1024] = {0};
	char *red = NULL;

	fptr = fopen(FILED, "r");
	red = fgets(line, sizeof(line), fptr);
	line[strlen(line)-1] = '\0';
	printf("%s\n", red);
	printf("%s\n", line);

	return 0;
}

