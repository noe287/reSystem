/* fscanf example */
#include <stdio.h>

int main ()
{
  char str [80];
  char stri [80];
  float f, fi;
  FILE * pFile;

  pFile = fopen ("myfile.txt","w+");
  fprintf (pFile, "%f %s", 3.1416, "PI");
  rewind (pFile);
  fscanf (pFile, "%f", &f);
  fscanf (pFile, "%s", str);

  rewind (pFile);
  fscanf (pFile, "%f %s", &fi, stri);
  fclose (pFile);
  printf ("I have read: %f and %s \n\n",f,str);
  printf ("I have read: %f and %s \n\n",fi,stri);
  return 0;
}
