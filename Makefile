NAME=SSM-showcase
HOST=i-0082f02cf168b4160

terraform-plan:
	@terraform init -reconfigure
	@terraform plan -out=terraform-${NAME}.plan -state=terraform-${NAME}.tfstate

terraform-apply:
	@terraform apply -state=terraform-${NAME}.tfstate terraform-${NAME}.plan

terraform-destroy:
	@terraform destroy -state=terraform-${NAME}.tfstate

ssh:
	@ssh admin@${HOST} -i ~/.ssh/ssm_showcase.pem -o "proxycommand aws --profile moneytec ssm start-session --target ${HOST} --document-name AWS-StartSSHSession"