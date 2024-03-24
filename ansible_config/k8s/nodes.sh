#These commands are part of the initial setup for a Kubernetes cluster, preparing the system to function as either a master node or a worker node without using swap memory.
printf "\n172.31.47.162 k8s-master\n k8s-node1\n k8s-node2\n\n" >> /etc/hosts
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install containerd
VERSION="1.7.14"
wget https://github.com/containerd/containerd/releases/download/$VERSION/containerd-$VERSION-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-$VERSION-linux-amd64.tar.gz
sudo rm -f containerd-$VERSION-linux-amd64.tar.gz

# Download and set up the systemd service file
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system/

# Start and enable the containerd service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

# Verify the service is running
sudo systemctl status containerd

# Configure containerd for Kubernetes
sudo mkdir -p /etc/containerd/
containerd config default | sudo tee /etc/containerd/config.toml

# Configure the systemd cgroup driver for runC
sudo sed -i 's/SystemdCgroup \\= false/SystemdCgroup \\= true/g' /etc/containerd/config.toml

#If you apply this change, make sure to restart containerd
sudo systemctl restart containerd

#Download & Install runc binary
wget https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
sudo mv runc.amd64 /usr/local/sbin/runc
sudo chmod +x /usr/local/sbin/runc
runc --version

#Download the CNI plugins package
VERSION="1.4.1"
wget wget https://github.com/containernetworking/plugins/releases/download/$VERSION/cni-plugins-linux-amd64-$VERSION.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-$VERSION.tgz
sudo rm -f cni-plugins-linux-amd64-$VERSION.tgz

#Download the crictl binary
VERSION="v1.29.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
sudo rm -f crictl-$VERSION-linux-amd64.tar.gz
sudo chmod +x /usr/local/bin/crictl

#Create a configuration file at /etc/crictl.yaml with the necessary settings for your container runtime. Here’s an example configuration for containerd
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: false
pull-image-on-create: false
EOF

#Loading Kernel Modules:Ensure that the overlay and br_netfilter modules are compatible with your Linux kernel version.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

#Enabling Kernel Modules
sudo modprobe overlay
sudo modprobe br_netfilter

#Setting Sysctl Parameters:Confirm that the sysctl parameters match your networking requirements and security policies.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

#Applying Sysctl Settings
sudo sysctl --system &> /home/ubuntu/sysctl-output.txt

#Verifying Sysctl Settings
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

#Persisting Sysctl Settings
sysctl -p /etc/sysctl.conf

#Update the apt package index and install packages needed to use the Kubernetes apt repository
sudo apt-get update -y && sudo apt-get install -y apt-transport-https curl gpg ca-certificates software-properties-common
sudo mkdir -m 755 /etc/apt/keyrings

#Install CRIO Runtime
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update -y
sudo apt-get install -y cri-o

sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo systemctl start crio.service

echo "CRI runtime installed successfully"

#Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

#Add the appropriate Kubernetes apt repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /
EOF

#Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version
sudo apt update -y
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl