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

  kms_s3_key_arn                     = aws_kms_key.kms_key.arn
  kms_s3_key_sse_algorithm           = var.kms_s3_key_sse_algorithm
  bucket_key_enabled                 = var.bucket_key_enabled
  use_default_server_side_encryption = var.use_default_server_side_encryption

  enable_versioning        = var.enable_versioning
  policy                   = var.policy
  lifecycle_rule           = var.lifecycle_rule
  metric_configuration     = var.metric_configuration
  analytics_configuration  = var.analytics_configuration
  bucket_name              = module.resource_names["s3_bucket"].recommended_per_length_restriction
  tags                     = local.tags
  object_ownership         = var.object_ownership
  control_object_ownership = var.control_object_ownership
  acl                      = var.acl

}

resource "aws_kms_key" "kms_key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = true
}

module "resource_names" {
  source = "git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name?ref=1.0.0"

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
