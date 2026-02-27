"""Data ingestion

This module provides functions to support data ingestion for a database-driven analysis. 
The functions allow for creating a database engine, executing SQL queries, and reading CSV 
files from web URLs. The module is designed to facilitate extracting, loading, and 
transforming data from various sources, enabling data processing workflows
to retrieve geographic, weather, soil, and farm management features for analysis. 

The module uses SQLAlchemy to interact with a SQL database and Pandas for data manipulation, with logging
enabled to capture information and errors.

Functions:
    create_db_engine(db_path): Creates a SQLAlchemy database engine.
    query_data(engine, sql_query): Executes a SQL query on the provided database engine.
    read_from_web_CSV(URL): Reads a CSV file from a web URL and loads it into a DataFrame.
"""
from sqlalchemy import create_engine, text
import logging
import pandas as pd

# Configure the logger
logger = logging.getLogger('data_ingestion')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

### START FUNCTION

def create_db_engine(db_path):
    """Create a SQLAlchemy database engine.

    Args:
        db_path (str): The path to the database.

    Returns:
        engine (str): The SQLAlchemy engine object for connecting to the database.

    Raises:
        ImportError: If SQLAlchemy is not installed.
        Exception: For general errors related to creating the database engine.
    """
    try:
        engine = create_engine(db_path)
        with engine.connect() as conn:
            pass
      
        logger.info("Database engine created successfully.")
        return engine 
    except ImportError: 
        logger.error("SQLAlchemy is required to use this function. Please install it first.")
        raise e
    except Exception as e:
        logger.error(f"Failed to create database engine. Error: {e}")
        raise e


def query_data(engine, sql_query):
    """Execute a SQL query on a database engine and return the result as a DataFrame.

    Args:
        engine (str): The SQLAlchemy engine object.
        sql_query (str): The SQL query to execute.

    Returns:
        DataFrame: The result of the SQL query as a DataFrame.
    Raises:
        ValueError: If the query returns an empty DataFrame.
        Exception: If an error occurs while querying the database.
    """
    try:
        with engine.connect() as connection:
            df = pd.read_sql_query(text(sql_query), connection)
        if df.empty:
            msg = "The query returned an empty DataFrame."
            logger.error(msg)
            raise ValueError(msg)
        logger.info("Query executed successfully.")
        return df
    except ValueError as e:
        logger.error(f"SQL query failed. Error: {e}")
        raise e
    except Exception as e:
        logger.error(f"An error occurred while querying the database. Error: {e}")
        raise e

def read_from_web_CSV(URL):
    """Read a CSV file from a web URL and return it as a DataFrame.

    Args:
        URL (str): The URL of the CSV file.

    Returns:
        pandas.DataFrame: The CSV file contents as a DataFrame.
    """
    try:
        df = pd.read_csv(URL)
        logger.info("CSV file read successfully from the web.")
        return df
    except pd.errors.EmptyDataError as e:
        logger.error("The URL does not point to a valid CSV file. Please check the URL and try again.")
        raise e
    except Exception as e:
        logger.error(f"Failed to read CSV from the web. Error: {e}")
        raise e

### END FUNCTION