#!/bin/bash

echo 'ℹ️  Transforming files with babel ℹ️'
mkdir local-temp
yarn babel src --out-dir local-temp/LAYER_NAME
echo '✅  Transform complete ✅'

echo 'ℹ️  Copying files to /opt ℹ️'
sudo cp -r local-temp/LAYER_NAME /opt
echo '✅  Copied fules to /opt ✅'


echo 'ℹ️  Cleaning up ℹ️'
rm -rf local-temp
echo '✅  Cleaned up ✅'
