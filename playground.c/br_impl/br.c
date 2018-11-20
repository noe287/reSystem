#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#include "br.h"

#define SYSFS_CLASS_NET "/home/noe/DataDrive/reSystem/playground.c/txt/sys/class/net/"
#define SYSFS_PATH_MAX  256

#define ETHER_ADDR_STR_LEN                18


#define _WHITE   "\033[37;1m"
#define _BLUE    "\033[34;1m"
#define _RED     "\033[31;1m"
#define _GREEN   "\033[32;1m"
#define _YELLOW  "\033[33;2m"

#define _DGREEN  "\033[32;1m"
#define _NORM    "\033[0m"

#ifndef ETHER_STR
#define ETHER_STR       "%02x:%02x:%02x:%02x:%02x:%02x"
#endif

#ifndef ETHER_ADDR
#define ETHER_ADDR(s)   (unsigned char)s[0],\
                        (unsigned char)s[1],\
                        (unsigned char)s[2],\
                        (unsigned char)s[3],\
                        (unsigned char)s[4],\
                        (unsigned char)s[5]
#endif

#ifndef IP_STR
#define IP_STR          "%i.%i.%i.%i"
#endif

#ifndef IP_ADDR
#define IP_ADDR(a)      ((u_int8_t*)(&a))[0], ((u_int8_t*)(&a))[1], ((u_int8_t*)(&a))[2], ((u_int8_t*)(&a))[3]
#endif


int main()
{
        char *port_name = NULL;
        int rc = -1;
	unsigned char mac[6];

	//this is the gw address that the node has retreived its ip address.
        sscanf("00:50:56:a6:33:70", "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5]);

        if ((rc = br_find_mac_port_name("br0", mac, &port_name)) != 0) {
                printf("Can not find gateway MAC address in fdb table.\n");
                goto bail;
}
/* printf("GW MAC Address found behind interface: %s\n", port_name); */
        free(port_name);
bail:
        return rc;
}

static FILE *fpopen(const char *dir, const char *name)
{
        char path[SYSFS_PATH_MAX];

        snprintf(path, SYSFS_PATH_MAX, "%s/%s", dir, name);
        return fopen(path, "r");
}

static int read_sysfs_int(const char *path, const char *name)
{
        FILE *f = fpopen(path, name);
        int value = -1;

        if (!f)
                return 0;

        fscanf(f, "%i", &value);
        fclose(f);
        return value;
}

static inline void __copy_fdb(struct fdb_entry *ent,
                              const struct __fdb_entry *f)
{
        memcpy(ent->mac_addr, f->mac_addr, 6);
        ent->port_no = f->port_no;
}


static int br_read_fdb(const char *bridge, struct fdb_entry *fdblist,
                unsigned long offset, int num)
{
        FILE *f;
        int i, n;
        struct __fdb_entry fe[num];
        char path[SYSFS_PATH_MAX];

        snprintf(path, SYSFS_PATH_MAX, SYSFS_CLASS_NET "%s/brforward", bridge);
        f = fopen(path, "r");
        if (f) {
                fseek(f, offset*sizeof(struct __fdb_entry), SEEK_SET);
                n = fread(fe, sizeof(struct __fdb_entry), num, f);
                fclose(f);
        } else {
                return -1;
        }

        for (i = 0; i < n; i++)
                __copy_fdb(fdblist+i, fe+i);

        return n;
}

int br_read_fdb_list(const char *brname, struct fdb_entry **fdb)
{
#define CHUNK 128
        int n;
        int offset = 0;

        for(;;) {
                *fdb = realloc(*fdb, (offset + CHUNK) * sizeof(struct fdb_entry));
                if (!*fdb) {
                        printf("%s: Out of memory\n", __func__);
                        return -1;
                }

                n = br_read_fdb(brname, *fdb+offset, offset, CHUNK);
                if (n == 0)
                        break;

                if (n < 0) {
                        printf("read of forward table failed: %s\n",
                                strerror(errno));
                        free(*fdb);
                        return -1;
                }

                offset += n;
        }

        return offset;
}

int br_find_port_no(const char *port, unsigned *port_no)
{
        DIR *d;
        char path[SYSFS_PATH_MAX];


        snprintf(path, SYSFS_PATH_MAX, SYSFS_CLASS_NET "%s/brport", port);
        d = opendir(path);
        if (!d)
                return -1;

        *port_no = read_sysfs_int(path, "port_no");
	/* printf("Port_no:%i ->> interface: %s\n", *port_no, port); */
        closedir(d);
        return 0;
}

int br_find_port_name(const char *brname, const unsigned portno, char **port)
{
        int rc = 0;
        int i, count;
        struct dirent **namelist;
        char path[SYSFS_PATH_MAX];
        unsigned _portno;

        snprintf(path, SYSFS_PATH_MAX, SYSFS_CLASS_NET "%s/brif", brname);
        count = scandir(path, &namelist, 0, alphasort);
        if (count < 0)
                return -1;

        for (i = 0; i < count; i++) {
                if (namelist[i]->d_name[0] == '.'
                    && (namelist[i]->d_name[1] == '\0'
                        || (namelist[i]->d_name[1] == '.'
                            && namelist[i]->d_name[2] == '\0')))
                        continue;

                if (br_find_port_no(namelist[i]->d_name, &_portno)) {
                        rc = -1;
                        goto out;
                }
                if (portno == _portno) {
                        *port = strdup(namelist[i]->d_name);
                        goto out;
                }
        }

out:
        for (i = 0; i < count; i++)
                free(namelist[i]);
        free(namelist);

        return rc;
}

int br_find_mac_port_name(const char *brname, const uint8_t* mac, char **port_name)
{
        int i, fdb_count;
        struct fdb_entry *fdb_list = NULL;
        int rc = -1;

        if ((fdb_count = br_read_fdb_list(brname, &fdb_list)) > 0) {
                for (i = 0; i < fdb_count; i++) {
                        const struct fdb_entry *f = fdb_list + i;

                        if (memcmp(f->mac_addr, mac, 6) == 0) {
				printf("GW Mac address("ETHER_STR") is found in bridge's fdb with port_no:%d\n",ETHER_ADDR(f->mac_addr),f->port_no);
				printf("Looking for port_name(interface) with port_no:%d\n", f->port_no);
                                if (br_find_port_name(brname, f->port_no, port_name) != 0)
                                        goto bail;
                                else {
					printf("Gw access is through port_name: %s with port_no:%i\n", *port_name, f->port_no);
                                        rc = 0;
                                        break;
                                }
                        }
                }
                free(fdb_list);
        }

bail:
        return rc;
}
