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
## Terrafrom
```
└── terraform
    ├── README.md
    ├── environments
    │   ├── dev
    │   └── staging
    ├── main.tf
    └── modules
        ├── ecs
        ├── services
        └── vpc
```
## Usage

To run this example, you need to go to one of environments e.g, dev:
```bash
cd terraform/environments/dev/
```
To initialize terraform modules:
```bash
terraform init
```
To plan terraform:
```bash
terraform plan
```
To apply terraform:
```bash
terraform apply
```

