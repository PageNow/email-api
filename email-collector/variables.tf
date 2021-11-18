variable "write_role" {
    description = "AWS Lambda Role to write to DynamoDB"
    default     = "lambda-ddb-write-role"
}

variable "ddb_name" {
    description = "Name of the DynamoDB table that stores emails."
    default     = "pagenow-email-subscription"
}

variable "lambda_s3_bucket" {
    description = "S3 bucket that stores the zipped Lambda code."
    default     = "pagenow-serverless"
}

variable "lambda_s3_key" {
    description = "Name of the zipped Lambda code uploaded on S3."
    default     = "pagenow-email-subscription-lambda.zip"
}

variable "lambda_handler" {
    description = "Handler function run by Lambda."
    default     = "index.handler"
}

variable "lambda_function_name" {
    description = "Name of the Lambda function that writes email to DynamoDB."
    default     = "pagenow-email-ddb-write"
}