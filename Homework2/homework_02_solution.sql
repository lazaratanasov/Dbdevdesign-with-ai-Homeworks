-- PART 1 — ADD CONSTRAINTS

ALTER TABLE cafeteria_menu_item
    ADD CONSTRAINT pk_cafeteria_menu_item PRIMARY KEY (id);

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN code SET NOT NULL;
ALTER TABLE cafeteria_menu_item
    ADD CONSTRAINT uq_cafeteria_menu_item_code UNIQUE (code);

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN dish_name SET NOT NULL;

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN category SET NOT NULL;

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN spice_level SET NOT NULL;
ALTER TABLE cafeteria_menu_item
    ADD CONSTRAINT chk_spice_level
    CHECK (spice_level BETWEEN 1 AND 5);

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN price_eur SET NOT NULL;
ALTER TABLE cafeteria_menu_item
    ADD CONSTRAINT chk_price_positive
    CHECK (price_eur > 0);

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN added_to_menu SET NOT NULL;

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN last_restocked_at SET DEFAULT NOW();

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN is_late_night SET NOT NULL;
ALTER TABLE cafeteria_menu_item
    ALTER COLUMN is_late_night SET DEFAULT FALSE;

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN remake_count SET NOT NULL;
ALTER TABLE cafeteria_menu_item
    ADD CONSTRAINT chk_remake_count_non_negative
    CHECK (remake_count >= 0);

ALTER TABLE cafeteria_menu_item
    ALTER COLUMN prep_station_code SET NOT NULL;
ALTER TABLE cafeteria_menu_item
    ADD CONSTRAINT chk_prep_station_code_format
    CHECK (prep_station_code ~ '^K-[A-Z]{4}$');

-- PART 1 — FIX BAD DATA

UPDATE cafeteria_menu_item SET dietary_note = NULL WHERE code = 'FD-001';
UPDATE cafeteria_menu_item SET spice_level = 1  WHERE code = 'FD-010';
UPDATE cafeteria_menu_item SET spice_level = 1  WHERE code = 'FD-011';
UPDATE cafeteria_menu_item SET spice_level = 1  WHERE code = 'FD-012';

-- PART 2 — QUERIES

SELECT code, dish_name, spice_level, price_eur
FROM cafeteria_menu_item
WHERE spice_level >= 4
ORDER BY price_eur DESC, dish_name ASC;

SELECT code, dish_name, kitchen_section
FROM cafeteria_menu_item
WHERE kitchen_section ILIKE '%Hollow%'
ORDER BY category, code;

SELECT code, dish_name, remake_count
FROM cafeteria_menu_item
WHERE is_late_night = TRUE AND remake_count > 0
ORDER BY remake_count DESC;

SELECT code, dish_name, price_eur, added_to_menu
FROM cafeteria_menu_item
WHERE price_eur > 5 AND price_eur < 12
ORDER BY added_to_menu ASC;

SELECT code, dish_name, last_restocked_at
FROM cafeteria_menu_item
WHERE last_restocked_at < '2025-01-16 00:00:00+00'
ORDER BY last_restocked_at ASC;

SELECT category, COUNT(*), ROUND(AVG(price_eur), 2)
FROM cafeteria_menu_item
GROUP BY category
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC, category ASC;

SELECT prep_station_code, SUM(remake_count), COUNT(DISTINCT category)
FROM cafeteria_menu_item
GROUP BY prep_station_code
ORDER BY SUM(remake_count) DESC;

SELECT COUNT(*) FROM cafeteria_menu_item;

SELECT ROUND(AVG(spice_level), 2) FROM cafeteria_menu_item;

SELECT SUM(remake_count) FROM cafeteria_menu_item;

SELECT MIN(price_eur), MAX(price_eur) FROM cafeteria_menu_item;

SELECT COUNT(DISTINCT kitchen_section) FROM cafeteria_menu_item;

SELECT COUNT(*) FROM cafeteria_menu_item WHERE is_late_night = TRUE;

SELECT code, dish_name, spice_level, price_eur
FROM cafeteria_menu_item
WHERE spice_level >= 4
ORDER BY price_eur DESC, dish_name ASC
LIMIT 5 OFFSET 5;