# Cloudflare Logging

Log pipeline based on the architecture used at Cloudflare

# Components

- Externaljsonprocessor: Custom OTEL processor that enriches logs with AWS EC2 metadata
- Salt states that deploy our custom OTEL collector and install kafka

# How to run

- Deloy resources with `make up`. Make sure to add all variable values in a .tfvars file in the terraform directory
- Wait for all EC2 instances to come up and their user data script to finish running
- Run the `Configure Minions` github workflow to accept all minion keys and deploy salt states to minions
- Make requests to the app instances to generate traffic and send logs to the kafka instance
- Run `docker compose up` in the root directory and visit `http://localhost:8080` to view the `Conduktor` web UI which you can use to connect to the kafka brokers and view logs.

# TODO
- [ ]  Test multi-region deployment. Multi region support is built in but i havent tested it yet
- [ ] Add all app instances in all regions to global accelerator for anycast routing
