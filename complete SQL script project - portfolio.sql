--complete SQL script project:

--Project 1
--creating a company database 

--Project 2
--cleaning and improving readability 

--Project 3
--querying created database

------------------------------------------

--Project 1
--creating a company database  

--EmployeeDemographics table
DROP TABLE IF EXISTS EmployeeDemographics
CREATE TABLE EmployeeDemographics (
  emp_id INT PRIMARY KEY,
  first_name NVARCHAR(40),
  last_name NVARCHAR(40),
  birth_day DATE,
  sex NVARCHAR(1),
  age INT,
  education NVARCHAR (40),
  no_of_trainings INT,
  length_of_service INT,
  previous_year_rating INT
);

SELECT*
FROM EmployeeDemographics

--EmployeeSalary table
DROP TABLE IF EXISTS EmployeeSalary
CREATE TABLE EmployeeSalary (
emp_id INT PRIMARY KEY,
job_title NVARCHAR(40),
salary INT,
super_id INT,
branch_id INT
);

SELECT*
FROM EmployeeSalary

--Branch table
DROP TABLE IF EXISTS Branch
CREATE TABLE Branch (
  branch_id INT PRIMARY KEY,
  branch_name NVARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES EmployeeSalary(emp_id) ON DELETE SET NULL
);

SELECT *
FROM Branch

--Altering EmployeeSalary foreign keys
ALTER TABLE EmployeeSalary
ADD FOREIGN KEY(branch_id)
REFERENCES Branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE EmployeeSalary
ADD FOREIGN KEY(super_id)
REFERENCES EmployeeDemographics(emp_id)
ON DELETE SET NULL;

--Client table
DROP TABLE IF EXISTS Client
CREATE TABLE Client (
  client_id INT PRIMARY KEY,
  name NVARCHAR(40),
  branch_id INT,
  domain NVARCHAR (60),
  year_founded INT,
  industry NVARCHAR(60),
  country NVARCHAR (40),
  locality NVARCHAR (100),
  current_employee_estimate INT,
  FOREIGN KEY(branch_id) REFERENCES Branch(branch_id) ON DELETE SET NULL
);

SELECT*
FROM Client

--EmployeeToClient
DROP TABLE IF EXISTS EmployeeToClient
CREATE TABLE EmployeeToClient (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES EmployeeDemographics(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

--Inserting data
--into EmployeeDemographics
INSERT INTO EmployeeDemographics VALUES
(1, 'Peter', 'Carter', '1967-11-17', 'M', 54, 'Masters & above', 1,  16, 5),
(2, 'Rachel', 'Stone', '1989-01-17', 'F', 31, 'Bachelors', 2,  3, 4),
(3, 'Melvyn', 'Hunt', '1961-05-11', 'M', 59, 'Bachelors', 1, 5, 3),
(4, 'Angela', 'Martin', '1971-06-25', 'F', 49, 'Masters & above', 2, 8, 2),
(5, 'Lucie', 'Grant', '1998-02-05', 'F', 22, 'Bachelors', 3, 1, 4),
(6, 'David', 'Green', '1976-02-19', 'M', 44, 'Masters & above', 1, 5, 5),
(7, 'Gary', 'Higgs', '1991-03-21', 'M', 29, 'Bachelors', 2, 2, 4),
(8, 'Nigel', 'Stevenson', '1979-04-22', 'M', 41, 'Bachelors', 1, 10, 5),
(9, 'Julie', 'Grimshaw', '1990-05-28', 'F', 30, 'Masters & above', 2, 3, 3),
(10, 'Tom', 'Simmonds', '1977-05-01', 'M', 43, 'Bachelors', 2, 12, 5);


--Inserting data
--into EmployeeSalary

--branch 1
INSERT INTO EmployeeSalary VALUES
(1, 'Manager', 65000, NULL, NULL);

INSERT INTO Branch VALUES
(1, 'London_inner', 1, '2006-02-09');

UPDATE EmployeeSalary
SET branch_id = 1
WHERE emp_id = 1;

INSERT INTO EmployeeSalary VALUES
(2, 'Salesman', 46000, 1, 1),
(3, 'Salesman', 45000, 1, 1),
(4, 'Accountant', 42000, 1, 1);

--branch 2
INSERT INTO EmployeeSalary VALUES
(5, 'Accountant', 40000, NULL, NULL);

INSERT INTO Branch VALUES (2, 'London_outer', NULL, '1992-04-06'); 

UPDATE EmployeeSalary
SET branch_id = 2
WHERE emp_id = 5;

--branch 3
INSERT INTO EmployeeSalary VALUES
(6, 'Manager',  62000, NULL, 2),
(7, 'Salesman', 45000, NULL, 2);

UPDATE EmployeeSalary
SET super_id = 6
WHERE emp_id = 5;

UPDATE EmployeeSalary
SET super_id = 6
WHERE emp_id = 7;

-- branch 3
INSERT INTO EmployeeSalary VALUES
(8, 'Supplier Relations', 45000, NULL, NULL);

INSERT INTO Branch VALUES(3, 'Manchester', NULL, '1998-02-13');

UPDATE EmployeeSalary
SET branch_id = 3
WHERE emp_id = 8;

INSERT INTO EmployeeSalary VALUES
(9, 'Salesman', 48000, NULL, 3),
(10, 'Manager', 65000, NULL, 3);

UPDATE EmployeeSalary
SET super_id = 10
WHERE emp_id = 8;

UPDATE EmployeeSalary
SET super_id = 10
WHERE emp_id = 9;

select * from Branch

--updating Branch table
UPDATE Branch
SET mgr_id = 6
WHERE branch_id = 2;

UPDATE Branch
SET mgr_id = 10
WHERE branch_id = 3;

--noticed wrong values in Branch 'mgr_start_date'
ALTER TABLE Branch DROP COLUMN mgr_start_date;

ALTER TABLE Branch ADD mgr_start_date DATE;

UPDATE Branch
SET mgr_start_date = '1990-02-09'
WHERE branch_id = 1;

UPDATE Branch
SET mgr_start_date = '1998-04-06'
WHERE branch_id = 2;

UPDATE Branch
SET mgr_start_date = '1992-02-13'
WHERE branch_id = 3;
-- Branch table 'mgr_start_date' fixed

--Inserting data
--into Client
INSERT INTO Client VALUES
(400, 'lloyds banking group', 2, NULL, 'financial services', 'london, greater london, united kingdom'),
(401, 'vodafone', 1, 1982, 'telecommunications', 'berks, west berkshire, united kingdom'),
(402, 'hays', 1, 1867, 'staffing and recruiting', 'london, greater london, united kingdom'),
(403, 'marks and spencer', 3, 1884, 'retail', 'london, london, united kingdom'),
(404, 'dyson', 3, 1993, 'electrical/electronic manufacturing', 'malmesbury, wiltshire, united kingdom'),
(405, 'metropolitan police', 2, 1829, 'law enforcement', 'london, greater london, united kingdom');

-- into EmployeeToClient
INSERT INTO EmployeeToClient VALUES
(1, 400, 55000),
(2, 401, 267000),
(8, 402, 22500),
(3, 403, 5000),
(8, 403, 12000),
(5, 404, 33000),
(6, 405, 26000),
(2, 405, 15000),
(10, 405, 130000);

--creation of company database is finished

--list all tables
SELECT *
FROM information_schema.tables;

-- 5 tables
SELECT * 
FROM EmployeeDemographics;
SELECT * 
FROM EmployeeSalary;
SELECT * 
FROM Branch
SELECT * 
FROM Client
SELECT * 
FROM EmployeeToClient

------------------------------------------
--Project 2
-- improving readability
-- 'locality' in the Client table would be more readable if seperated into city, district, country

--using parsename -- works only with '.' 
--neccessary to change ',' to '.'
SELECT
PARSENAME(REPLACE(locality,',', '.'), 3) -- 123 order would seperate the address backwards so 321 needed to get the right order
,PARSENAME(REPLACE(locality,',', '.'), 2)
,PARSENAME(REPLACE(locality,',', '.'), 1)
FROM Client;

ALTER TABLE Client
Add City NVARCHAR(60);

Update Client
SET City = PARSENAME(REPLACE(locality,',', '.'), 3)


ALTER TABLE Client
Add District NVARCHAR(60);

Update Client
SET District = PARSENAME(REPLACE(locality,',', '.'), 2)


ALTER TABLE Client
Add Country NVARCHAR(60);

Update Client
SET Country = PARSENAME(REPLACE(locality,',', '.'), 1)

SELECT *
FROM Client

--adding seniority levels column to EmployeeDemographics 
ALTER TABLE EmployeeDemographics
ADD seniority_levels NVARCHAR(40);

UPDATE EmployeeDemographics
SET seniority_levels = (CASE 
WHEN length_of_service <= 3 THEN 'Entry-level'
WHEN length_of_service BETWEEN 3 AND 12 THEN 'Mid-level'
WHEN length_of_service >= 12 THEN 'Senior-level'
END);

SELECT *
FROM EmployeeDemographics;

------------------------------------------
-- Project 3 
-- querying company database 

--getting birt_day from EmployeeDemographics in a desired format 'dd/mm/yyyy'
SELECT birth_day, CONVERT(NVARCHAR, birth_day, 103)
FROM EmployeeDemographics;

-- Find all employees ordered by salary
SELECT dem.emp_id, first_name, last_name, salary
FROM EmployeeSalary sal
JOIN EmployeeDemographics dem
ON sal.emp_id = dem.emp_id
ORDER BY Salary DESC;

-- Find the average of all employee's salaries
SELECT AVG(salary) AS avg_salary
FROM EmployeeSalary;

-- Find out how many males and females there are
SELECT DISTINCT sex, COUNT(sex)
FROM EmployeeDemographics
GROUP BY sex;

-- Find the total sales of each salesman
SELECT SUM(total_sales) AS total_sales, emp_id
FROM EmployeeToClient
GROUP BY emp_id
ORDER BY total_sales DESC;

-- Find the total amount of money spent by each client
SELECT SUM(total_sales) AS total_sales, client_id
FROM EmployeeToClient
GROUP BY client_id
ORDER BY total_sales DESC;

-- Find any bank clients
SELECT *
FROM Client
WHERE name LIKE '%bank%';

--creating STORED PROCEDURE
CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #Temp_Employee_2
(JobTitle nvarchar(50), EmployeesPerJob int, 
AvgAge int, AvgSalary int);

INSERT INTO #Temp_Employee_2
SELECT job_title, COUNT(job_title), AVG(age), AVG(salary)
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.emp_id=sal.emp_id
GROUP BY job_title;

SELECT *
FROM #Temp_Employee_2;

--executing it
EXEC Temp_Employee;

--modifying stored procedure 
--adding '@JobTitle nvarchar(100)' to alter procedure and 'WHERE job_title = @JobTitle'
--including the parameter of JobTitle
EXEC Temp_Employee @JobTitle = 'Salesman';

--temptable 
DROP TABLE IF EXISTS #Employee2
CREATE TABLE #Employee2
(JobTitle varchar(50), EmployeesPerJob int, 
AvgAge int, AvgSalary int, Avg_length_of_service INT);

INSERT INTO #Employee2
SELECT job_title, COUNT(job_title) , AVG(Age), AVG(Salary), AVG(length_of_service)
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.emp_id=sal.emp_id
GROUP BY job_title;

SELECT *
FROM #Employee2

--CTE
WITH CTE_Employee AS 
(SELECT first_name, last_name, sex, salary, 
COUNT(sex) OVER (PARTITION BY sex) as TotalGender,
AVG(salary) OVER (PARTITION BY sex) AS AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
ON emp.emp_id=sal.emp_id
WHERE Salary > '44000')

SELECT * 
FROM CTE_Employee

--calculating salary after raise
SELECT first_name, last_name, job_title, salary,
CASE
	WHEN job_title = 'Salesman' THEN salary + (salary * .10)
	WHEN job_title = 'Accountant' THEN salary + (salary * .05)
	WHEN job_title = 'HR' THEN salary + (salary * .000001)
	ELSE salary + (salary * .03) 
END AS SalaryAfterRaise
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.emp_id=sal.emp_id

---------------------------------------- THE END