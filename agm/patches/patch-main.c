$NetBSD$

--- main.c.orig	2016-07-27 19:51:51.437389107 +0000
+++ main.c
@@ -60,6 +60,7 @@ char main_RCSid[] = "Revision: 1.11 $";
 #include "agm.h"
 /* following just for getrusage () */
 #include <unistd.h>
+#include <stdlib.h>
 
 int listdict = FALSE; /* just output the final word dictionary */
 int hardmin = FALSE; /* hard minimums on words */
@@ -86,9 +87,8 @@ struct wnode *lstart = NULL, *lend = NUL
 
 int pct= 0, lastpct = -1; /* percentage complete counters */
 
-main (argc, argv)
-  int argc;
-  char **argv;
+int
+main (int argc, char **argv)
 {
   int wordno; /* loops along argument list */
   void matchwords ();
