#!/bin/bash

# Execute KSQL transformations
ksql http://localhost:8088 <<EOF
RUN SCRIPT '/movies_transform.sql';
EOF

# Wait for a few seconds to ensure KSQL streams are created
sleep 5

# Create Elasticsearch connector
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @/connect/movies-es-sink.json
