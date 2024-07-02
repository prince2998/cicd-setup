terraform -chdir="../terraform_config/jenkins" destroy --auto-approve
terraform -chdir="../terraform_config/sonar" destroy --auto-approve
terraform -chdir="../terraform_config/nexus" destroy --auto-approve
terraform -chdir="../terraform_config/master" destroy --auto-approve
terraform -chdir="../terraform_config/node1" destroy --auto-approve
<<<<<<< HEAD
=======
terraform -chdir="../terraform_config/node2" destroy --auto-approve
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6
