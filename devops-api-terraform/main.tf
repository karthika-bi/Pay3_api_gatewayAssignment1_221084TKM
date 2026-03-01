provider "aws" {
  region = "ap-south-1"
}

# -----------------------------
# REST API
# -----------------------------
resource "aws_api_gateway_rest_api" "devops_api" {
  name = "devops-api"
}

# =====================================================
# JSON ROUTE  -> /json/{todo}
# =====================================================

resource "aws_api_gateway_resource" "json" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  parent_id   = aws_api_gateway_rest_api.devops_api.root_resource_id
  path_part   = "json"
}

resource "aws_api_gateway_resource" "json_todo" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  parent_id   = aws_api_gateway_resource.json.id
  path_part   = "{todo}"
}

resource "aws_api_gateway_method" "json_get" {
  rest_api_id   = aws_api_gateway_rest_api.devops_api.id
  resource_id   = aws_api_gateway_resource.json_todo.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.todo" = true
  }
}

resource "aws_api_gateway_integration" "json_integration" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  resource_id = aws_api_gateway_resource.json_todo.id
  http_method = aws_api_gateway_method.json_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "https://jsonplaceholder.typicode.com/{todo}"

  request_parameters = {
    "integration.request.path.todo" = "method.request.path.todo"
  }
}

# =====================================================
# WEATHER ROUTE -> /weather
# =====================================================

resource "aws_api_gateway_resource" "weather" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  parent_id   = aws_api_gateway_rest_api.devops_api.root_resource_id
  path_part   = "weather"
}

resource "aws_api_gateway_method" "weather_get" {
  rest_api_id   = aws_api_gateway_rest_api.devops_api.id
  resource_id   = aws_api_gateway_resource.weather.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.latitude"  = true
    "method.request.querystring.longitude" = true
  }
}

resource "aws_api_gateway_integration" "weather_integration" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  resource_id = aws_api_gateway_resource.weather.id
  http_method = aws_api_gateway_method.weather_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "https://api.open-meteo.com/v1/forecast"

  request_parameters = {
    "integration.request.querystring.latitude"  = "method.request.querystring.latitude"
    "integration.request.querystring.longitude" = "method.request.querystring.longitude"
  }
}

# =====================================================
# COUNTRIES ROUTE -> /countries/{name}
# =====================================================

resource "aws_api_gateway_resource" "countries" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  parent_id   = aws_api_gateway_rest_api.devops_api.root_resource_id
  path_part   = "countries"
}

resource "aws_api_gateway_resource" "country_name" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  parent_id   = aws_api_gateway_resource.countries.id
  path_part   = "{name}"
}

resource "aws_api_gateway_method" "country_get" {
  rest_api_id   = aws_api_gateway_rest_api.devops_api.id
  resource_id   = aws_api_gateway_resource.country_name.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.name" = true
  }
}

resource "aws_api_gateway_integration" "country_integration" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  resource_id = aws_api_gateway_resource.country_name.id
  http_method = aws_api_gateway_method.country_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "https://restcountries.com/v3.1/name/{name}"

  request_parameters = {
    "integration.request.path.name" = "method.request.path.name"
  }
}

# =====================================================
# DEPLOYMENT
# =====================================================

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id

  depends_on = [
    aws_api_gateway_integration.json_integration,
    aws_api_gateway_integration.weather_integration,
    aws_api_gateway_integration.country_integration
  ]

  triggers = {
    redeployment = timestamp()
  }
}

# =====================================================
# STAGE
# =====================================================

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.devops_api.id
  stage_name    = "v1"
}