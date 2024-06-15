/home/ubuntu/otelcol.zip:
  file.managed:
    - source: https://github.com/utibeabasi6/cloudflare-logging/releases/download/v0.0.5/otelcol.zip
    - source_hash: B813CDE3D2AF814217EC164A09E2FF41
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