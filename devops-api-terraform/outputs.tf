output "invoke_url" {
  description = "Base URL of the deployed API Gateway stage"
  value       = aws_api_gateway_stage.v1.invoke_url
}