/home/ubuntu/kafka.tgz:
  file.managed:
    - source: https://dlcdn.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
    - source_hash: B76601FD46A887C9CB8B378E3F5D2886
      
extract_kafka:
  archive.extracted:
    - name: /home/ubuntu/kafka
    - source: /home/ubuntu/kafka.tgz