# Install script for directory: /Users/mikewinters/Desktop/ELVISon

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/Users/mikewinters/Desktop/ELVISon/build/Install")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "RelWithDebInfo")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/ELVISon" TYPE FILE FILES
    "/Users/mikewinters/Desktop/ELVISon/README.txt"
    "/Users/mikewinters/Desktop/ELVISon/ChangeLog"
    "/Users/mikewinters/Desktop/ELVISon/COPYING"
    "/Users/mikewinters/Desktop/ELVISon/AUTHORS"
    "/Users/mikewinters/Desktop/ELVISon/platform/mac/MOVED_STUFF.txt"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/ELVISon/ELVISon.app/Contents/Resources" TYPE DIRECTORY FILES "/Users/mikewinters/Desktop/ELVISon/SCClassLibrary" REGEX "ignoreme" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/ELVISon/ELVISon.app/Contents/Resources" TYPE DIRECTORY FILES "/Users/mikewinters/Desktop/ELVISon/sounds")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/ELVISon/ELVISon.app/Contents/Resources" TYPE DIRECTORY FILES "/Users/mikewinters/Desktop/ELVISon/examples" REGEX "/[^/]*\\~$" EXCLUDE REGEX "/[^/]*\\#$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/ELVISon/ELVISon.app/Contents/Resources" TYPE DIRECTORY FILES "/Users/mikewinters/Desktop/ELVISon/HelpSource" REGEX "/[^/]*\\~$" EXCLUDE REGEX "/[^/]*\\#$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/Users/mikewinters/Desktop/ELVISon/build/external_libraries/cmake_install.cmake")
  INCLUDE("/Users/mikewinters/Desktop/ELVISon/build/server/cmake_install.cmake")
  INCLUDE("/Users/mikewinters/Desktop/ELVISon/build/lang/cmake_install.cmake")
  INCLUDE("/Users/mikewinters/Desktop/ELVISon/build/editors/cmake_install.cmake")
  INCLUDE("/Users/mikewinters/Desktop/ELVISon/build/platform/cmake_install.cmake")
  INCLUDE("/Users/mikewinters/Desktop/ELVISon/build/testsuite/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

IF(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
ELSE(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
ENDIF(CMAKE_INSTALL_COMPONENT)

FILE(WRITE "/Users/mikewinters/Desktop/ELVISon/build/${CMAKE_INSTALL_MANIFEST}" "")
FOREACH(file ${CMAKE_INSTALL_MANIFEST_FILES})
  FILE(APPEND "/Users/mikewinters/Desktop/ELVISon/build/${CMAKE_INSTALL_MANIFEST}" "${file}\n")
ENDFOREACH(file)
