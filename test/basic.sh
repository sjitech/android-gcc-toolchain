#!/bin/bash
function _msg { echo "$@" >&2; }
function _dbg { [[ $AGCC_DBG == 1 ]] && echo "$@" >&2; }
function _guide { echo "" "$@" >&2; }

thisDir=${0%/*}; [[ $0 != */* ]] && thisDir=.
if target=`readlink "$0"`; then if [[ $target == /* ]]; then thisDir=${target%/*}; elif [[ $target == */* ]]; then thisDir+=/${target%/*}; fi; fi
_dbg "thisDir: '$thisDir'"
hackDir=$thisDir/../host

PATH=$thisDir/..:$PATH

[[ `android-gcc-toolchain sh -c 'echo $BIN/' 2>&1 <<<"echo hi"` == */std-toolchains/android-9-arm/bin/ ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain arm     2>&1 <<<"echo hi"` == hi ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain arm    --host ar-dual-os,gcc-no-lrt,gcc-m32 -C  2>&1 <<<"echo hi"` == hi ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain arm     -c 2>&1 <<<"echo hi"` == hi ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain arm     -C 2>&1 <<<"echo hi"` == hi ]] && echo OK || echo $LINENO
#[[ `android-gcc-toolchain --host a 2>&1 <<<"echo hi"` == *"--host option must be used with -C|-c option"* ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain --host a -C 2>&1 <<<"echo hi"` == *"invalid host compiler rule"* ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain --host ar-dual-os,-compilers -C 2>&1 <<<"echo hi"` == *"invalid host compiler rule"* ]] && echo OK || echo $LINENO

rm -fr $hackDir/xxx
[[ `android-gcc-toolchain --host xxx -C 2>&1 <<<"echo hi"` == *"invalid host compiler rule"* ]] && echo OK || echo $LINENO
mkdir $hackDir/xxx
[[ `android-gcc-toolchain --host xxx -C 2>&1 <<<"echo hi"` == "hi" ]] && echo OK || echo $LINENO
rm -fr $hackDir/xxx

[[ `android-gcc-toolchain --host ,, -C 2>&1 <<<"echo hi"` == *"invalid host compiler rule"* ]] && echo OK || echo $LINENO
[[ `android-gcc-toolchain --host ,, -C --list-host-rules 2>&1 <<<"echo hi"` == *"Available host compiler rules"*gcc-m32* ]] && echo OK || echo $LINENO
