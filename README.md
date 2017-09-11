TecdonorPlatform_Ubuntu
=======================
This repository contains the source for an Elastic Beanstalk Custom Platform.
This custom platform is based on **Ubuntu 16.04** and supports **Node.js 6.11.3**.

See the Packer template, *tecdonor_platform.json*, for details on the AMI and
scripts that the builder runs as it creates the tecdonor platform.

Once Packer has built the tecdonor platform, it is available in the Console,
EB CLI, and APIs/SDKs as "Tecdonor Platform Container".

For further information on custom platforms, see the
[Custom Platforms docs](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/custom-platforms.html).

