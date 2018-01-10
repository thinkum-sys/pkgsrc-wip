$NetBSD$

--- lib/sanitizer_common/sanitizer_procmaps_freebsd.cc.orig	2018-01-10 05:12:07.886871696 +0000
+++ lib/sanitizer_common/sanitizer_procmaps_freebsd.cc
@@ -19,6 +19,9 @@
 #include "sanitizer_procmaps.h"
 
 #include <unistd.h>
+#if SANITIZER_NETBSD
+#define sysctl _sysctl // Use an internal symbol to omit the interceptor
+#endif
 #include <sys/sysctl.h>
 #if SANITIZER_FREEBSD
 #include <sys/user.h>
