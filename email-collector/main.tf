provider "aws" {
   region = "us-east-1"
}

resource "aws_dynamodb_table" "ddbtable" {
    name             = var.ddb_name
    hash_key         = "email"
    billing_mode   = "PAY_PER_REQUEST"
    read_capacity  = 1
    write_capacity = 1
    attribute {
        name = "email"
        type = "S"
    }
}

resource "aws_iam_role_policy" "write_policy" {
    name = "lambda_ddb_write_policy"
    role = aws_iam_role.writeRole.id

    policy = file("./writeRole/write_policy.json")
}

resource "aws_iam_role" "writeRole" {
    name = var.write_role

    assume_role_policy = file("./writeRole/assume_write_role_policy.json")
}

resource "aws_lambda_function" "writeLambda" {
    function_name = var.lambda_function_name
    s3_bucket     = var.lambda_s3_bucket
    s3_key        = var.lambda_s3_key
    role          = aws_iam_role.writeRole.arn
    handler       = var.lambda_handler
    runtime       = "nodejs12.x"
}

resource "aws_api_gateway_rest_api" "apiLambda" {
    name        = "pagenow-email-subscription-api"
}


resource "aws_api_gateway_resource" "writeResource" {
    rest_api_id = aws_api_gateway_rest_api.apiLambda.id
    parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
    path_part   = "writedb"
}

resource "aws_api_gateway_method" "writeMethod" {
    rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
    resource_id   = aws_api_gateway_resource.writeResource.id
    http_method   = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "writeInt" {
    rest_api_id = aws_api_gateway_rest_api.apiLambda.id
    resource_id = aws_api_gateway_resource.writeResource.id
    http_method = aws_api_gateway_method.writeMethod.http_method

    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.writeLambda.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
    depends_on = [aws_api_gateway_integration.writeInt]

    rest_api_id = aws_api_gateway_rest_api.apiLambda.id
    stage_name  = "Prod"
}

resource "aws_lambda_permission" "writePermission" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.writeLambda.function_name
    principal     = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/POST/writedb"
}

output "base_url" {
    value = aws_api_gateway_deployment.apideploy.invoke_url
}