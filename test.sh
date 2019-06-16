#!/usr/bin/bash

WORKROOT=$(pwd)
cd ${WORKROOT}

# prepare PATH, GOROOT and GOPATH
export PATH=$(pwd)/go/bin:$PATH
export GOROOT=$(pwd)/go
export GOPATH=$(pwd)

ls -l ${GOPATH}/src/github.com/chef-partners/terraform-provisioner-habitat/habitat
go test ${GOPATH}/src/github.com/chef-partners/terraform-provisioner-habitat/habitat -v
if [ $? -ne 0 ];
then
    echo "Failure in habitat provisioner unit tests"
    exit 1
fi
echo "Successfully ran the unit tests for habitat provisioner"

