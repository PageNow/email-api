resource "aws_dynamodb_table" "default" {
    name         = var.ddb_name
    hash_key     = "user_id"
    range_key    = "timestamp"
    billing_mode = "PAY_PER_REQUEST"

    attribute {
        name = "user_id"
        type = "S"
    }
    attribute {
        name = "timestamp"
        type = "S"
    }
}