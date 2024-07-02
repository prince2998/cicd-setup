<<<<<<< HEAD
aws_instance_name = "k8s-node1"
aws_region        = "ap-south-1"
#ports             = [22, 80, 8080, 443]
instance_type = "t2.medium"
image_name    = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
=======
aws_instance_name = "k8s_node1"
aws_region        = "ap-south-1"
ports             = [22,80,8080,443,25,465,6643]
instance_type = "t2.medium"
image_name    = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6

