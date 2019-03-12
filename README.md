# Complete terraform ECS cluster provisioning and microservices deployment

## Microservics

```
├── microservices
│   ├── README.md
│   ├── __init__.py
│   ├── bookings
│   ├── movies
│   ├── showtimes
│   ├── tests
│   └── users
```
## Terrafrom environments
```
├── environments
│   ├── dev
│   │   ├── ecs_cluster
│   │   │   ├── configuration.tf
│   │   │   ├── main.tf
│   │   │   └── outputs.tf
│   │   └── services
│   │       └── bookings
│   │           ├── configuration.tf
│   │           ├── inputs.tf
│   │           ├── main.tf
│   │           └── tasks-definitions
│   │               ├── appspec.yaml
│   │               └── bookings.json
│   └── staging
│       ├── ecs_cluster
│       │   ├── configuration.tf
│       │   ├── main.tf
│       │   └── outputs.tf
│       └── services
│           └── bookings
│               ├── configuration.tf
│               ├── inputs.tf
│               ├── main.tf
│               └── tasks-definitions
│                   ├── appspec.yaml
│                   └── bookings.json
```
## Terrafrom modules
```
└── modules
    ├── codedeploy
    │   ├── inputs.tf
    │   └── main.tf
    ├── ecs
    │   ├── alb.tf
    │   ├── asg.tf
    │   ├── ecs.tf
    │   ├── iam.tf
    │   ├── inputs.tf
    │   ├── outputs.tf
    │   ├── template
    │   │   └── user-data.tpl
    │   └── variables.tf
    ├── services
    │   ├── inputs.tf
    │   ├── main.tf
    │   └── outputs.tf
    └── vpc
        ├── inputs.tf
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```
## Usage

To create ECS cluster for dev environment, you want go to `examples/environments/dev/ecs_cluster`:
```bash
cd examples/environments/dev/ecs_cluster
```
To initialize terraform modules:
```bash
AWS_REGION=eu-central-1 AWS_PROFILE=YOUR_AWS_PROFILE terraform init
```
To plan terraform:
```bash
AWS_REGION=eu-central-1 AWS_PROFILE=YOUR_AWS_PROFILE terraform plan
```
To apply terraform:
```bash
AWS_REGION=eu-central-1 AWS_PROFILE=YOUR_AWS_PROFILE terraform apply
```

Then, to create services deployments (e.g., bookings), you want go to `examples/environments/dev/services/bookings`:
```bash
cd examples/environments/dev/services/bookings
```
To initialize terraform modules:
```bash
AWS_REGION=eu-central-1 AWS_PROFILE=YOUR_AWS_PROFILE terraform init
```
To plan terraform:
```bash
AWS_REGION=eu-central-1 AWS_PROFILE=YOUR_AWS_PROFILE terraform plan
```
To apply terraform:
```bash
AWS_REGION=eu-central-1 AWS_PROFILE=YOUR_AWS_PROFILE terraform apply
```
