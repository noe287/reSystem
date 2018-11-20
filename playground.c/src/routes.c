#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <error.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

// Private Constant Definitions
#define MAX_INST_SIZE           64
#define UI_FX_TIMEOUT           120

#define WPS_OUI_FIXED_HEADER_OFF        16
#define WPS_OUI_HEADER_LEN              2
#define WPS_OUI_HEADER_SIZE             4
#define WPS_OUI_LEN                     3
#define WPS_ID_APP_LIST                 0x1058

#define VNDR_IE_MAX_LEN                 255

#define SCAN_STATUS_NOSCAN      0
#define SCAN_STATUS_INSCAN      1
#define SCAN_STATUS_UNKNOWN     (-1)

#define AUTOMESH_ROUTE_TYPE_DEFAULT       0
#define AUTOMESH_ROUTE_TYPE_LOCAL         1
#define AUTOMESH_ROUTE_TYPE_LEARNED       2                                                                                                             // Private Macro Definitions

#define ETHER_ADDR_STR_LEN                18


#define _WHITE   "\033[37;1m"
#define _BLUE    "\033[34;1m"
#define _RED     "\033[31;1m"
#define _GREEN   "\033[32;1m"
#define _YELLOW  "\033[33;2m"

#define _DGREEN  "\033[32;1m"
#define _NORM    "\033[0m"

#ifndef ETHER_STR
#define ETHER_STR       "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x"
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

#define RETURN_ON_ERROR(_ret)                  \
        do {                                   \
                if (ret != 0) {                \
                        printf("ret=%d", ret); \
                        return ret;            \
                }                              \
        } while (0)

#define BAIL_ON_ERROR(_ret)                    \
        do {                                   \
                if (ret != 0) {                \
                        printf("ret=%d", ret); \
                        goto bail;             \
                }                              \
        } while (0)

#if !defined(TAILQ_FOREACH_SAFE)
#define TAILQ_FOREACH_SAFE(var, head, field, next) \
        for ((var) = ((head)->tqh_first); (var) && ((next) = ((var)->field.tqe_next), 1); (var) = (next))
#endif

#ifndef MAC2STR
#define MAC2STR(a) (a)[0], (a)[1], (a)[2], (a)[3], (a)[4], (a)[5]
#define MACSTR "%02x:%02x:%02x:%02x:%02x:%02x"
#endif

#define OTHER_MODIFIER          1008
#define RETRY_SLEEP_SECS        5
#define RETRY_COUNT             3
#define LINE_MAX 1024
#define IFNAMSIZ 10

// copied from amioctl.h
typedef struct route_elem {
        unsigned char destination[6];
        char device[IFNAMSIZ];
        unsigned int short queued;
        unsigned int metric;
        unsigned int age;
        unsigned int idle;
        unsigned int short type;
} route_elem_t;

typedef struct route_list {
        unsigned int count;
        route_elem_t routes[0];
} route_list_t;

static inline void hex_to_ascii(const unsigned char *in_hex, char *out_ascii, unsigned int hex_len)
{
        unsigned int i = 0;
        unsigned int j = 0;

        for (i = 0; i < hex_len; i++) {
                j += sprintf(&out_ascii[j], "%02X", in_hex[i]);
        }
}

static void ascii_to_hex(const char *in_ascii, unsigned char *out_hex, unsigned int hex_len)
{
  unsigned int i = 0;

  for (i = 0; i < hex_len; i++) {
	  unsigned int a = 0;
	  unsigned int b = 0;
	  switch (in_ascii[2 * i]) {
	  case '0' ... '9':
		  a = in_ascii[2 * i] - '0';
		  break;
	  case 'a' ... 'f':
		  a = in_ascii[2 * i] - 'a' + 10;
		  break;
	  case 'A' ... 'F':
		  a = in_ascii[2 * i] - 'A' + 10;
		  break;
	  }
	  switch (in_ascii[2 * i + 1]) {
	  case '0' ... '9':
		  b = in_ascii[2 * i + 1] - '0';
		  break;
	  case 'a' ... 'f':
		  b = in_ascii[2 * i + 1] - 'a' + 10;
		  break;
	  case 'A' ... 'F':
		  b = in_ascii[2 * i + 1] - 'A' + 10;
		  break;
	  }
	  *out_hex++ = (a << 4) | b;
  }
}

static FILE *openRoutesFile(){

          FILE *fp = NULL;
          int ret = 0;

  	  //proc -> (Viper)
          fp = fopen("a.txt","r");
          if (fp == NULL)
                  //dev -> (STB)
                  fp = fopen("a.txt","r");

	  return fp;
}


int main(int argc, char *argv[])
{
	FILE *fp = NULL;
	int ret = 0;
	unsigned int len = 0, i = 0, k = 0, lineoffset = 0, num_col = 0, line_count = 0, found_line = 0;
	char *pline = NULL;
	char line[LINE_MAX]= {0};
	char dev[IFNAMSIZ] = {0};
	char destMacStr[ETHER_ADDR_STR_LEN] = {0};
	int metric = 0;
	float age = 0, idle = 0;
	unsigned int type;
	route_list_t *route_list = NULL;
	char keys[]="[";
	char str[LINE_MAX] = {0};



	if ((fp = openRoutesFile()) == NULL) {
		ret = -1;
		BAIL_ON_ERROR(ret);
	}

	//Count the number of entries after the header
	while ((pline = fgets(line, sizeof(line), fp)) != NULL) {
		if (found_line == 0) {
			if (strstr(pline, "hwaddr") != NULL)
				found_line = 1;
		}
		else {
			if (line[strlen(line) - 1] == '\n')
			line_count++;
		}

	}

	/* route_list = (struct route_list*) calloc(1, sizeof(route_list_t)); */
	route_list = (struct route_list*) malloc(sizeof(struct route_list) + line_count * sizeof(route_elem_t));
	memset(route_list, 0, sizeof(struct route_list) + line_count * sizeof(route_elem_t));

	/* printf("lcount:%d\n", line_count); */
	/* printf("route_list:%d\n", route_list->count); */
	route_list->count = line_count;
	line_count = 0;

	if ((fp = openRoutesFile()) == NULL) {
		ret = -1;
		BAIL_ON_ERROR(ret);
	}

	while ((pline = fgets(line, sizeof(line), fp)) != NULL) {
		if (lineoffset == 0) {
			if (strstr(pline, "hwaddr") != NULL){
				lineoffset = 1;
			}
			continue;
		}

	/* dev         id     hwaddr          metric    seq      age     idle [ seq0 / metric0 /devid0][ seq1 / metric1 /devid1][ seq2 / metric2 /devid2] flags */
	/* eth0         6  bc:ee:7b:8c:d9:33       0     34      2.4      2.4 [    34/        0/     6][    34/        0/     6][    34/        0/     6] 0 0 0 */
	/* eth0         6  c0:3e:0f:06:a8:40       0      0    260.6    260.6 [     0/        0/     6][     0/        0/     6][     0/        0/     6] local 0 0 0 */
	/* wds1.2       5  78:3e:53:ff:72:60    3571 408719      0.6      0.1 [408719/     3571/     5][408718/     3571/     5][408717/     3571/     5] hello 1 0 0 */
	/* wds1.1       4  78:3e:53:fd:7c:22    2941 181024     38.1     38.1 [181024/     2941/     4][181024/     2941/     4][181024/     2941/     4] 1 0 0 */
	/* wds1.1       4  78:3e:53:ff:72:62    5441 408689     38.1     38.1 [408689/     5441/     4][408689/     5555/     5][408689/     5555/     5] 2 0 0 */
	/* wds1.1       4  78:3e:53:fd:7c:23    2941 181031      1.1      0.5 [181031/     2941/     4][181030/     2941/     4][181029/     2941/     4] hello 1 0 0 */
	/* wl1          3  c0:3e:0f:06:a8:42       0      0    280.5    280.5 [     0/        0/     3][     0/        0/     3][     0/        0/     3] local 0 0 0 */
	/* wl0          2  c0:3e:0f:06:a8:44       0      0    280.8    280.8 [     0/        0/     2][     0/        0/     2][     0/        0/     2] local 0 0 0 */
	/* wl0          2  c0:3e:0f:06:a8:41       0      0    280.8    280.8 [     0/        0/     2][     0/        0/     2][     0/        0/     2] local 0 0 0V */

		num_col = sscanf(pline,"%s %*i %s %u %*i %f %f ", dev, destMacStr, &metric, &age, &idle);
		/* printf("cols:%d line:%s\n",num_col, pline); */
		if(num_col == 5) {
			if(strstr(pline, "local") != NULL)
				route_list->routes[i].type = AUTOMESH_ROUTE_TYPE_LOCAL;
			else if(strstr(pline, "discover") != NULL)
				route_list->routes[i].type = AUTOMESH_ROUTE_TYPE_LEARNED;
			else if(strstr(pline, "hello") != NULL)
				route_list->routes[i].type = AUTOMESH_ROUTE_TYPE_DEFAULT;
			else
				route_list->routes[i].type = AUTOMESH_ROUTE_TYPE_LEARNED;

			sscanf(destMacStr, "%2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx",
					&route_list->routes[i].destination[0],
					&route_list->routes[i].destination[1],
					&route_list->routes[i].destination[2],
					&route_list->routes[i].destination[3],
					&route_list->routes[i].destination[4],
					&route_list->routes[i].destination[5]);

			/* sscanf(mac_str, "%2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx", */
                       /* &addr[0], &addr[1], &addr[2], &addr[3], &addr[4], &addr[5]); */
/* route_list->routes[i].destination[0] */

			strncpy(route_list->routes[i].device, dev, sizeof(dev));
			route_list->routes[i].metric = metric;
			route_list->routes[i].age = age;
			route_list->routes[i].idle = idle;

			printf("ROUTE_TYPE:%d DEV:%s MAC:"MACSTR" METRIC:%d AGE:%d IDLE:%d \n",	route_list->routes[i].type, route_list->routes[i].device,
			MAC2STR(route_list->routes[i].destination), route_list->routes[i].metric,
			route_list->routes[i].age, route_list->routes[i].idle);
		}
		i++;

	}

bail:
	if(fp != NULL)
		fclose(fp);
	return ret;
}
