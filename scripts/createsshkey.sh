#!/bin/bash
# Replace "user" with your username and "your_server_ip" with the server's IP address.
# Remember to keep your private key ($KEY_NAME) secure and never share it.
# The public key ($KEY_NAME.pub) can be safely shared with servers you want to access.

#Jenkins
# Define the SSH key name
KEY_NAME="jenkins_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
echo "Add the public key to authorized_keys on your terraform jenkins directories."
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/jenkins
cd ../terraform_config/jenkins ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts

#Sonar
# Define the SSH key name
KEY_NAME="sonar_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
echo "Add the public key to authorized_keys on your terraform sonar directories."
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/sonar
cd ../terraform_config/sonar ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts

#Nexus
# Define the SSH key name
KEY_NAME="nexus_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
echo "Add the public key to authorized_keys on your terraform nexus directories."
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/nexus
cd ../terraform_config/nexus ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts

#Kubernetes Master
# Define the SSH key name
KEY_NAME="k8s_master_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
echo "Add the public key to authorized_keys on your terraform master directories."
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/master
cd ../terraform_config/master ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts

#Kubernetes Node1
# Define the SSH key name
KEY_NAME="k8s_node1_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
echo "Add the public key to authorized_keys on your terraform node1 directories."
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/node1
cd ../terraform_config/node1 ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts

#Kubernetes Node2
# Define the SSH key name
KEY_NAME="k8s_node2_key"
# Check if the SSH key exists
if [ -f ~/.ssh/$KEY_NAME ]; then
    echo "Existing SSH key $KEY_NAME found. Removing..."
    rm ~/.ssh/$KEY_NAME*
# Generate a new SSH key
fi
echo "Generating a new SSH key $KEY_NAME..."
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME
# Add the public key to authorized_keys on remote servers
echo "Add the public key to authorized_keys on your terraform node2 directories."
cp ~/.ssh/$KEY_NAME.pub ../terraform_config/node2
cd ../terraform_config/node2 ; rm publickey.pub ; mv $KEY_NAME.pub publickey.pub ; cd ../../scripts



