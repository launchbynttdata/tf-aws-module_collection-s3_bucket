# Complete example
This example demonstrates creating an auto-scaling target for an ECS service.

Note: This module assumes that a sample application is already present in the ECR (`var.container_image`) in the same AWS account where this module is run. Cross account ECR image pull is not supported at this moment as VPC endpoints only work in the same account. Our setup is done in a private VPC without internet connection.

## Provider requirements
Make sure a `provider.tf` file is created with the below contents inside the `examples/with_tls_enforced` directory
```shell
provider "aws" {
  profile = "<profile_name>"
  region  = "<aws_region>"
}
# Used to create a random integer postfix for aws resources
provider "random" {}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | ../.. | n/a |
| <a name="module_s3_bucket_target"></a> [s3\_bucket\_target](#module\_s3\_bucket\_target) | ../.. | n/a |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"backend"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Required) The location where the resource will be created. Must not have spaces<br>    For example, us-east-1, us-west-2, eu-west-1, etc. | `string` | `"us-east-2"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_maximum_length"></a> [maximum\_length](#input\_maximum\_length) | Number that represents the maximum length the resource name could have. | `number` | `60` | no |
| <a name="input_separator"></a> [separator](#input\_separator) | Separator to be used in the name | `string` | `"-"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names. | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "s3_bucket_source": {<br>    "name": "srcbkt"<br>  },<br>  "s3_bucket_target": {<br>    "name": "targetbkt"<br>  },<br>  "target_bucket_reader_policy": {<br>    "max_length": 60,<br>    "name": "targetbucketplcy"<br>  }<br>}</pre> | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | KMS key description. This KMS key is used for SSE-KMS encryption f source bucket. | `string` | `"KMS key used for source bucket encryption"` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | (Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately. | `number` | `30` | no |
| <a name="input_kms_s3_key_sse_algorithm"></a> [kms\_s3\_key\_sse\_algorithm](#input\_kms\_s3\_key\_sse\_algorithm) | Server-side encryption algorithm to use. Valid values are AES256 and aws:kms | `string` | `"aws:kms"` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether to enable bucket\_key for encryption. It reduces encryption costs. Default is false | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Whether to enable versioning for this S3 bucket. Default is false | `bool` | `false` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_metric_configuration"></a> [metric\_configuration](#input\_metric\_configuration) | Map containing bucket metric configuration. | `any` | `[]` | no |
| <a name="input_analytics_configuration"></a> [analytics\_configuration](#input\_analytics\_configuration) | Map containing bucket analytics configuration. | `any` | `{}` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid),<br>    Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the<br>    verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform,<br>    see the AWS IAM Policy Document Guide. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | An arbitrary map of tags that can be added to all resources. | `map(string)` | `{}` | no |
| <a name="input_access_log_delivery_policy_source_accounts"></a> [access\_log\_delivery\_policy\_source\_accounts](#input\_access\_log\_delivery\_policy\_source\_accounts) | (Optional) List of AWS Account IDs should be allowed to deliver access logs to this bucket. | `list(string)` | `[]` | no |
| <a name="input_attach_access_log_delivery_policy"></a> [attach\_access\_log\_delivery\_policy](#input\_attach\_access\_log\_delivery\_policy) | Controls if S3 bucket should have S3 access log delivery policy attached | `bool` | `false` | no |
| <a name="input_attach_policy"></a> [attach\_policy](#input\_attach\_policy) | Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the S3 Bucket |
| <a name="output_id"></a> [id](#output\_id) | ID of the S3 Bucket |
| <a name="output_target_bucket_arn"></a> [target\_bucket\_arn](#output\_target\_bucket\_arn) | ARN of the S3 Bucket |
| <a name="output_target_bucket_id"></a> [target\_bucket\_id](#output\_target\_bucket\_id) | ID of the S3 Bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
