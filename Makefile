NAME=SSM-showcase

terraform-plan:
	@terraform init -reconfigure
	@terraform plan -out=terraform-${NAME}.plan -state=terraform-${NAME}.tfstate

terraform-apply:
	@terraform apply -state=terraform-${NAME}.tfstate terraform-${NAME}.plan

terraform-destroy:
	@terraform destroy -state=terraform-${NAME}.tfstate

ssh-conf: ~/.ssh/config.d/${NAME}.ssh.conf

~/.ssh/config.d/${NAME}.ssh.conf:
	ln -s ${PWD}/${NAME}.ssh.conf ~/.ssh/config.d/${NAME}.ssh.conf

payload:
	dd if=/dev/zero of=100mb_file.bin bs=1M count=100