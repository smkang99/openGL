cmake_minimum_required(VERSION 3.4.1)

# build the ndk-helper library
get_filename_component(commonDir ${CMAKE_CURRENT_SOURCE_DIR}/../../../../common ABSOLUTE)
get_filename_component(ndkHelperSrc ${commonDir}/ndk_helper ABSOLUTE)
get_filename_component(assimpSrc ${CMAKE_CURRENT_SOURCE_DIR}/../externals/assimp-3.0 ABSOLUTE)
get_filename_component(openCVSrc ${CMAKE_CURRENT_SOURCE_DIR}/../externals/opencv-3.0.0 ABSOLUTE)
get_filename_component(nativeCodeDir ${CMAKE_CURRENT_SOURCE_DIR}/nativeCode ABSOLUTE)

include_directories(${assimpSrc}/include
                    ${nativeCodeDir}/common
                    ${nativeCodeDir}/modelAssimp
                    ${openCVSrc}/include)
add_subdirectory(${ndkHelperSrc}
        ${commonDir}/ndkHelperBin/${CMAKE_BUILD_TYPE}/${ANDROID_ABI})

add_library(hello-jni SHARED
           ./jniCalls/assimpActivity.cpp
           ./jniCalls/gestureClass.cpp
           ./jniCalls/myGLRenderer.cpp
           ./nativeCode/modelAssimp/modelAssimp.cpp
           ./nativeCode/common/assimpLoader.cpp
           ./nativeCode/common/misc.cpp
           ./nativeCode/common/myGLCamera.cpp
           ./nativeCode/common/myGLFunctions.cpp
           ./nativeCode/common/myJNIHelper.cpp
           ./nativeCode/common/myShader.cpp
           #hello-jni.c
        )

set(OpenCV_STATIC ON)
set(OpenCV_DIR ${openCVSrc}/sdk/native/jni)
find_package(OpenCV REQUIRED)

add_library(libassimp SHARED IMPORTED GLOBAL)

set_target_properties(libassimp PROPERTIES IMPORTED_LOCATION ${assimpSrc}/libs/${ANDROID_ABI}/libassimp.so)

if (${ANDROID_PLATFORM_LEVEL} LESS 12)
    message(FATAL_ERROR "OpenGL 2 is not supported before API level 11 \
                      (currently using ${ANDROID_PLATFORM_LEVEL}).")
    return()
elseif (${ANDROID_PLATFORM_LEVEL} LESS 18)
    add_definitions("-DDYNAMIC_ES3")
    set(OPENGL_LIB GLESv2)
else ()
    set(OPENGL_LIB GLESv3)
endif (${ANDROID_PLATFORM_LEVEL} LESS 12)

#target_include_directories(${openCVSrc} ${assimSrc}/include)
# Include libraries needed for hello-jni lib
target_link_libraries(hello-jni
                      android
                      native_app_glue
                      NdkHelper
                      libassimp
                      ${OpenCV_LIBS}
                      #${OPENGL_LIB}
                      GLESv3
                      log)
