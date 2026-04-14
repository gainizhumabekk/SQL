CREATE DATABASE university; 
CREATE TABLE address
(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(100) NOT NULL, 
    county VARCHAR(100),
    city VARCHAR (100),
    street VARCHAR (100),
    number INT
);

CREATE TABLE person
(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) DEFAULT 'No last name',
    phonenumber INT, 
    birthdate DATE NOT NULL,
    addressid INT, 
    FOREIGN KEY(addressid) references address (id) ON DELETE CASCADE,
    unique key (phonenumber)
);

CREATE TABLE student
(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    personid INT,
    description VARCHAR(40) NOT NULL,
    FOREIGN KEY(personid) references person(id) ON DELETE CASCADE
);

CREATE TABLE teacher
(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    personid INT,
    position VARCHAR(40) NOT NULL,
    FOREIGN KEY(personid) references person(id) ON DELETE CASCADE
);

CREATE TABLE course
(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40),
    credits INT default 0,
    description VARCHAR(40),
    teacherid INT, 
    FOREIGN KEY(teacherid) references teacher(id) ON DELETE CASCADE
);

INSERT INTO address (country, county, city, street, number) VALUES ('UK','England','London','Bond Street',5);
INSERT INTO address (country, county, city, street, number) VALUES ('UK','Yorkshire','Sheffield','High Street',10);
INSERT INTO address (country, county, city, street, number) VALUES ('USA','Alabama','Birmingham','1st Ave',8);
INSERT INTO address (country, city, street, number) VALUES ('Kazakhstan','Astana','Saraishyk',14);
INSERT INTO address (country, county, city, street, number) VALUES ('Kazakhstan','North Kazakhstan','Pavlodar','Abay',NULL);

ALTER TABLE person MODIFY phonenumber VARCHAR(15);
INSERT INTO person (first_name, last_name, phonenumber, birthdate, addressid) VALUES ('Gaini','Zhumabek',87089880496,'2001-02-15',4);
INSERT INTO person (first_name, last_name, phonenumber, birthdate, addressid) VALUES ('Taylor','Smyth',010254864,'1989-05-17',2);
INSERT INTO person (first_name, phonenumber, birthdate, addressid) VALUES ('William', 010254878,'1997-12-01',1);
INSERT INTO person (first_name, phonenumber, birthdate, addressid) VALUES ('Aliya',87012549661,'2000-03-06',5);
INSERT INTO person (first_name, last_name, phonenumber, birthdate, addressid) VALUES ('Sam','Johnson',012254878,'1996-05-01',3);

INSERT INTO student (personid, description) VALUES (1, 'Mathematics');
INSERT INTO student (personid, description) VALUES (4, 'Sociology');

INSERT INTO teacher (personid, position) VALUES (2, 'Teacher Assistant');
INSERT INTO teacher (personid, position) VALUES (3, 'Lecturer');
INSERT INTO teacher (personid, position) VALUES (2, 'PostDoc');

ALTER TABLE course MODIFY COLUMN credits INT default 5;
INSERT INTO course (name, credits, description, teacherid) VALUES ('MATH101',6,'Introduction to Math', 1);
INSERT INTO course (name, description, teacherid) VALUES ('BIOL101','Introduction to Biology', 2);
INSERT INTO course (name, credits, description, teacherid) VALUES ('MATH323',6,'Statistics', 1);
INSERT INTO course (name, credits, description, teacherid) VALUES ('CHEM102',10,'Organic Chemistry', 2);
INSERT INTO course (name, description, teacherid) VALUES ('PHYS202', 'Mechanics', 3);

SELECT * FROM address;
SELECT * FROM person;
SELECT * FROM student;
SELECT * FROM teacher;
SELECT * FROM course;
