#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash

. $BUILDER_DIR/CONFIG

rm -rf /etc/php

apt install -y php7.1 \
  php7.1-bcmath \
  php7.1-bz2 \
  php7.1-cli \
  php7.1-curl \
  php7.1-dba \
  php7.1-fpm \
  php7.1-gd \
  php7.1-intl \
  php7.1-json \
  php7.1-mbstring \
  php7.1-mcrypt \
  php7.1-mysql \
  php7.1-opcache \
  php7.1-readline \
  php7.1-soap \
  php7.1-sqlite3 \
  php7.1-xml \
  php7.1-xmlrpc \
  php7.1-xsl \
  php7.1-zip \
  php-imagick \
  composer

rsync -ar $BUILDER_DIR/platform-uploads/etc/php/ /etc/php/
