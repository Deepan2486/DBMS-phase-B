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


--RANDOM STRING GENERATOR FUNCTION
Create or replace function random_string(length integer) 
returns text 
language plpgsql 
as $$
declare
  chars text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
begin
  if length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$;


--FILLING THE ACTOR TABLE
CREATE OR REPLACE PROCEDURE fill_actor_table()
language plpgsql
as $$
declare
	counter INT :=0;
	str varchar(15);
begin
	
	WHILE counter<300000 LOOP
	
		str := random_string(15);
		
		INSERT INTO actor(a_id, name)
		VALUES (counter+1, str);
		
		str:='';
		
		counter:=counter+1;
	
	END LOOP;
	
end;
$$;

CALL fill_actor_table();



CREATE OR REPLACE PROCEDURE fill_productioncompany_table()
language plpgsql
as $$
declare
	counter INT :=0;
	str1 varchar(10);
	str2 varchar(30);
begin
	
	WHILE counter<80000 LOOP
	
		str1 := random_string(10);
		str2 := random_string(30);
		
		INSERT INTO production_company(pc_id, name, address)
		VALUES (counter+1, str1, str2);
		
		str1:='';
		str2:='';
		
		counter:=counter+1;
	
	END LOOP;
	
end;
$$;

CALL fill_productioncompany_table();


--STILL Unfinished

CREATE OR REPLACE PROCEDURE fill_movie_table()
language plpgsql
as $$
declare
	counter INT :=0;
	str varchar(10);
	year INT;
	imdb numeric(3,2);
	rec RECORD;
	rec1 RECORD;
begin

	WHILE counter<1000000 LOOP
	
		str := random_string(10);
		year:= floor(random()*(2000-1900+1))+1900;
		imdb := random()*(5-1)+1;
		
		INSERT INTO movie(m_id, name, year, imbd_score)
		VALUES (counter+1, str, year, imdb);
		
		str:='';
		
		counter:=counter+1;
	
	END LOOP;
	
	
	counter:=0;
	
	FOR rec in (select * from movie order by random()) LOOP
		if (counter>=100000) then
			EXIT;
		end if;
		
		UPDATE movie SET prod_company= floor(random()*(80000-501+1))+501 WHERE rec.m_id=m_id;
		
		counter:=counter+1;
	END LOOP;
	
	
	FOR rec1 in (select * from movie) LOOP
		if (rec1.prod_company IS NULL) then
			UPDATE movie SET prod_company= floor(random()*(500-1+1))+1 WHERE rec1.m_id=m_id;
		end if;
	END LOOP;
	
	
end;
$$;


CALL fill_movie_table();

delete from casting;


CREATE OR REPLACE PROCEDURE fill_casting_table()
language plpgsql
as $$
declare
	counter INT:=0;
	rec RECORD;
	random_actor INT;
	actor_count INT :=0;
	
begin
	
	WHILE counter<1000000 LOOP
		
		if (actor_count>= (4*950000)) then
			
			--fill actors with 10000<id<300000
			FOR rec in () LOOP
				
				random_actor := rec.a_id;
				
				INSERT into casting(m_id, a_id) VALUES (counter+1, random_actor);
				actor_count :=actor_count+1;
			END LOOP;
	
		else
			FOR rec in (select * from actor where a_id<10000 order by random() limit 4) LOOP
				
				random_actor := rec.a_id;
				
				INSERT into casting(m_id, a_id) VALUES (counter+1, random_actor);
				actor_count:=actor_count+1;
			END LOOP;
		end if;
	
		counter:=counter+1;
	END LOOP;
end;
$$;

CALL fill_casting_table();
