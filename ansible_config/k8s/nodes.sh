<<<<<<< HEAD
printf "\n172.31.11.125 k8s-master\n172.31.8.143 k8s-node1\n\n" >> /etc/hosts
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

wget https://github.com/containerd/containerd/releases/download/v1.6.16/containerd-1.6.16-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.6.16-linux-amd64.tar.gz
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mkdir -p /usr/local/lib/systemd/system
mv containerd.service /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

wget https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.2.0.tgz

VERSION="v1.26.0" # check latest version in /releases page
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

cat <<EOF |  tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
=======
#These commands are part of the initial setup for a Kubernetes cluster, preparing the system to function as either a master node or a worker node without using swap memory.
#!/bin/bash

# Define an associative array where keys are hostnames and values are IP addresses
declare -A HOSTS=( ["k8s_master"]="172.31.32.42" ["k8s_node1"]="172.31.45.176" ["k8s_node2"]="172.31.35.18" )

# Location of the hosts file
HOSTS_FILE="/etc/hosts"

# Loop through the associative array
for HOSTNAME in "${!HOSTS[@]}"
do
    IP_ADDRESS=${HOSTS[$HOSTNAME]}

    # Check if the IP and hostname combination already exists in the /etc/hosts file
    if grep -q "$IP_ADDRESS $HOSTNAME" "$HOSTS_FILE"; then
        echo "The entry $IP_ADDRESS $HOSTNAME already exists in $HOSTS_FILE removing old entry & addng new entry."
        # Use sed to remove the line containing the hostname
        sudo sed -i "/ $HOSTNAME/d" "$HOSTS_FILE"
    fi
        echo "Adding entry $IP_ADDRESS $HOSTNAME to $HOSTS_FILE"
        echo -e "\n$IP_ADDRESS $HOSTNAME" | sudo tee -a "$HOSTS_FILE" > /dev/null
done

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install containerd
VERSION1="1.7.14"
wget https://github.com/containerd/containerd/releases/download/$VERSION1/containerd-$VERSION1-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-$VERSION1-linux-amd64.tar.gz
sudo rm -f containerd-$VERSION1-linux-amd64.tar.gz

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
VERSION2="1.4.1"
wget wget https://github.com/containernetworking/plugins/releases/download/$VERSION2/cni-plugins-linux-amd64-$VERSION2.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-$VERSION2.tgz
sudo rm -f cni-plugins-linux-amd64-$VERSION2.tgz

#Download the crictl binary
VERSION3="v1.29.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION3/crictl-$VERSION3-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION3-linux-amd64.tar.gz -C /usr/local/bin
sudo rm -f crictl-$VERSION3-linux-amd64.tar.gz
sudo chmod +x /usr/local/bin/crictl

#Create a configuration file at /etc/crictl.yaml with the necessary settings for your container runtime. Here’s an example configuration for containerd
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6
debug: false
pull-image-on-create: false
EOF

<<<<<<< HEAD
cat <<EOF |  tee /etc/modules-load.d/k8s.conf
=======
#Loading Kernel Modules:Ensure that the overlay and br_netfilter modules are compatible with your Linux kernel version.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6
overlay
br_netfilter
EOF

<<<<<<< HEAD
modprobe overlay
modprobe br_netfilter
cat <<EOF |  tee /etc/sysctl.d/k8s.conf
=======
#Enabling Kernel Modules
sudo modprobe overlay
sudo modprobe br_netfilter

#Setting Sysctl Parameters:Confirm that the sysctl parameters match your networking requirements and security policies.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
<<<<<<< HEAD
 
sysctl --system &> /home/ubuntu/sysctl-output.txt
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
modprobe br_netfilter
sysctl -p /etc/sysctl.conf

apt-get update -y &&  apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -

cat <<EOF |  tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update -y
apt-get install -y kubelet  kubeadm kubectl 
apt-mark hold kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

=======

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
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6
