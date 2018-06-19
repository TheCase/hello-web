#!/bin/bash
# have to do this in a script because the env vars are not being 
# held in the environment even thoughthe 0.2 buildspec says they should
source codebuild/env.sh

echo "Pushing _build-cache..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:_build-cache

if [ "$GIT_BRANCH" == "master" ]; then
  echo "Pushing master as master..."
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:master
  TAG_REF=`git show-ref --tags ${GIT_TAG} | awk {'print $1'}`
  echo "# TAG_REF = $TAG_REF"
  if [ "$TAG_REF" == "$GIT_COMMIT" ]; then
    echo "Pushing master as latest..."
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
    echo "Pushing $GIT_TAG..."
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_TAG
  fi 
else
  echo "Pushing $GIT_BRANCH..."
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_BRANCH
  echo "Pushing $GIT_BRANCH-$GIT_SHA..."
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_BRANCH-$GIT_SHA

fi
