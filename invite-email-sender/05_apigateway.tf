resource "aws_api_gateway_rest_api" "default" {
    name        = "${var.api_gateway_name}"
    description = "${var.api_gateway_description}"
}

resource "aws_api_gateway_authorizer" "default" {
    name          = "pagenow_cognito_authorizer"
    rest_api_id   = aws_api_gateway_rest_api.default.id
    type          = "COGNITO_USER_POOLS"
    provider_arns = [ "arn:aws:cognito-idp:${var.region}:${var.account_id}:userpool/${var.cognito_pool_id}" ]
}

resource "aws_api_gateway_resource" "main" {
    rest_api_id = "${aws_api_gateway_rest_api.default.id}"
    parent_id   = "${aws_api_gateway_rest_api.default.root_resource_id}"
    path_part   = "email"
}

resource "aws_api_gateway_method" "send_email" {
    rest_api_id   = "${aws_api_gateway_rest_api.default.id}"
    resource_id   = "${aws_api_gateway_resource.main.id}"
    http_method   = "POST"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.default.id
}

resource "aws_api_gateway_integration" "integration" {
    rest_api_id             = "${aws_api_gateway_rest_api.default.id}"
    resource_id             = "${aws_api_gateway_resource.main.id}"
    http_method             = "${aws_api_gateway_method.send_email.http_method}"
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = "${aws_lambda_function.send_email.invoke_arn}"
}

resource "aws_api_gateway_method_response" "response_200" {
    rest_api_id = "${aws_api_gateway_rest_api.default.id}"
    resource_id = "${aws_api_gateway_resource.main.id}"
    http_method = "${aws_api_gateway_method.send_email.http_method}"
    status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response" {
    rest_api_id = "${aws_api_gateway_rest_api.default.id}"
    resource_id = "${aws_api_gateway_resource.main.id}"
    http_method = "${aws_api_gateway_method.send_email.http_method}"
    status_code = "${aws_api_gateway_method_response.response_200.status_code}"
    depends_on  = [aws_api_gateway_integration.integration]
}

resource "aws_api_gateway_method" "options_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.default.id}"
    resource_id   = "${aws_api_gateway_resource.main.id}"
    http_method   = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id = "${aws_api_gateway_rest_api.default.id}"
    resource_id = "${aws_api_gateway_resource.main.id}"
    http_method = "${aws_api_gateway_method.options_method.http_method}"
    status_code = "200"
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin"  = true
    }
    depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id = "${aws_api_gateway_rest_api.default.id}"
    resource_id = "${aws_api_gateway_resource.main.id}"
    http_method = "${aws_api_gateway_method.options_method.http_method}"
    type        = "MOCK"
    depends_on  = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id = "${aws_api_gateway_rest_api.default.id}"
    resource_id = "${aws_api_gateway_resource.main.id}"
    http_method = "${aws_api_gateway_method.options_method.http_method}"
    status_code = "${aws_api_gateway_method_response.options_200.status_code}"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
    depends_on = [aws_api_gateway_method_response.options_200]
}

resource "aws_lambda_permission" "allow_api_gateway" {
    statement_id  = "email"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.send_email.function_name}"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_api_gateway_rest_api.default.execution_arn}/*/POST/email"
}

resource "aws_api_gateway_deployment" "production" {
    depends_on = [aws_api_gateway_integration.integration]

    rest_api_id       = "${aws_api_gateway_rest_api.default.id}"
    stage_name        = "prod"
    description       = "Deployed at ${timestamp()}"
    stage_description = "Deployed at ${timestamp()}"

    lifecycle {
        create_before_destroy = true
    }
}
