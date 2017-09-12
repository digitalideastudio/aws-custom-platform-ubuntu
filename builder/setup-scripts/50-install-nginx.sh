#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash

. $BUILDER_DIR/CONFIG

rm -rf /etc/nginx/

apt install -y nginx-full

rsync -ar $BUILDER_DIR/platform-uploads/etc/nginx/ /etc/nginx/
chmod 755 /etc/nginx/conf.d
chmod 644 /etc/nginx/nginx.conf
chown -R root: /etc/nginx

mkdir -p /var/www/html/public
echo '<?php echo "<h1>Tecdonor Platform is Ready!</h1>";' > /var/www/html/public/index.php
echo '<?php echo "<h1>Tecdonor Platform is Ready!</h1>";' > /var/www/html/index.php
chown -R www-data: /var/www
