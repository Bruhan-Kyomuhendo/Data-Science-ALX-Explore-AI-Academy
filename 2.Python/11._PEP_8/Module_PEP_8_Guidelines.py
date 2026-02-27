"""
Data ingestion

This module provides functions to support data ingestion for a database-driven analysis. 
The functions allow for creating a database engine, executing SQL queries, and reading CSV 
files from web URLs. The module is designed to facilitate extracting, loading, and 
transforming data from various sources, enabling data processing workflows
to retrieve geographic, weather, soil, and farm management features for analysis. 

The module uses SQLAlchemy to interact with a SQL database and Pandas for data manipulation, with logging
enabled to provide informative logs about the data ingestion process.

Functions:
    create_db_engine(db_path): Creates a SQLAlchemy database engine.
    query_data(engine, sql_query): Executes a SQL query on the provided database engine.
    read_from_web_CSV(URL): Reads a CSV file from a web URL and loads it into a DataFrame.
"""

from sqlalchemy import create_engine, text
import logging
import pandas as pd

# Configure logger
logger = logging.getLogger('data_ingestion')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

### Database and Query Setup
db_path = 'sqlite:///Maji_Ndogo_farm_survey_small.db'
sql_query = """
SELECT *
FROM geographic_features
LEFT JOIN weather_features USING (Field_ID)
LEFT JOIN soil_and_crop_features USING (Field_ID)
LEFT JOIN farm_management_features USING (Field_ID)
"""

weather_data_URL = "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_station_data.csv"
weather_mapping_data_URL = "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_data_field_mapping.csv"

def create_db_engine(db_path):
    """Create a SQLAlchemy database engine.

    Args:
        db_path (str): The path to the database.

    Returns:
        sqlalchemy.engine.base.Engine: The SQLAlchemy engine object for connecting to the database.
        
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
        raise
    except Exception as e:
        logger.error(f"Failed to create database engine. Error: {e}")
        raise e

def query_data(engine, sql_query):
    """Execute a SQL query on a database engine and return the result as a DataFrame.

    Args:
        engine (str): The SQLAlchemy engine object to connect to the database.
        sql_query (str): The SQL query to execute on the database.

    Returns:
        pandas.DataFrame: The result of the SQL query as a DataFrame.

    Raises:
        ValueError: If the query returns an empty DataFrame.
        Exception: For general errors during query execution.
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
        DataFrame: The content of the CSV file as a DataFrame.

    Raises:
        EmptyDataError: If the URL does not point to a valid CSV file.
        Exception: For general errors while reading the CSV.
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
