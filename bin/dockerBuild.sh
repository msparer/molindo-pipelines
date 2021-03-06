#!/bin/bash -e
#
# build Dockerfile and push to ECR registry
#

# pipelines env
slug=${BITBUCKET_REPO_SLUG?}
commit=${BITBUCKET_COMMIT?}

# required variables
registry=${MOLINDO_DOCKER_REGISTRY?}

target=$registry/$slug:$commit

# ECR login
if [ `echo $registry | grep 'ecr\.[^.]*\.amazonaws\.com$'` ]; then
	# force env variables used by awscli
	key=${AWS_ACCESS_KEY_ID?}
	secret=${AWS_SECRET_ACCESS_KEY?}

	region=`echo $registry | sed -e 's/^.*\.\([^.]*\)\.amazonaws\.com$/\1/g'`
	echo "logging in to AWS ECR in $region"
	$( aws --region $region ecr get-login )
fi

echo "building $target"
docker build -t $target .

echo "pushing $target"
docker push $target
