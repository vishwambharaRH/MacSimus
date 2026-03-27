cmake_minimum_required(VERSION 3.15)
project(MacSimus)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find macOS frameworks
find_library(COREAUDIO CoreAudio)
find_library(AUDIOTOOLBOX AudioToolbox)
find_library(AVFOUNDATION AVFoundation)
find_library(COREFOUNDATION CoreFoundation)

if(NOT COREAUDIO OR NOT AUDIOTOOLBOX OR NOT AVFOUNDATION OR NOT COREFOUNDATION)
    message(FATAL_ERROR "Required macOS frameworks not found")
endif()

# DSP Library (header-only + test)
add_library(dsp_core INTERFACE)
target_include_directories(dsp_core INTERFACE ${CMAKE_SOURCE_DIR}/dsp)

# Audio Engine Library
add_library(audio_engine 
    audio/AudioEngine.cpp
    audio/VirtualAudioDevice.cpp
)
target_include_directories(audio_engine 
    PUBLIC ${CMAKE_SOURCE_DIR}
)
target_link_libraries(audio_engine 
    PUBLIC dsp_core
    PRIVATE ${COREAUDIO} ${AUDIOTOOLBOX} ${AVFOUNDATION} ${COREFOUNDATION}
)
target_compile_options(audio_engine PRIVATE -fPIC)

# Audio Wrapper Library (Objective-C++)
add_library(audio_wrapper OBJECT
    audio/AudioEngineWrapper.mm
    audio/VirtualAudioDeviceWrapper.mm
)
set_target_properties(audio_wrapper PROPERTIES
    LANGUAGE OBJCXX
)
target_include_directories(audio_wrapper 
    PUBLIC ${CMAKE_SOURCE_DIR}
)
target_link_libraries(audio_wrapper 
    PRIVATE audio_engine
    PRIVATE ${AVFOUNDATION}
)
target_compile_options(audio_wrapper PRIVATE -fPIC)

# DSP Test Binary
add_executable(dsp_test dsp/main.cpp dsp/utils.cpp)
target_link_libraries(dsp_test PRIVATE dsp_core)
set_target_properties(dsp_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/dsp")

# Audio Engine Test
add_executable(audio_test audio/test_audio.cpp)
target_link_libraries(audio_test PRIVATE audio_engine)
target_link_libraries(audio_test PRIVATE ${COREAUDIO} ${AUDIOTOOLBOX} ${AVFOUNDATION})
set_target_properties(audio_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/audio")

# System-Wide Audio Test
add_executable(system_audio_test audio/test_system_audio.cpp)
target_link_libraries(system_audio_test PRIVATE audio_engine)
target_link_libraries(system_audio_test PRIVATE ${COREAUDIO} ${AUDIOTOOLBOX} ${AVFOUNDATION} ${COREFOUNDATION})
set_target_properties(system_audio_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/audio")

message(STATUS "Build configured for macOS")
message(STATUS "DSP Library: dsp_core (header-only)")
message(STATUS "Audio Engine: audio_engine")
message(STATUS "Audio Wrapper: audio_wrapper")
message(STATUS "Test Binaries: dsp_test, audio_test, system_audio_test")
