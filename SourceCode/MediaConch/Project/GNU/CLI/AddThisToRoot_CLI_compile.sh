#! /bin/sh

#############################################################################
# Configure
Home=`pwd`
ZenLib_Options=""

#############################################################################
# Setup for parallel builds
Zen_Make()
{
 numprocs=1
 if test -e /proc/stat; then
  numprocs=`egrep -c ^cpu[0-9]+ /proc/stat || :`
  if [ "$numprocs" = "" ] || [ "$numprocs" = "0" ]; then
   numprocs=1
  fi
 fi
 if type sysctl &> /dev/null; then
  numprocs=`sysctl -n hw.ncpu`
  if [ "$numprocs" = "" ] || [ "$numprocs" = "0" ]; then
   numprocs=1
  fi
 fi
 make -s -j$numprocs
}

#############################################################################
# ZenLib
if test -e ZenLib/Project/GNU/Library/configure; then
 cd ZenLib/Project/GNU/Library/
 test -e Makefile && rm Makefile
 chmod u+x configure
 ./configure $ZenLib_Options $*
 if test -e Makefile; then
  make clean
  Zen_Make
  if test -e libzen.la; then
   echo ZenLib compiled
  else
   echo Problem while compiling ZenLib
   exit
  fi
 else
  echo Problem while configuring ZenLib
  exit
 fi
else
 echo ZenLib directory is not found
 exit
fi
cd $Home

#############################################################################
# MediaInfoLib
if test -e MediaInfoLib/Project/GNU/Library/configure; then
 cd MediaInfoLib/Project/GNU/Library/
 test -e Makefile && rm Makefile
 chmod u+x configure
 ./configure $*
 if test -e Makefile; then
  make clean
  Zen_Make
  if test "$(./libmediainfo-config la_name)" != "" && test -e $(./libmediainfo-config la_name); then
   echo MediaInfoLib compiled
  else
   echo Problem while compiling MediaInfoLib
   exit
  fi
 else
  echo Problem while configuring MediaInfoLib
  exit
 fi
else
 echo MediaInfoLib directory is not found
 exit
fi
cd $Home

#############################################################################
# MediaConch
if test -e MediaConch/Project/GNU/CLI/configure; then
 cd MediaConch/Project/GNU/CLI/
 test -e Makefile && rm Makefile
 chmod u+x configure
 ./configure --enable-staticlibs $*
 if test -e Makefile; then
  make clean
  Zen_Make
  if test -e mediaconch; then
   echo MediaConch compiled
  else
   echo Problem while compiling MediaConch
   exit
  fi
 else
  echo Problem while configuring MediaConch
  exit
 fi
else
 echo MediaConch directory is not found
 exit
fi
cd $Home

#############################################################################
# Going home
cd $Home
echo "MediaConch executable is in MediaConch/Project/GNU/CLI"
echo "For installing, cd MediaConch/Project/GNU/CLI && make install"