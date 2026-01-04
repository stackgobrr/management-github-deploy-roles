output "wm_dojo_role_arn" {
  description = "ARN of the wm-dojo IAM role"
  value       = module.wm_dojo.role_arn
}

output "spa_template_role_arn" {
  description = "ARN of the spa-template IAM role"
  value       = module.spa_template.role_arn
}
