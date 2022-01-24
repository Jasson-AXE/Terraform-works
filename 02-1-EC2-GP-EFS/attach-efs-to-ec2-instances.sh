#!/bin/bash
yum -y update
yum install -y amazon-efs-utils
cd /home/ec2-user
mkdir efs
