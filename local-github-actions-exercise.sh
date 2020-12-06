#!/bin/bash

# set default scheme

cd irish-rail-poc

scheme_list=$(xcodebuild -list -json | tr -d "\n")
default=$(echo $scheme_list | ruby -e "require 'json'; puts JSON.parse(STDIN.gets)['project']['targets'][0]")
echo $default | cat >default
echo Using default scheme: $default


# test
echo 'default='$default
device=`xcrun simctl list | grep -oE 'iPhone.*?[^\(]+' | tail -1`
device=`echo $device | xargs`
echo 'device='$device

scheme=$default

if [[ $scheme = default ]]; then scheme=$(cat default); fi
echo 'scheme='$scheme

if [ "`ls -A | grep -i \\.xcworkspace\$`" ]; then filetype_parameter="workspace" && file_to_build="`ls -A | grep -i \\.xcworkspace\$`"; else filetype_parameter="project" && file_to_build="`ls -A | grep -i \\.xcodeproj\$`"; fi

echo 'filetype_parameter='$filetype_parameter
echo 'file_to_build='$file_to_build

file_to_build=`echo $file_to_build | awk '{$1=$1;print}'`

echo 'file_to_build='$file_to_build

platform='iOS Simulator'

xcodebuild test-without-building -scheme "$scheme" -"$filetype_parameter" "$file_to_build" -destination "platform=$platform,name=$device"