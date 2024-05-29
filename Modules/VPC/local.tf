locals {
  public_subnets = [
    { name = "spaces-prod-public-la", cidr = "10.60.80.0/20" },
    { name = "spaces-prod-public-1", cidr = "10.60.96.0/20" },
    { name = "spaces-prod-public-10", cidr = "10.60.112.0/20" }
  ]

  private_subnets = [
    { name = "spaces-prod-private-la", cidr = "10.60.32.0/20" },
    { name = "spaces-prod-private-16", cidr = "10.60.128.0/20" },
    { name = "spaces-prod-private-1c", cidr = "10.60.144.0/20" }
  ]
}
