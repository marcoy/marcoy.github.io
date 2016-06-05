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

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone -b jekyll-staging https://${GH_TOKEN}@github.com/marcoy/marcoy.github.io.git "$BUILD_OUTPUT"

rm -rf "${BUILD_OUTPUT}/*"

# copy generated HTML site to `master' branch
# cp -R _site/* ../marcoy.github.io.master

# build site with `jekyll', by default to `_site' folder
jekyll build -V -d "$BUILD_OUTPUT"

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd "$BUILD_OUTPUT"
git add -A .
git config user.email "marcoy@gmail.com"
git config user.name "Marco Yuen"
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin jekyll-staging > /dev/null 2>&1
