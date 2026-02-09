DROP DATABASE IF EXISTS Company_Management_System;
CREATE DATABASE Company_Management_System;
USE Company_Management_System;
-- 1. DATABASE SETUP
CREATE DATABASE IF NOT EXISTS Company_Management_System;
USE Company_Management_System;

-- 2. TABLES
CREATE TABLE IF NOT EXISTS departments (
     dept_id INT PRIMARY KEY AUTO_INCREMENT,
     dept_name VARCHAR(50) NOT NULL,
     location VARCHAR(50) 
);

CREATE TABLE IF NOT exists employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,
    salary FLOAT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Professional addition: An Audit Table
CREATE TABLE  IF NOT EXISTS salary_history (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary FLOAT,
    new_salary FLOAT,
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. VIEWS
CREATE OR REPLACE VIEW employee_dept_summary AS
SELECT e.emp_name, e.salary, d.dept_name, d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
-- 4. PROCEDURES
DELIMITER //
CREATE PROCEDURE AddNewEmployee(IN p_name VARCHAR(50), IN p_salary FLOAT, IN p_dept_id INT)
BEGIN
    IF p_salary < 20000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary too low!';
    ELSE
        INSERT INTO employees (emp_name, salary, dept_id) VALUES (p_name, p_salary, p_dept_id);
    END IF;
END //

CREATE PROCEDURE GiveRaise(IN d_id INT, IN percentage FLOAT)
BEGIN
    UPDATE employees SET salary = salary + (salary * (percentage / 100)) WHERE dept_id = d_id;
END //
DELIMITER ;

-- 5. TRIGGER (Tracks salary changes automatically)
DELIMITER //
CREATE TRIGGER log_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_history (emp_id, old_salary, new_salary)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
END //
DELIMITER ;

-- 6. INSERT INITIAL DATA
INSERT INTO departments (dept_name, location) VALUES ('IT', 'New York'), ('HR', 'Chicago'), ('Finance', 'London');
CALL AddNewEmployee('Jane', 25000, 2);
CALL AddNewEmployee('Viola', 30000, 1);
CALL AddNewEmployee('Janet', 30000, 3);