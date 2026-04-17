DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS artists;

CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    country VARCHAR(120) NOT NULL,
    birth_date DATE,
    monthly_listeners INTEGER,
    is_active BOOLEAN NOT NULL
);

INSERT INTO artists (name, country, birth_date, monthly_listeners, is_active)
VALUES
    ('Usher', 'USA', '1978-10-14', 32000000, TRUE),
    ('Beyonce', 'USA', '1981-09-04', 55000000, TRUE),
    ('Alicia Keys', 'USA', '1981-01-25', 28000000, TRUE),
    ('Chris Brown', 'USA', '1989-05-05', 40000000, TRUE),
    ('Rihanna', 'Barbados', '1988-02-20', 60000000, TRUE);

CREATE TABLE songs (
    id SERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    artist_name VARCHAR(120) NOT NULL,
    genre VARCHAR(60),
    duration_seconds INTEGER,
    release_date DATE,
    is_explicit BOOLEAN NOT NULL
);

INSERT INTO songs (title, artist_name, genre, duration_seconds, release_date, is_explicit)
VALUES
    ('Yeah!', 'Usher', 'R&B', 250, '2004-01-20', FALSE),
    ('Burn', 'Usher', 'R&B', 234, '2004-05-18', FALSE),
    ('Crazy in Love', 'Beyonce', 'R&B', 236, '2003-05-18', FALSE),
    ('Irreplaceable', 'Beyonce', 'R&B', 229, '2006-10-23', FALSE),
    ('Fallin', 'Alicia Keys', 'R&B', 214, '2001-06-26', FALSE),
    ('No One', 'Alicia Keys', 'R&B', 237, '2007-09-11', FALSE),
    ('Run It!', 'Chris Brown', 'R&B', 208, '2005-08-02', FALSE),
    ('With You', 'Chris Brown', 'R&B', 242, '2007-10-02', FALSE),
    ('Umbrella', 'Rihanna', 'R&B', 275, '2007-03-29', FALSE),
    ('We Found Love', 'Rihanna', 'R&B', 216, '2011-09-22', FALSE);

CREATE TABLE playlists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    owner_name VARCHAR(120) NOT NULL,
    followers_count INTEGER,
    created_date DATE,
    is_public BOOLEAN NOT NULL
);

INSERT INTO playlists (name, description, owner_name, followers_count, created_date, is_public)
VALUES
    ('2000s R&B Hits', 'Best R&B songs from the 2000s', 'mike_r', 25000, '2021-03-15', TRUE),
    ('Late Night R&B', 'Smooth and soulful late night vibes', 'mike_r', 18000, '2020-11-01', TRUE),
    ('R&B Classics', 'Timeless R&B tracks everyone loves', 'john_doe', 9500, '2022-06-10', TRUE),
    ('Workout R&B', 'High energy R&B for the gym', 'jane_doe', 4700, '2023-01-20', FALSE),
    ('Chill R&B', 'Relaxed and melodic R&B songs', 'mike_r', 3100, '2023-08-05', FALSE);