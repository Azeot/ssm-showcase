NAME=SSM-showcase

terraform-plan:
	@cd terraform && terraform init -reconfigure
	@cd terraform && terraform plan -out=terraform-${NAME}.plan -state=terraform-${NAME}.tfstate

terraform-apply:
	@cd terraform && terraform apply -state=terraform-${NAME}.tfstate terraform-${NAME}.plan

terraform-destroy:
	@cd terraform && terraform destroy -state=terraform-${NAME}.tfstate

ssh-conf: ~/.ssh/config.d/${NAME}.ssh.conf

~/.ssh/config.d/${NAME}.ssh.conf:
	ln -s ${PWD}/${NAME}.ssh.conf ~/.ssh/config.d/${NAME}.ssh.conf

payload:
	dd if=/dev/urandom of=ansible/files/100mb_file.bin bs=1M count=100

run-copy:
	@ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook \
	--private-key ~/.ssh/ssm_showcase.pem \
	-i ansible/inventories/showcase/hosts \
	--user admin \
	ansible/ssm_showcase.yml