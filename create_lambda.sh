cd indexCase
npm install
zip -r ../indexCase.zip indexCase.js package.json node_modules
cd ..
cd indexMethod
npm install
zip -r ../indexMethod.zip indexMethod.js package.json node_modules
cd ..
cd indexOrganization
npm install
zip -r ../indexOrganization.zip indexOrganization.js package.json node_modules
cd ..
aws s3 cp indexCase.zip s3://pp-lambda/indexCase.zip
aws s3 cp indexMethod.zip s3://pp-lambda/indexMethod.zip
aws s3 cp indexOrganization.zip s3://pp-lambda/indexOrganization.zip

aws lambda create-function --region us-east-1 --function-name indexCase --code S3Bucket=pp-lambda,S3Key=indexCase.zip --role arn:aws:iam::647627399491:role/pp-lambda --handler indexCase.handler --runtime nodejs4.3 --profile ppadmin
aws lambda create-function --region us-east-1 --function-name indexMethod --code S3Bucket=pp-lambda,S3Key=indexMethod.zip --role arn:aws:iam::647627399491:role/pp-lambda --handler indexMethod.handler --runtime nodejs4.3 --profile ppadmin
aws lambda create-function --region us-east-1 --function-name indexOrganization --code S3Bucket=pp-lambda,S3Key=indexOrganization.zip --role arn:aws:iam::647627399491:role/pp-lambda --handler indexOrganization.handler --runtime nodejs4.3 --profile ppadmin

