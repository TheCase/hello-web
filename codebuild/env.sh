#!/bin/bash

export CI=true
export CB=true

export GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$GIT_BRANCH" == "" ] ; then
  GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  export GIT_BRANCH=${GIT_BRANCH#remotes/origin/}
fi

export GIT_MESSAGE=`git log -1 --pretty=%B`
export GIT_AUTHOR=`git log -1 --pretty=%an`
export GIT_AUTHOR_EMAIL=`git log -1 --pretty=%ae`
export GIT_COMMIT=`git log -1 --pretty=%H`
export GIT_TAG=`git describe --tags --abbrev=0`

export PULL_REQUEST=false
if [[ $GIT_BRANCH == pr-* ]] ; then
  export PULL_REQUEST=${GIT_BRANCH#pr-}
fi

export PROJECT=${BUILD_ID%:$LOG_PATH}
export BUILD_URL=https://$AWS_DEFAULT_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_DEFAULT_REGION#/builds/$BUILD_ID/view/new

export GIT_SHA=`git rev-parse --short HEAD`

echo "==> AWS CodeBuild Extra Environment Variables:"
echo "==> CI = $CI"
echo "==> CB = $CB"
echo "==> GIT_AUTHOR = $GIT_AUTHOR"
echo "==> GIT_AUTHOR_EMAIL = $GIT_AUTHOR_EMAIL"
echo "==> GIT_BRANCH = $GIT_BRANCH "
echo "==> GIT_COMMIT = $GIT_COMMIT"
echo "==> GIT_SHA = $GIT_SHA"
echo "==> GIT_MESSAGE = $GIT_MESSAGE"
echo "==> GIT_TAG = $GIT_TAG"
echo "==> PROJECT = $PROJECT"
echo "==> PULL_REQUEST = $PULL_REQUEST"

printenv
