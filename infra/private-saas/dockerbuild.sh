#!/bin/bash
# Docker login
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_REGION="ap-northeast-1"
REPOSITORY_NAME="private-saas-with-privatelink-app"
PROJECT_NAME="private-saas-with-privatelink"

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# build container image
docker build --platform linux/arm64 -t $REPOSITORY_NAME:latest ../../sample-app

# Set the ECR repository URI
ECR_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME
COMMIT_HASH=$(git rev-parse --short HEAD)

# Tag with latest and commit hash
docker tag $REPOSITORY_NAME:latest $ECR_URI:$COMMIT_HASH

# Push the image to the ECR repository
docker push $ECR_URI:$COMMIT_HASH
aws ssm put-parameter \
    --name "/${PROJECT_NAME}/ecr/${REPOSITORY_NAME}/latest-image-uri" \
    --type "String" \
    --value "$ECR_URI:$COMMIT_HASH" \
    --overwrite
echo "Docker image has been successfully built and pushed to the ECR repository."
