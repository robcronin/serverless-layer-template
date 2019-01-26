# Serverless Layer Template

This repo is derived from [AnomalyInnovations/serverless-nodejs-starter](https://github.com/AnomalyInnovations/serverless-nodejs-starter)

It provides the set up to create an AWS lambda layer with serverless using babel 7

- jest, eslint and prettier configured

Layers can then be used in any of your other lambdas

- e.g. a layer could be common code you use in many lambdas

A template with support for these layers: https://github.com/robcronin/serverless-lambda-with-optional-layer-template

For an example repo of a lambda with a layer created with these templates see [here](https://github.com/robcronin/lambda-with-layer-example)

## Requirements

- [Install the Serverless Framework](https://serverless.com/framework/docs/providers/aws/guide/installation/)
- [Configure your AWS CLI](https://serverless.com/framework/docs/providers/aws/guide/credentials/)

## Install

```
sls install --url https://github.com/robcronin/serverless-layer-template --name [NAME_OF_YOUR_LAYER]
```

or

```
git clone https://github.com/robcronin/serverless-layer-template
```

- `cd [NAME_OF_YOUR_LAYER]`
- `yarn`
- `./setUp.sh` - answer the prompts

## Modify

Edit the code in the `src` directory as required

By default it is a simple sum function

## Deploy

- `yarn deploy` or `./deploy.sh`
  - This will transpile your code with babel, create the serverless package and deploy it
  - The output will give you the `arn` you will need in your lambda functions

## Usage

- In your actual lambda elsewhere add this `arn` to your function config:

```yml
functions:
  hello:
    handler: handler.hello
    events:
      - http:
          path: hello
          method: get
    layers:
      - [YOUR_ARN_HERE]
```

- At runtime the code in your layer will now be located at `/opt`
- If you had deployed the default sum function in this repo, you could then import it with:

```js
import { sum } from '/opt/[LAYER_NAME]';
```

## Local usage

- As you are not creating endpoints you can't use the useful `sls invoke` or `sls offline start`
- If you wish to use your layer locally in another lambda, one solution is to copy your code to your local `/opt`
  - `./local.sh` will do this for you (requires `sudo` permission)
  - While developing the code in your layer you can use `yarn watch` which will run `local.sh` after any file changes (requires `sudo` permission)
- Note: if you use webpack in your main function you may run into issues with this, use https://github.com/robcronin/serverless-lambda-with-optional-layer-template for a working template

## Tests

`yarn test` will run:

- `yarn lint`
- `yarn jest`
