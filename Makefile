up:
	@cd terraform && terraform apply -var-file=./.tfvars

plan:
	@cd terraform && terraform plan -var-file=./.tfvars

update_salt:
	@sudo cp -r salt/* /etc/salt/srv/salt
	@sudo salt-ssh '*' state.apply --sudo

collector:
	@cd otel && ocb --config builder-config.yaml
	@cd otel/otelcol && ./otelcol --config config.yaml