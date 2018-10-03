#include <stdio.h>
#include <string.h>

#define PEERS "../txt/air_mesh_peers.txt"

int main(void)
{
    /* char str[] = "1,22,333,4444,55555"; */
    char *rest = NULL;
    char *token;
    FILE *fds = NULL;

    fds = fopen(PEERS, "r");


    for (token = strtok_r(str, ",", &rest); token != NULL; token = strtok_r(NULL, ",", &rest)) {
        printf("token:%s\n", token);
    }

    return 0;
}

/*   Name        Peer MAC        Peer Bridge MAC    Metric */
/* ========  =================  ================= ========== */
/*   wds1.2: 00:00:00:00:00:00  00:00:00:00:00:00       2941 */
/*   wds1.1: 78:3e:53:ff:72:60  78:3e:53:ff:72:62       2500 */
