![qbo-home](./qbo-home.png)

- [`QBO Home`](#qbo-home)
- [Features](#features)
- [Download](#download)
- [Configuration](#configuration)
  - [Registries](#registries)
    - [Docker](#docker)
    - [Gitlab](#gitlab)
  - [Images](#images)
  - [MacOS](#macos)
  - [Linux](#linux)
    - [inotify](#inotify)
    - [cgroups](#cgroups)
- [Start QBO API](#start-qbo-api)
- [Web Interface](#web-interface)
- [QBO CLI](#qbo-cli)
- [Cluster Operations](#cluster-operations)
  - [Add Cluster](#add-cluster)
  - [Stop cluster](#stop-cluster)
  - [Start cluster](#start-cluster)
  - [Delete cluster](#delete-cluster)
- [Node Operations](#node-operations)
  - [Stop Node](#stop-node)
  - [Start Node](#start-node)
  - [Add Node](#add-node)
  - [Delete Node](#delete-node)
  - [Get Networks](#get-networks)
  - [Get Clusters](#get-clusters)
- [kubectl configuration](#kubectl-configuration)
- [Logs](#logs)

# `QBO Home`

QBO is the fastest and easiet k8s deployment out there. It uses Docker in Docker [https://kind.sigs.k8s.io/](https://kind.sigs.k8s.io/) node images to deploy k8s clusters in seconds in MAC and Linux. It has a web graphical interface and a Websockets API. It doesn't require virtual machines

Compatible with docker kind images [https://hub.docker.com/r/kindest/node/tags](https://hub.docker.com/r/kindest/node/tags)

# Features


○ Installation<br>
■ Local machine<br>

○ OS<br>
■ Linux<br>
■ MacOS<br>

○ Multi cluster support<br>
○ Cluster scaling<br>

○ Cluster operations<br>
■ Add cluster<br>
■ Delete cluster<br>
■ Stop cluster<br>
■ Start cluster<br>

○ Node operations<br>
■ Add node<br>
■ Delete node<br>
■ Start node<br>
■ Stop node<br>

○ Kubernetes<br>
■ Kubeconfig management<br>

○ CNI<br>
■ kindnet<br>

○ Registry<br>
■ Gitlab Regsitry<br>
■ Docker Hub<br>

■ Kind Kubernetes image support<br>
■ Custom image support<br>

○ Management<br>
■ `qbo` Websockets API<br>
■ `qbo` CLI<br>
■ Web interface<br>
■ Real Time logs<br>
■ Web terminal<br>


# Download
> From a Mac or Linux OS:
```
git clone https://git.eadem.com/alex/qbo-home.git
cd qbo-home
```

# Configuration


## Registries

### Docker
> To use default kind images you can set the follwing configuration: 

```
cat << EOF > ~/.qbo/api.json
{
"registry_user":"kindest",
"registry_auth":"hub.docker.com",
"registry_token":"",
"registry_repo":"",
"registry_hostname":"hub.docker.com",
"registry_type":"docker"
}
EOF
```

### Gitlab

> `qbo` support `Gitlab` registries and authentication.

> Sample config:

```
cat << EOF > ~/.qbo/api.json
{
"registry_user":"alex",
"registry_auth":"git.eadem.com",
"registry_token":"4Xo5X241L5vmsFSpkzXX",
"registry_repo":"qbo-home",
"registry_hostname":"registry.eadem.com",
"registry_type":"gitlab"
}
E0F

```


## Images
> You can create custom images and host them in Gitlab or Docker Hub. For more information on how to create custom images:
> 
> https://kind.sigs.k8s.io/docs/design/node-image/
## MacOS

> Install Docker Desktop on Mac
> [https://docs.docker.com/desktop/install/mac-install/](https://docs.docker.com/desktop/install/mac-install/) 


> QBO requires docker.raw.sock to work in MAC OS. 
> While Docker Desktop is running, run the following cmds to fix this:
```
sudo rm /var/run/docker.sock
sudo ln -s ~/Library/Containers/com.docker.docker/Data/docker.raw.sock /var/run/docker.sock
```
> Restart Docker Desktop

> Optional:
> 
> Install `jq` in MacOS

```
brew install jq
```


## Linux

### inotify
> `inotify` default settings are not set to run cluster with multiple nodes, increase the resource limits as defined by `fs.inotify.max_user_watches` and `fs.inotify.max_user_instances` or you may experience `too many open files` errors.

```
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512

```
### cgroups

> Disable `systemd.unified_cgroup_hierarchy=0"` to run kubernetes verisons earlier than `v1.24.0`

>Fedora
```
sudo grubby --update-kernel=`sudo grubby --default-kernel` --args="systemd.unified_cgroup_hierarchy=0"
sudo reboot
```
> Ubuntu
```
sudo vi /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="systemd.unified_cgroup_hierarchy=0 quiet splash"
sudo update-grub  
sudo reboot

```


References: 

> [https://kind.sigs.k8s.io/docs/user/known-issues/](https://kind.sigs.k8s.io/docs/user/known-issues/)

> Optional:
> 
> Install `jq` in Fedora

``` 
sudo dnf install jq
```
# Start QBO API

> Start the QBO API to start creating cluster using `kind` images and access the web UI.
> 
```
./qbo start api 
```

# Web Interface
> Access the web interface via a web browser: [http://localhost:9601/](http://localhost:9601/)

![QBO web interface](qbo_web_interface.gif)
# QBO CLI

```
qbo start api                         -- start api
 -c                                   -- start clean
qbo stop api                          -- stop api api
qbo attach terminal                   -- attach api. (CTRL-p, CTL-q) to exit
qbo logs                              -- get api logs
 -f                                   -- follow logs
qbo add cluster {cluster_name ...}
 -n {number_of_nodes}
qbo delete cluster {cluster_name ... | -A}
qbo stop cluster {cluster_name ... | -A}
qbo start cluster {cluster_name ... | -A}
qbo add node {cluster_name ... }
 -n {numer_of_nodes}
qbo get network(s) {cluster_name ... | -A}
qbo get cluster(s) {cluster_name ... | -A}
qbo get image(s)
qbo version
qbo help

```


# Cluster Operations
## Add Cluster
> Create two new cluster `dev prod` cluster
```
qbo add cluster dev prod | jq

```

> Create new cluster `test` with `5` nodes
```
qbo add cluster test -n 5 | jq

```

## Stop cluster
> Stop cluster `test`. All nodes in cluster `test` will be stopped
```
qbo stop cluster test | jq

```
## Start cluster
> Start cluster `test`.

```
qbo start cluster test | jq

```
## Delete cluster
> Delete cluster `test`. Cluster will be deleted. Operation is irreversible  

```
qbo delete cluster test | jq

```

 > Delete `all` clusters.  


```
qbo delete cluster -A | jq

```

# Node Operations

## Stop Node
> Stops node with name `node-8a774663.localhost` `bfc61532`
```
qbo stop node node-123 node-567 | jq

```

## Start Node
> Starts nodes `bfc61532`

```
qbo start node node-123 | jq

```
## Add Node

> Add new a new node to cluster `test`

```
qbo add node test | jq

```

> Add new `2` new nodes to cluster `test`

```
qbo add node test -n 2 | jq

```
## Delete Node
> Scale cluster down by deleting node `node-8a774663.localhost`

```
qbo del node node-123 | jq

```
## Get Networks
> Get all cluster networks
```
qbo get networks -A
```
> Get `dev` and `prod` cluster networks
```
qbo get network dev prod
```
## Get Clusters
> Get all clusters
```
qbo get clusters -A
```

# kubectl configuration

> From `qbo` web terminal
```
export KUBECONFIG=/tmp/qbo/test.conf
kubectl get nodes
```

> In linux 

```
export KUBECONFIG=~/.qbo/test.conf
kubectl get nodes
```
# Logs

> Follow `qbo` api logs
```
qbo logs api -f
```
> Open logs with `vi`

```
qbo logs api
```

