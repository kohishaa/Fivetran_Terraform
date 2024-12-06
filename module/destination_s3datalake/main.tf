# Create an S3 bucket for the Fivetran destination
resource "aws_s3_bucket" "fivetran_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "dev"
  }
}


# Creating IAM Role with trust relationship
resource "aws_iam_role" "fivetran_role" {
  name = "fivetran_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${var.aws_account_id}:root"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId": var.external_id
          }
        }
      }
    ]
  })
  depends_on = [ aws_s3_bucket.fivetran_bucket ]
}

data "aws_iam_policy_document" "fivetran_bucket_policy" {
  statement {
    sid    = "AllowListBucketOfASpecificPrefix"
    effect = "Allow"

    actions = ["s3:ListBucket"]

    resources = [
      aws_s3_bucket.fivetran_bucket.arn
    ]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowAllObjectActionsInSpecificPrefix"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:DeleteObjectTagging",
      "s3:ReplicateObject",
      "s3:DeleteObjectVersion"
    ]

    resources = [
      "${aws_s3_bucket.fivetran_bucket.arn}/*"
    ]
  }
}


# Attach the policy to the IAM role
resource "aws_iam_policy" "fivetran_policy" {
  name   = "bucket_access_policy"
  policy = data.aws_iam_policy_document.fivetran_bucket_policy.json
}

resource "aws_iam_role_policy_attachment" "fivetran_policy_attachment" {
  role       = aws_iam_role.fivetran_role.name
  policy_arn = aws_iam_policy.fivetran_policy.arn
} 

# Fivetran Destination
resource "fivetran_destination" "destination" {
  group_id = var.group_id
  service  = "new_s3_datalake"

  time_zone_offset = "0"
  region           = ""
  daylight_saving_time_enabled = "true"
  run_setup_tests              = "true"

  config {
    fivetran_role_arn = aws_iam_role.fivetran_role.arn
    bucket            = aws_s3_bucket.fivetran_bucket.bucket
    table_format = "DELTA_LAKE"
    region = var.region
    #port = "443"
    prefix_path = ""
    is_private_key_encrypted = "false"
  }
  
   lifecycle {
    create_before_destroy = false
    ignore_changes        = all
  }

  timeouts {
    create = "60m"
    update = "60m"
  }
}
