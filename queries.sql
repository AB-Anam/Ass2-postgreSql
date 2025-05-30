-- Active: 1748363366254@@127.0.0.1@5432@conservation_db


--problem 1️⃣ 
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

--Problem 2️⃣
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

--Problem 3️⃣

SELECT
    sighting_id,
    species_id,
    ranger_id,
    location,
    sighting_time,
    notes
FROM sightings
WHERE location ILIKE '%Pass%';

--Problem 4️⃣

SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name
ORDER BY r.name;

--Problem 5️⃣

SELECT common_name
FROM species sp
LEFT JOIN sightings si ON sp.species_id = si.species_id
WHERE si.sighting_id IS NULL;

--Problem 6️⃣

SELECT sp.common_name, si.sighting_time, r.name
FROM sightings si
JOIN species sp ON si.species_id = sp.species_id
JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;


--Problem 7️
ALTER TABLE species DROP CONSTRAINT species_conservation_status_check;

ALTER TABLE species ADD CONSTRAINT species_conservation_status_check
CHECK (conservation_status IN (
    'Endangered',
    'Vulnerable',
    'Extinct',
    'Least Concern',
    'Near Threatened',
    'Historic'
));

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

--Problem 8️⃣

SELECT 
    sighting_id,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

--Problem 9️⃣

DELETE FROM rangers
WHERE NOT EXISTS (
    SELECT 1
    FROM sightings
    WHERE sightings.ranger_id = rangers.ranger_id
);

