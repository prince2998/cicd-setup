#!/bin/bash

echo -e "\nCreating inventory file for ansible ....\n"

cat <<EOF > ../ansible_config/inventory
jenkins    ansible_host=  ansible_user=ubuntu ansible_connection=ssh
sonar      ansible_host=  ansible_user=ubuntu ansible_connection=ssh
nexus      ansible_host=  ansible_user=ubuntu ansible_connection=ssh
k8s_master ansible_host=  ansible_user=ubuntu ansible_connection=ssh
k8s_node1 ansible_host=  ansible_user=ubuntu ansible_connection=ssh
k8s_node2 ansible_host=  ansible_user=ubuntu ansible_connection=ssh
EOF

echo -e "Populating inventory file for ansible ....\n"

jenkins_public_ip=`terraform -chdir="../terraform_config/jenkins" output | grep public_ip |awk '{print $3}' | tr -d '"'`
sonar_public_ip=`terraform -chdir="../terraform_config/sonar" output | grep public_ip |awk '{print $3}' | tr -d '"'`
nexus_public_ip=`terraform -chdir="../terraform_config/nexus" output | grep public_ip |awk '{print $3}' | tr -d '"'`
master_public_ip=`terraform -chdir="../terraform_config/master" output | grep public_ip |awk '{print $3}' | tr -d '"'`
node1_public_ip=`terraform -chdir="../terraform_config/node1" output | grep public_ip |awk '{print $3}' | tr -d '"'`
node2_public_ip=`terraform -chdir="../terraform_config/node2" output | grep public_ip |awk '{print $3}' | tr -d '"'`

sed -i "s/^jenkins.*ansible_host=.*/jenkins ansible_host=$jenkins_public_ip ansible_user=ubuntu ansible_connection=ssh/" ../ansible_config/inventory
sed -i "s/^sonar.*ansible_host=.*/sonar ansible_host=$sonar_public_ip ansible_user=ubuntu ansible_connection=ssh/" ../ansible_config/inventory
sed -i "s/^nexus.*ansible_host=.*/nexus ansible_host=$nexus_public_ip ansible_user=ubuntu ansible_connection=ssh/" ../ansible_config/inventory
sed -i "s/^k8s_master.*ansible_host=.*/k8s_master ansible_host=$master_public_ip ansible_user=ubuntu ansible_connection=ssh/" ../ansible_config/inventory
sed -i "s/^k8s_node1.*ansible_host=.*/k8s_node1 ansible_host=$node1_public_ip ansible_user=ubuntu ansible_connection=ssh/" ../ansible_config/inventory
sed -i "s/^k8s_node2.*ansible_host=.*/k8s_node2 ansible_host=$node2_public_ip ansible_user=ubuntu ansible_connection=ssh/" ../ansible_config/inventory

echo -e "Add Host to Known Hosts......\n"

if [ -n "$jenkins_public_ip" ]; then
    echo "Adding SSH key for Jenkins ($jenkins_public_ip)"
    ssh-keyscan -H $jenkins_public_ip >> ~/.ssh/known_hosts
elif [ -n "$sonar_public_ip" ]; then
    echo "Adding SSH key for Sonar ($sonar_public_ip)"
    ssh-keyscan -H $sonar_public_ip >> ~/.ssh/known_hosts
elif [ -n "$nexus_public_ip" ]; then
    echo "Adding SSH key for Nexus ($nexus_public_ip)"
    ssh-keyscan -H $nexus_public_ip >> ~/.ssh/known_hosts
elif [ -n "$master_public_ip" ]; then
    echo "Adding SSH key for Master ($master_public_ip)"
    ssh-keyscan -H $master_public_ip >> ~/.ssh/known_hosts
elif [ -n "$node1_public_ip" ]; then
    echo "Adding SSH key for Node 1 ($node1_public_ip)"
    ssh-keyscan -H $node1_public_ip >> ~/.ssh/known_hosts
elif [ -n "$node2_public_ip" ]; then
    echo "Adding SSH key for Node 2 ($node2_public_ip)"
    ssh-keyscan -H $node2_public_ip >> ~/.ssh/known_hosts
else
    echo "Not found publicip address.\n"
fi

echo -e "Done!!!\n"