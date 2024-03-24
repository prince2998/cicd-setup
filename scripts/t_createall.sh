
echo -e "\n\033[1;32mProvisioning Jenkins server\033[0m\n"
terraform -chdir="../terraform_config/jenkins" init
terraform -chdir="../terraform_config/jenkins" plan
terraform -chdir="../terraform_config/jenkins" apply --auto-approve

echo -e "\n\033[1;32mProvisioning SonarQube server\033[0m\n"
terraform -chdir="../terraform_config/sonar" init
terraform -chdir="../terraform_config/sonar" plan
terraform -chdir="../terraform_config/sonar" apply --auto-approve

echo -e "\n\033[1;32mProvisioning Nexus server\033[0m\n"
terraform -chdir="../terraform_config/nexus" init
terraform -chdir="../terraform_config/nexus" plan
terraform -chdir="../terraform_config/nexus" apply --auto-approve

echo -e "\n\033[1;32mProvisioning kubernetes control plane node - \033[1;34mk8smaster\033[0m\n"
terraform -chdir="../terraform_config/master" init
terraform -chdir="../terraform_config/master" plan
terraform -chdir="../terraform_config/master" apply --auto-approve

echo -e "\n\033[1;32mProvisioning kubernetes worker node1 - \033[1;34mk8snode1\033[0m\n"
terraform -chdir="../terraform_config/node1" init
terraform -chdir="../terraform_config/node1" plan
terraform -chdir="../terraform_config/node1" apply --auto-approve

echo -e "\n\033[1;32mProvisioning kubernetes worker node2 - \033[1;34mk8snode2\033[0m\n"
terraform -chdir="../terraform_config/node2" init
terraform -chdir="../terraform_config/node2" plan
terraform -chdir="../terraform_config/node2" apply --auto-approve

echo -e "\n\033[1;32mProvisioned the infrastructure required for the JAVA web application CICD project.\033[0m\n"
