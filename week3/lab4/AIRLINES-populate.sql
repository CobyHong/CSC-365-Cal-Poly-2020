-- Airlines
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (1, 'United Airlines', 'UAL', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (2, 'US Airways', 'USAir', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (3, 'Delta Airlines', 'Delta', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (4, 'Southwest Airlines', 'Southwest', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (5, 'American Airlines', 'American', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (6, 'Northwest Airlines', 'Northwest', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (7, 'Continental Airlines', 'Continental', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (8, 'JetBlue Airways', 'JetBlue', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (9, 'Frontier Airlines', 'Frontier', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (10, 'AirTran Airways', 'AirTran', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (11, 'Allegiant Air', 'Allegiant', 'USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (12, 'Virgin America', 'Virgin', 'USA');

-- Airports
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Aberdeen', 'APG', 'Phillips AAF', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Aberdeen', 'ABR', 'Municipal', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Abilene', 'DYS', 'Dyess AFB', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Abilene', 'ABI', 'Municipal', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Abingdon', 'VJI', 'Virginia Highlands', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Ada', 'ADT', 'Ada', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Adak Island', 'ADK', 'Adak Island Ns', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Adrian', 'ADG', 'Lenawee County', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Afton', 'AFO', 'Municipal', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Alken', 'AIK', 'Municipal', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Ainsworth', 'ANW', 'Ainsworth', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Akhlok', 'AKK', 'Akhlok SPB', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Aklachak', 'KKI', 'Spb', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Aklak', 'AKI', 'Aklak', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Akron CO', 'AKO', 'Colorado Plains Regional Airport', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Akron/Canton OH', 'CAK', 'Akron/canton Regional', 'United States', 'US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev) VALUES ('Akron/Canton', 'AKC', 'Fulton International', 'United States', 'US');

-- flights
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 28, 'APG', 'ABR');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 29, 'AIK', 'ADT');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 44, 'AKO', 'AKI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 45, 'CAK', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 54, 'AFO', 'AKO');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (3, 2, 'AIK', 'ADT');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (3, 3, 'DYS', 'ABI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (3, 26, 'AKK', 'VJI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1260, 'AKO', 'AKC');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1261, 'APG', 'ABR');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1286, 'ABR', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1287, 'DYS', 'ANW');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (10, 6, 'KKI', 'AKC');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (10, 7, 'VJI', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (10, 54, 'ADT', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 4, 'AIK', 'AKO');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 5, 'CAK', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 28, 'AKO', 'ABI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 29, 'ABR', 'ABI');