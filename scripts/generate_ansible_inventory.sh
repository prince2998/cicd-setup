#!/bin/bash

echo -e "\nCreating inventory file for ansible ....\n"

cat <<EOF > ../ansible_config/inventory
jenkins ansible_host=  ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'
sonar ansible_host=  ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'
nexus ansible_host=  ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'
k8s_master ansible_host=  ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'
k8s_node1 ansible_host=  ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'
k8s_node2 ansible_host=  ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'
EOF

echo -e "Populating inventory file for ansible ....\n"

jenkins_public_ip=`terraform -chdir="../terraform_config/jenkins" output | grep public_ip |awk '{print $3}' | tr -d '"'`
sonar_public_ip=`terraform -chdir="../terraform_config/sonar" output | grep public_ip |awk '{print $3}' | tr -d '"'`
nexus_public_ip=`terraform -chdir="../terraform_config/nexus" output | grep public_ip |awk '{print $3}' | tr -d '"'`
master_public_ip=`terraform -chdir="../terraform_config/master" output | grep public_ip |awk '{print $3}' | tr -d '"'`
node1_public_ip=`terraform -chdir="../terraform_config/node1" output | grep public_ip |awk '{print $3}' | tr -d '"'`
node2_public_ip=`terraform -chdir="../terraform_config/node2" output | grep public_ip |awk '{print $3}' | tr -d '"'`

sed -i "s|^jenkins.*ansible_host=.*|jenkins ansible_host=$jenkins_public_ip ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'|" ../ansible_config/inventory
sed -i "s|^sonar.*ansible_host=.*|sonar ansible_host=$sonar_public_ip ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'|" ../ansible_config/inventory
sed -i "s|^nexus.*ansible_host=.*|nexus ansible_host=$nexus_public_ip ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'|" ../ansible_config/inventory
sed -i "s|^k8s_master.*ansible_host=.*|k8s_master ansible_host=$master_public_ip ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'|" ../ansible_config/inventory
sed -i "s|^k8s_node1.*ansible_host=.*|k8s_node1 ansible_host=$node1_public_ip ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'|" ../ansible_config/inventory
sed -i "s|^k8s_node2.*ansible_host=.*|k8s_node2 ansible_host=$node2_public_ip ansible_user=ubuntu ansible_connection=ssh ansible_ssh_private_key_file='~/.ssh/ssh_key'|" ../ansible_config/inventory

echo -e "Removed old IPs and Added new IPs to known_hosts"
echo -e "\nRemove Jenkins Ip From Known Hosts......"
if [ -n "$jenkins_public_ip" ]; then
    ssh-keygen -R "$jenkins_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nRemove Sonar Ip From Known Hosts......"
if [ -n "$sonar_public_ip" ]; then
    ssh-keygen -R "$sonar_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nRemove Nexus Ip From Known Hosts......"
if [ -n "$nexus_public_ip" ]; then
    ssh-keygen -R "$nexus_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nRemove Master Ip From Known Hosts......"
if [ -n "$master_public_ip" ]; then
    ssh-keygen -R "$master_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nRemove Node1 Ip From Known Hosts......"
if [ -n "$node1_public_ip" ]; then
    ssh-keygen -R "$node1_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nRemove Node2 Ip From Known Hosts......"
if [ -n "$node2_public_ip" ]; then
    ssh-keygen -R "$node2_public_ip" >> ~/.ssh/known_hosts
fi

echo -e "\nAdding Jenkins Ip to Known Hosts......"
if [ -n "$jenkins_public_ip" ]; then
    ssh-keyscan -H "$jenkins_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nAdding Sonar Ip to Known Hosts......"
if [ -n "$sonar_public_ip" ]; then
    ssh-keyscan -H "$sonar_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nAdding Nexus Ip to Known Hosts......"
if [ -n "$nexus_public_ip" ]; then
    ssh-keyscan -H "$nexus_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nAdding Master Ip to Known Hosts......"
if [ -n "$master_public_ip" ]; then
    ssh-keyscan -H "$master_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nAdding Node1 Ip to Known Hosts......"
if [ -n "$node1_public_ip" ]; then
    ssh-keyscan -H "$node1_public_ip" >> ~/.ssh/known_hosts
fi
echo -e "\nAdding Node2 Ip to Known Hosts......"
if [ -n "$node2_public_ip" ]; then
    ssh-keyscan -H "$node2_public_ip" >> ~/.ssh/known_hosts
fi

echo -e "Done!!!\n"