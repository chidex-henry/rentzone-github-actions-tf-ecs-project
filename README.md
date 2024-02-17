# Dynamic Web App Deployment using CI/CD Pipelines with GitHub Actions

This project focuses on implementing CI/CD pipelines with GitHub Actions to deploy dynamic web applications on AWS infrastructure. GitHub Actions, an automated CI/CD platform, integrates seamlessly with GitHub repositories, automating software building, testing, and deployment processes.

## Setting up the Environment

1. **GitHub Repository Setup**: 
    - Created and cloned a GitHub repository to store Terraform infrastructure code.
    - Pushed changes from the local repository to the remote repository.

2. **IAM User Creation**:
    - Created an IAM user with programmatic access and attached a permission policy for resource creation in AWS.

3. **Named Profile Configuration**:
    - Configured a named profile for the IAM user to allow Terraform to authenticate with AWS.

4. **AWS Configuration**:
    - Configured and authenticated Terraform with AWS credentials for resource provisioning.

5. **Terraform Infrastructure**:
    - Added Terraform code to deploy the CI/CD pipeline, including VPCs, subnets, gateways, security groups, ALB, ECR, ECS, RDS, S3, and Route 53.

6. **State Management**:
    - Utilized S3 bucket (henry-terraform-github-action-state) to store the Terraform state file.
    - Launched a DynamoDB table (terraform-state-lock) to lock the state file and prevent conflicts.

  <img width="431" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/a4a0fa4a-0d3f-44df-9045-8c9195e3b4fe">

  <img width="441" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/f54453d1-7492-466d-865d-af7257663f52">

7. **Secrets Management**:
    - Utilized AWS Secrets Manager to store RDS credentials and ECR registry securely.
  
    <img width="473" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/8c12a9d6-ed4e-4c4b-9308-22b6ca349913">

    <img width="338" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/8423f0f8-ae87-46d6-9e51-299818a3e0ba">

8. **DNS Configuration**:
    - Registered a domain name (chidiukaegbu.com) and set up DNS records using Route 53.

## Building the CI/CD Pipeline with GitHub Actions

### Components of GitHub Actions:

- **Workflow**: A configurable automated process defined by a YAML file that runs one or more jobs triggered by repository events or scheduled tasks.

- **Event**: Specific activity in a repository that triggers a workflow run, such as pull requests, issues, or commits.

- **Job**: Set of steps executed on a runner, which can be GitHub-hosted or self-hosted.

- **Action**: Custom application performing complex, repeated tasks within the GitHub Actions platform.

- **Runner**: Server on which a job runs, either GitHub-hosted (cloud-based) or self-hosted.

### CI/CD Process Summary:

<img width="394" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/08757d3f-2e7b-48ac-ad0b-7c75051d1cc0">

1. **Personal Access Token Creation**: Allowed Docker to clone the application code repository during image building.

2. **GitHub Repository Secrets**: Stored sensitive data for GitHub Actions job execution.

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/d018ecd0-35bd-495b-82b3-e2ff05ee4350)

3. **Workflow File Creation**: Created deploy_pipeline.yml in the .github folder to define the workflow.

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/f1b1ff8c-3518-4fc2-8e24-e947f83bf2aa)

4. **IAM Configuration**: Configured IAM credentials to verify AWS access for GitHub Actions jobs.

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/25da1c27-287c-4bf0-80a6-ce55e2b0b0be)

5. **Terraform Infrastructure Provisioning**: Used Terraform and GitHub Hosted Runner to provision AWS resources such as VPC with public and private subnets, Internet Gateway, NAT gateways, security groups, ALB, RDS instance, S3 bucket, IAM role, ECS (cluster, task definition, service), and Route 53. The terraform apply command was used to deploy the AWS infrastructures and the terraform destroy command was to destroy the resources

6. **Amazon ECR Setup**: Created ECR service job to store Docker images.

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/94aa0070-81ef-4038-bc6c-69459cb0efe9)


### Self-Hosted Runner Deployment:

1. **EC2 Instance Runner Setup**:
    - Started a self-hosted EC2 runner in the private subnet (GitHub Action Runner) for building Docker images and database migration with Flyway.
    - Launched an EC2 instance, installed Docker and Git, and created an Amazon Machine Image (AMI) before termination.
      
 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/57f8b1e9-e6eb-404a-89d8-130d6ae477c9)

2. **SSH into the EC2 Instance**:
   - SSH into the EC2 instance in the private subnet, installed Docker and Git on the EC2 instance, and then created an Amazon Machine Image (AMI). The EC2 was terminated after the AMI was created. A job action was created to start the self-hosted runner

### GitHub Actions Jobs for Docker Image Building and Database Migration:

- **Repository Setup**: Prepared application code repository and Dockerfile.
- **Docker Image and RDS Migration Jobs**:
    1. Built and pushed Docker image to Amazon ECR.

<img width="468" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/10e086ef-0789-42ee-be87-79efddcecb38">

    2. Migrated data into the RDS database with Flyway.

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/28e37d27-732f-4e1b-840b-2f6cfb468819)
    
    3. Exported environment variables to an S3 bucket.
    4. Terminated the self-hosted runner (EC2 instance) after job completion.

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/5d9db091-1e57-4a48-857f-a64f3564fcd8)

<img width="396" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/14abd911-084b-42d2-8ab2-3af7dbd1d302">

<img width="544" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/f3395be3-52ec-4e6d-8373-369ee7a11357">

### Amazon ECS Task Definition and Service Restart:

- Created jobs for updating Amazon ECS task definition and restarting ECS Fargate service to deploy the latest application revision.

<img width="468" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/3810bf39-0f8f-4cf4-8b8b-cc27460be680">

<img width="468" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/442dc060-2cb4-4f0f-ac87-5afcc488a366">

<img width="468" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/a2f917ec-b92f-4d2d-9ca9-c49b7afb8a11">

 ![image](https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/c2524204-4010-4616-b9d3-15a735292923)

 ## Application Assessment after CI/CD Delivery 

 <img width="468" alt="image" src="https://github.com/chidex-henry/rentzone-github-actions-tf-ecs-project/assets/77998377/4f54b5da-d592-402b-8ef1-8f0d153a6e6b">

## Conclusion

This project successfully demonstrates the setup of CI/CD pipelines using GitHub Actions for deploying dynamic web applications on AWS infrastructure. The deployment process ensures efficiency, reliability, and security in software delivery through comprehensive configuration and automation.
