/home/ubuntu/otelcol.zip:
  file.managed:
    - source: https://velocity-store-utibeabasi6.s3.amazonaws.com/otelcol.zip # temporary url
    - source_hash: 32d316ea9c3e23fe91f06ef344bc7489
    - failhard: True

extract_otelcol:
  archive.extracted:
    - name: /home/ubuntu/otelcol
    - source: /home/ubuntu/otelcol.zip
    - failhard: True

/home/ubuntu/otelcol/config.yaml:
  file.managed:
    - source: salt://app/files/config.yaml
    - failhard: True

/etc/systemd/system/otelcol.service:
  file.managed:
    - source: salt://app/files/otelcol.service
    - failhard: True

otelcol:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/otelcol.service
      - file: /home/ubuntu/otelcol/config.yaml