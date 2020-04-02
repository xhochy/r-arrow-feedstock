#!/bin/bash

set -exuo pipefail

export BUILD_PREFIX_SH=${BUILD_PREFIX//\\//}
export BUILD_PREFIX_SH=/${BUILD_PREFIX_SH//:}

# Patch Makeconf
sed -i -e "s;g++;${BUILD_PREFIX_SH}/Library/bin/clang++.exe;g" $BUILD_PREFIX/Lib/R/etc/x64/Makeconf
sed -i -e "s;nm;${BUILD_PREFIX_SH}/Library/bin/llvm-nm.exe;g" $BUILD_PREFIX/Lib/R/etc/x64/Makeconf
sed -i -e "s;gnu++11;gnu++14;g" $BUILD_PREFIX/Lib/R/etc/x64/Makeconf
sed -i -e 's/attribute_visible/__declspec(dllexport)/g' $BUILD_PREFIX/Lib/R/library/Rcpp/include/RcppCommon.h

# Patch Rcpp
sed -i -e 's;abs;std::abs;g' $BUILD_PREFIX/Lib/R/library/Rcpp/include/Rcpp/DataFrame.h

# Patch build rules
sed -i -e 's/@ tmp\.def/@/g' $BUILD_PREFIX/Lib/R/share/make/winshlib.mk

sed -i -e 's/R_init_arrow/R_init_lib_arrow/g' r/src/arrowExports.cpp
sed -i -e 's/useDynLib(arrow/useDynLib(lib_arrow/g' r/NAMESPACE
