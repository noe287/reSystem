/* strstr example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char str[] ="SERIAL_NUMBER=23425295AFASF";
  char * pch;
  char * psh;
  pch = strstr (str,"SERIAL_NUMBER");
//  strncpy (pch,"sample",6);
  printf("%s\n", pch+14);
  psh=strdup(pch);
  printf("%s\n",psh);
  puts (str);
  return 0;
}
