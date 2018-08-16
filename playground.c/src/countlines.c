#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main(int argc, char *argv[])
{
	char *line = NULL;
	char buf[128] = {0};
	FILE *fp = NULL;
	int count = 0;

	fp = fopen("a.txt", "r");
	if (fp == NULL)
		return -1;

	while((line = fgets(buf, sizeof(buf), fp)) != NULL)
		count++;

	printf("count:%d\n", count);
	
	/* if (fp == NULL) */
	/* 	fclose(fp); */

	fp = fopen("a.txt", "r");
	if (fp == NULL)
		return -1;

	while((line = fgets(buf, sizeof(buf), fp)) != NULL)
		printf("%s", line);

	if (fp == NULL)
		fclose(fp);
	return 0;
}
