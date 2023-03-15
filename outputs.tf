output "this_namespace_id" {
  description = "ID of the namespace."
  value       =  length(tencentcloud_scf_namespace.this) > 0 ? tencentcloud_scf_namespace.this[0].id : ""
}

/*
* 是否需输出namespaceid
*/

output "this_function_id" {
  description = "ID of the function."
  value       =  length(tencentcloud_scf_function.this) > 0 ? tencentcloud_scf_function.this[0].id : ""
}
