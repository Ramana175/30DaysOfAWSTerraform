variable "monthly_budget" {

  description = "Monthly Cloud Budget"

  type = number

  default = 500

}

variable "service_costs" {

  description = "AWS Service Costs"

  type = map(number)

  default = {

    EC2        = 120

    RDS        = 250

    S3         = 80

    CloudFront = 50

  }
}