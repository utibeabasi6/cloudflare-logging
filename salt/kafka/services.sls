{% set public_ip = salt["cmd.run"]("curl -s icanhazip.com ") %}

/home/ubuntu/kafka/server.properties:
  file.managed:
    - source: salt://kafka/files/server.properties
    - template: jinja
    - defaults:
      public_ip: '127.0.0.1'
    - context:
      public_ip: '{{public_ip}}'

{% for service in "zookeeper", "kafka"%}
/etc/systemd/system/{{service}}.service:
  file.managed:
    - source: salt://kafka/files/{{service}}.service
  
{{service}}:
  service.running:
    - enable: True
    - reload: True
{% endfor %}