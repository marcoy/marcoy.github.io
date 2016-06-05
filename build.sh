#!/bin/bash

BUILD_OUTPUT=../site

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e 

# cleanup
rm -rf "$BUILD_OUTPUT"

git clone -b jekyll-staging https://${GH_TOKEN}@github.com/marcoy/marcoy.github.io.git "$BUILD_OUTPUT"

# Clear out the content of ${BUILD_OUTPUT}
rm -rf "${BUILD_OUTPUT}/*"

jekyll build -V -d "$BUILD_OUTPUT"

cd "$BUILD_OUTPUT"
git status
git add -A .
git config user.email "marcoy@gmail.com"
git config user.name "Marco Yuen"
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin jekyll-staging > /dev/null 2>&1
