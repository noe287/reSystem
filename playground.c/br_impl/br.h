#ifndef _STATS_BR_H
#define _STATS_BR_H

#include <netinet/in.h>

#include <linux/if.h>
#include <linux/if_bridge.h>

struct fdb_entry
{
        uint8_t mac_addr[6];
        uint16_t port_no;
};

int br_read_fdb_list(const char *brname, struct fdb_entry **fdb);
int br_find_port_name(const char *brname, unsigned portno, char **port);
int br_find_port_no(const char *port, unsigned *port_no);
int br_find_mac_port_name(const char *brname, const uint8_t* mac, char **port_name);

#endif

