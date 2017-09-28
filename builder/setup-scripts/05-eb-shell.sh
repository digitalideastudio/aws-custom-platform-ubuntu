#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

#### `eb ssh` support
apt -y install zsh zsh-syntax-highlighting
adduser --debug --home /home/ec2-user --disabled-password --shell /bin/zsh --gecos '' ec2-user
echo 'ec2-user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/99-ec2-user
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed -E 's|\s+env zsh||g' > /tmp/install-oh-my-zh.sh
chmod 777 /tmp/install-oh-my-zh.sh
su - ec2-user -c 'sh -c /tmp/install-oh-my-zh.sh'
git clone https://github.com/bhilburn/powerlevel9k.git /home/ec2-user/.oh-my-zsh/custom/themes/powerlevel9k

echo 'export ZSH=/home/ec2-user/.oh-my-zsh
ZSH_THEME="powerlevel9k/powerlevel9k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias tinker="php artisan tinker"
alias a="php artisan"
cd /var/www/html
' > /home/ec2-user/.zshrc

mkdir -p /home/ec2-user/.ssh
cp /home/ubuntu/.ssh/authorized_keys /home/ec2-user/.ssh
chown -R ec2-user: /home/ec2-user
chmod 700 /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys
