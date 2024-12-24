curl -X POST -H "Content-Type: application/json" --data '{
    "name": "mysql-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1",
        "database.hostname": "192.168.137.5",
        "database.port": "3306",
        "database.user": "root",
        "database.password": "root",
        "topic.prefix": "mysql",
        "database.server.id": "2",
        "database.server.name": "mysql_binlog",
        "database.include.list": "testdb",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "schema-changes.testdb",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "schema.history.internal.kafka.topic": "schema-history.testdb",
        "snapshot.mode": "initial"
    }
}' http://localhost:8083/connectors
