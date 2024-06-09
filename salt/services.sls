{% for service in "zookeeper", "kafka"%}
/etc/systemd/system/{{service}}.service:
  file.managed:
    - source: salt://kafka/{{service}}.service

{{service}}:
  service.running:
    - enable: True
    - reload: True
{% endfor %}