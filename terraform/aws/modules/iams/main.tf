data "aws_caller_identity" "account_id" { }
resource "aws_iam_user" "create_ops_account" {
    
    count = length(var.ops_list_username)
    name = element(var.ops_list_username, count.index)
  
}

resource "aws_iam_access_key" "ops_account_access_keys" {
    count = length(var.ops_list_username)
    user = element(aws_iam_user.create_ops_account[*].name, count.index)


}

resource "aws_iam_user_login_profile" "ops_account_password" {
    count = length(var.ops_list_username)
    user = element(aws_iam_user.create_ops_account[*].name, count.index)

    password_length = 16
    password_reset_required = false
    lifecycle {
        ignore_changes = [ password_length, ]
    }
  
}

resource "aws_iam_group" "operations" {
    name = "operations"
    path = "/ops/"
  
}

resource "aws_iam_group_membership" "ops_member" {
    name = "ops_group"
    count = length(var.ops_list_username)
    users = [ element(aws_iam_user.create_ops_account[*].name,count.index) ]


    group = aws_iam_group.operations.name
}

resource "aws_iam_group_policy_attachment" "ops_group_policy" {
    group = aws_iam_group.operations.name
    policy_arn = var.ec2_full_access_arn
  
}