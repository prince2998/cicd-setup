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

