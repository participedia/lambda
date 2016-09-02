cd indexCase
zip -r ../indexCase.zip indexCase.js package.json node_modules
cd ..
cd indexMethod
zip -r ../indexMethod.zip indexMethod.js package.json node_modules
cd ..
cd indexOrganization
zip -r ../indexOrganization.zip indexOrganization.js package.json node_modules
cd ..
aws s3 cp indexCase.zip s3://pp-lambda/indexCase.zip
aws s3 cp indexMethod.zip s3://pp-lambda/indexMethod.zip
aws s3 cp indexOrganization.zip s3://pp-lambda/indexOrganization.zip
aws lambda update-function-code --function-name indexCase --s3-bucket pp-lambda --s3-key indexCase.zip
aws lambda update-function-code --function-name indexMethod --s3-bucket pp-lambda --s3-key indexMethod.zip
aws lambda update-function-code --function-name indexOrganization --s3-bucket pp-lambda --s3-key indexOrganization.zip


