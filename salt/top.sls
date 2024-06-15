base:          
  'app-*':      
    - app.install
    - app.deploy-otelcol
  'kafka-*':
    - kafka.install