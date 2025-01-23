curl -X POST -H "Content-Type: application/json" --data '{
    "name": "elasticsearch-sink",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "tasks.max": "1",
        "topics": "transformed_movies_topic",
        "connection.url": "http://elasticsearch:9200",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "consumer.auto.offset.reset": "earliest"
    }
}' http://localhost:8083/connectors


# "type.name": "_doc",
# "key.ignore": "true",
