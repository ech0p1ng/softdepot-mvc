--администратор
CREATE TABLE administrator(
	id SERIAL PRIMARY KEY,
	email varchar(50) UNIQUE NOT NULL,
	password varchar(50) NOT NULL,
	administrator_name varchar(50) NOT NULL
);

--покупатель
CREATE TABLE customer(
	id SERIAL PRIMARY KEY,
	customer_name varchar(50) NOT NULL,
	email varchar(50) UNIQUE NOT NULL,
	password varchar(50) NOT NULL,
	profile_img_url varchar(100),
	balance numeric(10,2) CHECK (balance >= 0)
);

--разработчик
CREATE TABLE developer(
	id SERIAL PRIMARY KEY,
	email varchar(50) UNIQUE NOT NULL,
	developer_name varchar(50) NOT NULL,
	password varchar(50) NOT NULL,
	profile_img_url varchar(100)
);

--ключевое слово
CREATE TABLE tag(
	id SERIAL PRIMARY KEY,
	tag_name varchar(50) NOT NULL UNIQUE
);

--программа
CREATE TABLE program(
	id SERIAL PRIMARY KEY,
	developer_id int NOT NULL REFERENCES developer(id),
	program_name varchar(50) NOT NULL,
	price numeric(10,2) CHECK (price >= 0),
	description varchar(50) NOT NULL,
	logo_url varchar(100) NOT NULL,
	installer_windows_url varchar(100),
	installer_linux_url varchar(100),
	installer_macos_url varchar(100),
	screenshots_url varchar(100)[]
);

--степень принадлежности к ключевому слову
CREATE TABLE degree_of_belonging(
	id SERIAL PRIMARY KEY,
	program_id int NOT NULL REFERENCES program(id) ON DELETE CASCADE,
	tag_id int NOT NULL REFERENCES tag(id) ON DELETE CASCADE,
	degree_value int NOT NULL CHECK (degree_value >= 0 AND degree_value <= 10)
);

--покупка
CREATE TABLE purchase(
	id SERIAL PRIMARY KEY,
	purchase_date_time timestamp NOT NULL,
	customer_id int NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
	program_id int NOT NULL REFERENCES program(id)
);

--ежедневная статистика
CREATE TABLE daily_stats(
	id SERIAL PRIMARY KEY,
	stats_date timestamp NOT NULL,
	program_id int NOT NULL REFERENCES program(id) ON DELETE CASCADE,
	avg_estimation FLOAT NOT NULL CHECK (avg_estimation >=0 AND avg_estimation <= 5),
	earnings numeric(10,2) CHECK (earnings >= 0),
	purchases_amount int NOT NULL,
	reviews_amount int NOT NULL
	
);

--отзыв
CREATE TABLE review(
	id SERIAL PRIMARY KEY,
	customer_id int NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
	program_id int NOT NULL REFERENCES program(id) ON DELETE CASCADE,
	estimation int NOT NULL CHECK (estimation >=0 AND estimation <= 5),
	date_time timestamp NOT NULL,
	review_text TEXT NOT NULL
);

--роли
CREATE ROLE administrator_role WITH LOGIN PASSWORD '9QrlLHkwMJah3hNoMRlW' SUPERUSER;
CREATE ROLE customer_role WITH LOGIN PASSWORD 'at7DcsAixTk4Eqs7zdp3' NOCREATEDB NOCREATEROLE NOBYPASSRLS;
CREATE ROLE developer_role WITH LOGIN PASSWORD '32BItzvBNem4vEaXxjBb'NOCREATEDB NOCREATEROLE NOBYPASSRLS;
CREATE ROLE unregistered_role WITH LOGIN PASSWORD 'WqQMglB97jPxKw7TCiFc'NOCREATEDB NOCREATEROLE NOBYPASSRLS;

--покупатель
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE purchase TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE customer TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE review TO customer_role;
GRANT SELECT ON TABLE administrator TO customer_role;
GRANT SELECT ON TABLE developer TO customer_role;
GRANT SELECT ON TABLE program TO customer_role;
GRANT USAGE, SELECT ON SEQUENCE customer_id_seq TO customer_role;

--разработчик
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE degree_of_belonging TO developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE developer TO developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE program TO developer_role;
GRANT SELECT ON TABLE administrator TO developer_role;
GRANT SELECT ON TABLE daily_stats TO developer_role;
GRANT SELECT ON TABLE customer TO developer_role;
GRANT SELECT ON TABLE review TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE developer_id_seq TO developer_role;

--неавторизованный пользователь
GRANT SELECT ON TABLE administrator TO unregistered_role;
GRANT SELECT ON TABLE customer TO unregistered_role;
GRANT SELECT ON TABLE review TO unregistered_role;
GRANT SELECT ON TABLE developer TO unregistered_role;
GRANT SELECT ON TABLE program TO unregistered_role;






