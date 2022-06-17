#!/bin/sh

# Create management cluster
tanzu management-cluster create --file $HOME/.config/tanzu/tkg/clusterconfigs/mgmt-cluster-config.yaml

# Create workload cluster
tanzu cluster create --file $HOME/.config/tanzu/tkg/clusterconfigs/dev01-cluster-config.yaml
