#!/bin/sh

# Script take from:
# <http://masteringswift.blogspot.de/2016/01/swift-for-linux-part-1-building.html>

PROJECTNAME=""
DIRNAME=""
PACKAGEFILENAME="Package.swift"
MAINFILENAME="main.swift"
SOURCESDIRNAME="Sources"

#Check to make sure at least one command
#line arg is present otherwise exit script
if [ $# -le 0 ]; then
    echo "Usage: creatproject {Name for project} {Optional directory name}"
    exit 1
fi

#Assign the value of the first command line arg to the project name
#if a second command line arg is present assign that value to the
#the directory name otheerwise use the project name
PROJECTNAME=$1
if [ "$1" != "" ]; then
    DIRNAME=$1
else
    DIRNAME=$PROJECTNAME
fi

#Check to see if the directory exists and if so display an error
#and exit
if [ -d "$DIRNAME" ]; then
    echo "Directory already exists, please choose another name"
    exit 1
fi

#Make the directory structure
mkdir -p $DIRNAME/$SOURCESDIRNAME

#Change to the project's directory and create the Package.swift file
cd $DIRNAME
touch $PACKAGEFILENAME

echo "import PackageDescription" >> $PACKAGEFILENAME
echo "" >> $PACKAGEFILENAME
echo "let package = Package(" >> $PACKAGEFILENAME
echo "    name:  \"$PROJECTNAME\"" >> $PACKAGEFILENAME
echo ")" >> $PACKAGEFILENAME

#Change to the Sources directory and create the main.swift file
cd $SOURCESDIRNAME
touch $MAINFILENAME

echo "import Foundation" >> $MAINFILENAME
echo ""  >> $MAINFILENAME
echo "print(\"Hello from Swift\")" >> $MAINFILENAME
