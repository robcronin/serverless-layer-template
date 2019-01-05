#!/bin/bash

echo 'ℹ️  Transforming files with babel ℹ️'
rm -rf local-temp
rm -rf src/temp
mkdir local-temp
yarn install --modules-folder src/temp --production=true --ignore "package.json"
yarn
cd src
mv temp node_modules
cd ..
yarn babel src --out-dir local-temp/LAYER_NAME
echo '✅  Transform complete ✅'

echo 'ℹ️  Fixing bad requires in source-map-support (WIP) ℹ️'
cd local-temp/LAYER_NAME/node_modules/source-map-support
sed -i.bak "s/require('.\/')/require('.\/source-map-support')/" register.js && rm register.js.bak
sed -i.bak "s/require('source-map')/require('.\/node_modules\/source-map\/source-map')/" source-map-support.js && rm source-map-support.js.bak
cd ../../../..
echo '✅  Fixed bad requires in source-map-support (WIP) ✅'


echo 'ℹ️  Copying files to /opt ℹ️'
sudo cp -r local-temp/LAYER_NAME /opt
echo '✅  Copied fules to /opt ✅'


echo 'ℹ️  Cleaning up ℹ️'
rm -rf local-temp
rm -rf src/temp
echo '✅  Cleaned up ✅'
