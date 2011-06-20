
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

PROJECT( "AS_TO_CPP" )

SET(EXECUTABLE_OUTPUT_PATH  ${CMAKE_SOURCE_DIR}/bin CACHE PATH "Default executable path" FORCE)
SET(LIBRARY_OUTPUT_PATH     ${CMAKE_SOURCE_DIR}/lib CACHE PATH "Default library path" FORCE)

SET( ASC java -jar ${LIBRARY_OUTPUT_PATH}/asc.jar )
SET( PNC ${EXECUTABLE_OUTPUT_PATH}/pnc )
SET( PNLD ${EXECUTABLE_OUTPUT_PATH}/pn-ld ) 

SET(CMAKE_MODULE_PATH
    "${CMAKE_SOURCE_DIR}/CMake"
    "${CMAKE_SOURCE_DIR}/CMake/Packages"
    )

SET( AST_THRIFT "${CMAKE_SOURCE_DIR}/project/thrift/SyntaxTree.thrift")

make_directory( ${CMAKE_SOURCE_DIR}/lib/ )
make_directory( ${CMAKE_SOURCE_DIR}/bin/ ) 

FIND_PACKAGE(Thrift REQUIRED) 
FIND_PACKAGE(Boost REQUIRED thread date_time program_options unit_test_framework filesystem regex system serialization)
FIND_PACKAGE(LLVM REQUIRED) 


FILE( GLOB ASC_JAVA_SRC ${CMAKE_SOURCE_DIR}/project/asc/src/java/*/*/*.java )

#message("  ${ASC_JAVA_SRC} ")

ADD_CUSTOM_TARGET(asc.jar ALL echo
    OUTPUT ${CMAKE_SOURCE_DIR}/lib/asc.jar
    DEPENDS ${AST_THRIFT}  ${ASC_JAVA_SRC}
    COMMAND ant -f ${CMAKE_SOURCE_DIR}/project/asc/build/java/build.xml -Dthrift.file=${AST_THRIFT} -Dthrift.compiler=${THRIFT_COMPILER}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/project/asc/lib/asc.jar ${CMAKE_SOURCE_DIR}/lib/
    COMMENT "updating asc.jar"
    )

ADD_SUBDIRECTORY( ${CMAKE_SOURCE_DIR}/project/pn-translator/ )

SET(ENABLE_COMPLEX_TEST FALSE CACHE BOOL "Enable complex test")
if( ENABLE_COMPLEX_TEST )
    ADD_SUBDIRECTORY( ${CMAKE_SOURCE_DIR}/project/complex-test)
endif()
