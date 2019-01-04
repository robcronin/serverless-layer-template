#!/bin/bash

echo 'Name of Layer?'

read layerName

sed -i.bak "s/LAYER\_NAME/$layerName/g" deploy.sh serverless.yml package.json && rm deploy.sh.bak serverless.yml.bak package.json.bak