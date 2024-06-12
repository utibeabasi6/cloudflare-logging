up:
	@cd terraform && terraform apply -var-file=./.tfvars

plan:
	@cd terraform && terraform plan -var-file=./.tfvars

update_salt:
	@sudo cp -r salt/* /etc/salt/srv/salt
	# @sudo salt-ssh '*' state.apply kafka.install --sudo
	# @sudo salt-ssh '*' state.apply kafka.kafka
	# @sudo salt-ssh '*' state.apply kafka.services --sudo
	@sudo salt-ssh '*' state.apply -l debug --sudo