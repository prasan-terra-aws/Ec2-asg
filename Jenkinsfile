pipeline {
    agent any
    parameters {
        string(name: "aws_regions", defaultValue: "us-east-2", description:"Provide the aws region to deploy")
        string(name: "plan_name", defaultValue: "Terra_example_react", description:"Provide name to store the terraform ec2_name/plan output")
        string(name: "sg_tag", defaultValue: "Terra_example_SG_N", description:"Provide the Security group name")
        string(name: "instance_type", defaultValue: "t2.micro", description:"Provide the instance_type")
        string(name: "asg_name", defaultValue: "Terra_example_react_ASG", description:"Provide the asg_name")
        string(name: "min_cp_asg", defaultValue: "1", description:"Provide the minimum ASG capacity")
        string(name: "max_cp_asg", defaultValue: "1", description:"Provide the maximum ASG capacity")
        string(name: "desired_cp_asg", defaultValue: "1", description:"Provide the desired ASG capacity")
        string(name: "K_scale_down", defaultValue: "15 07 * * SAT", description:"Provide the ASG scale down schedule")
        string(name: "K_scale_up", defaultValue: "0 02 * * MON", description:"Provide the ASG scale up schedule")
        booleanParam(name: "Terraform_Plan", defaultValue: true, description: "Dry run the plan")
        booleanParam(name: "example_Deployment", defaultValue: false, description: "Are you ready with deployment, if yes please checking")
        booleanParam(name: "example_Destroy", defaultValue: false, description: "Destroy the example deployment")
    }
    environment {
        aws_regions = "${params.aws_regions}"
        instance_type = "${params.instance_type}"
        plan_name = "${params.plan_name}"
        Terraform_Plan = "${params.Terraform_Plan}"
        example_Deployment = "${params.example_Deployment}"
        example_Destroy = "${params.example_Destroy}"
        AWS_Credentials = credentials('svc_terraform_QA')
        sg_tag = "${params.sg_tag}"
        asg_name = "${params.asg_name}"
        min_cp_asg = "${params.min_cp_asg}"
        max_cp_asg = "${params.max_cp_asg}"
        desired_cp_asg = "${params.desired_cp_asg}"
        K_scale_down = "${params.K_scale_down}"
        K_scale_up = "${params.K_scale_up}"
    }
    stages {
        stage('Build tfvars'){
            steps{
                script{
                    sh '''
                    make tfvars
                    pwd
                    ls -la
                    cat example-${plan_name}.tfvars 
                    '''
                }
            }
        }
        stage('Initialize and run terraform plan'){
            when { environment name: "Terraform_Plan", value: "true"}
            steps {
                script{
                    sh '''
                    echo "Initialize and Validate the terraform provider"
                    make validate
                    echo "Dry run using terrafrom plan"
                    make plan
                    '''
                }
            }
        }
        stage('example deployment'){
             when { environment name: "example_Deployment", value: "true"}
            steps{
                script{
                    sh'''
                    make infra-apply
                    '''
                }
            }
        }
        stage('Destroy example deployment'){
             when { environment name: "example_Destroy", value: "true"}
            steps{
                script{
                    sh'''
                    make destroy
                    '''
                }
            }
        }
    }
}