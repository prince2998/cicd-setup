aws_instance_name = "k8s-master"
aws_region        = "ap-south-1"
ports             = [22,80,8080,443,25,465,6643]
instance_type     = "t2.medium"
image_name        = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

