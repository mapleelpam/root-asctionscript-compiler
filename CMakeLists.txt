
CMAKE_MINIMUM_REQUIRED(VERSION 2.6.3)

PROJECT( "AS_TO_CPP" )

SET(CMAKE_MODULE_PATH
    "${CMAKE_SOURCE_DIR}/CMake"
    "${CMAKE_SOURCE_DIR}/CMake/Packages"
    )

SET( AST_THRIFT "${CMAKE_SOURCE_DIR}/project/thrift/SyntaxTree.thrift")

make_directory( ${CMAKE_SOURCE_DIR}/lib/ )
make_directory( ${CMAKE_SOURCE_DIR}/bin/ ) 

FIND_PACKAGE(Thrift REQUIRED) 
FIND_PACKAGE(Boost REQUIRED thread date_time program_options unit_test_framework filesystem regex system serialization)


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
