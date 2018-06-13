#!/bin/bash

CI=true
CB=true

CB_GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$CB_GIT_BRANCH" == "" ] ; then
  CB_GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  CB_GIT_BRANCH=${CB_GIT_BRANCH#remotes/origin/}
fi

CB_GIT_MESSAGE=`git log -1 --pretty=%B`
CB_GIT_AUTHOR=`git log -1 --pretty=%an`
CB_GIT_AUTHOR_EMAIL=`git log -1 --pretty=%ae`
CB_GIT_COMMIT=`git log -1 --pretty=%H`
CB_GIT_TAG=`git describe --tags --abbrev=0`

CB_PULL_REQUEST=false
if [[ $CB_GIT_BRANCH == pr-* ]] ; then
  CB_PULL_REQUEST=${CB_GIT_BRANCH#pr-}
fi

CB_PROJECT=${CB_BUILD_ID%:$CB_LOG_PATH}
CB_BUILD_URL=https://$AWS_DEFAULT_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_DEFAULT_REGION#/builds/$CB_BUILD_ID/view/new

echo "==> AWS CodeBuild Extra Environment Variables:"
echo "==> CI = $CI"
echo "==> CB = $CB"
echo "==> CB_GIT_AUTHOR = $CB_GIT_AUTHOR"
echo "==> CB_GIT_AUTHOR_EMAIL = $CB_GIT_AUTHOR_EMAIL"
echo "==> CB_GIT_BRANCH = $CB_GIT_BRANCH "
echo "==> CB_GIT_COMMIT = $CB_GIT_COMMIT"
echo "==> CB_GIT_MESSAGE = $CB_GIT_MESSAGE"
echo "==> CB_GIT_TAG = $CB_GIT_TAG"
echo "==> CB_PROJECT = $CB_PROJECT"
echo "==> CB_PULL_REQUEST = $CB_PULL_REQUEST"
