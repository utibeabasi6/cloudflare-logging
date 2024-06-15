/home/ubuntu/otelcol.zip:
  file.managed:
    - source: https://velocity-store-utibeabasi6.s3.amazonaws.com/otelcol.zip # temporary url
    - source_hash: 32d316ea9c3e23fe91f06ef344bc7489

extract_otelcol:
  archive.extracted:
    - name: /home/ubuntu/otelcol
    - source: /home/ubuntu/otelcol.zip

/home/ubuntu/otelcol:
  file.managed:
    - source: salt://app/files/config.yaml

/etc/systemd/system/otelcol.service:
  file.managed:
    - source: salt://app/files/otelcol.service

otelcol:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/otelcol.service
      - file: /home/ubuntu/otelcol/config.yaml