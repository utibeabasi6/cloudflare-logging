up:
	@cd terraform && terraform apply -var-file=./.tfvars

plan:
	@cd terraform && terraform plan -var-file=./.tfvars

update_salt:
	@sudo cp -r salt/* /etc/salt/srv/salt
	@sudo salt-ssh '*' state.apply install --sudo
	@sudo salt-ssh '*' state.apply kafka
	@sudo salt-ssh '*' state.apply services --sudo