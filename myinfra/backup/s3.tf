resource "aws_s3_bucket" "TF_state" {
    bucket = "alokkodzz"
    tags = var.tags
}