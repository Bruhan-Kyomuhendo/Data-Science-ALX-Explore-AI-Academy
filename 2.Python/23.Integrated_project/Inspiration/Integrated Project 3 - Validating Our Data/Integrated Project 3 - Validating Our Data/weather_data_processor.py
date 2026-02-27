# These are the imports we're going to use in the weather data processing module
import re
import numpy as np
import pandas as pd
import logging
from data_ingestion import read_from_web_CSV

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

config_params = {

    "sql_query": """
                SELECT *
                FROM geographic_features
                LEFT JOIN weather_features USING (Field_ID)
                LEFT JOIN soil_and_crop_features USING (Field_ID)
                LEFT JOIN farm_management_features USING (Field_ID)
            """, # Insert your SQL query
    "db_path": 'sqlite:///Maji_Ndogo_farm_survey_small.db', # Insert the db_path of the database
    "columns_to_rename": {'Annual_yield': 'Crop_type', 'Crop_type': 'Annual_yield'}, # Insert the disctionary of columns we want to swop the names of,
    "values_to_rename": {'cassaval': 'cassava', 'wheatn': 'wheat', 'teaa': 'tea'}, # Insert the croptype renaming dictionary
    "weather_mapping_csv": "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_data_field_mapping.csv", # Insert the weather data mapping CSV here

    # Add two new keys
   "weather_csv_path":  "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_station_data.csv", # Insert the URL for the weather station data
    "regex_patterns" : {
    'Rainfall': r'(\d+(\.\d+)?)\s?mm',
     'Temperature': r'(\d+(\.\d+)?)\s?C',
    'Pollution_level': r'=\s*(-?\d+(\.\d+)?)|Pollution at \s*(-?\d+(\.\d+)?)'
    } , # Insert the regex pattern we used to process the messages
}

### START FUNCTION 

class WeatherDataProcessor:
    """
    This class is responsible for processing weather data from various sources.
    """
    def __init__(self, config_params, logging_level="INFO"):
        """
        Initialize the WeatherDataProcessor with the provided configuration parameters.

        Args:
            config_params (dict): A dictionary containing configuration parameters.
            logging_level (str, optional): The logging level. Defaults to "INFO".
        """
        self.weather_station_data = config_params['weather_csv_path']
        self.patterns = config_params['regex_patterns']
        self.weather_df = None  # Initialize weather_df as None or as an empty DataFrame
        self.initialize_logging(logging_level)

    def initialize_logging(self, logging_level):
        """
        Initialize logging with the provided logging level.

        Args:
            logging_level (str): The logging level.
        """
        logger_name = __name__ + ".WeatherDataProcessor"
        self.logger = logging.getLogger(logger_name)
        self.logger.propagate = False  # Prevents log messages from being propagated to the root logger

        # Set logging level
        if logging_level.upper() == "DEBUG":
            log_level = logging.DEBUG
        elif logging_level.upper() == "INFO":
            log_level = logging.INFO
        elif logging_level.upper() == "NONE":  # Option to disable logging
            self.logger.disabled = True
            return
        else:
            log_level = logging.INFO  # Default to INFO

        self.logger.setLevel(log_level)

        # Only add handler if not already added to avoid duplicate messages
        if not self.logger.handlers:
            ch = logging.StreamHandler()  # Create console handler
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            ch.setFormatter(formatter)
            self.logger.addHandler(ch)

    def weather_station_mapping(self):
        """
        Load weather station data from the specified URL and assign it to the weather_df attribute.
        """
        self.weather_df = read_from_web_CSV(self.weather_station_data)
        self.logger.info("Successfully loaded weather station data from the web.")
    
    def extract_measurement(self, message):
        """
        Extract measurements from the provided message using the defined regex patterns.

        Args:
            message (str): The message from which to extract measurements.

        Returns:
            tuple: A tuple containing the measurement type and its corresponding value.
        """
        for key, pattern in self.patterns.items():
            match = re.search(pattern, message)
            if match:
                self.logger.debug(f"Measurement extracted: {key}")
                return key, float(next((x for x in match.groups() if x is not None)))
        self.logger.debug("No measurement match found.")
        return None, None

    def process_messages(self):
        """
        Process messages to extract measurements and assign them to the weather_df DataFrame.
        """
        if self.weather_df is not None:
            result = self.weather_df['Message'].apply(self.extract_measurement)
            self.weather_df['Measurement'], self.weather_df['Value'] = zip(*result)
            self.logger.info("Messages processed and measurements extracted.")
        else:
            self.logger.warning("weather_df is not initialized, skipping message processing.")
        return self.weather_df

    def calculate_means(self):
        """
        Calculate the mean values of measurements for each weather station.

        Returns:
            pandas.DataFrame: A DataFrame containing the mean values of measurements for each weather station.
        """
        if self.weather_df is not None:
            means = self.weather_df.groupby(by=['Weather_station_ID', 'Measurement'])['Value'].mean()
            self.logger.info("Mean values calculated.")
            return means.unstack()
        else:
            self.logger.warning("weather_df is not initialized, cannot calculate means.")
            return None
    
    def process(self):
        """
        Process the weather data by loading and mapping weather station data, processing messages,
        and calculating mean values of measurements.
        """
        self.weather_station_mapping() 
        self.process_messages()  
        self.logger.info("Data processing completed.")
### END FUNCTION
