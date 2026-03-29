#############################################
# Public IP
#############################################

output "ec2_public_ip" {
  value = [
    for instance in aws_instance.my_instance :
    instance.public_ip
  ]
}

#############################################
# Public DNS
#############################################

output "ec2_public_dns" {
  value = [
    for instance in aws_instance.my_instance :
    instance.public_dns
  ]
}

#############################################
# Private IP
#############################################

output "ec2_private_ip" {
  value = [
    for instance in aws_instance.my_instance :
    instance.private_ip
  ]
}