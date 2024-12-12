#!/bin/bash

PROJECT_PATH=$(pwd)

cd $PROJECT_PATH

flutter build apk --release

echo "The APK build has completed successfully and the file is saved at $PROJECT_PATH/build/app/outputs/apk/app-release.apk"
