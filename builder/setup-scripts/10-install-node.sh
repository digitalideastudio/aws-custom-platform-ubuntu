#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

. $BUILDER_DIR/CONFIG

### INSTALL AND VALIDATE NODE ####
echo "SETTING UP NODE ON THE INSTANCE"

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt install -y nodejs

echo "Validate Node.js got installed."
if [ -a /usr/bin/node ]; then
	NODE_VER=`/usr/bin/node --version`
	if [ -z "$NODE_VER" ];  then
		echo "Node could not be installed. "
	else
		echo "Node successfully installed.."
	fi
fi
