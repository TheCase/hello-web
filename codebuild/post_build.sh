#!/bin/bash
# have to do this in a script because the env vars are not being 
# held in the environment even thoughthe 0.2 buildspec says they should
source codebuild/env.sh

if [ "$GIT_BRANCH" == "master" ]; then
  echo "Pusing master as latest..."
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
  TAG_REF=`git showref --tags $GIT_TAG | awk {'print $1'}`
  echo "# TAG_REF = $TAG_REF"
  if [ "$TAG_REF" == "$GIT_COMMIT"]; then
    echo "Pusing $GIT_TAG..."
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_TAG
  fi 
else
  echo "Pusing $GIT_BRANCH..."
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_BRANCH
  echo "Pusing $GIT_BRANCH-$GIT_SHA..."
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_BRANCH-$GIT_SHA

fi
