#!/usr/bin/bash

WORKROOT=$(pwd)
cd ${WORKROOT}

# unzip go environment
go_env="go1.12.6.linux-amd64.tar.gz"
wget -c https://dl.google.com/go/go1.6.2.linux-amd64.tar.gz
tar -zxf $go_env
if [ $? -ne 0 ];
then
    echo "Failure in extracting go"
    exit 1
fi
echo "Successfully installed Go"
rm -rf $go_env

# prepare PATH, GOROOT and GOPATH
export PATH=$(pwd)/go/bin:$PATH
export GOROOT=$(pwd)/go
export GOPATH=$(pwd)

# build
cd ${WORKROOT}
go build -o terraform-provisioner-habitat_dev -v
if [ $? -ne 0 ];
then
    echo "Failure in building habitat provisioner"
    exit 1
fi
echo "Successfully built habitat provisoner"