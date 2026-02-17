You are senior devsecops engineer and you have been asked to create the infrastructure for the backend and frontend projects of the company lti recruiter.

# TASKS
## LOCAL ENVIRONMENT
1. Generate a Dockerfile for frontend that installs dependencies and runs it exposing port 3000 and uses node 18 as base
2. Generate a Dockerfile for backend that runs prisma migrations, builds and runs the code exposing port 8080 and uses node 18 as base
3. Generate a sh script file that will give the following options:
    - Give a version number for the frontend and backend docker images.
    - Allow to create the frontend and backend images.

## AWS INFRASTRUCTURE
1. The infrastructure consists of 2 EC2 instances of type t2.micro one for the frontend and one for the backend.
2. You will use the terraform files available in the repository `tf/` to create the infrastructure.
3. You will add a monitoring layer that uses datadog to monitor the EC2 instances and the applications running on them.
4. You will set up a CI/CD pipeline using GitHub Actions that will build and push the Docker images to a container registry (e.g., Amazon ECR) whenever there is a push to the main branch. The pipeline should also deploy the updated images to the EC2 instances.


# CONSTRAINTS:
- The local environement and the production aws environment must monitor the applications using datadog. Make sure to include the datadog agent in the Dockerfiles and configure it to send metrics and logs to datadog.
- The CI/CD pipeline should include steps to run tests before building and pushing the Docker images.
- The Terraform files should be modular and reusable, allowing for easy updates and maintenance of the infrastructure. Make sure to include variables for configurable parameters such as instance types, region, and datadog API key.
- Ensure that the EC2 instances are properly secured, with appropriate security groups and IAM roles to allow only necessary access to the applications and monitoring tools.
- The Docker images should be optimized for production use, minimizing the image size and ensuring that only necessary dependencies are included. Use multi-stage builds in the Dockerfiles to achieve this.
- The CI/CD pipeline should include proper error handling and notifications in case of build or deployment failures, such as sending alerts to a Slack channel or email.
- The Terraform configuration should include proper tagging of resources for better organization and cost management, and should follow best practices for infrastructure as code, such as using remote state management and version control.
- The docker compose files must be production ready, with proper environment variable management and secrets handling, cpu and ram limits, health checks, and should be able to run the applications in a local environment for testing and development purposes.

Feel free to ask for any clarifications or additional information needed to complete the tasks if necessary.