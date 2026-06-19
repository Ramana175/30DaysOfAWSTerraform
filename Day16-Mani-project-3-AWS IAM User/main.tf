
#AWS Caller Identity in Terraform
data "aws_caller_identity" "current" {}

output "account_id" {
value = data.aws_caller_identity.current.account_id
}


#csvdecode Function
#csvdecode decodes a string containing CSV-formatted data and produces a list of maps representing that data.
#CSV is Comma-separated Values, an encoding format for tabular data. There are many variants of CSV, but this function implements the format defined in RFC 4180.
#The first line of the CSV data is interpreted as a "header" row: the values given are used as the keys in the resulting maps. 
#Each subsequent line becomes a single map in the resulting list, matching the keys from the header row with the given values by index. 
#All lines in the file must contain the same number of fields, or this function will produce an error.
locals{
    users =csvdecode(file("users.csv"))
}

#output of the users names
output "user-names"{
    value=[for user in local.users: "${user.first_name} ${user.last_name}"]

}


#Creating AWS IAM User
resource "aws_iam_user" "royal" {
    for_each = {for user in local.users: user.first_name => user}

    name = lower("${substr(each.value.first_name,0,1)}${each.value.last_name}")
    path ="/users/"

    tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
    Email       = each.value.email
  Phone       = each.value.phone
  }
}



#Creating AWS IAM User Login Profile
resource "aws_iam_user_login_profile" "example" {
    for_each = aws_iam_user.royal
  user    = each.value.name
  password_reset_required = true

   lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

output "password" {
  value = {
  for user, profile in aws_iam_user_login_profile.example : 
  user => "password created -user must reset password on first login"
  }
  sensitive = true
}





