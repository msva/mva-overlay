--- a/Telegram/cmake/lib_tgcalls.cmake
+++ b/Telegram/cmake/lib_tgcalls.cmake
@@ -171,6 +171,7 @@
     desktop-app::external_openssl
     desktop-app::external_rnnoise
     desktop-app::external_zlib
+    desktop-app::external_libyuv
 )
 
 target_compile_definitions(lib_tgcalls
