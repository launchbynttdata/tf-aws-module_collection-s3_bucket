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

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "example"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  default     = "us-east-2"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-module-resource_name to generate resource names."
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    s3_bucket_source = {
      name = "src-bkt"
    }
    s3_bucket_target = {
      name = "target-bkt"
    }
    target_bucket_reader_policy = {
      name       = "target-bucket-plcy"
      max_length = 60
    }
  }
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "use_default_server_side_encryption" {
  description = "Flag to indiate if default server side encryption should be used. SSE-KMS encryption is used if the flag value is set to false(which is default). If flag value is set to true then default server side encryption(encryption set by AWS for all S3 objects)"
  type        = bool
  default     = false
}

variable "kms_key_description" {
  description = "KMS key description. This KMS key is used for SSE-KMS encryption f source bucket."
  type        = string
  default     = "KMS key used for source bucket encryption"
}

variable "kms_key_deletion_window_in_days" {
  description = "(Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately."
  type        = number
  default     = 30
}


variable "kms_s3_key_sse_algorithm" {
  description = "Server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
  default     = "aws:kms"
}

variable "bucket_key_enabled" {
  description = "Whether to enable bucket_key for encryption. It reduces encryption costs. Default is false"
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Whether to enable versioning for this S3 bucket. Default is false"
  type        = bool
  default     = false
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "metric_configuration" {
  description = "Map containing bucket metric configuration."
  type        = any
  default     = []
}

variable "analytics_configuration" {
  description = "Map containing bucket analytics configuration."
  type        = any
  default     = {}
}

variable "policy" {
  description = <<EOF
    (Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid),
    Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the
    verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform,
    see the AWS IAM Policy Document Guide.
  EOF
  type        = string
  default     = null
}

variable "tags" {
  description = "An arbitrary map of tags that can be added to all resources."
  type        = map(string)
  default     = {}
}

variable "access_log_delivery_policy_source_buckets" {
  description = "(Optional) List of S3 bucket ARNs wich should be allowed to deliver access logs to this bucket."
  type        = list(string)
  default     = []
}

variable "access_log_delivery_policy_source_accounts" {
  description = "(Optional) List of AWS Account IDs should be allowed to deliver access logs to this bucket."
  type        = list(string)
  default     = []
}

variable "attach_access_log_delivery_policy" {
  description = "Controls if S3 bucket should have S3 access log delivery policy attached"
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}
