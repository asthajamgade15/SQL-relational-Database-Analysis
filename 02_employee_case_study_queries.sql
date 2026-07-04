-- ============================================================
-- SQL Relational Database Design & Analysis
-- Part 2: Employee Case Study - Comprehensive Query Practice
-- ============================================================
-- A four-table relational schema (Location, Department, Job,
-- Employee) used to practice the full range of SQL querying:
-- simple SELECTs, WHERE filters, ORDER BY, GROUP BY/HAVING,
-- JOINs, CASE statements, and subqueries.
-- ============================================================

-- ---------- SCHEMA CREATION ----------

CREATE TABLE LOCATION (
    Location_ID INT PRIMARY KEY,
    City VARCHAR(50)
);

INSERT INTO LOCATION (Location_ID, City)
VALUES (122, 'New York'),
       (123, 'Dallas'),
       (124, 'Chicago'),
       (167, 'Boston');

CREATE TABLE DEPARTMENT (
    Department_Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Location_Id INT,
    FOREIGN KEY (Location_Id) REFERENCES LOCATION(Location_ID)
);

INSERT INTO DEPARTMENT (Department_Id, Name, Location_Id)
VALUES (10, 'Accounting', 122),
       (20, 'Sales', 124),
       (30, 'Research', 123),
       (40, 'Operations', 167);

CREATE TABLE JOB (
    JOB_ID INT PRIMARY KEY,
    DESIGNATION VARCHAR(20)
);

INSERT INTO JOB VALUES
    (667, 'CLERK'),
    (668, 'STAFF'),
    (669, 'ANALYST'),
    (670, 'SALES_PERSON'),
    (671, 'MANAGER'),
    (672, 'PRESIDENT');

CREATE TABLE EMPLOYEE (
    EMPLOYEE_ID INT,
    LAST_NAME VARCHAR(20),
    FIRST_NAME VARCHAR(20),
    MIDDLE_NAME CHAR(1),
    JOB_ID INT FOREIGN KEY REFERENCES JOB(JOB_ID),
    MANAGER_ID INT,
    HIRE_DATE DATE,
    SALARY INT,
    COMM INT,
    DEPARTMENT_ID INT FOREIGN KEY REFERENCES DEPARTMENT(Department_Id)
);

INSERT INTO EMPLOYEE VALUES
    (7369, 'SMITH', 'JOHN', 'Q', 667, 7902, '17-DEC-84', 800, NULL, 20),
    (7499, 'ALLEN', 'KEVIN', 'J', 670, 7698, '20-FEB-84', 1600, 300, 30),
    (7505, 'DOYLE', 'JEAN', 'K', 671, 7839, '04-APR-85', 2850, NULL, 30),
    (7506, 'DENNIS', 'LYNN', 'S', 671, 7839, '15-MAY-85', 2750, NULL, 30),
    (7507, 'BAKER', 'LESLIE', 'D', 671, 7839, '10-JUN-85', 2200, NULL, 40),
    (7521, 'WARK', 'CYNTHIA', 'D', 670, 7698, '22-FEB-85', 1250, 500, 30);

-- ============================================================
-- SIMPLE QUERIES
-- ============================================================

-- 1. List all employee details
SELECT * FROM EMPLOYEE;

-- 2. List all department details
SELECT * FROM DEPARTMENT;

-- 3. List all job details
SELECT * FROM JOB;

-- 4. List all locations
SELECT * FROM LOCATION;

-- 5. First name, last name, and salary of all employees
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE;

-- 6. Employee ID, last name, salary, commission, department ID
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, COMM, DEPARTMENT_ID
FROM EMPLOYEE;

-- 7. Employee ID, last name, department ID with aliases
SELECT
    EMPLOYEE_ID AS "ID of the Employee",
    LAST_NAME AS "Name of the Employee",
    DEPARTMENT_ID AS "Dep_ID"
FROM EMPLOYEE;

-- ============================================================
-- WHERE CONDITIONS
-- ============================================================

-- 1. Details of employee 'Smith'
SELECT * FROM EMPLOYEE WHERE LAST_NAME = 'Smith';

-- 2. Employees working in department 20
SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID = 20;

-- 3. Employees earning salary between 2000 and 3000
SELECT * FROM EMPLOYEE WHERE SALARY BETWEEN 2000 AND 3000;

-- 4. Employees working in department 10 or 20
SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID IN (10, 20);

-- 5. Employees NOT working in department 10 or 30
SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID NOT IN (10, 30);

-- 6. Employees whose name starts with 'L'
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE 'L%';

-- 7. Employees whose name starts with 'L' and ends with 'E'
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE 'L%E';

-- 8. Employees whose name length is 4 and starts with 'J'
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE 'J_';

-- 9. Employees in department 30 earning more than 2500
SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID = 30 AND SALARY > 2500;

-- 10. Employees not receiving commission
SELECT * FROM EMPLOYEE WHERE COMM IS NULL OR COMM = 0;

-- ============================================================
-- ORDER BY CLAUSE
-- ============================================================

-- 1. Employee ID and last name, ascending order by Employee ID
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEE
ORDER BY EMPLOYEE_ID ASC;

-- 2. Employee ID and full name, descending order by salary
SELECT EMPLOYEE_ID,
       CONCAT(FIRST_NAME, ' ', MIDDLE_NAME, LAST_NAME) AS NAME,
       SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 3. All employee details, ascending order by last name
SELECT * FROM EMPLOYEE ORDER BY LAST_NAME ASC;

-- 4. Employee details ordered by last name ascending, then department ID descending
SELECT * FROM EMPLOYEE
ORDER BY LAST_NAME ASC, DEPARTMENT_ID DESC;

-- ============================================================
-- GROUP BY AND HAVING CLAUSE
-- ============================================================

-- 1. Department-wise max, min, and average salary
SELECT DEPARTMENT_ID,
       MAX(SALARY) AS MAX_SALARY,
       MIN(SALARY) AS MIN_SALARY,
       AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE
GROUP BY DEPARTMENT_ID;

-- 2. Job-wise max, min, and average salary
SELECT JOB_ID,
       MAX(SALARY) AS MAX_SALARY,
       MIN(SALARY) AS MIN_SALARY,
       AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE
GROUP BY JOB_ID;

-- 3. Number of employees who joined each month, ascending order
SELECT MONTH(HIRE_DATE) AS JOINING_MONTH,
       COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
GROUP BY MONTH(HIRE_DATE)
ORDER BY MONTH(HIRE_DATE) ASC;

-- 4. Number of employees for each month and year, ascending order
SELECT YEAR(HIRE_DATE) AS JOINING_YEAR,
       MONTH(HIRE_DATE) AS JOINING_MONTH,
       COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
GROUP BY YEAR(HIRE_DATE), MONTH(HIRE_DATE)
ORDER BY YEAR(HIRE_DATE) ASC, MONTH(HIRE_DATE) ASC;

-- 5. Departments having at least 4 employees
SELECT DEPARTMENT_ID, COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 4;

-- 6. Employees who joined in February
SELECT COUNT(*) AS FEB_JOINERS
FROM EMPLOYEE
WHERE MONTH(HIRE_DATE) = 2;

-- 7. Employees who joined in May or June
SELECT COUNT(*) AS MAY_JUNE_JOINERS
FROM EMPLOYEE
WHERE MONTH(HIRE_DATE) IN (5, 6);

-- 8. Employees who joined in 1985
SELECT COUNT(*) AS JOINED_1985
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985;

-- 9. Employees joined each month in 1985
SELECT MONTH(HIRE_DATE) AS MONTH_NUMBER,
       COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985
GROUP BY MONTH(HIRE_DATE)
ORDER BY MONTH(HIRE_DATE);

-- 10. Employees who joined in April 1985
SELECT COUNT(*) AS APRIL_1985_JOINERS
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985 AND MONTH(HIRE_DATE) = 4;

-- 11. Departments with 3+ employees joining in April 1985
SELECT DEPARTMENT_ID, COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985 AND MONTH(HIRE_DATE) = 4
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 3;

-- ============================================================
-- JOINS
-- ============================================================

-- 1. Employees with their department names
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.DEPARTMENT_ID, d.Name
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id;

-- 2. Employees with their designations
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, j.DESIGNATION
FROM EMPLOYEE e
JOIN JOB j ON e.JOB_ID = j.JOB_ID;

-- 3. Employees with their department names and city
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, d.Name, l.City
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
JOIN LOCATION l ON d.Location_Id = l.Location_ID;

-- 4. Employee count per department, with department names
SELECT d.Name, COUNT(e.EMPLOYEE_ID) AS NUM_EMPLOYEES
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
GROUP BY d.Name;

-- 5. Number of employees working in the Sales department
SELECT COUNT(*) AS SALES_EMPLOYEES
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
WHERE d.Name = 'Sales';

-- 6. Departments with 3+ employees, names in ascending order
SELECT d.Name, COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
GROUP BY d.Name
HAVING COUNT(*) >= 3
ORDER BY d.Name ASC;

-- 7. Employees working in 'Dallas'
SELECT COUNT(*) AS DALLAS_EMPLOYEES
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
JOIN LOCATION l ON d.Location_Id = l.Location_ID
WHERE l.City = 'Dallas';

-- 8. All employees in Sales or Operations departments
SELECT e.*
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
WHERE d.Name IN ('Sales', 'Operations');

-- ============================================================
-- CONDITIONAL STATEMENTS (CASE)
-- ============================================================

-- 1. Employee details with a salary grade
SELECT
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID,
    CASE
        WHEN SALARY >= 10000 THEN 'A'
        WHEN SALARY >= 5000 THEN 'B'
        WHEN SALARY >= 3000 THEN 'C'
        WHEN SALARY >= 1000 THEN 'D'
        ELSE 'E'
    END AS GRADE
FROM EMPLOYEE;

-- 2. Number of employees per salary grade
SELECT
    CASE
        WHEN SALARY >= 8000 THEN 'A'
        WHEN SALARY >= 5000 THEN 'B'
        WHEN SALARY >= 3000 THEN 'C'
        WHEN SALARY >= 1000 THEN 'D'
        ELSE 'E'
    END AS GRADE,
    COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
GROUP BY
    CASE
        WHEN SALARY >= 8000 THEN 'A'
        WHEN SALARY >= 5000 THEN 'B'
        WHEN SALARY >= 3000 THEN 'C'
        WHEN SALARY >= 1000 THEN 'D'
        ELSE 'E'
    END;

-- 3. Salary grades for employees earning between 2000 and 5000
SELECT
    CASE
        WHEN SALARY >= 8000 THEN 'A'
        WHEN SALARY >= 5000 THEN 'B'
        WHEN SALARY >= 3000 THEN 'C'
        WHEN SALARY >= 1000 THEN 'D'
        ELSE 'E'
    END AS GRADE,
    COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000 AND 5000
GROUP BY
    CASE
        WHEN SALARY >= 8000 THEN 'A'
        WHEN SALARY >= 5000 THEN 'B'
        WHEN SALARY >= 3000 THEN 'C'
        WHEN SALARY >= 1000 THEN 'D'
        ELSE 'E'
    END;

-- ============================================================
-- SUBQUERIES
-- ============================================================

-- 1. Employee(s) with the maximum salary
SELECT * FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

-- 2. Employees working in the Sales department
SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID = (
    SELECT Department_Id FROM DEPARTMENT WHERE Name = 'Sales'
);

-- 3. Employees working as 'Clerk'
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.SALARY, j.DESIGNATION
FROM EMPLOYEE e
JOIN JOB j ON e.JOB_ID = j.JOB_ID
WHERE j.DESIGNATION = 'Clerk';

-- 4. Employees living in 'Boston'
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, d.Name AS DEPARTMENT_NAME, l.City
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
JOIN LOCATION l ON d.Location_Id = l.Location_ID
WHERE l.City = 'Boston';

-- 5. Number of employees working in the Sales department
SELECT d.Name AS DEPARTMENT_NAME, COUNT(e.EMPLOYEE_ID) AS TOTAL_EMPLOYEES
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DEPARTMENT_ID = d.Department_Id
WHERE d.Name = 'Sales'
GROUP BY d.Name;

-- 6. Give a 10% raise to employees working as clerks
UPDATE EMPLOYEE
SET SALARY = SALARY + (SALARY * 0.10)
WHERE JOB_ID IN (SELECT JOB_ID FROM JOB WHERE DESIGNATION = 'Clerk');

-- 7. Employee with the second highest salary
SELECT * FROM EMPLOYEE
WHERE SALARY = (
    SELECT MAX(SALARY) FROM EMPLOYEE
    WHERE SALARY < (SELECT MAX(SALARY) FROM EMPLOYEE)
);

-- 8. Employees earning more than everyone in department 30
SELECT * FROM EMPLOYEE
WHERE SALARY > ALL (
    SELECT SALARY FROM EMPLOYEE WHERE DEPARTMENT_ID = 30
);

-- 9. Departments with no employees
SELECT Name AS DEPARTMENT_NAME
FROM DEPARTMENT
WHERE Department_Id NOT IN (
    SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEE WHERE DEPARTMENT_ID IS NOT NULL
);

-- 10. Employees earning more than their department's average salary
SELECT * FROM EMPLOYEE e
WHERE SALARY > (
    SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
);
