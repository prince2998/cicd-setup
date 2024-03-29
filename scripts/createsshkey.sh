#Jenkins
ssh-keygen -t rsa -b 4096 -f ~/.ssh/jenkins_key
cp ~/.ssh/jenkins_key.pub ../terraform_config/jenkins
cd ../terraform_config/jenkins ; rm publickey.pub ; mv jenkins_key.pub publickey.pub
#Sonar
ssh-keygen -t rsa -b 4096 -f ~/.ssh/sonar_key
cp ~/.ssh/sonar_key.pub ../terraform_config/sonar
cd ../terraform_config/sonar ; rm publickey.pub ; mv sonar_key.pub publickey.pub
#Nexus
ssh-keygen -t rsa -b 4096 -f ~/.ssh/nexus_key
cp ~/.ssh/nexus_key.pub ../terraform_config/nexus
cd ../terraform_config/nexus ; rm publickey.pub ; mv nexus_key.pub publickey.pub
#Kubernetes Master
ssh-keygen -t rsa -b 4096 -f ~/.ssh/k8s_master_key
cp ~/.ssh/k8s_master_key.pub ../terraform_config/master
cd ../terraform_config/master ; rm publickey.pub ; mv k8s_master_key.pub publickey.pub
#Kubernetes Node1
ssh-keygen -t rsa -b 4096 -f ~/.ssh/k8s_node1_key
cp ~/.ssh/k8s_node1_key.pub ../terraform_config/node1
cd ../terraform_config/node1 ; rm publickey.pub ; mv k8s_node1_key.pub publickey.pub
#Kubernetes Node2
ssh-keygen -t rsa -b 4096 -f ~/.ssh/k8s_node2_key
cp ~/.ssh/k8s_node2_key.pub ../terraform_config/node2
cd ../terraform_config/node2 ; rm publickey.pub ; mv k8s_node2_key.pub publickey.pub
