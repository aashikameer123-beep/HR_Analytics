SELECT version();

CREATE TABLE employees (
    employee_id VARCHAR(20),
    employee_name VARCHAR(100),
    gender VARCHAR(20),
    age INT,
    department VARCHAR(50),
    job_role VARCHAR(100),
    location VARCHAR(50),
    joining_date DATE,
    experience_years DECIMAL(4,1),
    salary_inr NUMERIC(12,2),
    performance_score INT,
    attendance_percentage DECIMAL(5,2),
    overtime VARCHAR(10),
    training_hours INT,
    job_satisfaction INT,
    work_hours_per_week INT,
    promotion_last_3_years VARCHAR(10),
    attrition VARCHAR(10),
    exit_date DATE
);

select * from employees

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'employees'
ORDER BY ordinal_position;


ALTER TABLE employees
ALTER COLUMN training_hours TYPE DECIMAL(10,2);

SELECT * FROM employees

SELECT COUNT(*)
FROM employees;

SELECT *
FROM employees
LIMIT 10;

SELECT COUNT(*) AS total_employees
FROM employees;

SELECT employee_id, COUNT(*) AS employee_count
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- How many employees are in each department?

SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

--Average Salary by Department

SELECT 
    department,
    ROUND(AVG(salary_inr), 2) AS average_salary
FROM employees
GROUP BY department
ORDER BY average_salary DESC;

-- Average Salary by Job Role
 
 SELECT 
    job_role,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary_inr), 2) AS average_salary
FROM employees
GROUP BY job_role
ORDER BY average_salary DESC;

-- attrition rate 

select 
   attrition , 
   count (*) as employee_count 
   from employees 
   group by attrition 
   order by employee_count

-- attrition rate 

SELECT 
    ROUND(
        100.0 * SUM(
            CASE 
                WHEN attrition = 'Yes' THEN 1 
                ELSE 0 
          END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees;

--Attrition by department 

SELECT 
  department ,
    ROUND(
        100.0 * SUM(
            CASE 
                WHEN attrition = 'Yes' THEN 1 
                ELSE 0 
          END
        ) / COUNT(*),
        2
    ) AS attrition_rate 
FROM employees 
 group by department 
 order by attrition_rate

 --Attrition by department with count 

select 
 department, 
 count (*) as totel_employee,
 sum (
    case 
	 when attrition = 'Yes' then 1 
	 else 0 end ) as emplloyee_left, 
	 round (100.0 *  sum (
    case 
	 when attrition = 'Yes' then 1 
	 else 0 end ) / count (* ) , 2
	 ) as attrition_rate 
	 from employees
      group by department 
	  order by attrition_rate desc ;

-- Attrition by Overtime

select 
 overtime, 
 count (*) as totel_employee,
 sum (
    case 
	 when attrition = 'Yes' then 1 
	 else 0 end ) as emplloyee_left, 
	 round (100.0 *  sum (
    case 
	 when attrition = 'Yes' then 1 
	 else 0 end ) / count (* ) , 2
	 ) as attrition_rate 
	 from employees
      group by overtime
	  order by attrition_rate desc ;

	-- Attrition by job satisfaction

select 
 job_satisfaction, 
 count (*) as totel_employee,
 sum (
    case 
	 when attrition = 'Yes' then 1 
	 else 0 end ) as emplloyee_left, 
	 round (100.0 *  sum (
    case 
	 when attrition = 'Yes' then 1 
	 else 0 end ) / count (* ) , 2
	 ) as attrition_rate 
	 from employees
      group by job_satisfaction
	  order by job_satisfaction  ;  

-- Attrition by the  combination of Overtime, job_satisfaction 
SELECT 
    overtime,
    job_satisfaction,
    COUNT(*) AS total_employees,
    SUM(
        CASE 
            WHEN attrition = 'Yes' THEN 1 
            ELSE 0 
        END
    ) AS employees_left,
    ROUND(
        100.0 * SUM(
            CASE 
                WHEN attrition = 'Yes' THEN 1 
                ELSE 0 
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY 
    overtime,
    job_satisfaction
ORDER BY 
    overtime,
    job_satisfaction;


-- attrition by  the combination of overtime , salary 

 SELECT
    CASE
        WHEN salary_inr < 40000 THEN 'Below 40K'
        WHEN salary_inr < 60000 THEN '40K - 60K'
        WHEN salary_inr < 80000 THEN '60K - 80K'
        WHEN salary_inr < 100000 THEN '80K - 100K'
        ELSE '100K+'
    END AS salary_band,
    overtime,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY
    salary_band,
    overtime
ORDER BY
    salary_band,
    overtime;

--employee attrition rate in CTE queries

	WITH department_attrition AS (
    SELECT
        department,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department
)
SELECT
    department,
    total_employees,
    employees_left,
    ROUND(
        100.0 * employees_left / total_employees,
        2
    ) AS attrition_rate
FROM department_attrition
ORDER BY attrition_rate DESC;


--Compare departments with overall attrition

WITH department_attrition AS (
    SELECT
        department,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department
),
overall_attrition AS (
    SELECT
        ROUND(
            100.0 * SUM(
                CASE
                    WHEN attrition = 'Yes' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS company_attrition_rate
    FROM employees
)
SELECT
    d.department,
    d.total_employees,
    d.employees_left,
    ROUND(
        100.0 * d.employees_left / d.total_employees,
        2
    ) AS department_attrition_rate,
    o.company_attrition_rate
FROM department_attrition d
CROSS JOIN overall_attrition o
ORDER BY department_attrition_rate DESC;

--Find departments above company average

WITH department_attrition AS (
    SELECT
        department,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department
),
overall_attrition AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    d.department,
    ROUND(
        100.0 * d.employees_left / d.total_employees,
        2
    ) AS department_attrition_rate,
    ROUND(o.company_attrition_rate, 2) AS company_attrition_rate
FROM department_attrition d
CROSS JOIN overall_attrition o
WHERE
    100.0 * d.employees_left / d.total_employees
    > o.company_attrition_rate
ORDER BY department_attrition_rate DESC;

--Department risk classification

WITH department_attrition AS (
    SELECT
        department,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department
),
overall_attrition AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    d.department,
    ROUND(
        100.0 * d.employees_left / d.total_employees,
        2
    ) AS department_attrition_rate,
    ROUND(o.company_attrition_rate, 2) AS company_attrition_rate,
    CASE
        WHEN 100.0 * d.employees_left / d.total_employees
             > o.company_attrition_rate
        THEN 'High Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM department_attrition d
CROSS JOIN overall_attrition o
ORDER BY department_attrition_rate DESC;




WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
overall_attrition AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    r.job_role,
    r.total_employees,
    r.employees_left,
    ROUND(
        100.0 * r.employees_left / r.total_employees,
        2
    ) AS role_attrition_rate,
    ROUND(o.company_attrition_rate, 2) AS company_attrition_rate
FROM role_attrition r
CROSS JOIN overall_attrition o
WHERE
    100.0 * r.employees_left / r.total_employees
    > o.company_attrition_rate
ORDER BY role_attrition_rate DESC; 

--Find the highest-risk roles with enough employees

WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
overall_attrition AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    r.job_role,
    r.total_employees,
    r.employees_left,
    ROUND(
        100.0 * r.employees_left / r.total_employees,
        2
    ) AS role_attrition_rate,
    ROUND(o.company_attrition_rate, 2) AS company_attrition_rate
FROM role_attrition r
CROSS JOIN overall_attrition o
WHERE
    r.total_employees >= 50
    AND 100.0 * r.employees_left / r.total_employees
        > o.company_attrition_rate
ORDER BY role_attrition_rate DESC;

--Find the highest-risk roles with enough employees

WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
overall_attrition AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    r.job_role,
    r.total_employees,
    r.employees_left,
    ROUND(
        100.0 * r.employees_left / r.total_employees,
        2
    ) AS role_attrition_rate,
    ROUND(o.company_attrition_rate, 2) AS company_attrition_rate
FROM role_attrition r
CROSS JOIN overall_attrition o
WHERE
    r.total_employees >= 50
    AND 100.0 * r.employees_left / r.total_employees
        > o.company_attrition_rate
ORDER BY role_attrition_rate DESC;




WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
)
SELECT
    job_role,
    total_employees,
    employees_left,
    ROUND(
        100.0 * employees_left / total_employees,
        2
    ) AS attrition_rate,
    RANK() OVER (
        ORDER BY
            100.0 * employees_left / total_employees DESC
    ) AS attrition_rank
FROM role_attrition
ORDER BY attrition_rank;

--ompare each role with the previous role

WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
ranked_roles AS (
    SELECT
        job_role,
        total_employees,
        employees_left,
        ROUND(
            100.0 * employees_left / total_employees,
            2
        ) AS attrition_rate
    FROM role_attrition
)
SELECT
    job_role,
    total_employees,
    employees_left,
    attrition_rate,
    LAG(attrition_rate) OVER (
        ORDER BY attrition_rate DESC
    ) AS previous_role_rate
FROM ranked_roles
ORDER BY attrition_rate DESC;

--Calculate the difference

WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
ranked_roles AS (
    SELECT
        job_role,
        total_employees,
        employees_left,
        ROUND(
            100.0 * employees_left / total_employees,
            2
        ) AS attrition_rate
    FROM role_attrition
),
role_comparison AS (
    SELECT
        job_role,
        total_employees,
        employees_left,
        attrition_rate,
        LAG(attrition_rate) OVER (
            ORDER BY attrition_rate DESC
        ) AS previous_role_rate
    FROM ranked_roles
)
SELECT
    job_role,
    total_employees,
    employees_left,
    attrition_rate,
    previous_role_rate,
    ROUND(
        attrition_rate - previous_role_rate,
        2
    ) AS rate_difference
FROM role_comparison
ORDER BY attrition_rate DESC;

--running avarage 

WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
ranked_roles AS (
    SELECT
        job_role,
        total_employees,
        employees_left,
        ROUND(
            100.0 * employees_left / total_employees,
            2
        ) AS attrition_rate
    FROM role_attrition
)
SELECT
    job_role,
    total_employees,
    employees_left,
    attrition_rate,
    ROUND(
        AVG(attrition_rate) OVER (
            ORDER BY attrition_rate DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_avg_attrition
FROM ranked_roles
ORDER BY attrition_rate DESC;

-- top n  

WITH role_attrition AS (
    SELECT
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY job_role
),
ranked_roles AS (
    SELECT
        job_role,
        total_employees,
        employees_left,
        ROUND(
            100.0 * employees_left / total_employees,
            2
        ) AS attrition_rate
    FROM role_attrition
),
numbered_roles AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY attrition_rate DESC
        ) AS row_number
    FROM ranked_roles
)
SELECT
    job_role,
    total_employees,
    employees_left,
    attrition_rate,
    row_number
FROM numbered_roles
WHERE row_number <= 5
ORDER BY row_number;

--Attrition ranking within each department

WITH role_attrition AS (
    SELECT
        department,
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department, job_role
)
SELECT
    department,
    job_role,
    total_employees,
    employees_left,
    ROUND(
        100.0 * employees_left / total_employees,
        2
    ) AS attrition_rate,
    RANK() OVER (
        PARTITION BY department
        ORDER BY
            100.0 * employees_left / total_employees DESC
    ) AS department_rank
FROM role_attrition
ORDER BY department, department_rank;

-- Find the highest-risk role in each department

WITH role_attrition AS (
    SELECT
        department,
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department, job_role
),
ranked_roles AS (
    SELECT
        department,
        job_role,
        total_employees,
        employees_left,
        ROUND(
            100.0 * employees_left / total_employees,
            2
        ) AS attrition_rate,
        RANK() OVER (
            PARTITION BY department
            ORDER BY
                100.0 * employees_left / total_employees DESC
        ) AS department_rank
    FROM role_attrition
)
SELECT
    department,
    job_role,
    total_employees,
    employees_left,
    attrition_rate
FROM ranked_roles
WHERE department_rank = 1
ORDER BY attrition_rate DESC;

--compare each department's highest-risk role against the overall company attrition rate.

WITH role_attrition AS (
    SELECT
        department,
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department, job_role
),
ranked_roles AS (
    SELECT
        department,
        job_role,
        total_employees,
        employees_left,
        100.0 * employees_left / total_employees AS attrition_rate,
        RANK() OVER (
            PARTITION BY department
            ORDER BY
                100.0 * employees_left / total_employees DESC
        ) AS department_rank
    FROM role_attrition
),
company_rate AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    r.department,
    r.job_role,
    r.total_employees,
    r.employees_left,
    ROUND(r.attrition_rate, 2) AS attrition_rate,
    ROUND(c.company_attrition_rate, 2) AS company_attrition_rate,
    ROUND(r.attrition_rate - c.company_attrition_rate, 2)
        AS difference_from_company
FROM ranked_roles r
CROSS JOIN company_rate c
WHERE r.department_rank = 1
ORDER BY difference_from_company DESC;

--Create our first HR analytics view
--department attrition analysis

CREATE VIEW vw_department_attrition AS
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY department
ORDER BY attrition_rate DESC;

SELECT *
FROM vw_department_attrition;

--View #2 — Job Role Attrition.

CREATE VIEW vw_job_role_attrition AS
SELECT
    job_role,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY job_role
ORDER BY attrition_rate DESC;

SELECT *
FROM vw_job_role_attrition;

--View #3 — Salary & Attrition

CREATE VIEW vw_salary_attrition AS
SELECT
    CASE
        WHEN salary_inr < 40000 THEN 'Below 40K'
        WHEN salary_inr < 60000 THEN '40K - 60K'
        WHEN salary_inr < 80000 THEN '60K - 80K'
        WHEN salary_inr < 100000 THEN '80K - 100K'
        ELSE '100K+'
    END AS salary_band,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,
  ROUND(
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY
    CASE
        WHEN salary_inr < 40000 THEN 'Below 40K'
        WHEN salary_inr < 60000 THEN '40K - 60K'
        WHEN salary_inr < 80000 THEN '60K - 80K'
        WHEN salary_inr < 100000 THEN '80K - 100K'
        ELSE '100K+'
    END
ORDER BY attrition_rate DESC;

SELECT *
FROM vw_salary_attrition;

--View #4 — Overtime & Attrition

CREATE VIEW vw_overtime_attrition AS
SELECT
    overtime,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN attrition = 'Yes' THEN 1
            ELSE 0
        END
    ) AS employees_left,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM employees
GROUP BY overtime
ORDER BY attrition_rate DESC;

SELECT *
FROM vw_overtime_attrition;

--View #5 — High-Risk Roles

CREATE VIEW vw_high_risk_roles AS
WITH role_attrition AS (
    SELECT
        department,
        job_role,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) AS employees_left
    FROM employees
    GROUP BY department, job_role
),
ranked_roles AS (
    SELECT
        department,
        job_role,
        total_employees,
        employees_left,
        100.0 * employees_left / total_employees AS attrition_rate,
        RANK() OVER (
            PARTITION BY department
            ORDER BY
                100.0 * employees_left / total_employees DESC
        ) AS department_rank
    FROM role_attrition
),
company_rate AS (
    SELECT
        100.0 * SUM(
            CASE
                WHEN attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS company_attrition_rate
    FROM employees
)
SELECT
    r.department,
    r.job_role,
    r.total_employees,
    r.employees_left,
    ROUND(r.attrition_rate, 2) AS attrition_rate,
    ROUND(c.company_attrition_rate, 2) AS company_attrition_rate,
    ROUND(
        r.attrition_rate - c.company_attrition_rate,
        2
    ) AS difference_from_company
FROM ranked_roles r
CROSS JOIN company_rate c
WHERE r.department_rank = 1
ORDER BY difference_from_company DESC;

SELECT *
FROM vw_high_risk_roles;
