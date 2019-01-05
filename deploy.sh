#!/bin/bash

echo 'ℹ️  Transforming files with babel ℹ️'
rm -rf deploy-temp
mkdir deploy-temp
yarn babel src --out-dir deploy-temp/LAYER_NAME
echo '✅  Transform complete ✅'

echo 'ℹ️  Installing yarn dependencies ℹ️'
yarn install --modules-folder deploy-temp/node_modules --production=true
echo '✅  Installed yarn dependencies ✅'

echo 'ℹ️  Zipping files ℹ️'
cd deploy-temp
zip -r LAYER_NAME.zip LAYER_NAME
echo '✅  Files zipped ✅'
 
echo 'ℹ️  Creating Serverless package ℹ️'
cd ..
sls package
mv deploy-temp/LAYER_NAME.zip .serverless/LAYER_NAME.zip
echo '✅  Serverless package created ✅'

echo 'ℹ️  Cleaning up ℹ️'
rm -rf deploy-temp
echo '✅  Cleaned up ✅'

echo 'ℹ️  Deploying ℹ️'
sls deploy --package .serverless
echo '✅  Successfully deployed ✅'
