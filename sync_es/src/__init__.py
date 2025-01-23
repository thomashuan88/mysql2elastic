import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../.env'))

# Now you can access the variables throughout the package
# kafka_broker = os.getenv('KAFKA_BROKER')
# es_host = os.getenv('ES_HOST')

# You can also define any other package-level variables or functions here