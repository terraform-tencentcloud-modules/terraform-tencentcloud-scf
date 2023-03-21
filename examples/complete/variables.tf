
/*
* namespace_config
*/
variable "create_namespace" {
  description = "Whether to create a new SCF namespace. Default to true."
  type        = bool
  default     = true
}

variable "namespace_name" {
  description  = "Name of the SCF namespace."
  type         = string
  default      = "test-namespace2"
}

variable "namespace_description" {
  description   = "Description of the SCF namespace."
  type          = string
  default       = ""
}

/*
* scf_function_config
*/
variable "create_function" {
  description = "Whether to create event function."
  type        = bool
  default     = true
}

variable "function_namespace" {
  description = "Namespace of the SCF function, default is default."
  type        = string
  default     = "default"
}

variable "function_name" {
  description = "Name of the SCF function. Name supports 26 English letters, numbers, connectors, and underscores, it should start with a letter. The last character cannot be - or _. Available length is 2-60."
  type        = string
  default     = "test-name"
}

variable "function_description" {
  description = "Description of the SCF function. Description supports English letters, numbers, spaces, commas, newlines, periods and Chinese, the maximum length is 1000."
  type        = string
  default     = ""
}

variable "function_zip_file" {
  description = "Zip file of the SCF function, conflict with cos_bucket_name, cos_object_name, cos_bucket_region."
  type        = string
  default     = "./go_example/main.zip"
}

variable "function_cos_bucket_name" {
  description = "Cos bucket name of the SCF function, such as cos-1234567890, conflict with zip_file."
  type        = string
  default     = ""
}

variable "function_cos_object_name" {
  description = "Cos object name of the SCF function, should have suffix .zip or .jar, conflict with zip_file."
  type        = string
  default     = ""
}

variable "function_cos_bucket_region" {
  description = "Cos bucket region of the SCF function, conflict with zip_file."
  type        = string
  default     = ""
}

variable "function_runtime" {
  description = "Runtime of the SCF function, only supports Python2.7, Python3.6, Nodejs6.10, Nodejs8.9, Nodejs10.15, PHP5, PHP7, Golang1, and Java8."
  type        = string
  default     = "Go1"
}

variable "function_handler" {
  description = "Handler of the SCF function. The format of name is <filename>.<method_name>, and it supports 26 English letters, numbers, connectors, and underscores, it should start with a letter. The last character cannot be - or _. Available length is 2-60."
  type        = string
  default     = "main"
}

variable "function_mem_size" {
  description = "Memory size of the SCF function, unit is MB. The default is 128MB. The ladder is 128M."
  type        = number
  default     = 128
}

variable "function_timeout" {
  description = "Timeout of the SCF function, unit is second. Default 3. Available value is 1-900."
  type        = number
  default     = 3
}

variable "function_cls_logset_id" {
  description = "cls logset id of the SCF function."
  type        = string
  default     = ""
}

variable "function_cls_topic_id" {
  description = "cls topic id of the SCF function."
  type        = string
  default     = ""
}

variable "function_vpc_id" {
  description = "VPC ID of the SCF function."
  type        = string
  default     = ""
}

variable "function_subnet_id" {
  description = " Subnet ID of the SCF function."
  type        = string
  default     = ""
}

variable "function_enable_public_net" {
  description = "Indicates whether public net config enabled. Default false. NOTE: only vpc_id specified can disable public net config."
  type        = bool
  default     = false
}

variable "function_trigger_config" {
  description = "Trigger list of the SCF function, note that if you modify the trigger list, all existing triggers will be deleted, and then create triggers in the new list."
  type = list(object({
    name = string
    trigger_desc = string
    type = string
    cos_region = string
  }))
  default = [
      {
          name="bob-test-timer-trigger"
          trigger_desc="0 0 0 */1 * * *"
          type="timer"
          cos_region=""
      }
  ]
}

/*
* layer_config
*/

