# serverless-email-collector 

1. Create an S3 bucket and set the bucket name in ```variables.tf```
2. Zip and upload index.js to the S3 bucket. Set the zipped file name in ```variables.tf```
3. Deploy the resources to AWS by running the following.
```shell
$ terraform init
$ terraform apply -auto-approve
```
4. Verify the API is working by running the following. BASE_URL is the URL presented in the terminal after uploading the resources to the cloud.
```shell
$ curl -X post -d '{"email"}
```

## Caveats

There were some manual operations I needed to do. I had to manually click "Deploy API" on the API Gateway page.

## References

* https://levelup.gitconnected.com/serverless-application-with-api-gateway-aws-lambda-and-dynamodb-using-terraform-79ecdedc6103

* https://www.vic-l.com/aws-lamba-and-api-gateway-integration-with-terraform-to-collect-emails