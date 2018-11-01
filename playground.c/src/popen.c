#include <stdio.h>



int awf_get_bridge_name_from_ifname(char *ifname, char *br_ifname)
{
        char cmd[1024];
        int read;
        size_t len;
        char *line = NULL;
        char brname[IFNAMSIZ];
        int found = 0;
        char *ctx;
        FILE *fd;

        sprintf(cmd, "brctl show");

        fd = popen(cmd, "r");

        while (fd && (!feof(fd)) && ((read = getline(&line, &len, fd)) != -1)) {
                /* printf("got line %s", line); */

                /* get rid of first line */
                if (strncmp(line, "bridge", 6) == 0) {
                        goto nextline;
                }

                /* detect if the line starts with an ifname, i.e. next bridge name */
                if (strncmp(line, "\t", 1) != 0) {
                        char *pch = strtok_r(line," \t\n", &ctx);
                        if (pch == NULL) {
                                PRINT(LEVEL_ERR, "Could not find bridge name. Fetched line = %s\n", line);
                                pclose(fd);
                                return 0;
                        }

                        strcpy(brname, pch);
                        /* printf("bridge name=%s\n", brname); */

                        /* skip bridge id and stp enabled fields */
                        pch = strtok_r(NULL," \t\n", &ctx);
                        /* printf("skip %s\n", pch); */
                        pch = strtok_r(NULL," \t\n", &ctx);
                        /* printf("skip %s\n", pch); */

                        pch = strtok_r(NULL," \t\n", &ctx);
                        if (pch == NULL) {
                                PRINT(LEVEL_ERR, "Could not get any interface name. Fetched line = %s\n", line);
                                pclose(fd);
                                return 0;
                        }

                        if (strcmp(pch, ifname) == 0) {
                                found = 1;
                                PRINT(LEVEL_DEBUG, "Bridge name found at line %s\n", line);
                                strcpy(br_ifname, brname);
                                break;
                        }

                        goto nextline;
                }

                /* trim and get the ifname */
                awf_trim(line);

                if (strcmp(line, ifname) == 0) {
                        found = 1;
                        PRINT(LEVEL_DEBUG, "Bridge name found at line %s\n", line);
                        strcpy(br_ifname, brname);
                        break;
                }

nextline:
                if (line)
                        free(line);
                line = NULL;
        }

        if (fd)
                pclose(fd);

        if (line)
                free(line);
        line = NULL;

        return found;
}
