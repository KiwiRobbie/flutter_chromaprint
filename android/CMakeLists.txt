cmake_minimum_required(VERSION 3.4.1)

include_directories(../include)
add_library(libchromaprint SHARED IMPORTED)
set_target_properties(libchromaprint PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libchromaprint.so)
