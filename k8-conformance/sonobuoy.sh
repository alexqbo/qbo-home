#!/bin/bash

# sononuoy binary path
SONOBUOY=~/git/sonobuoy/
OUTPUT_DIR=$PWD

usage() {
    echo "$0 {kubeconfig_path} -- Run CNCF conformance results." 
    exit 1;
}
PROD_NAME=qbo

if [ -z $1 ]; then
    usage
fi

export KUBECONFIG=$1
echo "KUBECONFIG=$KUBECONFIG"

cd $SONOBUOY

if [ -d results ]; then
    mv results results-`date +%Y%m%d%H%M%S`
fi

K8S_VERSION=`kubectl version -o json  | jq -r .serverVersion.gitVersion | cut -d '.' -f 1-2`
echo "K8S_VERSION=$K8S_VERSION"

if [ -z $K8S_VERSION ]; then

    echo "Unable to get kubectl version"
    exit 1;
fi

QBO_VERSION=`docker exec -i qbo cli version | jq -r '.version[]?.qbo'`
echo "QBO_VERSION=$QBO_VERSION"
if [ -z $QBO_VERSION ]; then

    echo "Unable to get qbo version"
    exit 1;
fi

./sonobuoy run --mode=certified-conformance --wait
OUTFILE=$(./sonobuoy retrieve)
mkdir ./results; tar xzf $OUTFILE -C ./results


if [ ! -d  ${OUTPUT_DIR}/${K8S_VERSION}/${PROD_NAME}/ ]; then
    mkdir -p ./${K8S_VERSION}/${PROD_NAME}
fi
cp ./results/plugins/e2e/results/global/* ${OUTPUT_DIR}/${K8S_VERSION}/${PROD_NAME}/

cat << EOF > ${OUTPUT_DIR}/${K8S_VERSION}/${PROD_NAME}/PRODUCT.yaml
vendor: QBO LLC
name: $PROD_NAME
version: $QBO_VERSION
website_url: https://github.com/alexeadem/qbo-home
repo_url: https://github.com/alexeadem/qbo-home
documentation_url: https://github.com/alexeadem/qbo-home
product_logo_url: https://raw.githubusercontent.com/alexeadem/qbo-home/master/qbo_250x150.svg
type: distribution
description: "QBO is the fastest and easiest k8s deployment out there. It uses https://kind.sigs.k8s.io/ node images to deploy k8s clusters everywhere. It has a web graphical interface and a Websockets API. It doesn't require virtual machines. It is written in C and runs in docker."
EOF


cat << EOF > ${OUTPUT_DIR}/${K8S_VERSION}/${PROD_NAME}/README.md

# CNCF conformance results with QBO

# Requirements
> Linux kernel-5.6.6 or higher and Docker API version 1.40 or higher
> Tested in Fedora, Ubuntu and Debian.

# Clone QBO Home repo

```
git clone https://github.com/alexeadem/qbo-home.git
```

# Start the QBO API
```
cd qbo-home
./qbo start api 
```

# Create a Kubernetes cluster
> Access the web interface via a web browser: [http://localhost:9601/](http://localhost:9601/)
> Type `test` in the autocomplete section and select the Kubernetes version you plan to test
> Wait for the cluster to be created

# Run conformance tests
> Once the cluster has been created you can use the following script to get the results

```
cd k8-conformance
./sonobuoy.sh ~/.qbo/test.conf
```
EOF




