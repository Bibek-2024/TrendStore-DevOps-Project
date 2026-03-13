output "jenkins_public_ip" {
  description = "Public IP of the Jenkins Server"
  value       = aws_instance.jenkins_server.public_ip
}

output "jenkins_public_dns" {
  description = "Public DNS of the Jenkins Server"
  value       = aws_instance.jenkins_server.public_dns
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.jenkins_server.id
}

output "security_group_id" {
  description = "The ID of the Security Group used"
  value       = aws_security_group.trendstore_sg.id
}
