NAME=SSM-showcase
INSTANCE_ID=i-0adb56e2bbad82238

terraform-plan:
	@terraform init -reconfigure
	@terraform plan -out=terraform-${NAME}.plan -state=terraform-${NAME}.tfstate

terraform-apply:
	@terraform apply -state=terraform-${NAME}.tfstate terraform-${NAME}.plan

terraform-destroy:
	@terraform destroy -state=terraform-${NAME}.tfstate

ssh:
	@ssh admin@${INSTANCE_ID} -i ~/.ssh/ssm_showcase.pem -o Proxycommand="aws --profile opfa ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartSSHSession"