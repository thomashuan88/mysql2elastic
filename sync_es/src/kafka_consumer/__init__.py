import os
from kafka import KafkaConsumer

# Define kafka_broker as a global variable
kafka_broker = None

def check_kafka_connection():
    global kafka_broker
    kafka_broker = os.getenv("KAFKA_BROKER")
    if not kafka_broker:
        raise Exception("KAFKA_BROKER is not set in the environment variables.")
    
    try:
        # Attempt to create a consumer to check the connection
        consumer = KafkaConsumer(bootstrap_servers=kafka_broker)
        print("Successfully connected to Kafka broker.")
        
        # If successful, return True
        return True
    except Exception as e:
        print(f"Failed to connect to Kafka broker: {e}")
        exit(1)

# Automatically check the connection when the module is imported
check_kafka_connection()