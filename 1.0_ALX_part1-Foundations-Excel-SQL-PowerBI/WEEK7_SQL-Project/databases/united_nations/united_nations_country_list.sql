-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: united_nations
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `country_list`
--

DROP TABLE IF EXISTS `country_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country_list` (
  `Country` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_list`
--

LOCK TABLES `country_list` WRITE;
/*!40000 ALTER TABLE `country_list` DISABLE KEYS */;
INSERT INTO `country_list` VALUES ('Kazakhstan'),('Kyrgyzstan'),('Tajikistan'),('Turkmenistan'),('Uzbekistan'),('Afghanistan'),('Bangladesh'),('Bhutan'),('India'),('Iran (Islamic Republic of)'),('Maldives'),('Nepal'),('Pakistan'),('Sri Lanka'),('China'),('Democratic People\'s Republic of Korea'),('Japan'),('Mongolia'),('Republic of Korea'),('Brunei Darussalam'),('Cambodia'),('Indonesia'),('Lao People\'s Democratic Republic'),('Malaysia'),('Myanmar'),('Philippines'),('Singapore'),('Thailand'),('Timor-Leste'),('Viet Nam'),('Bermuda'),('Canada'),('Greenland'),('Saint Pierre and Miquelon'),('United States of America'),('Anguilla'),('Antigua and Barbuda'),('Aruba'),('Bahamas'),('Barbados'),('British Virgin Islands'),('Cayman Islands'),('Cuba'),('Curaçao'),('Dominica'),('Dominican Republic'),('Grenada'),('Guadeloupe'),('Haiti'),('Jamaica'),('Martinique'),('Montserrat'),('Puerto Rico'),('Saint Barthélemy'),('Saint Kitts and Nevis'),('Saint Lucia'),('Saint Martin (French Part)'),('Saint Vincent and the Grenadines'),('Sint Maarten (Dutch part)'),('Trinidad and Tobago'),('Turks and Caicos Islands'),('United States Virgin Islands'),('Belize'),('Costa Rica'),('El Salvador'),('Guatemala'),('Honduras'),('Mexico'),('Nicaragua'),('Panama'),('Argentina'),('Bolivia (Plurinational State of)'),('Brazil'),('Chile'),('Colombia'),('Ecuador'),('Falkland Islands (Malvinas)'),('French Guiana'),('Guyana'),('Paraguay'),('Peru'),('Suriname'),('Uruguay'),('Venezuela (Bolivarian Republic of)'),('Algeria'),('Egypt'),('Libya'),('Morocco'),('Sudan'),('Tunisia'),('Armenia'),('Azerbaijan'),('Bahrain'),('Cyprus'),('Georgia'),('Iraq'),('Israel'),('Jordan'),('Kuwait'),('Lebanon'),('Oman'),('Qatar'),('Saudi Arabia'),('State of Palestine'),('Syrian Arab Republic'),('Türkiye'),('United Arab Emirates'),('Yemen'),('Australia'),('New Zealand'),('Fiji'),('New Caledonia'),('Papua New Guinea'),('Solomon Islands'),('Vanuatu'),('Guam'),('Kiribati'),('Marshall Islands'),('Micronesia (Federated States of)'),('Nauru'),('Northern Mariana Islands'),('Palau'),('American Samoa'),('Cook Islands'),('French Polynesia'),('Niue'),('Samoa'),('Tokelau'),('Tonga'),('Tuvalu'),('Wallis and Futuna Islands'),('Burundi'),('Comoros'),('Djibouti'),('Eritrea'),('Ethiopia'),('Kenya'),('Madagascar'),('Malawi'),('Mauritius'),('Mayotte'),('Mozambique'),('Rwanda'),('Réunion'),('Seychelles'),('Somalia'),('South Sudan'),('Uganda'),('United Republic of Tanzania'),('Zambia'),('Zimbabwe'),('Angola'),('Cameroon'),('Central African Republic'),('Chad'),('Congo'),('Democratic Republic of the Congo'),('Equatorial Guinea'),('Gabon'),('Sao Tome and Principe'),('Botswana'),('Eswatini'),('Lesotho'),('Namibia'),('South Africa'),('Benin'),('Burkina Faso'),('Cabo Verde'),('Côte d\'Ivoire'),('Gambia'),('Ghana'),('Guinea'),('Guinea-Bissau'),('Liberia'),('Mali'),('Mauritania'),('Niger'),('Nigeria'),('Saint Helena'),('Senegal'),('Sierra Leone'),('Togo');
/*!40000 ALTER TABLE `country_list` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-21 11:38:49
