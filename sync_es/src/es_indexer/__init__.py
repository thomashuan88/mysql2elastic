import os
from elasticsearch import Elasticsearch

# Define es_host as a global variable
es_host = None

def check_es_connection():
    global es_host
    es_host = os.getenv("ES_HOST")
    if not es_host:
        raise Exception("ES_HOST is not set in the environment variables.")
    
    # Check if the host address is in a valid format
    if not es_host.startswith("http://") and not es_host.startswith("https://"):
        raise Exception("ES_HOST is not in a valid format. It should start with 'http://' or 'https://'.")

    try:
        # Attempt to create an Elasticsearch client to check the connection
        es_client = Elasticsearch([es_host])
        if es_client.ping():
            print("Successfully connected to Elasticsearch.")
            return True
        else:
            print("Elasticsearch connection failed: ping unsuccessful.")
            return False
    except Exception as e:
        print(f"Failed to connect to Elasticsearch: {e}")
        exit(1)

# Automatically check the connection when the module is imported
check_es_connection()