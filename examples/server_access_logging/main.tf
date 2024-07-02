// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "s3_bucket" {
  source = "../.."

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.region
  class_env               = var.class_env

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls      = var.ignore_public_acls
  enable_versioning       = var.enable_versioning
  policy                  = var.policy
  lifecycle_rule          = var.lifecycle_rule
  logging                 = local.logging
  metric_configuration    = var.metric_configuration
  analytics_configuration = var.analytics_configuration
  bucket_name             = module.resource_names["s3_bucket_source"].recommended_per_length_restriction
  tags                    = local.tags

  //Setting this value to false(as set in locals.tf) will ensure the default server side encryption is not enabled on S3 source bucket. Instead SSE-KMS encryption is used.
  use_default_server_side_encryption = local.use_default_server_side_encryption_src_bkt

  //On source bucket the SSE-KMS encryption is enabled.
  kms_s3_key_arn           = aws_kms_key.kms_key.arn
  kms_s3_key_sse_algorithm = var.kms_s3_key_sse_algorithm
  bucket_key_enabled       = var.bucket_key_enabled
}

resource "aws_kms_key" "kms_key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = true
}

module "s3_bucket_target" {
  source = "../.."

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.region
  class_env               = var.class_env

  bucket_name                                = module.resource_names["s3_bucket_target"].recommended_per_length_restriction
  access_log_delivery_policy_source_buckets  = [module.s3_bucket.arn]
  access_log_delivery_policy_source_accounts = var.access_log_delivery_policy_source_accounts
  attach_access_log_delivery_policy          = var.attach_access_log_delivery_policy
  attach_policy                              = var.attach_policy
  enable_versioning                          = var.enable_versioning

  //Setting this value to true(as set in locals.tf) will ensure the default server side encryption is enabled on S3 target bucket(bucket where access logs are delivered).
  //As per [this](https://docs.aws.amazon.com/AmazonS3/latest/userguide/troubleshooting-server-access-logging.html) documentation, You can use default bucket encryption on the target bucket only if you use server-side encryption with Amazon S3 managed keys (SSE-S3). Default server-side encryption with AWS Key Management Service (AWS KMS) keys (SSE-KMS) is not supported for server access logging target buckets.
  use_default_server_side_encryption = local.use_default_server_side_encryption_target_bkt
}


module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
}
