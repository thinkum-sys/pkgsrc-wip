$NetBSD$

--- lib/sanitizer_common/sanitizer_platform_interceptors.h.orig	2018-02-02 19:10:23.884730145 +0000
+++ lib/sanitizer_common/sanitizer_platform_interceptors.h
@@ -406,6 +406,7 @@
 
 #define SANITIZER_INTERCEPT_STAT \
   (SI_FREEBSD || SI_MAC || SI_ANDROID || SI_NETBSD || SI_SOLARIS)
+#define SANITIZER_INTERCEPT_LSTAT SI_NETBSD
 #define SANITIZER_INTERCEPT___XSTAT (!SANITIZER_INTERCEPT_STAT && SI_POSIX)
 #define SANITIZER_INTERCEPT___XSTAT64 SI_LINUX_NOT_ANDROID
 #define SANITIZER_INTERCEPT___LXSTAT SANITIZER_INTERCEPT___XSTAT
@@ -442,6 +443,17 @@
 #define SANITIZER_INTERCEPT_FACCESSAT SI_NETBSD
 #define SANITIZER_INTERCEPT_GETGROUPLIST SI_NETBSD
 #define SANITIZER_INTERCEPT_STRLCPY SI_NETBSD
+#define SANITIZER_INTERCEPT_KVM SI_NETBSD
+#define SANITIZER_INTERCEPT_DEVNAME SI_NETBSD
+#define SANITIZER_INTERCEPT_SYSCTL SI_NETBSD
+#define SANITIZER_INTERCEPT_ATOF SI_NETBSD
+#define SANITIZER_INTERCEPT_GETTTYENT SI_NETBSD
+#define SANITIZER_INTERCEPT_FGETLN SI_NETBSD
+#define SANITIZER_INTERCEPT_GETPROTOENT SI_NETBSD
+#define SANITIZER_INTERCEPT_GETNETENT SI_NETBSD
+#define SANITIZER_INTERCEPT_FTS SI_NETBSD
+#define SANITIZER_INTERCEPT_STRMODE SI_NETBSD
+#define SANITIZER_INTERCEPT_REGEX SI_NETBSD
 
 #define SANITIZER_INTERCEPT_NAME_TO_HANDLE_AT SI_LINUX_NOT_ANDROID
 #define SANITIZER_INTERCEPT_OPEN_BY_HANDLE_AT SI_LINUX_NOT_ANDROID
