#ifndef CLASSES_ATTRIBUTE_H
#define CLASSES_ATTRIBUTE_H

char * generate_attribute_name( Variable a, char * out );
char * generate_attribute_func_name( Variable a, char * out );

void ATTRsign_access_methods( Variable a, const char * objtype, FILE * file );
void ATTRprint_access_methods( const char * entnm, Variable a, FILE * file );

/** print logging code for access methods for attrs that are entities
 * \p var is the variable name, minus preceding underscore, or null if 'x' is to be used
 * \p dir is either "returned" or "assigned"
 */
void ATTRprint_access_methods_entity_logging( const char * entnm, const char * funcnm, const char * nm,
                                              const char * var, const char * dir, FILE * file );

/** print access methods for attrs that are entities
 * prints const and non-const getters and a setter
 */
void ATTRprint_access_methods_entity( const char * entnm, const char * attrnm, const char * funcnm, const char * nm,
                                      const char * ctype, Variable a, FILE * file );
#endif
