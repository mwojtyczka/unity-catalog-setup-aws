//
// Create AWS Objects for Unity Catalog Metastore
//

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "unity_metastore" {
  bucket = var.metastore_bucket_name

  tags = {
    Name = "Databricks Unity Catalog root bucket"
  }

  provider = aws
}

resource "aws_s3_bucket_acl" "unity_metastore" {
  bucket = aws_s3_bucket.unity_metastore.id
  acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "unity_metastore" {
  bucket = aws_s3_bucket.unity_metastore.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  provider = aws
}

resource "aws_iam_policy" "unity_metastore" {
  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id = "databricks-unity-catalog-metastore"
    Statement = [
      {
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:PutLifecycleConfiguration"
        ],
        "Resource": [
          aws_s3_bucket.unity_metastore.arn,
          "${aws_s3_bucket.unity_metastore.arn}/*"
        ],
        "Effect": "Allow"
      },
      {
        "Action": [
          "sts:AssumeRole"
        ],
        "Resource": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.metastore_role_name}"
        ],
        "Effect": "Allow"
      }
    ]
  })

  tags = {
    Name = "Databricks Unity Catalog Metastore IAM policy"
  }

  provider = aws
}

data "aws_iam_policy_document" "unity_trust_relationship" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
    }
    actions = ["sts:AssumeRole"]

    condition {
      test = "StringEquals"
      values = [var.databricks_account_id]
      variable = "sts:ExternalId"
    }
  }

  provider = aws
}

resource "aws_iam_role" "unity_metastore" {
  name = var.metastore_role_name
  description = "allows access to s3 bucket for the unity metastore root bucket and creates trust relationship to the Databricks Unity Catalog Service Account"
  assume_role_policy  = data.aws_iam_policy_document.unity_trust_relationship.json

  tags = {
    Name = "Databricks Unity Catalog IAM role"
  }

  provider = aws
}

resource "aws_iam_role_policy_attachment" "unity_metastore_policy" {
  role = aws_iam_role.unity_metastore.name
  policy_arn = aws_iam_policy.unity_metastore.arn
}