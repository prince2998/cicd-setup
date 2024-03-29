#!/bin/bash
# Replace "user" with your username and "your_server_ip" with the server's IP address.
# Remember to keep your private key ($KEY_NAME) secure and never share it.
# The public key ($KEY_NAME.pub) can be safely shared with servers you want to access.

# Define the SSH key name
KEY_NAME="ssh_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/jenkins
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/sonar
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/nexus
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/master
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/node1
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/node2
cd ../terraform_config/jenkins ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts
cd ../terraform_config/sonar ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts
cd ../terraform_config/nexus ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts
cd ../terraform_config/master ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts
cd ../terraform_config/node1 ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts
cd ../terraform_config/node2 ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts

echo -e "Add the public key to authorized_keys on your terraform all directories.\n"
