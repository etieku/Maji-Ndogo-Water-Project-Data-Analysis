USE 
	md_water_services;

-- SET SQL_SAFE_UPDATES = 0;
#------------------------------------------------------------------------------------------------
# Displaying the list of all the tables in the database.
#------------------------------------------------------------------------------------------------
SHOW 
	TABLES; # The tables were named pretty well because we can kind of figure out what each table is about without having to think too hard.
#------------------------------------------------------------------------------------------------
# Looking at the location table
#------------------------------------------------------------------------------------------------
SELECT
	*
FROM 		  # this table has information on a specific location, with an address, the province and town the location is in, and if it's
	location  # in a city (Urban) or not.
LIMIT 5;
#------------------------------------------------------------------------------------------------
# Looking at the visits table
#------------------------------------------------------------------------------------------------
SELECT
	* 	# the table shows a list of location_id, source_id, record_id, and a date and time, so someone (assigned_employee_id) visited some 
FROM    # location (location_id) at some time (time_of_record ) and found a 'source' there (source_id).
	visits
LIMIT 5;
#------------------------------------------------------------------------------------------------
# Looking at the water_source table to see what a 'source' is
#------------------------------------------------------------------------------------------------
SELECT
	*
FROM
	water_source;
#------------------------------------------------------------------------------------------------
# Querying the data_dictionary table to get an explanation of each column
#------------------------------------------------------------------------------------------------
SELECT 
	*
FROM 
	data_dictionary;
#------------------------------------------------------------------------------------------------
# Finding all the unique types of water sources.
#------------------------------------------------------------------------------------------------
SELECT 
	DISTINCT(type_of_water_source)
FROM 
	water_source;
#------------------------------------------------------------------------------------------------
# A query that retrieves all records from the visits table where the time_in_queue is more than some crazy time, say 500 min.
#------------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 			# 500+ minutes seems a long time to queue for water. This will be investigated further
	visits
WHERE 
	time_in_queue > 500;
#------------------------------------------------------------------------------------------------
# Some water sources that take long to queue (>500).
#------------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 
	water_source
WHERE 
	source_id IN ('AkRu05234224','HaZa21742224');
#------------------------------------------------------------------------------------------------
# Assessing the quality of water sources
#------------------------------------------------------------------------------------------------
SELECT 
	*
FROM 
	water_quality;
#------------------------------------------------------------------------------------------------  
# Finding records where the 'subject_quality_score' is 10, only looking for home taps, and where the source was visited a second time
#------------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 
	water_quality
WHERE 
	subjective_quality_score = 10 AND visit_count = 2;
#------------------------------------------------------------------------------------------------
# Investigating pollution issues
#------------------------------------------------------------------------------------------------
SELECT 
	* 		
FROM 
	well_pollution;
#------------------------------------------------------------------------------------------------
# Checking if the results is 'Clean' but the biological column is > 0.01
#------------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 
	well_pollution
WHERE 
	results = 'clean' AND biological > 0.01;
#------------------------------------------------------------------------------------------------
# Records that have the word Clean mistakenly labelled in the description
#------------------------------------------------------------------------------------------------ 
SELECT * 
FROM well_pollution
WHERE description LIKE 'Clean%' AND biological > 0.01; 

-- removing(fixing) clean from the descriptions mistankenly labelled clean
-- case 1a: Clean Bacteria: Giardia Lamblia was changed Bacteria: Giardia Lamblia
UPDATE md_water_services.well_pollution 
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

-- case 1b: Clean Bacteria: E. coli is updated to Bacteria: E. coli
UPDATE md_water_services.well_pollution 
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

-- case 2: updating the results column from Clean to Contaminated: Biological where the biological column has a value greater than 0.01.
UPDATE md_water_services.well_pollution 
SET results = 'Contaminated: Biological'
WHERE biological > 0.01;