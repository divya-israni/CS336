import sys
import psycopg2
import pandas as pd
import getpass

def main():
    # Get query from argument or stdin
    if len(sys.argv) > 1:
        query = sys.argv[1]
    else:
        print("Reading query from stdin (extra credit mode)...")
        query = sys.stdin.read().strip()

    # Database connection parameters (customize these!)
    db_config = {
        'host': 'postgres.cs.rutgers.edu',  # host: postgres.cs.rutgers.edu or localhost
        'port': 5432,                       # Default PostgreSQL port: 5432
        'dbname': 'ycw7',                   # Replace with your database name
        'user': 'ycw7',                     # Replace with your username
        'password': getpass.getpass("Enter your password (ilab_script): ") # I think this is only needed when testing locally
    }

    # If testing locally:
    # ssh tunnel setup: ssh -L 5433:postgres.cs.rutgers.edu:5432 ycw7@ilab.cs.rutgers.edu
    # Change host to 'localhost' and port to 5433 in db_config

    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()

        # Execute the query and fetch results using pandas
        df = pd.read_sql_query(query, conn)
        print(df.to_string(index=False))  # Pretty table print

        # Clean up
        cursor.close()
        conn.close()

    except Exception as e:
        print("An error occurred:", e)

if __name__ == "__main__":
    main()

# To test: python ilab_script.py "SELECT * FROM loan LIMIT 1;"
# stdin: echo "SELECT * FROM loan LIMIT 1;" | python ilab_script.py