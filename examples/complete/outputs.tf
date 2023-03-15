output "this_namespace_id" {
  description = "ID of the namespace."
  value       =  module.scf_function.this_namespace_id
}

/*
* 是否需输出namespaceid
*/

output "this_function_id" {
  description = "ID of the function."
  value       =  module.scf_function.this_function_id
}
