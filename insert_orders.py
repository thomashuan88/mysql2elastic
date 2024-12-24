import mysql.connector
import time

# Database connection configuration
config = {
    'user': 'root',  # replace with your MySQL username
    'password': 'root',  # replace with your MySQL password
    'host': 'localhost',
    'database': 'testdb'
}

# Connect to the database
try:
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()

    # Create the orders table
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_name VARCHAR(100),
        product_name VARCHAR(100),
        quantity INT,
        order_date DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    '''
    cursor.execute(create_table_query)
    print("Table 'orders' created successfully.")

    # Insert 10,000 records
    for i in range(10000):
        insert_query = '''
        INSERT INTO orders (customer_name, product_name, quantity) VALUES (%s, %s, %s)
        '''
        data = (f'Customer {i}', f'Product {i}', i % 100)
        cursor.execute(insert_query, data)
        connection.commit()
        print(f'Record {i+1} inserted.')
        time.sleep(1)  # Delay of 1 second

except mysql.connector.Error as err:
    print(f'Error: {err}')
finally:
    if connection:
        cursor.close()
        connection.close()
        print("Database connection closed.")
