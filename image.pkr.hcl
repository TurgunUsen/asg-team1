packer {
	required_plugins {
		amazon = {
			version = ">= 0.0.1"
			source = "github.com/hashicorp/amazon"
		}
	}
}

source "amazon-ebs" "image" {
	ami_name             = "ami-for-team1"
	ssh_private_key_file = "/home/ec2-user/.ssh/id_rsa"
	ssh_keypair_name     = "packer"
	instance_type        = "t2.micro"
	ssh_username         = "ec2-user"
	region               = "us-east-1"
	source_ami = "ami-090fa75af13c156b4"
   
	run_tags = {
		Name = "AMI team1"
	}
}

# Customized AMI for wordpress site
build {
	sources = [
		"source.amazon-ebs.image"
	]
	provisioner "shell" {
		inline = [
			"echo Installing Telnet",
            "sudo yum install httpd -y",
            "sudo yum install php php-mysql -y",
            "sudo systemctl restart httpd",
            "sudo systemctl enable httpd",
            "sudo yum install wget -y",
            "sudo wget https://wordpress.org/wordpress-4.0.32.tar.gz",
            "sudo tar -xf wordpress-4.0.32.tar.gz -C /var/www/html/",
            "sudo mv /var/www/html/wordpress/* /var/www/html/",
            "sudo chown -R apache:apache /var/www/html/",
            "sudo systemctl restart httpd"
		]
	}
	
}