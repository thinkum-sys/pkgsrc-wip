$NetBSD$

--- output.c.orig	2016-07-27 19:51:51.440788492 +0000
+++ output.c
@@ -24,8 +24,8 @@ char output_RCSid[] = "Revision: 1.5 $";
 
 #include "agm.h"
 
-print_prevs (percent)
-     int percent;
+void
+print_prevs (int percent)
 {
   int loop;
 
@@ -46,8 +46,7 @@ print_prevs (percent)
   spos += totlen + prevcount + 1;
 }
 
-list_dictionary (p)
-  struct wnode *p;
+list_dictionary (struct wnode *p)
 {
   while (p != NULL) {
     puts (p->word);
