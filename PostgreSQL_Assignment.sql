-- Active: 1748363366254@@127.0.0.1@5432@conservation_db


CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50)
        CHECK (conservation_status IN (
            'Endangered',
            'Vulnerable',
            'Extinct',
            'Least Concern',
            'Near Threatened'
        ))
);


CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(50) NOT NULL,
    sighting_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



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

