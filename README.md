# flutter_chromaprint

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

The plugin project was generated without specifying the `--platforms` flag, no platforms are currently supported.
To add platforms, run `flutter create -t plugin --platforms <platforms> .` in this directory.
You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.


# Building Chromaprint 
## iOS
- Clone repo 
- Run CMake
- Build XCode 
- Copy the built chromaprint.framework into the `ios` folder

1. Clone chromaprint from the acoustid repo:
```sh
git clone https://github.com/acoustid/chromaprint.git
```

2. Use CMake to create an XCode project:
```sh
cmake -G Xcode -B build \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_Swift_COMPILER_FORCED=true \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
    -DCMAKE_FRAMEWORK=true
```

3. Open the XCode projecet and build the chromaprint target 
4. Copy the resulting `chromaprint.framework` folder into the `ios` folder of this plugin

## Android
1. Clone chromaprint from the `arm` branch of the acoustid repo.
2. Insert this to the top of the CMakeLists.txt: 
```cmake
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 24)
#set(CMAKE_ANDROID_ARCH_ABI armeabi-v7a)
set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)

set(CMAKE_ANDROID_NDK /home/kiwi/Android/Sdk/ndk/23.1.7779620)
set(KISSFFT_SOURCE_DIR ../vendor/kissfft)
```

3. Run CMake: 
```sh
cmake -DCMAKE_TOOLCHAIN_FILE=$NDK_PATH/build/cmake/android.toolchain.cmake -DANDROID_NDK=$NDK_PATH -DANDROID_ABI=armeabi-v7a -DANDROID_PLATFORM=android-21 -DANDROID_STL=c++_shared -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=build
```
Copy the resulting `libchromaprint.so` to the correct directory in `android/src/main/jniLibs`.
libchromaprint.so
```
android/src/main/jniLibs
├── arm64-v8a
│   ├── libc++abi.a
│   ├── libchromaprint.so
│   ├── libc++_shared.so
│   └── libc++_static.a
├── armeabi-v7a
│   ├── libandroid_support.a
│   ├── libc++abi.a
│   ├── libchromaprint.so
│   ├── libc++_shared.so
│   └── libc++_static.a
├── x86
│   ├── libandroid_support.a
│   ├── libc++abi.a
│   ├── libc++_shared.so
│   └── libc++_static.a
└── x86_64
    ├── libc++abi.a
    ├── libc++_shared.so
    └── libc++_static.a
```
4. Repeat for each target arch. 
4. Run make: 
```sh
make
```
5. Copy `libchromaprint.so` to correct location in android folder. 

