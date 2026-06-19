# Create IAM Groups
resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

# Create IAM Groups
resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

# Create IAM Groups
resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}

# Add users to the Education group
resource "aws_iam_group_membership" "education_members" {
  name  = "education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.royal : user.name if user.tags.Department == "Education"
  ]
}

# Add users to the Managers group
resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.royal : user.name if user.tags.Department == "Managers"
  ]
}

# Add users to the Engineers group
resource "aws_iam_group_membership" "engineers_members" {
  name  = "engineers-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.royal : user.name if user.tags.Department == "Engineers"
  ]
}



resource "aws_iam_group_policy_attachment" "education_readonly" {
  group      = aws_iam_group.education.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "managers_fullaccess" {
  group      = aws_iam_group.managers.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}





resource "aws_iam_group_policy_attachment" "education_mfa" {
  group      = aws_iam_group.education.name
  policy_arn = aws_iam_policy.require_mfa.arn
}

resource "aws_iam_group_policy_attachment" "managers_mfa" {
  group      = aws_iam_group.managers.name
  policy_arn = aws_iam_policy.require_mfa.arn
}




