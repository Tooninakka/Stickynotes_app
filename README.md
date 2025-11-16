flowchart TB

%% STYLE
classDef svc fill:#e9f5ff,stroke:#4992ff,stroke-width:1px,color:#003366;
classDef tool fill:#fff7e6,stroke:#ff9800,stroke-width:1px,color:#663c00;
classDef sec fill:#ffe6e6,stroke:#ff4d4d,stroke-width:1px,color:#660000;
classDef build fill:#eaffea,stroke:#3bb54a,stroke-width:1px,color:#003300;
classDef infra fill:#f2f2f2,stroke:#595959,stroke-width:1px,color:#1a1a1a;

%% SOURCE
A[GitHub\nCode Repositories\n(Multi-Service / Multi-Language)]:::svc

%% TRIGGER / CONTROLLER
B[Jenkins Controller\n(on Kubernetes)]:::infra

%% AGENTS
C1[Kubernetes Ephemeral Agents\n(Python/Java/Node/Go)]:::infra
C2[Windows Build Agents\n(for .NET Services)]:::infra

%% PIPELINE STAGES
D1[Checkout & Prepare\n- Branch/PR Sync\n- Jenkinsfile Validation]:::build
D2[Install Dependencies\n(Lang-specific)]:::build
D3[Lint & Static Checks]:::build
D4[Unit Tests & Coverage]:::build

%% SECURITY
E1[SAST\n(SonarQube)]:::sec
E2[SCA / Dependency Scan\n(Snyk/Dependabot)]:::sec
E3[Secrets Detection\n(TruffleHog/git-secrets)]:::sec

%% ARTIFACT + SUPPLY CHAIN
F1[Build Artifacts\n(Docker Image / Binary)]:::build
F2[SBOM Generation\n(Syft)]:::sec
F3[Image Scan\n(Trivy)]:::sec
F4[Image Signing\n(Cosign + KMS/Vault)]:::sec

%% REGISTRY + STORAGE
G1[ECR / Artifact Registry\n(Immutable Artifacts)]:::infra
G2[S3 / Artifact Storage\n(SBOMs, Scan Reports, Logs)]:::infra

%% EPHEMERAL TESTING
H1[Ephemeral Test Environment\n(K8s Namespace)]:::svc
H2[Smoke & Integration Tests]:::build

%% FEEDBACK LOOP
I1[GitHub PR Status\nChecks & Gates]:::svc
I2[Slack / Email\nNotifications]:::svc
I3[PagerDuty\n(Critical Security Alerts)]:::svc

%% OBSERVABILITY
J1[Prometheus Metrics]:::tool
J2[Grafana Dashboards]:::tool
J3[Central Logging\n(OpenSearch/CloudWatch)]:::tool

%% FLOW CONNECTIONS
A -->|Webhook Trigger| B

B -->|Starts Build| C1
B --> C2

C1 --> D1 --> D2 --> D3 --> D4
C1 --> E1 --> E2 --> E3
C1 --> F1 --> F2 --> F3 --> F4

F4 -->|Push Artifact| G1
F2 -->|Upload SBOM| G2
F3 -->|Upload Scan Report| G2

%% Ephemeral Testing Flow
G1 -->|Deploy Image| H1 --> H2 -->|Test Results| B

%% Feedback & Notifications
B --> I1
B --> I2
E2 -->|Critical Vulnerability| I3

%% Observability Flow
B --> J1 --> J2
C1 --> J1
B --> J3
