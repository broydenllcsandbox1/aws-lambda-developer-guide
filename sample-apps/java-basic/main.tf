terraform {
  backend "s3" {
    bucket = "broydensandbox1-terraform-keys"
    key    = "lambda/functions"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
}

########################################################################################################################################################################################
# LAMBDA FUNCTION SETUP
########################################################################################################################################################################################

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# arn:aws:iam::152454028344:user/

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "java-basic-1.0-SNAPSHOT.jar"
  function_name = "terraform_lambda_function_java"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "example.HandlerStream"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("java-basic-1.0-SNAPSHOT.jar")

  runtime = "java11"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
