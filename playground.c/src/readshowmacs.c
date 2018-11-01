#include <stdio.h>
#include <string.h>

#define FILE "../txt/showmacx.txt"

int main(){
	FILE *fptr = NULL;
	char line[1024] = {0};
	char *red = NULL;

	fptr = fopen(FILE, "r");
	red = fgets(line, sizeof(line), fptr);
	line[strlen(line)-1] = '\0';
	printf("%s\n", red);
	printf("%s\n", line);

	return 0;
}

