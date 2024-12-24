# FROM confluentinc/cp-kafka-connect:7.5.7-1-ubi8

FROM confluentinc/cp-kafka-connect:latest

# Step 2: Set environment variables
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

# Step 3: Install Elasticsearch Sink Connector using Confluent Hub Client
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:latest

# Step 4: Expose Kafka Connect REST API port
EXPOSE 8083

# Step 5: Start Kafka Connect
CMD ["/etc/confluent/docker/run"]
