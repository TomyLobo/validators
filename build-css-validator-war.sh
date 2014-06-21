#!/bin/sh

## this script probably runs only on a Linux-based machine
## you need CVS, Java and ant to be already installed

# check out the source
if [ ! -d 2002 ]; then
    export CVSROOT=":pserver:anonymous@dev.w3.org:/sources/public"
    echo
    echo "IMPORTANT: enter anonymous as the password for cvs"
    echo
    cvs login
    cvs get 2002/css-validator
    # fix for an issue with the Velocity templates
    sed -i '/Velocity.getLog/i }' ./2002/css-validator/org/w3c/css/index/IndexGenerator.java
    sed -i '/For each language, we set the context/i if(false) {' ./2002/css-validator/org/w3c/css/index/IndexGenerator.java
    sed -i 's/"1.6"/"1.7"/g' ./2002/css-validator/build.xml
    sed -i 's#<copy file="[^"]*velocity[^"]*.jar" tofile="[^"]*velocity[^"]*.jar"/>#\0<get dest="lib/velocity-tools-2.0.jar" src="http://central.maven.org/maven2/org/apache/velocity/velocity-tools/2.0/velocity-tools-2.0.jar"/>#' ./2002/css-validator/build.xml
fi;

# build the jar file
cd 2002/css-validator
ant
ant jar

# stages the jar and templates so that it's part of the SBT project
cd ../..
echo copying the jar and other files
cp 2002/css-validator/css-validator.jar lib
mkdir -p src/main/resources/org/w3c/css/index src/main/resources/org/w3c/css/css
cp 2002/css-validator/*html* src/main/resources/org/w3c/css/index
cp 2002/css-validator/org/w3c/css/index/*.vm src/main/resources
