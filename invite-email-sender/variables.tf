# Core
variable "region" {
    description = "The AWS region to create resources in."
    default     = "us-west-2"
}

variable "role_name" {
    description = "Name for the Lambda role."
    default     = "email-sender-role"
}

variable "lambda_zip_name" {
    description = "Name of the zipped Lambda function handler file"
    default     = "index.js.zip"
}

variable "function_name" {
    description = "Name for the Lambda function."
    default     = "invite-email-sender"
}

variable "billing_tag" {
    description = "Name for a tag to keep track of resource for billing."
    default     = "invite-email-sender"
}

variable "api_gateway_name" {
    description = "Name for your API gateway."
    default     = "invite-email-sender-api"
}

variable "api_gateway_description" {
    description = "Description of your API gateway."
    default     = "API gateway for invite-email-sender"
}

variable "account_id" {
    description = "Account ID"
    default     = "257206538165"
}

variable "cognito_pool_id" {
    description = "Cognito user pool id"
    default     = "us-west-2_32JgtVKUN"
}

variable "ddb_name" {
    description = "Name of DynamoDB table to store invitation history"
    default     = "pagenow-invitation-email-table"
}
