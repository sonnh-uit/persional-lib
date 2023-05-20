output "account_id" {
    value = data.aws_caller_identity.account_id.account_id
  
}
output "authenticate_list_account" {
    # type = map
    value = [
        {
            account = [
                {
                    "username" : {for user, i in aws_iam_user.create_ops_account: user => i.name},
                    "password" : {for pass, i in aws_iam_user_login_profile.ops_account_password: pass => i.password},
                    "access_key" : {for key, i in aws_iam_access_key.ops_account_access_keys: key => i.id},
                    "secret_access": {for secret, i in aws_iam_access_key.ops_account_access_keys: secret => i.secret}
                }
               
            ]
        }
        
    ] 
        
}