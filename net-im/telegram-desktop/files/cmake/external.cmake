find_package(LibLZMA REQUIRED)
find_package(OpenAL REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(Threads REQUIRED)
find_package(X11 REQUIRED)
find_package(ZLIB REQUIRED)
find_package(Qt5 REQUIRED COMPONENTS Core DBus Gui Widgets Network)

get_target_property(QTCORE_INCLUDE_DIRS Qt5::Core INTERFACE_INCLUDE_DIRECTORIES)
list(GET QTCORE_INCLUDE_DIRS 0 QT_INCLUDE_DIR)

foreach(__qt_module IN ITEMS QtCore QtGui)
	list(APPEND QT_PRIVATE_INCLUDE_DIRS
		${QT_INCLUDE_DIR}/${__qt_module}/${Qt5_VERSION}
		${QT_INCLUDE_DIR}/${__qt_module}/${Qt5_VERSION}/${__qt_module}
	)
endforeach()
message(STATUS "Using Qt private include directories: ${QT_PRIVATE_INCLUDE_DIRS}")

find_package(PkgConfig REQUIRED)
pkg_check_modules(FFMPEG REQUIRED libavcodec libavformat libavutil libswresample libswscale)
pkg_check_modules(LIBDRM REQUIRED libdrm)
pkg_check_modules(LIBVA REQUIRED libva libva-drm libva-x11)
pkg_check_modules(MINIZIP REQUIRED minizip)
pkg_check_modules(OPUS REQUIRED opus)
#pkg_check_modules(RLOTTIE REQUIRED rlottie)
pkg_check_modules(tg_owt REQUIRED tg_owt)
if(NOT DESKTOP_APP_DISABLE_CRASH_REPORTS)
	pkg_check_modules(CRASH_REPORTS REQUIRED breakpad_client)
endif()

foreach(__qt_plugin IN ITEMS
	QComposePlatformInputContextPlugin
	QGenericEnginePlugin
	QGifPlugin
	QJpegPlugin
	QWebpPlugin
	QXcbIntegrationPlugin

#	QNetworkManagerEnginePlugin
#	QConnmanEnginePlugin
#	QIbusPlatformInputContextPlugin
#	QFcitxPlatformInputContextPlugin
#	QHimePlatformInputContextPlugin
#	NimfInputContextPlugin
)
	get_target_property(_p Qt5::${__qt_plugin} LOCATION)
	list(APPEND __qt_plugin_list ${_p})
endforeach()
message("PLUGINS::${__qt_plugin_list}")

add_library(desktop-app::external_ffmpeg INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_lz4 INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_openal INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_openssl INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_qt INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_zlib INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_opus INTERFACE IMPORTED GLOBAL)
#add_library(desktop-app::external_rlottie INTERFACE IMPORTED GLOBAL)
#add_library(desktop-app::external_gsl INTERFACE IMPORTED GLOBAL)
#add_library(desktop-app::external_expected INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_xxhash INTERFACE IMPORTED GLOBAL)
#add_library(desktop-app::external_variant INTERFACE IMPORTED GLOBAL)
#add_library(desktop-app::external_ranges INTERFACE IMPORTED GLOBAL)
if(NOT DESKTOP_APP_DISABLE_CRASH_REPORTS)
	add_library(desktop-app::external_crash_reports INTERFACE IMPORTED GLOBAL)
endif()
add_library(tdesktop::lib_tgvoip INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_tg_owt INTERFACE IMPORTED GLOBAL)


#target_compile_definitions(desktop-app::external_xxhash INTERFACE XXH_INLINE_ALL) # requires xxhash.c (and static linking). No way.
target_compile_definitions(desktop-app::external_qt INTERFACE
	_REENTRANT
#	QT_STATICPLUGIN # No way
	QT_PLUGIN
	QT_WIDGETS_LIB
	QT_NETWORK_LIB
	QT_GUI_LIB
	QT_CORE_LIB
	Q_OS_LINUX64
)
target_compile_definitions(desktop-app::external_openal INTERFACE
#	AL_LIBTYPE_STATIC # No way
	AL_ALEXT_PROTOTYPES
)


target_include_directories(desktop-app::external_ffmpeg SYSTEM INTERFACE ${FFMPEG_INCLUDE_DIRS})
target_include_directories(desktop-app::external_lz4 SYSTEM INTERFACE ${LIBLZMA_INCLUDE_DIRS})
target_include_directories(desktop-app::external_openal SYSTEM INTERFACE ${OPENAL_INCLUDE_DIR})
target_include_directories(desktop-app::external_qt SYSTEM INTERFACE ${QT_PRIVATE_INCLUDE_DIRS})
target_include_directories(desktop-app::external_zlib SYSTEM INTERFACE ${MINIZIP_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIR})
if(NOT DESKTOP_APP_DISABLE_CRASH_REPORTS)
	target_include_directories(desktop-app::external_crash_reports SYSTEM INTERFACE ${CRASH_REPORTS_INCLUDE_DIRS})
endif()
#target_include_directories(desktop-app::external_gsl SYSTEM INTERFACE ${CMAKE_INSTALL_PREFIX}/include/gsl)
#target_include_directories(desktop-app::external_expected SYSTEM INTERFACE ${CMAKE_INSTALL_PREFIX}/include/tl)
#target_include_directories(desktop-app::external_variant SYSTEM INTERFACE ${CMAKE_INSTALL_PREFIX}/include/mapbox)
target_include_directories(tdesktop::lib_tgvoip SYSTEM INTERFACE ${CMAKE_INSTALL_PREFIX}/include/libtgvoip)
target_include_directories(desktop-app::external_tg_owt SYSTEM INTERFACE ${tg_owt_INCLUDE_DIR})



target_link_libraries(desktop-app::external_ffmpeg INTERFACE ${FFMPEG_LIBRARIES})
target_link_libraries(desktop-app::external_lz4 INTERFACE ${LIBLZMA_LIBRARIES} lz4)
target_link_libraries(desktop-app::external_openal INTERFACE ${OPENAL_LIBRARY})
target_link_libraries(desktop-app::external_openssl INTERFACE OpenSSL::Crypto OpenSSL::SSL)
target_link_libraries(desktop-app::external_qt INTERFACE Qt5::DBus Qt5::Network Qt5::Widgets)
  target_link_options(desktop-app::external_qt INTERFACE -pthread -rdynamic)
target_link_libraries(desktop-app::external_zlib INTERFACE
	${MINIZIP_LIBRARIES} ${ZLIB_LIBRARY_RELEASE} Threads::Threads dl ${X11_X11_LIB} # FIXME
)
target_link_libraries(desktop-app::external_opus INTERFACE ${OPUS_LIBRARIES})
#target_link_libraries(desktop-app::external_rlottie INTERFACE ${RLOTTIE_LIBRARIES})
if(NOT DESKTOP_APP_DISABLE_CRASH_REPORTS)
	target_link_libraries(desktop-app::external_crash_reports INTERFACE ${CRASH_REPORTS_LIBRARIES})
endif()
target_link_libraries(desktop-app::external_xxhash INTERFACE xxhash)
target_link_libraries(tdesktop::lib_tgvoip INTERFACE tgvoip)
target_link_libraries(desktop-app::external_tg_owt INTERFACE tg_owt)
