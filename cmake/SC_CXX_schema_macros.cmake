# macros to be used in the CMakeLists generated by the schema scanner

# uses SC_GENERATE_CXX_ONESHOT - if true, files will only be generated once. this is useful when debugging and modifying code, not otherwise. TODO: print a warning when set (and actually implement it!)

# find all part 21 files in schema dir, add a test for each one
MACRO( P21_TESTS sfile )
  get_filename_component( SCHEMA_DIR ${sfile} PATH )
  file( GLOB_RECURSE P21_FILES ${SCHEMA_DIR}/*.stp ${SCHEMA_DIR}/*.step ${SCHEMA_DIR}/*.p21 ${SCHEMA_DIR}/*.ifc )
  foreach( TEST_FILE ${P21_FILES} )
    get_filename_component( FNAME ${TEST_FILE} NAME_WE )
    add_test( NAME read_write_cpp_${PROJECT_NAME}_${FNAME}
              WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
              COMMAND p21read_${PROJECT_NAME} ${TEST_FILE} )
    set_tests_properties( read_write_cpp_${PROJECT_NAME}_${FNAME} PROPERTIES DEPENDS build_cpp_${PROJECT_NAME} LABELS cpp_schema_rw )
    if(NOT WIN32)
      add_test( NAME read_lazy_cpp_${PROJECT_NAME}_${FNAME}
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMAND lazy_${PROJECT_NAME} ${TEST_FILE} )
      set_tests_properties( read_lazy_cpp_${PROJECT_NAME}_${FNAME} PROPERTIES DEPENDS build_lazy_cpp_${PROJECT_NAME} LABELS cpp_schema_rw )
    endif(NOT WIN32)
  endforeach()
ENDMACRO( P21_TESTS sfile )

#
MACRO( SCHEMA_EXES )
  RELATIVE_PATH_TO_TOPLEVEL(${CMAKE_CURRENT_SOURCE_DIR} RELATIVE_PATH_COMPONENT)
  SC_ADDEXEC( p21read_${PROJECT_NAME} "${RELATIVE_PATH_COMPONENT}/src/test/p21read/p21read.cc" "${PROJECT_NAME};base" "TESTABLE" )
  #add_dependencies( p21read_${PROJECT_NAME} version_string )
  if(NOT WIN32)
    SC_ADDEXEC( lazy_${PROJECT_NAME} "${RELATIVE_PATH_COMPONENT}/src/cllazyfile/lazy_test.cc" "${PROJECT_NAME};steplazyfile;stepeditor" "TESTABLE" )
    #add_dependencies( lazy_${PROJECT_NAME} version_string )
  endif(NOT WIN32)

  #add user-defined executables
  foreach( src ${SC_SDAI_ADDITIONAL_EXES_SRCS} )
    get_filename_component( name ${src} NAME_WE )
    get_filename_component( path ${src} ABSOLUTE )
    SC_ADDEXEC( ${name}_${PROJECT_NAME} "${src}" "${PROJECT_NAME};base" "TESTABLE" )
    add_dependencies( ${name}_${PROJECT_NAME} version_string )
    #set_target_properties( ${name}_${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "${${PROJECT_NAME}_COMPILE_FLAGS} -I${path}" )
  endforeach( src ${SC_SDAI_ADDITIONAL_EXES_SRCS} )
ENDMACRO( SCHEMA_EXES )


# label the tests and set dependencies
MACRO( SCHEMA_TESTS sname )
  add_test( NAME generate_cpp_${sname}
              WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
              COMMAND ${CMAKE_COMMAND} --build .
                                      --target generate_cpp_${sname}
                                      --config $<CONFIGURATION> )
  set_tests_properties( generate_cpp_${sname} PROPERTIES LABELS cpp_schema_gen )
  add_test( NAME build_cpp_${PROJECT_NAME}
              WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
              COMMAND ${CMAKE_COMMAND} --build .
                                      --target p21read_${PROJECT_NAME}
                                      --config $<CONFIGURATION> )
  set_tests_properties( build_cpp_${PROJECT_NAME} PROPERTIES DEPENDS generate_cpp_${sname} LABELS cpp_schema_build )
  if(NOT WIN32)
  add_test( NAME build_lazy_cpp_${PROJECT_NAME}
              WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
              COMMAND ${CMAKE_COMMAND} --build .
                                      --target lazy_${PROJECT_NAME}
                                      --config $<CONFIGURATION> )
  set_tests_properties( build_lazy_cpp_${PROJECT_NAME} PROPERTIES DEPENDS generate_cpp_${sname} LABELS cpp_schema_build )
  endif(NOT WIN32)
ENDMACRO( SCHEMA_TESTS sname )

# SCHEMA_TARGETS macro -
# expFile: path to express file
# schemaName: name of the schema
# sourceFiles: list of .cc and .h files
#
# create targets for the schema(s) in expFile
# targets include gen_cxx_*, sdai_cxx_*, p21read_*, lazyp21_*, ...
MACRO( SCHEMA_TARGETS expFile schemaName sourceFiles )
  # schema scanner comes up with a short schema name for PROJECT() ( which sets ${PROJECT_NAME} )
  message( STATUS "Will generate code for ${PROJECT_NAME}.")

  add_custom_target( generate_cpp_${PROJECT_NAME} DEPENDS exp2cxx ${expFile} ${sourceFiles} SOURCES ${sourceFiles} )
  set( _gen_script_args "-DEXE=\"$<TARGET_FILE:exp2cxx>\" -DEXP=\"${expFile}\" -DONESHOT=\"${SC_GENERATE_CXX_ONESHOT}\" -DDIR=\"${CMAKE_CURRENT_LIST_DIR}\"" )
  # this calls a cmake script because it doesn't seem to be possible to divert stdout, stderr in cmake except via execute_process
  add_custom_command( OUTPUT ${sourceFiles}
                      COMMAND ${CMAKE_COMMAND} -P ${SC_CMAKE_DIR}/SC_Run_exp2cxx.cmake ${_gen_script_args}
                      WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
                    )
  # will include_directories behave as desired in a macro?
  include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}         ${SC_SOURCE_DIR}/src/cldai          ${SC_SOURCE_DIR}/src/cleditor
    ${SC_SOURCE_DIR}/src/clutils        ${SC_SOURCE_DIR}/src/clstepcore     ${SC_SOURCE_DIR}/src/base
    ${SC_SOURCE_DIR}/src/base/judy/src
  )
  # if testing is enabled, "TESTABLE" sets property EXCLUDE_FROM_ALL and prevents installation
  SC_ADDLIB( ${PROJECT_NAME} "${sourceFiles}" "stepdai;stepcore;stepeditor;steputils;base" "TESTABLE" )
  add_dependencies( ${PROJECT_NAME} generate_cpp_${PROJECT_NAME} )

  SCHEMA_TESTS( ${PROJECT_NAME} )
  P21_TESTS( ${expFile} )

ENDMACRO( SCHEMA_TARGETS expFile schemaName sourceFiles )