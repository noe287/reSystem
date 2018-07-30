#include <stdio.h>
#include <string.h>

int main(){
	char str1[]="Rudolf 23432 is 12 years [ old";
	char *line = str1;
	char str [20];
	char *ptr = NULL;
	int i;
	char keys[]="[";


	i = strcspn(line, keys);

	printf("position :%d \n",i+1);
	/* ptr = strstr(str1,"["); */
	/* printf("ptr: %s \n", ptr); */
	

	/* strcpy(); */

	sscanf(line,"%s %*i %*s %d", str, &i);
	printf("%s --> %d\n", str, i);
	return 0;
}
