CREATE TABLE employees(
	employee_id INTEGER PRIMARY KEY,
	last_name VARCHAR,
	first_name VARCHAR,
	title VARCHAR,
	reports_to INTEGER,
	birthdate DATE,
	hire_date DATE,
	address VARCHAR,
	city VARCHAR,
	state VARCHAR,
	country VARCHAR,
	postal_code VARCHAR,
	phone VARCHAR,
	fax VARCHAR,
	email VARCHAR,

	CONSTRAINT fk_reports_to FOREIGN KEY (reports_to)
	REFERENCES employees (employee_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)

CREATE TABLE customers (
	customer_id INTEGER PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR,
	company VARCHAR,
	address VARCHAR,
	city VARCHAR,
	state VARCHAR,
	country VARCHAR,
	postal_code VARCHAR,
	phone VARCHAR,
	fax VARCHAR,
	email VARCHAR,
	support_rep_id INTEGER,

	CONSTRAINT fk_support_rep_id FOREIGN KEY (support_rep_id)
	REFERENCES employees (employee_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)

CREATE TABLE invoices (
	invoice_id INTEGER PRIMARY KEY,
	customer_id INTEGER,
	invoice_date DATE,
	billing_address VARCHAR,
	billing_city VARCHAR,
	billing_state VARCHAR,
	billing_country VARCHAR,
	billing_postal_code VARCHAR,
	total INTEGER,

	CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
	REFERENCES customers (customer_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
CREATE TABLE artists (
	artist_id INTEGER PRIMARY KEY,
	name VARCHAR
)

CREATE TABLE albums (
	album_id INTEGER PRIMARY KEY,
	title VARCHAR,
	artist_id INTEGER,

	CONSTRAINT fk_artist_id FOREIGN KEY (artist_id)
	REFERENCES artists (artist_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)

CREATE TABLE media_types(
	media_type_id INTEGER PRIMARY KEY,
	name VARCHAR
)

CREATE TABLE genres(
	genre_id INTEGER PRIMARY KEY,
	name VARCHAR
)

CREATE TABLE tracks(
	track_id INTEGER PRIMARY KEY,
	name VARCHAR,
	album_id INTEGER,
	media_type_id INTEGER,
	genre_id INTEGER,
	composer VARCHAR,
	milliseconds INTEGER,
	bytes INTEGER,
	unit_price NUMERIC,

	CONSTRAINT fk_album_id FOREIGN KEY (album_id)
	REFERENCES albums (album_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT fk_media_type_id FOREIGN KEY (media_type_id)
	REFERENCES media_types (media_type_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE,
	CONSTRAINT fk_genre_id FOREIGN KEY (genre_id)
	REFERENCES genres (genre_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)



CREATE TABLE invoice_lines (
	invoice_line_id INTEGER PRIMARY KEY,
	invoice_id INTEGER,
	track_id INTEGER,
	unit_price NUMERIC,
	quantity INTEGER,

	CONSTRAINT fk_invoice_id FOREIGN KEY (invoice_id)
	REFERENCES invoices (invoice_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT fk_track_id FOREIGN KEY (track_id)
	REFERENCES tracks (track_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)

CREATE TABLE playlists(
	playlist_id INTEGER PRIMARY KEY,
	name VARCHAR
)

CREATE TABLE playlist_tracks (
	playlist_id INTEGER,
	track_id INTEGER,

	CONSTRAINT fk_playlist_id FOREIGN KEY (playlist_id)
	REFERENCES playlists (playlist_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT fk_track_id FOREIGN KEY (track_id)
	REFERENCES tracks (track_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)