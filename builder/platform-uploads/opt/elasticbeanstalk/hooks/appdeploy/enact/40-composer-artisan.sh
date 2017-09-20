#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

. /etc/TecdonorPlatform/platform.config

cd $LIVE_DIR

# Check if composer.json is here
if [ -f composer.json ]; then
    HOME=/root COMPOSER_HOME=/root composer install -n -o
    chown www-data: -R ./
    chmod 777 storage/logs
fi

# Check if Laravel app is here
if [ -f artisan ]; then
    php artisan migrate --force
fi