##### AWS Availability Zones ######
data "aws_availability_zones" "available" {
  state = "available"
}

###### AWS Key Pair ###################
resource "aws_key_pair" "devkey" {
  key_name   = var.key_name
  public_key = file(var.pub_key)
}

############### AWS ASG Lanuch configuration ##################
resource "aws_launch_configuration" "example_asg_lc" {
  name_prefix = var.ec2_name
  image_id = var.amiid
  instance_type = var.instance_typ
  key_name = var.key_name
  iam_instance_profile = var.iam_role_ec2
  security_groups = [var.sgid]
  associate_public_ip_address = false
  user_data = file(var.init_script)
  root_block_device {
    volume_size = "8"
    volume_type = "gp2"
  }
  lifecycle {
    create_before_destroy = true
  }
}

######## AWS ASG ######################
resource "aws_autoscaling_group" "example_asg" {
  name = var.asg_name
  min_size = var.min_asg
  max_size = var.min_asg
  desired_capacity = var.desired_asg
  depends_on = [ aws_launch_configuration.example_asg_lc ]
  ###### Launch configurations
  launch_configuration = aws_launch_configuration.example_asg_lc.name
  #### Networking ######
  //availability_zones = [ data.aws_availability_zones.available.names[1],data.aws_availability_zones.available.names[2] ]
  vpc_zone_identifier = [ var.subnet_2b,var.subnet_2c ]
  #######Load Balancing 
  ##### Health checks #####
  health_check_type = "EC2"
  health_check_grace_period = 300
  #### Advanced Configuration
  service_linked_role_arn = var.asg_service_arn
  termination_policies = [ "default" ]
  default_cooldown = 300
  tag {
      key ="Name"
      value = var.ec2_name
      propagate_at_launch = true
    }
  tag{
      key ="Customers"
      value = var.customers
      propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "example_asg_policy" {
  name = "example_asg_policy"
  policy_type = "TargetTrackingScaling"
  metric_aggregation_type = "Average"
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
  //cooldown = 60
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.asg_metric_type
    }
    target_value = 50
  }
}

resource "aws_autoscaling_schedule" "example_asg_sch_down" {
  scheduled_action_name = "scale_down"
  min_size = "0"
  max_size = "0"
  desired_capacity = "0"
  recurrence = var.scale_down
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
}

resource "aws_autoscaling_schedule" "example_asg_sch_up" {
  scheduled_action_name = "scale_up"
  min_size = var.min_asg
  max_size = var.min_asg
  desired_capacity = var.desired_asg
  recurrence = var.scale_up
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
}

resource "aws_sns_topic" "example_sns" {
  name = var.example_sns_asg  
}

resource "aws_autoscaling_notification" "example_sns_asg" {
  group_names = [ aws_autoscaling_group.example_asg.name ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = aws_sns_topic.example_sns.arn
}