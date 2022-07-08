#!/bin/sh

# Prepare environment
. /home/ubuntu/.env

# Export vars
set -a
. /home/ubuntu/.govc.env
. /home/ubuntu/.vmd.env
set +a

# Set up HTTP proxy support
if ! [ -z "$HTTP_PROXY_HOST" ]; then
  export http_proxy=http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}
  export https_proxy=http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}
  export NO_PROXY=localhost,127.0.0.1,.svc,.local

  cat <<EOF >> /home/ubuntu/apt-proxy
Acquire {
  HTTP::proxy "http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}";
  HTTPS::proxy "http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}";
}
EOF
  sudo mv /home/ubuntu/apt-proxy /etc/apt/apt.conf.d/proxy
  sudo snap set system proxy.http="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}"
  sudo snap set system proxy.https="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}"

  cat <<EOF >> /home/ubuntu/docker-proxy
[Service]
Environment="HTTP_PROXY=http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}"
Environment="HTTPS_PROXY=http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}"
Environment="NO_PROXY="localhost,127.0.0.1,::1,.local"
EOF
  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo mv /home/ubuntu/docker-proxy /etc/systemd/system/docker.service.d/proxy.conf
fi

# Install vmd 
if ! [ -f /usr/local/bin/vmd ]; then
  curl -L https://github.com/laidbackware/vmd/releases/download/v0.3.0/vmd-linux-v0.3.0 -o /home/ubuntu/vmd-linux-v0.3.0 && \
    sudo install /home/ubuntu/vmd-linux-v0.3.0 /usr/local/bin/vmd && \
    rm /home/ubuntu/vmd-linux-v0.3.0
    cat ~/.vmd.env >> ~/.bashrc
fi

# Download Tanzu CLI
if ! [ -f /home/ubuntu/vmd-downloads/tanzu-cli-bundle-linux-amd64.tar ]; then
  vmd download -p vmware_tanzu_kubernetes_grid -s tkg -v 1.5.4 -f 'tanzu-cli-bundle-linux-amd64.tar.gz' --accepteula && \
    cp /home/ubuntu/vmd-downloads/tanzu-cli-bundle-linux-amd64.tar.gz /home/ubuntu/tanzu-cli.tar
fi

# Uncompress TKG archive and install CLI.
if [ -f /home/ubuntu/tanzu-cli.tar ]; then
  mkdir /home/ubuntu/tanzu && mv /home/ubuntu/tanzu-cli.tar /home/ubuntu/tanzu && \
    cd /home/ubuntu/tanzu && tar vxf tanzu-cli.tar && cd /home/ubuntu/tanzu/cli && \
    sudo install core/v*/tanzu-core-linux_amd64 /usr/local/bin/tanzu && \
    gunzip ytt-linux-amd64-*.gz && sudo install ytt-linux-amd64* /usr/local/bin/ytt && \
    gunzip kapp-linux-amd64*.gz && sudo install kapp-linux-amd64* /usr/local/bin/kapp && \
    gunzip imgpkg-linux-amd64*.gz && sudo install imgpkg-linux-amd64* /usr/local/bin/imgpkg && \
    gunzip kbld-linux-amd64*.gz && sudo install kbld-linux-amd64* /usr/local/bin/kbld && \
    gunzip vendir-linux-amd64*.gz && sudo install vendir-linux-amd64* /usr/local/bin/vendir && \
    tanzu init && \
    tanzu plugin clean

  # For TKG 1.5+:
  cd /home/ubuntu/tanzu && tanzu plugin sync

  cd /home/ubuntu && mkdir -p /home/ubuntu/.config/tanzu && \
    tanzu completion bash > /home/ubuntu/.config/tanzu/completion.bash.inc && \
    printf "\n# Tanzu shell completion\nsource '/home/ubuntu/.config/tanzu/completion.bash.inc'\n" >> ~/.bashrc
fi

# Generate a TKG cluster configurations
if ! [ -f /home/ubuntu/.config/tanzu/tkg/clusterconfigs/mgmt-cluster-config.yaml ]; then
  tanzu config init > /dev/null 2>&1
  mkdir -p ~/.config/tanzu/tkg/clusterconfigs
  mv /home/ubuntu/mgmt-cluster-config.yaml /home/ubuntu/.config/tanzu/tkg/clusterconfigs/mgmt-cluster-config.yaml
  mv /home/ubuntu/dev01-cluster-config.yaml /home/ubuntu/.config/tanzu/tkg/clusterconfigs/dev01-cluster-config.yaml
fi

# Generate a SSH keypair.
if ! [ -f /home/ubuntu/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f /home/ubuntu/.ssh/id_rsa -q -P ''
fi

# Install K8s CLI.
if ! [ -f /usr/local/bin/kubectl ]; then
  K8S_VERSION=v1.22.9
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo install ./kubectl /usr/local/bin/kubectl && \
    rm ./kubectl
    echo 'source <(kubectl completion bash)' >> ~/.bashrc
fi

# Install govc.
if ! [ -f /usr/local/bin/govc ]; then
  curl -L https://github.com/vmware/govmomi/releases/download/v0.20.0/govc_linux_amd64.gz | gunzip -c > /tmp/govc && \
    sudo install /tmp/govc /usr/local/bin/govc
  cat ~/.govc.env >> ~/.bashrc
fi

# Configure TKG.
if [ -f /home/ubuntu/tkg-cluster.yml ]; then
  cat /home/ubuntu/tkg-cluster.yml >> ~/.config/tanzu/tkg/config.yaml
  SSH_PUBLIC_KEY=`cat /home/ubuntu/.ssh/id_rsa.pub`
  cat <<EOF >> ~/.config/tanzu/tkg/config.yaml
VSPHERE_SSH_AUTHORIZED_KEY: "$SSH_PUBLIC_KEY"
EOF
  /bin/rm -f /home/ubuntu/tkg-cluster.yml
fi

# Install jq & yq.
sudo snap install jq
sudo snap install yq

# Upload TKG OVA
# TKG_OVA_NAME=photon-3-kube-v1.22.9+vmware.1-tkg.1-06852a87cc9526f5368519a709525c68
TKG_OVA_NAME=ubuntu-2004-kube-v1.22.9+vmware.1-tkg.1-2182cbabee08edf480ee9bc5866d6933
TKG_OVA_FILE=$TKG_OVA_NAME.ova
TKG_OVA_PATH=/home/ubuntu/vmd-downloads/$TKG_OVA_FILE
if ! [ -f $TKG_OVA_PATH ]; then
  vmd download -p vmware_tanzu_kubernetes_grid -s tkg -v 1.5.4 -f $TKG_OVA_FILE --accepteula && \
    govc import.spec ${TKG_OVA_PATH} | jq '.Name="'${TKG_OVA_NAME}'"' | jq '.NetworkMapping [0].Network="'"${GOVC_NETWORK}"'"' > tkg-ova.json && \
    govc import.ova -options=tkg-ova.json ${TKG_OVA_PATH} && \
    govc vm.markastemplate ${TKG_OVA_NAME} && \
    rm tkg-ova.json
fi

# Configure VIm.
if ! [ -f /home/ubuntu/.vimrc ]; then
  cat <<EOF >> /home/ubuntu/.vimrc
filetype plugin indent on
syntax on
set term=xterm-256color

set ai
set et
set ts=2
set sw=2
set ruler
set cursorcolumn
EOF
fi

# Install Docker.
sudo apt-get update && \
  sudo apt-get -y install docker.io && \
  sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker && \
  sudo usermod -aG docker ubuntu

# Various
sudo apt-get install -y unzip

# Install K9s.
if ! [ -f /usr/local/bin/k9s ]; then
  mkdir /home/ubuntu/k9s && \
  cd /home/ubuntu/k9s && \
  curl -L https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz -o k9s.tar.gz && \
  tar zxf k9s.tar.gz && \
  sudo install ./k9s /usr/local/bin/k9s && \
  cd /home/ubuntu && \
  rm -rf /home/ubuntu/k9s
fi

# Install kubectx.
if ! [ -f /usr/local/bin/kubectx ]; then
  curl -L https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx_v0.9.4_linux_x86_64.tar.gz -o /home/ubuntu/kubectx.tar.gz && \
  tar zxf /home/ubuntu/kubectx.tar.gz && \
  sudo install /home/ubuntu/kubectx /usr/local/bin/kubectx && \
  rm /home/ubuntu/kubectx /home/ubuntu/kubectx.tar.gz
fi

# Install Kind.
KIND_VERSION=v0.11.1
curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64
sudo mv kind /usr/local/bin
chmod +x /usr/local/bin/kind

# Add Aliases
if ! [ -f /home/ubuntu/.bash_aliases ]; then
  echo 'alias k=kubectl' >> /home/ubuntu/.bash_aliases
  echo 'complete -F __start_kubectl k' >> /home/ubuntu/.bash_aliases
  echo 'alias kctx=kubectx' >> /home/ubuntu/.bash_aliases
fi
