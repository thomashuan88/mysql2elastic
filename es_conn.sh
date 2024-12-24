curl -X POST -H "Content-Type: application/json" --data '{
    "name": "elasticsearch-sink",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "tasks.max": "1",
        "topics": "mysql.testdb.orders",
        "connection.url": "http://elasticsearch:9200",
        "type.name": "_doc",
        "key.ignore": "true",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter"
    }
}' http://localhost:8083/connectors


