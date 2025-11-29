# data "aws_iam_role" "lambda_role" {
#   name = "LabRole"
# }

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_file = "${path.module}/lambda_function.py"
#   output_path = "${path.module}/lambda_function.zip"
# }

# resource "aws_lambda_function" "stockwiz_logger" {
#   function_name    = "stockwiz_logger"
#   runtime          = "python3.9"
#   handler          = "lambda_function.lambda_handler"
#   role             = data.aws_iam_role.lambda_role.arn
#   filename         = data.archive_file.lambda_zip.output_path
#   source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
#   timeout          = 5
# }
