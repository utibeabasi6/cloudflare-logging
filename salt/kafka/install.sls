openjdk-8-jdk:
  pkg.installed: []

/home/ubuntu/kafka.tgz:
  file.managed:
    - source: https://dlcdn.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
    - source_hash: B76601FD46A887C9CB8B378E3F5D2886
      
extract_kafka:
  archive.extracted:
    - name: /home/ubuntu/kafka
    - source: /home/ubuntu/kafka.tgz
    
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