#!/bin/bash

echo 'ℹ️  Transforming files with babel ℹ️'
rm -rf deploy-temp
rm -rf src/temp
mkdir deploy-temp
yarn install --modules-folder src/temp --production=true --ignore "package.json"
yarn
cd src
mv temp node_modules
cd ..
yarn babel src --out-dir deploy-temp/LAYER_NAME
echo '✅  Transform complete ✅'

echo 'ℹ️  Fixing bad requires in source-map-support (WIP) ℹ️'
cd deploy-temp/LAYER_NAME/node_modules/source-map-support
sed -i.bak "s/require('.\/')/require('.\/source-map-support')/" register.js && rm register.js.bak
sed -i.bak "s/require('source-map')/require('.\/node_modules\/source-map\/source-map')/" source-map-support.js && rm source-map-support.js.bak
cd ../../../..
echo '✅  Fixed bad requires in source-map-support (WIP) ✅'

echo 'ℹ️  Zipping files ℹ️'
cd deploy-temp
zip -r LAYER_NAME.zip LAYER_NAME
cd ..
echo '✅  Files zipped ✅'
 
echo 'ℹ️  Creating Serverless package ℹ️'
sls package
mv deploy-temp/LAYER_NAME.zip .serverless/LAYER_NAME.zip
echo '✅  Serverless package created ✅'

echo 'ℹ️  Cleaning up ℹ️'
rm -rf deploy-temp
rm -rf src/temp
echo '✅  Cleaned up ✅'

echo 'ℹ️  Deploying ℹ️'
sls deploy --package .serverless
echo '✅  Successfully deployed ✅'
