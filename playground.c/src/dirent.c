#include <stdio.h>
#include <dirent.h>
#include <stdlib.h>

int main(void)
{
    struct dirent **namelist;
    int n,i;

    n = scandir(".", &namelist, NULL, alphasort);
    if (n < 0)
        perror("scandir");
    else {
		for (i = 0; i < n; i++) {
                	if (namelist[i]->d_name[0] == '.'
                   	 && (namelist[i]->d_name[1] == '\0'
                        	|| (namelist[i]->d_name[1] == '.'
                            	&& namelist[i]->d_name[2] == '\0')))
                        	continue;
            		printf("%s\n", namelist[i]->d_name);
		}
	}


    while (n--) {
         free(namelist[n]);
    }
    free(namelist);

    return 0;
}
