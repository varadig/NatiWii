#!/bin/bash

# set for debug
# set -xv

TARGET=NatiWii


rm -f $TARGET

FLEX_SDK=/Volumes/Work/AS3/_SDK_/air_sdk_19
ADT=$FLEX_SDK/bin/adt
DEPLOYMENT=Release

echo $FLEX_SDK
echo $ADT

rm -rf build
rm -rf ane
mkdir -p build/mac
mkdir ane

cp -r ./osx/$TARGET/DerivedData/$TARGET/Build/Products/$DEPLOYMENT/$TARGET.framework build/mac
cp ./extension.xml build
cp ./as3/bin/$TARGET.swc build
unzip -o -q build/$TARGET.swc library.swf
mv library.swf build/mac

"$ADT" -package \
	-target ane $TARGET.ane build/extension.xml \
	-swc build/$TARGET.swc  \
	-platform MacOS-x86 \
	-C build/mac .
#	library.swf libIOSMightyLib.a
#	-platformoptions platformoptions.xml

if [ -f ./$TARGET.ane ];
then
    echo "SUCCESS"
	rm -rf build
	mv ./$TARGET.ane ./ane
	#cp $TARGET.ane ../Wiiskars/lib/
else
    echo "FAILED"
fi

