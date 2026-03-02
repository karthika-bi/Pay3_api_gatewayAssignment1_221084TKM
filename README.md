# Pay3_api_gatewayAssignment1_221084TKM
DevOps Assignment 1 - AWS API Gateway (Manual + Terraform) using VS Code
This project demonstrates the manual creation and configuration of a REST API using Amazon API Gateway in the ap-south-1 region. The objective of this assignment is to understand how API Gateway resources, methods, integrations, stages, and CORS configurations work before automating the infrastructure.

A single REST API was created with three routes, each integrating with different public backend APIs:

/json/{todo} → Integrated with JSONPlaceholder

/weather → Integrated with Open-Meteo

/countries/{name} → Integrated with REST Countries

All routes are deployed under a common stage named v1 and share a single base invoke URL. CORS has been enabled to allow access from any frontend application.



## Level 1 of Gateway1

Base Invoke URL:https://ryo4hnc97e.execute-api.ap-south-1.amazonaws.com/v1

## Route 1: /json/{todo}
 Backend API

Integrated with:
JSONPlaceholder

This route forwards the full path parameter {todo} to the backend API.

curl https://ryo4hnc97e.execute-api.ap-south-1.amazonaws.com/v1/json/todos

Expected Output:
Returns JSON data of todo item with ID 1

## Route 2: /weather
 Backend API

Integrated with:
Open-Meteo

This route accepts query parameters:

latitude (required)

longitude (required)

hourly (optional)

Example curl:"https://ryo4hnc97e.execute-api.ap-south-1.amazonaws.com/v1/weather?latitude=10&longitude=76"
## Route 3: /countries/{name}
Backend API

Integrated with:
REST Countries

This route extracts {name} as a path parameter and forwards it to the backend API.

 Example curl: https://ryo4hnc97e.execute-api.ap-south-1.amazonaws.com/v1/countries/india

Expected Output:
Returns country details for India.


##CORS Configuration

CORS is enabled for all three routes to allow requests from any frontend application.
Allowed Origins: *
Allowed Methods: GET, OPTIONS
Allowed Headers: All default headers

included Screenshoots of resources, stage_v1 ,json,weather and countries.


## Verification Summary

Single REST API

Three routes under one base URL

Stage name: v1

CORS enabled

Each route successfully integrates with its backend

All curl commands tested and working

## Level 2 – Terraform Automation

This level recreates the same API Gateway infrastructure using Terraform.

Infrastructure includes:

Single REST API

Three routes

Stage: v1

Automatic redeployment on configuration change

Output of invoke URL

## Prerequisites

AWS CLI configured

Terraform installed

AWS Free Tier account

## Deployment Steps
cd level-2-terraform

terraform init

terraform plan

terraform apply

## Output

Terraform prints:

invoke_url =https://q080p77vn1.execute-api.ap-south-1.amazonaws.com/v1
## Tear Down

terraform destroy

## Conclusion

This project provided hands-on experience in designing, deploying, and automating a REST API using Amazon API Gateway. In Level 1, the API was manually configured through the AWS Console to understand how resources, methods, integrations, stages, and CORS settings function in real-world scenarios. This helped build a strong foundational understanding of API Gateway architecture.

In Level 2, the same infrastructure was fully automated using Terraform, demonstrating Infrastructure as Code (IaC) principles. The automation ensures repeatability, consistency, and easy redeployment without manual intervention. Automatic redeployment triggers and output configuration further enhance maintainability and scalability.

Overall, this project strengthened practical knowledge in cloud services, API integration, DevOps practices, and infrastructure automation, making it a strong foundational project in AWS and Terraform.
