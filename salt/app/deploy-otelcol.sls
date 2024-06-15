/home/ubuntu/otelcol.zip:
  file.managed:
    - source: https://github.com/utibeabasi6/cloudflare-logging/releases/download/v0.0.6/otelcol.zip
    - source_hash: FCDF24F7F79CBBCFF76DA362B7326BDF
    - failhard: True

extract_otelcol:
  archive.extracted:
    - name: /home/ubuntu/otelcol
    - source: /home/ubuntu/otelcol.zip
    - failhard: True
    - enforce_toplevel: False

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