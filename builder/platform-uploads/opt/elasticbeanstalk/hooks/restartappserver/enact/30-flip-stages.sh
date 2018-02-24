#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

. /etc/DIPlatform/platform.config

rm -rf $LIVE_DIR
mv $STAGING_DIR $LIVE_DIR
cd $LIVE_DIR

# Check if composer.json is here
if [ -f composer.json ]; then
    HOME=/root COMPOSER_HOME=/root composer install -n -o
    chown www-data: -R ./
    chmod 777 storage/logs
    find public -type d -exec chmod 777 {} \;
fi

# Check if Laravel app is here
if [ -f artisan ]; then
    php artisan down --message="Configuring Database... Please wait" --retry=60
    # Check whether DB variables are populated
    DB_HOST=`cat $CONFIG_DIR/envvars.json | jq -e -r '."aws:elasticbeanstalk:application:environment".DB_HOST'` || exit 0
    DB_USERNAME=`cat $CONFIG_DIR/envvars.json | jq -e -r '."aws:elasticbeanstalk:application:environment".DB_USERNAME'` || exit 0
    DB_PASSWORD=`cat $CONFIG_DIR/envvars.json | jq -e -r '."aws:elasticbeanstalk:application:environment".DB_PASSWORD'` || exit 0

    # Check whether DB server is reachable
    mysql --connect-timeout=2 -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD -e 'SHOW VARIABLES LIKE "%version%";' || exit 0

    # Run migrations
    php artisan migrate --force --seed
    php artisan up
fi