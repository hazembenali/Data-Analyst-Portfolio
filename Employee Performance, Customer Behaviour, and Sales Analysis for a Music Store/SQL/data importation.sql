COPY artists (artist_id, name)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\artist.csv'
CSV
HEADER
DELIMITER ','

COPY albums (album_id, title, artist_id)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\album.csv'
CSV
HEADER
DELIMITER ','

COPY playlists (playlist_id, name)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\playlist.csv'
CSV
HEADER
DELIMITER ','

COPY genres(genre_id, name)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\genre.csv'
CSV
HEADER
DELIMITER ','

COPY media_types(media_type_id, name)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\media_type.csv'
CSV
HEADER
DELIMITER ','

COPY tracks (track_id,name,album_id,media_type_id,genre_id,composer,milliseconds,bytes,unit_price)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\track.csv'
CSV
HEADER
DELIMITER ','

COPY playlist_tracks (playlist_id, track_id)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\playlist_track.csv'
CSV
HEADER
DELIMITER ','


COPY employees (employee_id,last_name,first_name,title,reports_to,levels,birthdate,hire_date,address,city,state,country,postal_code,phone,fax,email)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\employee.csv'
CSV
HEADER
DELIMITER ','

COPY customers (customer_id,first_name,last_name,company,address,city,state,country,postal_code,phone,fax,email,support_rep_id)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\customer.csv'
CSV
HEADER
DELIMITER ','


COPY invoices (invoice_id,customer_id,invoice_date,billing_address,billing_city,billing_state,billing_country,billing_postal_code,total)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\invoice.csv'
CSV
HEADER
DELIMITER ','

COPY invoice_lines(invoice_line_id,invoice_id,track_id,unit_price,quantity)
FROM 'C:\Users\Hazem Ben Ali\Desktop\studying\projects\Music Store\Data\music store data\invoice_line.csv'
CSV
HEADER
DELIMITER ','

