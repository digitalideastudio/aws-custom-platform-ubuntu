DIPlatform_Ubuntu
=======================
This repository contains the source for an Elastic Beanstalk Custom Platform.
This custom platform is based on **Ubuntu 16.04** and supports **Node.js 8.x.x**.

See the Packer template, *di_platform.json*, for details on the AMI and
scripts that the builder runs as it creates the platform.

Once Packer has built the platform, it is available in the Console,
EB CLI, and APIs/SDKs as "DI Platform Container".

For further information on custom platforms, see the
[Custom Platforms docs](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/custom-platforms.html).

### Usage
To create a new environment (usually for testing purposes) using this platform please run the following command:
```
eb create -p "arn:aws:elasticbeanstalk:us-west-2:NNNNNN:platform/DIPlatform_Ubuntu/X.Y.Z" di-new-platform-test -c di-new-platform-test
```
Where `NNNNNN` is your account ID and `X.Y.Z` is the platform version.
Please note: Don't forget to terminate the environment once you're done with testing:

```
eb terminate di-new-platform-test --force
```

### Development
To change the platform, please change any relevant files and issue the following command:
```
eb platform create
```
It will create a new version of the platform and new AMI images which can be used later for Elastic Beanstalk instances.
