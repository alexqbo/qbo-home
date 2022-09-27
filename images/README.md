
- [Custom Kind Images](#custom-kind-images)
  - [Requirements](#requirements)
  - [Configuration](#configuration)
  - [Image script](#image-script)
  - [K8s Tags](#k8s-tags)
  - [GitLab Registry](#gitlab-registry)
  - [Find latest tag](#find-latest-tag)
  - [Build Kind Base Image](#build-kind-base-image)
  - [Build Kind Node Image v1.25.2](#build-kind-node-image-v1252)

# Custom Kind Images

## Requirements
> Install `buildx`
> 
> Get buildx binary here: [https://github.com/docker/buildx#linux-packages](https://github.com/docker/buildx#linux-packages)

```
 mv ~/Downloads/buildx-v0.9.1.linux-amd64 ~/.docker/cli-plugins/docker-buildx	
 chmod +x ~/.docker/cli-plugins/docker-buildx

```

## Configuration

```
vi image
```

> Replace the following values with your Gitlab configuration.

```
### BEGIN GITLAB ###

REGISTRY=replace_with_gitlab_registry
API=replace_with_gitlab_api
OWNER=replace_wtih_gitlab_user
REPO=replace_with_gitlab_repo

### END GITLAB ###


```

## Image script

> `image` script can create custom kind images directly from the K8s source code and push the images to a Gitlab repo.

```
./image 
./image list k8s                          - list all remote tags
./image list registry                     - list qbo nodes tags in registry
./image last {tag}                        - get lastest tags from https://github.com/kubernetes/kubernetes.git (default v1.18.19)
./image build base                        - build base image
./image build node {tag}                  - build node image
```

## K8s Tags
> List k8s tags availale in Kubernetes upstream
```
./image list k8s
e8f0a6a19633ff704b78220666a54dce6d49942d	refs/tags/v1.26.0-alpha.1
1e4d7df2a59801e51c20fba94ad4153d270606f7	refs/tags/v1.26.0-alpha.0
3cb39a645e8ee19b3b121296399d065855d0457c	refs/tags/v1.25.3-rc.0
3229d1c27de5bc65b21139888f83b13c8e282f33	refs/tags/v1.25.2-rc.0
e313ec204d698755f1772515a87764bf524c8ac6	refs/tags/v1.25.2
8188504b9f2f08a1545f905733a9ec6820a62ee7	refs/tags/v1.25.1-rc.0
c3a6b2bc5f5a42fb3159df90f58980f22ce3cf4b	refs/tags/v1.25.1
...
```

## GitLab Registry

> List all images available in the Gitlab repo

```
./image list registry
https://registry.eadem.com/v2/alex/qbo-ctl/node/tags/list
{"name":"alex/qbo-ctl/node","tags":["v1.17.17","v1.18.19","v1.19.11","v1.20.7","v1.21.1","v1.25.2"]}
```

## Find latest tag

> Find the latest 1.25.x version

```
./image last 1.25
v1.25.2
```

## Build Kind Base Image
> For more info see https://kind.sigs.k8s.io/docs/design/base-image/

```
./image build base
```

## Build Kind Node Image v1.25.2
> For more info see https://kind.sigs.k8s.io/docs/design/node-image/

```
./image build node v1.25.2
```