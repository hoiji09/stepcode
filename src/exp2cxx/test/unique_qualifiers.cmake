cmake_minimum_required( VERSION 2.8 )

# executable is ${EXE}, input file is ${INFILE}

set( ofile "SdaiAll.cc" )
execute_process( COMMAND ${EXE} ${INFILE}
                RESULT_VARIABLE CMD_RESULT )
if( NOT ${CMD_RESULT} EQUAL 0 )
    message(FATAL_ERROR "Error running ${EXE} on ${INFILE}")
endif( NOT ${CMD_RESULT} EQUAL 0 )

file( READ ${ofile} cxx LIMIT 4096 )

# ur = new Uniqueness_rule("UR1 : SELF\shape_aspect_relationship.name;\n");
string( REGEX MATCH "new  *Uniqueness_rule *\\\( *\\\" *[uU][rR]1 *: *SELF *\\\\ *shape_aspect_relationship *\\. *name" match_result ${cxx} )

if( match_result STREQUAL "" )
    message( FATAL_ERROR "exp2cxx output does not match input schema." )
endif( match_result STREQUAL "" )
