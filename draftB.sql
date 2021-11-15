CREATE TABLE actor(
	a_id INT UNIQUE PRIMARY KEY,
	name varchar(15)
);

CREATE TABLE production_company(
	pc_id INT UNIQUE,
	name varchar(10),
	address varchar(30)

);
