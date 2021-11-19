# Invite Email Sender

## How to Deploy

1. Initialize `layer` directory by runnin `npm install`
2. Run `zip -r lambda_layer_payload.zip layer`
3. Run `zip index.js.zip index.js`
4. Run `terraform apply`
5. Deploy API at API Gateway

## References

* https://gitlab.com/nextlink/lambda-api-sendmail/-/tree/master
* https://medium.com/swlh/deploy-aws-lambda-and-dynamodb-using-terraform-6e04f62a3165
