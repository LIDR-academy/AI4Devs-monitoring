# System Patterns

## Architecture Overview
The project follows a **Monorepo** structure with clear separation between frontend and backend.

### Backend (`/backend`)
-   **Framework**: Express with TypeScript.
-   **Layered Architecture**:
    -   `presentation/`: Controllers and API routes.
    -   `application/`: Core business logic and use cases.
    -   `domain/`: Entities and domain models.
    -   `infrastructure/`: Database access (Prisma) and external services.
-   **Data Access**: Prisma ORM connecting to PostgreSQL.

### Frontend (`/frontend`)
-   **Framework**: React (Create React App).
-   **State Management**: React state / Context (implied).
-   **Routing**: React Router (implied).
-   **Styling**: CSS/SCSS (to be confirmed).

## Deployment & Infrastructure
-   **Docker**: Docker Compose manages the PostgreSQL database and application containers.
-   **Build Process**: Separate build scripts for frontend and backend (`npm run build`).

## Design Patterns
-   **Repository Pattern**: Used in the backend infrastructure layer to abstract data access.
-   **Dependency Injection**: Likely used to decouple layers in the backend.
-   **RESTful API**: Communication between frontend and backend.

## Monitoring Architecture
-   **Datadog Agent**: Installed on EC2 instances via User Data script using API Key injection.
    -   **Installation Script**: [backend_user_data.sh](../tf/scripts/backend_user_data.sh) / [frontend_user_data.sh](../tf/scripts/frontend_user_data.sh)
    -   **Agent Version**: Datadog Agent 7 (latest stable)
    -   **API Key Injection**: `var.datadog_api_key` (marked as sensitive)
    -   **Site Configuration**: DD_SITE="datadoghq.eu" (EU region) ✅
    -   **Hostname**: Custom descriptive names (lti-backend-prod, lti-frontend-prod) ✅
    -   **Tags**: Custom tags configured ✅
        - project:lti-monitoring
        - env:dev
        - service:backend/frontend
        - component:api/web
-   **AWS-Datadog Integration**: Bidirectional connection established via:
    -   **IAM Role**: `DatadogIntegrationRole` with SecurityAudit policy.
    -   **Trust Relationship**: External ID validated using `datadog_app_key`.
    -   **Datadog Resource**: `datadog_integration_aws` links AWS Account ID with IAM Role.
-   **Network Configuration**:
    -   **VPC**: Default VPC (includes Internet Gateway)
    -   **Security Groups**: Egress rule 0.0.0.0/0 allows outbound traffic to Datadog endpoints
    -   **Datadog Endpoints**: US region (datadoghq.com) - ports 443 (HTTPS)
-   **Data Flow**:
    -   **EC2 Agents → Datadog API (US)**: System metrics via Agent over HTTPS
        - CPU, Memory, Disk, Network I/O
        - Process monitoring
        - Log collection (if configured)
    -   **Datadog → AWS CloudWatch**: AWS service metrics via IAM Role
        - EC2 instance metadata
        - S3 bucket metrics
        - IAM activity (CloudTrail if enabled)
-   **Visualization Layer (Dashboards)**:
    -   **Dashboard IaC**: Defined in `dashboard.tf` using Terraform
    -   **Dashboard ID**: `wy2-7xn-fu3` (Datadog EU)
    -   **Dashboard URL**: https://app.datadoghq.eu/dashboard/wy2-7xn-fu3
    -   **Layout**: Ordered layout with 6 themed sections
    -   **Status**: ✅ Deployed and operational
    -   **Sections**:
        1. 🖥️ CPU Performance (user, system, idle + query value)
        2. 💾 Memory Usage (timeseries + query values in bytes & %)
        3. 💿 Disk I/O Performance (read_time, write_time, usage %)
        4. 🌐 Network Traffic (bytes sent/received)
        5. ⚖️ System Load Average (1m, 5m, 15m)
        6. 📊 Hosts Overview (host map by service)
    -   **Filtering**: All widgets filtered by `project:lti-monitoring`
    -   **Grouping**: Metrics grouped by `host`, `device`, `service`
    -   **Color Schemes**: Technical palettes (dog_classic, warm, cool, blue, orange)
    -   **Real-time Updates**: Metrics refreshed automatically
-   **Dashboards**:
    -   **System Metrics**: CPU, RAM, Disk I/O (Dashboard ID: 96v-e57-ws8).
    -   **Custom Metrics**: Application-specific business metrics (future).

