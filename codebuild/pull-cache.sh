#!/bin/bash
# have to do this in a script because the env vars are not being 
# held in the environment even thoughthe 0.2 buildspec says they should
source codebuild/env.sh

docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$GIT_BRANCH || true
