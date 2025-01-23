from sync_es.src.es_indexer import indexer
from sync_es.src.kafka_consumer import consumer

if __name__ == "__main__":
    # # Start the Kafka consumer
    consumer.my_func()

    # # Start the Elasticsearch indexer
    # indexer.start()
    pass