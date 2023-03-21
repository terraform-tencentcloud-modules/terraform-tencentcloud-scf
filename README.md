# TencentCloud SCF Module for Terraform

## terraform-tencentcloud-scf

A terraform module used for create TencentCloud Serverless Cloud Function,namespace and trigger.

The following resources are included.

* [scf_function](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/scf_function)
* [scf_namespace](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/scf_namespace)

These features of SCF configurations are supported:
- namespace setting
- function setting
- function log setting
- function vpc and subnet setting
- function trigger setting
- the role of function trigger setting


Usage
-----
### Create a function in the default namespace
```hcl
 module "scf_function" {
   source = "terraform-tencentcloud-modules/scf/tencentcloud"
 
   #namespace
   create_namespace     = false
   #function
   create_function      = true
   function_name        = "test-tf-function"
   function_zip_file    = "./complete/go_example/main.zip"
   function_runtime     = "Go1"
   function_handler     = "main"
 }
```

### Create a namespace when creating a function, and set the function namespace to the created namespace

```hcl
 module "scf_function" {
   source = "terraform-tencentcloud-modules/scf/tencentcloud"
 
   #namespace
   create_namespace     = true
   namespace_name = "test-tf-namespace"
   #function
   create_function      = true
   function_name        = "test-tf-function"
   function_zip_file    = "./complete/go_example/main.zip"
   function_runtime     = "Go1"
   function_handler     = "main"
 }
```

### create namespace,function and triggers
```hcl
module "scf_function" {
  source = "terraform-tencentcloud-modules/scf/tencentcloud"

  #namespace
  create_namespace     = true
  namespace_name       = "test-tf-namespace"
  #function
  create_function      = true
  function_name        = "test-tf-function"
  function_zip_file    = "./complete/go_example/main.zip"
  function_runtime     = "Go1"
  function_handler     = "main"
  function_trigger_config = [
          {
              name="test-timer-trigger2"
              trigger_desc="0 0 0 */1 * * *"
              type="timer"
              cos_region=""
          }
      ]
}
```

### Create several  triggers
```hcl
module "scf_function" {
  source = "terraform-tencentcloud-modules/scf/tencentcloud"

  #namespace
  create_namespace     = true
  namespace_name = "test-tf-namespace"
  #function
  create_function      = true
  function_name        = "test-tf-function"
  function_zip_file    = "./complete/go_example/main.zip"
  function_runtime     = "Go1"
  function_handler     = "main"
  function_trigger_config = [
          {
              name="test-timer-trigger2"
              trigger_desc="0 0 0 */1 * * *"
              type="timer"
              cos_region=""
          },
          {
              name="test-timer-trigger3"
              trigger_desc="0 0 */1 * * * *"
              type="timer"
              cos_region=""
           }
      ]
}
```

## Examples:

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencent-scf/tree/master/examples/complete
) - A complete example of SCF features


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.18.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.18.1 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_namespace | Whether to create a new SCF namespace. | bool | true | no
| namespace_name | Name of the SCF namespace. | string | "" | no
| namespace_description | Description of the SCF namespace. | bool | true | no
| create_function | Whether to create event function. | bool | true | no
| function_namespace | Namespace of the SCF function. | string | default | no
| function_name | Name of the SCF function. Name supports 26 English letters, numbers, connectors, and underscores, it should start with a letter. The last character cannot be - or _. Available length is 2-60. | string | "" | no
| function_description | Description of the SCF function. Description supports English letters, numbers, spaces, commas, newlines, periods and Chinese, the maximum length is 1000. | string | "" | no
| function_zip_file | Zip file of the SCF function, conflict with cos_bucket_name, cos_object_name, cos_bucket_region. | string | "" | no
| function_cos_bucket_name | Cos bucket name of the SCF function, such as cos-1234567890, conflict with zip_file. | string | "" | no
| function_cos_object_name | Cos object name of the SCF function, should have suffix .zip or .jar, conflict with zip_file. | string | "" | no
| function_cos_bucket_region | Cos bucket region of the SCF function, conflict with zip_file. | string | "" | no
| function_runtime | Runtime of the SCF function, only supports Python2.7, Python3.6, Nodejs6.10, Nodejs8.9, Nodejs10.15, PHP5, PHP7, Golang1, and Java8.| string | "" | no
| function_handler | Handler of the SCF function. The format of name is <filename>.<method_name>, and it supports 26 English letters, numbers, connectors, and underscores, it should start with a letter. The last character cannot be - or _. Available length is 2-60. | string | "main" | no
| function_mem_size | Memory size of the SCF function, unit is MB. The default is 128MB. The ladder is 128M. | number | 128 | no
| function_timeout | Timeout of the SCF function, unit is second. Default 3. Available value is 1-900. | number | 3 | no
| function_role | Role of the SCF function. | string | "" | no
| function_cls_logset_id | cls logset id of the SCF function.| string | "" | no
| function_cls_topic_id | cls topic id of the SCF function. | string | "" | no
| function_vpc_id | VPC ID of the SCF function. | string | "" | no
| function_subnet_id | Subnet ID of the SCF function. | string | "" | no
| function_enable_public_net | Indicates whether public net config enabled. Default false. NOTE: only vpc_id specified can disable public net config. | bool | false | no
| function_trigger_config | Trigger list of the SCF function, note that if you modify the trigger list, all existing triggers will be deleted, and then create triggers in the new list. | list(object()| [] | no

### function_trigger_config
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the SCF function trigger, if type is ckafka, the format of name must be <ckafkaInstanceId>-<topicId>; if type is cos, the name is cos bucket id, other In any case, it can be combined arbitrarily. It can only contain English letters, numbers, connectors and underscores. The maximum length is 100. | string | "" | yes
| trigger_desc | TriggerDesc of the SCF function trigger, parameter format of timer is linux cron expression; parameter of cos type is json string {"bucketUrl":"<name-appid>.cos.<region>.myqcloud.com","event":"cos:ObjectCreated:*","filter":{"Prefix":"","Suffix":""}}, where bucketUrl is cos bucket (optional), event is the cos event trigger, Prefix is the corresponding file prefix filter condition, Suffix is the suffix filter condition, if not need filter condition can not pass; cmq type does not pass this parameter; ckafka type parameter format is json string {"maxMsgNum":"1","offset":"latest"}; apigw type parameter format is json string {"api":{"authRequired":"FALSE","requestConfig":{"method":"ANY"},"isIntegratedResponse":"FALSE"},"service":{"serviceId":"service-dqzh68sg"},"release":{"environmentName":"test"}}. | string | "" | yes
| type | Type of the SCF function trigger, support cos, cmq, timer, ckafka, apigw.| string | "" | no
| cos_region | Region of cos bucket. if type is cos, cos_region is required. | string | "" | no

## Outputs

| Name | Description |
|------|-------------|
| this_namespace_id | ID of the namespace. |
| this_function_id | ID of the function. |


## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
