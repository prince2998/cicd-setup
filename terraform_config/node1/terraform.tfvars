aws_instance_name = "k8s-node1"
aws_region        = "ap-south-1"
ports             = [22,80,8080,443,25,465,6643,3000-10000,30000-32767]
instance_type = "t2.medium"
image_name    = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

