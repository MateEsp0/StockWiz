#!/bin/bash

ACCOUNT_ID="905418384536"
REGION="us-east-1"
ECR_URL="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

cd product-service
docker build -t stockwiz-product-service .
docker tag stockwiz-product-service:latest $ECR_URL/stockwiz-product-service:latest
docker push $ECR_URL/stockwiz-product-service:latest
cd ..

cd inventory-service
docker build -t stockwiz-inventory-service .
docker tag stockwiz-inventory-service:latest $ECR_URL/stockwiz-inventory-service:latest
docker push $ECR_URL/stockwiz-inventory-service:latest
cd ..

cd api-gateway
docker build -t stockwiz-api-gateway .
docker tag stockwiz-api-gateway:latest $ECR_URL/stockwiz-api-gateway:latest
docker push $ECR_URL/stockwiz-api-gateway:latest
cd ..

echo "Uploaded digests:"
aws ecr describe-images --repository-name stockwiz-product-service     --query "imageDetails[?imageTags[0]=='latest'].imageDigest" --output text
aws ecr describe-images --repository-name stockwiz-inventory-service  --query "imageDetails[?imageTags[0]=='latest'].imageDigest" --output text
aws ecr describe-images --repository-name stockwiz-api-gateway        --query "imageDetails[?imageTags[0]=='latest'].imageDigest" --output text
