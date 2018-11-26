aws s3api create-bucket --bucket rothsmith-cloudformation --region us-east-1 
aws s3api put-bucket-policy --bucket rothsmith-cloudformation --policy file://cf-bucketpolicy.json
