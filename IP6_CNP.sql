#Specifying which table I want to use
USE crime_data;

#Query 1
SELECT DISTINCT(crime_type) AS unique_crime 
	FROM incident_reports;
    
#Query 2
SELECT COUNT(incident_number) AS num_crimes
	FROM incident_reports
    GROUP BY crime_type
    ORDER BY crime_type ASC;
    
#Query 3
SELECT COUNT(incident_number) AS num_of_crimes
	FROM incident_reports
    WHERE TIMESTAMPDIFF(day, date_reported, date_occured) = 0;
    
#Query 4
SELECT date_occured, date_reported, crime_type, TIMESTAMPDIFF(year, date_reported, date_occured) AS time_difference
	FROM incident_reports
    WHERE TIMESTAMPDIFF(year, date_reported, date_occured) >= 1
    ORDER BY TIMESTAMPDIFF(year, date_reported, date_occured) DESC;
    
#Query 5
SELECT YEAR(date_occured) AS year, COUNT(incident_number) AS num_incidents
	FROM incident_reports
    GROUP BY YEAR(date_occured)
    ORDER BY YEAR(date_occured) DESC;
    
#Query 6
SELECT *
	FROM incident_reports
    WHERE crime_type = "ROBBERY";
    
#Query 7
SELECT lmpd_division, incident_number, date_occured
	FROM incident_reports
	WHERE att_comp = "ATTEMPTED"
    ORDER BY lmpd_division ASC, date_occured ASC;
    
#Query 8
SELECT date_occured, crime_type
	FROM incident_reports
    WHERE zip_code = "40202"
    ORDER BY crime_type, date_occured;
    
#Query 9 Query
SELECT zip_code, COUNT(incident_number) AS num_thefts
	FROM incident_reports
    WHERE crime_type LIKE "MOTOR VEHICLE THEFT" OR crime_type LIKE "VEHICLE BREAK-IN/THEFT"
    GROUP BY zip_code
    ORDER BY COUNT(incident_number) DESC;
    
SELECT COUNT(zip_code)
	FROM(SELECT zip_code, COUNT(incident_number) AS num_thefts
			FROM incident_reports
			WHERE crime_type LIKE "MOTOR VEHICLE THEFT" OR crime_type LIKE "VEHICLE BREAK-IN/THEFT"
			GROUP BY zip_code
			ORDER BY COUNT(incident_number) DESC) AS q9;
    
    #This query returned 49 different values. The zipcode with the highest number of thefts was 40214.
    
#Query 10
SELECT COUNT(DISTINCT(city)) AS city_count
	FROM incident_reports;
    
#Query 11
SELECT city, COUNT(incident_number) AS incident_count
	FROM incident_reports
    WHERE city != "LOUISVILLE"
    GROUP BY city
    ORDER BY COUNT(incident_number) DESC
    LIMIT 1;
    
#In this database, the second highest city behind Louisville is Lvil, which is also Louisville and seems
#to be an abbreviation that is commonly used.

#Query 12
SELECT uor_desc, crime_type
	FROM incident_reports
    WHERE crime_type != "OTHER"
    ORDER BY uor_desc, crime_type;
    
#For this database, the crime type seems to be a general type of offense or category
#while the uor description seems to be the specific offense
    
#Query 13
SELECT COUNT(DISTINCT(lmpd_beat)) as beat_count
	FROM incident_reports;
    
#Query 14
SELECT COUNT(DISTINCT(offense_code)) as nibrs_count
	FROM nibrs_codes;

#Query 15
SELECT COUNT(DISTINCT(nibrs_code)) as nibrs_count
	FROM incident_reports;
    
#Query 16
SELECT date_occured, block_address, zip_code, nibrs_codes.offense_description
	FROM incident_reports, nibrs_codes
    WHERE incident_reports.nibrs_code = nibrs_codes.offense_code AND incident_reports.nibrs_code IN ("240", "250", "270", "280")
    ORDER BY block_address;
    
#Query 17
SELECT zip_code, nibrs_codes.offense_against
	FROM incident_reports, nibrs_codes
    WHERE incident_reports.nibrs_code = nibrs_codes.offense_code AND (LENGTH(incident_reports.zip_code) = 5 AND (nibrs_codes.offense_against != '999'))
    ORDER BY zip_code;
    
#Query 19
SELECT nibrs_codes.offense_against, COUNT(incident_number) AS num_of_offenses
	FROM incident_reports, nibrs_codes
    WHERE incident_reports.nibrs_code = nibrs_codes.offense_code AND (nibrs_codes.offense_against != '' AND nibrs_codes.offense_against IS NOT NULL)
    GROUP BY nibrs_codes.offense_against
    ORDER BY nibrs_codes.offense_against, COUNT(incident_number);
#Query 91 - 1
SELECT crime_type, nibrs_codes.offense_against, premise_type, COUNT(incident_number) AS count_incidents
	FROM incident_reports, nibrs_codes
    WHERE incident_reports.nibrs_code = nibrs_codes.offense_code AND (nibrs_codes.offense_against != '' AND nibrs_codes.offense_against IS NOT NULL) AND (premise_type != '' AND premise_type IS NOT NULL)
    GROUP BY crime_type, nibrs_codes.offense_against, premise_type
    HAVING COUNT(incident_number) > 1000
    ORDER BY crime_type, nibrs_codes.offense_against, COUNT(incident_number) DESC;

#Query 19 - 2
SELECT crime_type, nibrs_codes.offense_against, premise_type, COUNT(incident_number) AS count_incidents
	FROM incident_reports, nibrs_codes
    WHERE incident_reports.nibrs_code = nibrs_codes.offense_code AND (nibrs_codes.offense_against != '' AND nibrs_codes.offense_against IS NOT NULL) AND (premise_type != '' AND premise_type IS NOT NULL)
    GROUP BY crime_type, nibrs_codes.offense_against, premise_type
    HAVING COUNT(incident_number) > 1000
    ORDER BY COUNT(incident_number) DESC;
    
#Query 20
SELECT crime_type, nibrs_codes.offense_category, COUNT(incident_number) AS count_incidents
	FROM incident_reports, nibrs_codes
    WHERE incident_reports.nibrs_code = nibrs_codes.offense_code AND zip_code = '40202' AND (nibrs_codes.offense_against != '' AND nibrs_codes.offense_against IS NOT NULL)
    GROUP BY crime_type, nibrs_codes.offense_category
    ORDER BY COUNT(incident_number) DESC;
    