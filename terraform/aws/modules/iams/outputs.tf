output "account_id" {
  value = data.aws_caller_identity.account_id.account_id

}

output "authenticate_list_account" {
  value = [
    {
      account = [
        for idx in range(length(var.ops_list_username)) :
        {
            "username" : aws_iam_user_login_profile.ops_account_password[idx].password,
            "password" : aws_iam_user.create_ops_account[idx].name,
            "access_key" : aws_iam_access_key.ops_account_access_keys[idx].id,
            "access_secret" : aws_iam_access_key.ops_account_access_keys[idx].secret,

        }
      ]
    }
  ]

}
