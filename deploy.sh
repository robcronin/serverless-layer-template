#!/bin/bash

echo 'ℹ️  Transforming files with babel ℹ️'
mkdir deploy-temp
yarn babel commonFunctions --out-dir deploy-temp/commonFunctions
echo '✅  Transform complete ✅'

echo 'ℹ️  Zipping files ℹ️'
cd deploy-temp
zip -r commonFunctions.zip commonFunctions
echo '✅  Files zipped ✅'
 
echo 'ℹ️  Creating Serverless package ℹ️'
cd ..
sls package
mv deploy-temp/commonFunctions.zip .serverless/commonFunctions.zip
echo '✅  Serverless package created ✅'

echo 'ℹ️  Cleaning up ℹ️'
rm -rf deploy-temp
echo '✅  Cleaned up ✅'

echo 'ℹ️  Deploying ℹ️'
sls deploy --package .serverless
echo '✅  Successfully deployed ✅'
