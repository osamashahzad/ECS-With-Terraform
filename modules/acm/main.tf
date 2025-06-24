resource "aws_acm_certificate" "custom_domain" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  tags = merge(var.default_tags, {
    Name        = "${var.domain_name}-${var.env}-${var.project_name}"
    description = "Custom Domain for ${var.env}-${var.project_name}"
  })
}