#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


#!/bin/bash

. /etc/DIPlatform/platform.config

cp /etc/DIPlatform/.env.default $LIVE_DIR/.env

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
  while read -r line; do
      option_name=`echo $line | cut -d"=" -f1`
      line_number=`egrep -n "^${option_name}=" /etc/DIPlatform/.env.default | cut -d':' -f1`
      sed -i "${line_number}s|.*|${line}|" $LIVE_DIR/.env
  done <<<`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment"|to_entries|map("\(.key)=\"\(.value|tostring)\"")|.[]|select(.!="=\"null\"")'`

  REDIS_HOST=`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment".REDIS_HOST'`
  APP_URL=`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment".APP_URL'`
  DOMAIN_NAME=`cat $CONFIG_DIR/envvars.json | jq -r '."aws:elasticbeanstalk:application:environment".DOMAIN_NAME'`

  if [ ! -z "$REDIS_HOST" ]; then
      redis-cli -h $REDIS_HOST --scan | xargs redis-cli -h $REDIS_HOST DEL
  fi

  if [ ! -z "$REDIS_HOST" ] && [ ! -z "$APP_URL" ]; then
      cat /etc/laravel-echo-server-example.json | \
          sed "s|__REDIS_HOST__|$REDIS_HOST|g" | \
          sed "s|__APP_URL__|$APP_URL|g" > /etc/laravel-echo-server.json

      supervisorctl restart all
  else
      echo "REDIS_HOST and APP_URL environment variables must be set in order to have Laravel Echo Server working"
  fi

  #### Generate a new Munin config
  cat /etc/munin.example.conf | sed "s|__DOMAIN_NAME__|$DOMAIN_NAME|g" > /etc/munin/munin.conf
  service munin-node restart
fi