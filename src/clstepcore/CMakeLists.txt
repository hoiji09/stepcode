
set(LIBSTEPCORE_SRCS
  collect.cc                    mgrnodearray.cc                 sdaiSelect.cc
  complexlist.cc                mgrnodelist.cc                  SingleLinkList.cc
  dispnode.cc                   multlist.cc                     SingleLinkList.inline.cc
  dispnodelist.cc               needFunc.cc                     STEPaggregate.cc
  entlist.cc                    non-ors.cc                      STEPattribute.cc
  entnode.cc                    orlist.cc                       STEPattribute.inline.cc
  ExpDict.cc                    print.cc                        STEPattributeList.cc
  ExpDict.inline.cc             read_func.cc                    STEPcomplex.cc
  instmgr.cc                    Registry.inline.cc              STEPinvAttrList.cc
  match-ors.cc                  sdai.cc                         STEPundefined.cc
  mgrnode.cc                    sdaiApplication_instance.cc     trynext.cc
 )

set(SC_CLSTEPCORE_HDRS
  baseType.h                    mgrnodearray.h                  SingleLinkList.h
  complexSupport.h              mgrnodelist.h                   STEPaggregate.h
  dictdefs.h                    needFunc.h                      STEPattribute.h
  dispnode.h                    read_func.h                     STEPattributeList.h
  dispnodelist.h                Registry.h                      STEPcomplex.h
  ExpDict.h                     sdai.h                          STEPinvAttrList.h
  instmgr.h                     sdaiApplication_instance.h      STEPundefined.h
  mgrnode.h                     sdaiSelect.h                    SubSuperIterators.h
 )

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${SC_SOURCE_DIR}/src/base
  ${SC_SOURCE_DIR}/src/cldai
  ${SC_SOURCE_DIR}/src/cleditor
  ${SC_SOURCE_DIR}/src/clutils
  )

SC_ADDLIB(stepcore "${LIBSTEPCORE_SRCS}" "steputils;stepdai;base")

install(FILES ${SC_CLSTEPCORE_HDRS}
  DESTINATION ${INCLUDE_INSTALL_DIR}/stepcode/clstepcore)

if(SC_ENABLE_TESTING)
  add_subdirectory(test)
endif(SC_ENABLE_TESTING)

# Local Variables:
# tab-width: 8
# mode: cmake
# indent-tabs-mode: t
# End:
# ex: shiftwidth=2 tabstop=8

