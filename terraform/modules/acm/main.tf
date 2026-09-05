# it's not for free tier :((
# just understand the main idea and all easy
# just reminder: DevOps just a concept not tools. 

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "the-lord-of-the-pings.com"
  zone_id     = "Z2ES7B9AZ6SHAE"

  validation_method = "DNS"

  subject_alternative_names = [
    "*.the-lord-of-the-pings.com",
    "app.sub.the-lord-of-the-pings.com",
  ]

  wait_for_validation = true

  tags = {
    Name = "my-domain.com"
  }
}
