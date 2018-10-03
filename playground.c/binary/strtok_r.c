#include <stdio.h>
#include <string.h>

int main(void)
{
    char str[] = "1,22,333,4444,55555";
    char *rest = NULL;
    char *token;

    for (token = strtok_r(str, ",", &rest);
         token != NULL;
         token = strtok_r(NULL, ",", &rest)) {
        printf("token:%s\n", token);
    }

    return 0;
}
