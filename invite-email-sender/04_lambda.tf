resource "aws_lambda_layer_version" "lambda_layer" {
    filename   = "lambda_layer_payload.zip"
    layer_name = "invite_email_sender_lambda_layer"

    compatible_runtimes = ["nodejs12.x"]
}

resource "aws_lambda_function" "send_email" {
    filename      = var.lambda_zip_name
    function_name = "${var.function_name}"
    role          = "${aws_iam_role.lambda_iam.arn}"
    handler       = "index.handler"

    # The filebase64sha256() function is available in Terraform 0.11.12 and later
    # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
    # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
    source_code_hash = "${filebase64sha256(var.lambda_zip_name)}"

    runtime = "nodejs12.x"

    layers  = [aws_lambda_layer_version.lambda_layer.arn]

    environment {
        variables = {
            billing = "${var.billing_tag}"
        }
    }
}
