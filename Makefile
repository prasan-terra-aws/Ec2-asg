var_val="${plan_name}.tfvars"

tfvars:
		## Build tfvars for the terraform parameters
		echo aws_regions='"'"${aws_regions}"'"' > $(var_val)
		echo sg_tag='"'"${sg_tag}"'"' >> $(var_val)
		echo instance_type='"'"${instance_type}"'"' >> $(var_val)
		echo ec2_name='"'"${plan_name}"'"' >> $(var_val)
		echo asg_name='"'"${asg_name}"'"' >> $(var_val)
		echo min_cp_asg='"'"${min_cp_asg}"'"' >> $(var_val)
		echo max_cp_asg='"'"${max_cp_asg}"'"' >> $(var_val)
		echo desired_cp_asg='"'"${desired_cp_asg}"'"' >> $(var_val)
		echo K_scale_down='"'"${K_scale_down}"'"' >> $(var_val)
		echo K_scale_up='"'"${K_scale_up}"'"' >> $(var_val)
validate:
		## This section to Initialise and validate the terraform scripts for AWS provider
		terraform init && terraform validate

plan: 
		## Creating terraform plan for the deployment
		terraform plan -var-file=$(var_val) -out="${plan_name}.plan"

infra-apply: 
		## Get the modules, Deploy the Infrastructure
		terraform get && terraform apply -var-file=$(var_val) -auto-approve

destroy: 
		## Destroying the deployed infrastructure, be caution before applying this package
		terraform destroy -var-file=$(var_val) -auto-approve && rm -rf *.plan *.tfvars*