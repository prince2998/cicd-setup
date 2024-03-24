### This script replaces the existing ip address of the k8s-master and k8s-node1 with the dummy values which are required for the add_k8s_ip.sh script.
#!/bin/bash

echo "Fetching Existing IPs of k8s-master, k8s-node1, k8-node2 to the master.sh and nodes.sh scripts"
mip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' ../../../master.sh | head -n 1`
n1ip=$(grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' ../../../master.sh | head -n 2 | awk 'NR==2')
n2ip=$(grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' ../../../master.sh | head -n 3 | sed -n '3p')

echo "Replacing IPs of k8s-master, k8s-node1, k8-node2 to the master.sh and nodes.sh scripts"
new_mip=`terraform -chdir="../../terraform_config/master" output | grep private_ip |awk '{print $3}' | tr -d '"'`
new_n1ip=`terraform -chdir="../../terraform_config/node1" output | grep private_ip |awk '{print $3}' | tr -d '"'`
new_n2ip=`terraform -chdir="../../terraform_config/node2" output | grep private_ip |awk '{print $3}' | tr -d '"'`

if df | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' ../ansible_config/k8s/master.sh;
then
{
echo "Previously used IPs found"
#echo "Replaced previously used IPs of k8s-master, k8s-node1, k8s-node2 with dummy variables kmaster-ip, knode1-ip, knode2-ip in master.sh and nodes.sh scripts"
sed -i "s/$mip/$new_mip/g" ../../../master.sh
sed -i "s/$n1ip/$new_n1ip/g" ../../../master.sh
sed -i "s/$n2ip/$new_n2ip/g" ../../../master.sh

sed -i "s/$mip/$new_mip/g" ../../../nodes.sh
sed -i "s/$n1ip/$new_n1ip/g" ../../../nodes.sh
sed -i "s/$n2ip/$new_n2ip/g" ../../../nodes.sh
}
else echo "Dummy variables already present";
fi
