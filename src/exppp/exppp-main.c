#include <stdlib.h>
#include <stdio.h>
#include "../express/express.h"
#include "exppp.h"

static void
exppp_usage() {
    fprintf( stderr, "usage: %s [-a|A] [-v] [-d #] [-p <object_type>] {-w|-i <warning>} [-l <length>] [-o [file|--]] express_file\n", EXPRESSprogram_name );
    fprintf( stderr, "where\t-a or -A causes output to be alphabetized\n" );
    fprintf( stderr, "\t-v produces a version description\n" );
    fprintf( stderr, "\t-l specifies line length in output\n" );
    fprintf( stderr, "\t-o specifies the name of the output file (-- for stdout)\n" );
    fprintf( stderr, "\t-d turns on debugging (\"-d 0\" describes this further\n" );
    fprintf( stderr, "\t-p turns on printing when processing certain objects (see below)\n" );
    fprintf( stderr, "\t-w warning enable\n" );
    fprintf( stderr, "\t-i warning ignore\n" );
    fprintf( stderr, "and <warning> is one of:\n" );
    fprintf( stderr, "\tnone\n\tall\n" );
    LISTdo( ERRORwarnings, opt, Error_Warning )
    fprintf( stderr, "\t%s\n", opt->name );
    LISTod
    fprintf( stderr, "and <object_type> is one or more of:\n" );
    fprintf( stderr, "	e	entity\n" );
    fprintf( stderr, "	p	procedure\n" );
    fprintf( stderr, "	r	rule\n" );
    fprintf( stderr, "	f	function\n" );
    fprintf( stderr, "	t	type\n" );
    fprintf( stderr, "	s	schema or file\n" );
    fprintf( stderr, "	#	pass #\n" );
    fprintf( stderr, "	E	everything (all of the above)\n" );
    exit( 2 );
}

int Handle_Exppp_Args( int i, char * arg ) {
    if( tolower( ( char )i ) == 'a' ) {
        exppp_alphabetize = true;
        return 0;
    } else if( tolower( ( char )i ) == 'o' ) {
        if( !strcmp( "--", arg ) ) {
            exppp_print_to_stdout = true;
            return 0;
        }
        exppp_output_filename_reset = false;
        exppp_output_filename = arg;
        return 0;
    } else if( tolower( ( char )i ) == 'l' ) {
        if( ( strlen( arg ) > 5 ) || ( strlen( arg ) < 2 ) ) {
            fprintf( stderr, "Unreasonable number of chars in arg for -l: %s\nTry 2-5 digits.", arg );
            return 1;
        }
        exppp_linelength = atoi( arg );
        return 0;
    }
    return 1;
}

void EXPRESSinit_init( void ) {
    exppp_alphabetize = false;
    EXPRESSbackend = EXPRESSout;
    ERRORusage_function = exppp_usage;
    strcat( EXPRESSgetopt_options, "aAo:l:" );
    EXPRESSgetopt = Handle_Exppp_Args;
}
