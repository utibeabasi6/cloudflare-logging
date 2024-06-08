/etc/systemd/system/zookeeper.service:
  file.managed:
    - source: salt://kafka/zookeeper.service

/etc/systemd/system/kafka.service:
  file.managed:
    - source: salt://kafka/kafka.service

zookeeper:
  service.running:
    - enable: True
    - reload: True

kafka:
  service.running:
    - enable: True
    - reload: True