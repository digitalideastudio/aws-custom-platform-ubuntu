#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


#!/bin/bash

. /etc/TecdonorPlatform/platform.config

if [ -f $CONFIG_DIR/envvars.json ]; then
  ## NGINX OPTIONS
  # DOCUMENT_ROOT=/var/www/html/`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:container:php:phpini".document_root | select (.!=null)'`
  # DEFAULT=`cat /etc/nginx/sites-available/default | sed -E 's|root(\s*)(.*);|root\1'"$DOCUMENT_ROOT"';|'`
  # echo "$DEFAULT" > /etc/nginx/sites-available/default

  ## PHP OPTIONS
  MEMORY_LIMIT=`cat $CONFIG_DIR/envvars.json | jq -r .\"aws:elasticbeanstalk:container:php:phpini\".memory_limit`
  MAX_EXECUTION_TIME=`cat $CONFIG_DIR/envvars.json | jq -r .\"aws:elasticbeanstalk:container:php:phpini\".max_execution_time`
  DISPLAY_ERRORS=`cat $CONFIG_DIR/envvars.json | jq -r .\"aws:elasticbeanstalk:container:php:phpini\".display_errors`
  ALLOW_URL_FOPEN=`cat $CONFIG_DIR/envvars.json | jq -r .\"aws:elasticbeanstalk:container:php:phpini\".allow_url_fopen`
  ZLIB_OUTPUT_COMPRESSION=`cat $CONFIG_DIR/envvars.json | jq -r .\"aws:elasticbeanstalk:container:php:phpini\".zlib_output_compression`

  ### PHP ENV
  cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment"|to_entries|map("env[\(.key)]=\"\(.value|tostring)\"")|.[]|select(.!="env[]=\"null\"")' > /etc/php/7.0/fpm/env.conf
  REDIS_HOST=`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment".REDIS_HOST'`
  APP_URL=`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment".APP_URL'`

  if [ ! -z "$REDIS_HOST" ] && [ ! -z "$APP_URL" ]; then
      cat /etc/laravel-echo-server-example.json | \
          sed "s|__REDIS_HOST__|$REDIS_HOST|g" | \
          sed "s|__APP_URL__|$APP_URL|g" > /etc/laravel-echo-server.json

      supervisorctl update
  else
      echo "REDIS_HOST and APP_URL environment variables must be set in order to have Laravel Echo Server working"
  fi
fi