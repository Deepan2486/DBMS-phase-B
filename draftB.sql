CREATE TABLE actor(
	a_id INT UNIQUE PRIMARY KEY,
	name varchar(15)
);


CREATE TABLE production_company(
	pc_id INT UNIQUE PRIMARY KEY,
	name varchar(10),
	address varchar(30)

);


CREATE TABLE movie(

	m_id INT UNIQUE PRIMARY KEY,
	name varchar(10),
	year INT,
	imbd_score numeric(3,2),
	prod_company INT,
	
	CONSTRAINT fk_pid FOREIGN KEY(prod_company) REFERENCES production_company(pc_id)
);


CREATE TABLE casting(
	
	m_id INT,
	a_id INT,
	
	CONSTRAINT fk_mid FOREIGN KEY(m_id) REFERENCES movie(m_id),
	CONSTRAINT fk_aid FOREIGN KEY(a_id) REFERENCES actor(a_id),
	
	PRIMARY KEY (m_id, a_id)
);
