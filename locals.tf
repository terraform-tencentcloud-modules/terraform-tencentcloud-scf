locals {
  function_namespace_name = var.create_namespace ? length(tencentcloud_scf_namespace.this) > 0 ?tencentcloud_scf_namespace.this.0.id :"": length(data.tencentcloud_scf_namespaces.this.namespaces)> 0 ? data.tencentcloud_scf_namespaces.this.namespaces.0.namespace : ""
  }

data "tencentcloud_scf_namespaces" "this" {
  namespace = var.function_namespace
}