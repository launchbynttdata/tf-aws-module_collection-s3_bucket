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

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.0"

  //If calling module has passed the bucket name, it will be used, if not a name will be generated using a standard naming convention.
  bucket = var.bucket_name == null ? module.resource_names["s3"].recommended_per_length_restriction : var.bucket_name

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # Allow deletion of non-empty bucket
  force_destroy = true

  object_lock_enabled       = var.object_lock_enabled
  object_lock_configuration = var.object_lock_configuration

  server_side_encryption_configuration = local.server_side_encryption_configuration

  versioning = {
    enabled = var.enable_versioning
  }

  lifecycle_rule                             = var.lifecycle_rule
  policy                                     = var.policy
  logging                                    = var.logging
  access_log_delivery_policy_source_buckets  = var.access_log_delivery_policy_source_buckets
  access_log_delivery_policy_source_accounts = var.access_log_delivery_policy_source_accounts
  attach_access_log_delivery_policy          = var.attach_access_log_delivery_policy
  metric_configuration                       = var.metric_configuration
  analytics_configuration                    = var.analytics_configuration

  # Terragrunt converts a null to a string "null". This list will fix that issue.
  # Added a try as the below line throws error when var.policy is null
  # `anytrue` function is added for the cases where policy may not be passed, but attach_policy variable value(true) will indicate that default policies defined in `terraform-aws-modules/s3-bucket/aws` module should be used.
  attach_policy = anytrue([var.attach_policy, try(contains(["", null, "null"], var.policy), true) ? false : true])

  object_ownership         = var.object_ownership
  control_object_ownership = var.control_object_ownership
  acl                      = var.acl


  tags = merge(local.tags, { resource_name = local.bucket_name })
}
