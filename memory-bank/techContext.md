# Tech Context

## Technology Stack
-   **Frontend**: React, TypeScript (assumed based on backend), HTML/CSS.
-   **Backend**: Node.js, Express, TypeScript.
-   **Database**: PostgreSQL.
-   **ORM**: Prisma.
-   **Containerization**: Docker, Docker Compose.
-   **Infrastructure as Code**: Terraform.
-   **Monitoring**: Datadog (Agent & Provider).

## Development Environment
-   **Package Manager**: `npm`.
-   **Testing**: Cypress (E2E), Jest (Backend Unit Tests).
-   **Linting/Formatting**: ESLint, Prettier.
-   **Terraform**: Version 1.x.
-   **Cloud Provider**: AWS (us-east-1).

## AWS Authentication
-   **Method**: AWS CLI V2 (modern authentication).
-   **Setup**: 
    ```bash
    # For standard profiles
    aws configure
    
    # For SSO users
    aws configure sso
    aws sso login --profile <profile-name>
    ```
-   **Terraform Integration**: Uses AWS CLI credentials automatically.
-   **Profile**: Default profile used unless specified in provider.tf.
-   **Security**: No static access keys in code - credentials managed by AWS CLI.

## Deployment Workflow
-   **Prerequisites**: 
    1. AWS credentials configured via CLI (`aws configure` or `aws sso login`).
    2. Copy `tf/terraform.tfvars.example` to `tf/terraform.tfvars` and fill in Datadog secrets.
-   **Plan**: `cd tf && terraform plan`
-   **Apply**: `cd tf && terraform apply`
-   **Note**: Never commit `terraform.tfvars` to the repository.

## EC2 Instances (Current Infrastructure)

**Backend Instance:**
-   **Instance ID**: `i-0a06e794b5e6d4a92`
-   **Public IP**: `54.91.78.197`
-   **Instance Type**: `t2.micro`
-   **AMI**: `ami-075d39ebbca89ed55` (Amazon Linux 2)
-   **Hostname**: `lti-backend-prod`
-   **Tags**: `project:lti-monitoring`, `env:dev`, `service:backend`, `component:api`
-   **Datadog Agent**: Version 7, DD_SITE="datadoghq.eu"

**Frontend Instance:**
-   **Instance ID**: `i-0b392c10d66e0ce98`
-   **Public IP**: `98.89.46.199`
-   **Instance Type**: `t2.medium`
-   **AMI**: `ami-075d39ebbca89ed55` (Amazon Linux 2)
-   **Hostname**: `lti-frontend-prod`
-   **Tags**: `project:lti-monitoring`, `env:dev`, `service:frontend`, `component:web`
-   **Datadog Agent**: Version 7, DD_SITE="datadoghq.eu"

**Previous Instances (Terminated):**
-   Backend: `i-09e72a3add200405f` (54.85.210.233) - US region configuration
-   Frontend: `i-00fa4067c8c00dbc0` (54.225.53.208) - US region configuration

-   **Testing**: Cypress (E2E), Jest (Backend Unit Tests).
-   **Linting/Formatting**: ESLint, Prettier.

## Key Commands
-   **Start Backend**: `cd backend && npm start` (Runs on port 3010).
-   **Start Frontend**: `cd frontend && npm start` (Runs on port 3000).
-   **Database Setup**: `docker-compose up -d`, `npx prisma migrate dev`, `ts-node seed.ts`.
-   **Build**: `npm run build` in respective directories.

## Constraints & Standards
-   Follow the layered architecture in the backend.
-   Ensure type safety with TypeScript.
-   Use `prompts.md` for task logging as per `AGENTS.md`.

## File Management
-   **Terraform State**: All `.tfstate` and backup files are excluded from version control via `.gitignore`.
-   **Sensitive Files**: `terraform.tfvars` contains secrets and must never be committed.
-   **IDE Configuration**: `.vscode/settings.json` hides noise files from workspace explorer.
