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

### Configure

Everything you place under `builder/platform-uploads/etc` path will appear under `/etc` directory on Ubuntu. So you can override any package you want.
Additionally, if you want to change an application or config deployment process, feel free to change scripts under `builder/platform-uploads/opt/elasticbeanstalk/hooks` directory for relevant hooks.
More details about Platform Hooks, please refer to [this article](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/custom-platform-hooks.html).

### 1. Build

In order to use the AMI in your region and account you need to build it first.
You may do it by issuing the following command:

```
ebp create
```

It will create a new version of the platform and new AMI image which can be used for your EC2 instances.

### 2. Utilize

To create a new environment using this platform use the following command:

```
eb create -p "aws_arn_identifier"
```
Where `aws_arn_identifier` is an ARN path to your recently built platform and has a similar format to: `arn:aws:elasticbeanstalk:us-east-1:1234567890:platform/DIPlatform_Ubuntu/1.2.3`. Copy this path from the previous step.

#### 3. Clean

In certain circumstances, instances launched by Packer are not cleaned up and have to be manually terminated.

```
eb terminate eb-custom-platform-builder-packer --force
```
Alternatively, you can use [manual cleanup](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/custom-platforms-packercleanup.html)

### TODO
* Add a config option for turning off/on ClamAV
* Enhance extended monitoring
