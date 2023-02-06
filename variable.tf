variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "base_name" {
  type        = string
  description = "Base Name to append to the policy name (prevents duplication)"
}

variable "policy_json" {
  type        = map(any)
  description = "Policy definition in JSON"
  default     = {}
}

variable "management_group_id" {
  type        = string
  description = "Management Group to apply the policy"
  default     = null
}
