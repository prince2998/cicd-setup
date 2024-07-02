<<<<<<< HEAD
### This script replaces the dummy values present in the master.sh and node.sh scripts with the private ips of the k8s-master and k8s-node1 servers.
### This will work first time on it's own after that if you need to recreate instances and change their ips then first run replace_k8s_ip.sh and then run this script.
#!/bin/bash

mip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh | head -n 1`
nip=`grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh | tail -n 1`

if df | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' master.sh;
then
{
echo "Previously used IPs found"
#echo "Replaced previously used IPs of k8s-master and k8s-node1 with dummy variables kmaster-ip & knode1-ip in master.sh and nodes.sh scripts"
sed -i "s/$mip/kmaster-ip/g" master.sh
sed -i "s/$nip/knode1-ip/g" master.sh
sed -i "s/$mip/kmaster-ip/g" nodes.sh
sed -i "s/$nip/knode1-ip/g" nodes.sh
}
else echo "Dummy variables already present";
fi

echo "Adding IPs of k8s-master and k8s-node1 to the master.sh and nodes.sh scripts"
master_private_ip=`terraform -chdir="../../terraform_config/master" output | grep private_ip |awk '{print $3}' | tr -d '"'`
node1_private_ip=`terraform -chdir="../../terraform_config/node1" output | grep private_ip |awk '{print $3}' | tr -d '"'`

sed -i "s/kmaster-ip/$master_private_ip/g" master.sh
sed -i "s/knode1-ip/$node1_private_ip/g" master.sh
sed -i "s/kmaster-ip/$master_private_ip/g" nodes.sh
sed -i "s/knode1-ip/$node1_private_ip/g" nodes.sh
=======
### This script replaces the dummy values present in the master.sh and node.sh scripts with the private ips of the k8s-master, k8s-node1, k8-node2 servers.
### This will work first time on it's own after that if you need to recreate instances and change their ips then first run replace_k8s_ip.sh and then run this script.
#!/bin/bash

# Define the placeholder strings for the IPs
declare -A PLACEHOLDERS=( ["k8s_master"]="kmaster-ip" ["k8s_node1"]="knode1-ip" ["k8s_node2"]="knode2-ip" )

# Define the directories for Terraform configurations
declare -A TF_DIRS=( ["k8s_master"]="../../terraform_config/master" ["k8s_node1"]="../../terraform_config/node1" ["k8s_node2"]="../../terraform_config/node2" )

# Update IPs in master.sh and nodes.sh scripts
for HOST in "${!PLACEHOLDERS[@]}"; do
    placeholder=${PLACEHOLDERS[$HOST]}
    tf_dir=${TF_DIRS[$HOST]}
    
    # Fetch new IP from Terraform output
    new_ip=$(terraform -chdir="$tf_dir" output | grep private_ip | awk '{print $3}' | tr -d '"')

    # Check if the new IP is not empty
    if [ -n "$new_ip" ]; then
        echo "Attempting to replace placeholder for $HOST with IP $new_ip"
        # Replace the placeholder with the new IP in master.sh and nodes.sh
        for file in master.sh nodes.sh; do
            if grep -q "$placeholder" "$file"; then
                echo "Replacing placeholder in $file"
                sed -i 's/$placeholder/$new_ip/g' "$file"
            elif grep -qEo '([0-9]{1,3}[\.]){3}[0-9]{1,3}' "$file"; then
                old_ip=$(grep -Eo '([0-9]{1,3}[\.]){3}[0-9]{1,3}' "$file")
                echo "Replacing old IP in $file"
                sed -i 's/$old_ip/$new_ip/g' "$file"
            fi
        done
    else
        echo "New IP for $HOST is not found. Placeholder remains unchanged."
    fi
done
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6

