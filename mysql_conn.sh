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
        "database.server.id": "200",
        "database.server.name": "mysql_binlog",
        "database.include.list": "mv_datas",
        "table.include.list": "mv_datas.mv_video,mv_datas.mv_video_channel,mv_datas.mv_video_category_mapper,mv_datas.mv_video_channel_category,mv_datas.mv_video_actor,mv_datas.mv_actor,mv_datas.mv_video_tag_mapper,mv_datas.mv_video_tag",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "schema-changes.mv_datas",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "schema.history.internal.kafka.topic": "schema-history.mv_datas",
        "snapshot.mode": "initial",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.drop.tombstones": "false",
        "transforms.unwrap.delete.handling.mode": "rewrite",
        "transforms.unwrap.add.fields": "op,table,lsn,source.ts_ms",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": "true",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": "true",
        "include.schema.changes": "true"
    }
}' http://localhost:8083/connectors
