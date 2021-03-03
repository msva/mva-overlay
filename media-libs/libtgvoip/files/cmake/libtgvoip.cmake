cmake_minimum_required(VERSION 3.14)
project(tgvoip)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

option(ENABLE_ALSA "Enable ALSA" ON)
option(ENABLE_PULSEAUDIO "Enable pulseaudio" ON)
option(BUILD_STATIC_LIBRARY "Build static library" OFF)
option(BUILD_SHARED_LIBRARY "Build static library" ON)

file(GLOB TGVOIP_SOURCE_FILES
	*.cpp
	audio/*.cpp
	os/linux/*.cpp
	os/posix/*.cpp
	video/*.cpp
)

if(BUILD_SHARED_LIBRARY OR BUILD_STATIC_LIBRARY)
	find_package(tg_owt REQUIRED)
	find_package(PkgConfig REQUIRED)
	pkg_check_modules(OPUS REQUIRED opus)
	set(TGVOIP_COMPILE_DEFINITIONS TGVOIP_USE_DESKTOP_DSP WEBRTC_NS_FLOAT WEBRTC_POSIX WEBRTC_LINUX INSTALL_TARGETS)

	if(ENABLE_ALSA)
		pkg_check_modules(ALSA REQUIRED alsa)
	else()
		file(GLOB ALSA_SOURCE_FILES
			os/linux/AudioInputALSA.cpp
			os/linux/AudioOutputALSA.cpp
		)
		list(REMOVE_ITEM TGVOIP_SOURCE_FILES ${ALSA_SOURCE_FILES})
		list(APPEND TGVOIP_COMPILE_DEFINITIONS WITHOUT_ALSA)
	endif()

	if(ENABLE_PULSEAUDIO)
		pkg_check_modules(LIBPULSE REQUIRED libpulse)
	else()
		file(GLOB PULSEAUDIO_SOURCE_FILES
			os/linux/AudioInputPulse.cpp
			os/linux/AudioOutputPulse.cpp
			os/linux/AudioPulse.cpp
		)
		list(REMOVE_ITEM TGVOIP_SOURCE_FILES ${PULSEAUDIO_SOURCE_FILES})
		list(APPEND TGVOIP_COMPILE_DEFINITIONS WITHOUT_PULSE)
	endif()

	get_target_property(OWT_INCLUDE_DIRS tg_owt::tg_owt INTERFACE_INCLUDE_DIRECTORIES)
	
	add_library(${PROJECT_NAME} OBJECT ${TGVOIP_SOURCE_FILES})
	list(APPEND INSTALL_TARGETS ${PROJECT_NAME})
	target_compile_definitions(${PROJECT_NAME} PUBLIC ${TGVOIP_COMPILE_DEFINITIONS})
	target_include_directories(${PROJECT_NAME} PUBLIC
		"${OPUS_INCLUDE_DIRS}"
#		"${CMAKE_CURRENT_LIST_DIR}/webrtc_dsp"
		"${CMAKE_CURRENT_LIST_DIR}/audio"
		"${CMAKE_CURRENT_LIST_DIR}/video"
		"${OWT_INCLUDE_DIRS}"
	)
	set(LIBTGVOIP_VERSION 2.4.4)
	set(prefix "${CMAKE_INSTALL_PREFIX}")
	set(exec_prefix "${CMAKE_INSTALL_PREFIX}")
	set(libdir "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
	set(includedir "${CMAKE_INSTALL_PREFIX}/include")
	configure_file(tgvoip.pc.in tgvoip.pc @ONLY)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/tgvoip.pc DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig")

	set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER TgVoip.h)
#	install(TARGETS ${PROJECT_NAME} PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/tgvoip")
endif(BUILD_SHARED_LIBRARY OR BUILD_STATIC_LIBRARY)

if(BUILD_SHARED_LIBRARY)
	add_library(${PROJECT_NAME}_shared SHARED $<TARGET_OBJECTS:${PROJECT_NAME}>)
	target_compile_definitions(${PROJECT_NAME}_shared PUBLIC ${TGVOIP_COMPILE_DEFINITIONS})
	set_target_properties(${PROJECT_NAME}_shared PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
	set_target_properties(${PROJECT_NAME}_shared PROPERTIES SOVERSION 2 VERSION ${LIBTGVOIP_VERSION})
	target_link_libraries(${PROJECT_NAME}_shared dl ${OPUS_LIBRARIES} tg_owt)
	list(APPEND INSTALL_TARGETS ${PROJECT_NAME}_shared)
endif(BUILD_SHARED_LIBRARY)

if(BUILD_STATIC_LIBRARY)
	add_library(${PROJECT_NAME}_static STATIC $<TARGET_OBJECTS:${PROJECT_NAME}>)
	target_compile_definitions(${PROJECT_NAME}_static PUBLIC ${TGVOIP_COMPILE_DEFINITIONS})
	set_target_properties(${PROJECT_NAME}_static PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
	target_link_libraries(${PROJECT_NAME}_static dl ${OPUS_LIBRARIES} tg_owt)
	list(APPEND INSTALL_TARGETS ${PROJECT_NAME}_static)
endif(BUILD_STATIC_LIBRARY)

install(TARGETS ${INSTALL_TARGETS}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(DIRECTORY ${CMAKE_SOURCE_DIR}/ DESTINATION include/${PROJECT_NAME} FILES_MATCHING PATTERN "*.h*" PATTERN "webrtc_dsp/*" EXCLUDE PATTERN ".git*" EXCLUDE)
