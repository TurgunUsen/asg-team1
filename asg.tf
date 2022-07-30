#Launch Template
resource "aws_launch_template" "template" {
  name          = "template-asg"
  instance_type = "t2.micro"
  image_id      = "ami-0cff7528ff583bf9a"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Wordpress"
    }
  }

  user_data = filebase64("/home/ec2-user/test-asg/userdata.sh")

}

  

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity = 3
  max_size         = 99
  min_size         = 3
  vpc_zone_identifier  = data.aws_subnet_ids.subnet.id
  

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}