-- 1) Pobierz zatrudnionych w roku 1990 i później
SELECT * FROM employees
WHERE hire_date >= '1990-01-01';

-- 2) Ile kobiet pracowało do tej pory w firmie?
SELECT COUNT(*) AS liczba_kobiet FROM employees
WHERE gender = 'F';

-- 3) Pobierz imię, nazwisko oraz nazwę działu pracownika
SELECT e.emp_no, first_name AS Imię, last_name AS Nazwisko, dept_name AS Dział
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
ORDER BY emp_no;

-- 4) Wyświetl imię, nazwisko i datę urodzenia najmłodszej kobiety
SELECT first_name AS Imię, last_name AS Nazwisko, birth_date AS Data_Urodzenia
FROM employees
WHERE gender = 'F' AND birth_date = (SELECT MAX(birth_date) from employees WHERE gender = 'F');

-- 5) Wyświetl pracownika o numerze 10009 z wszystkimi dotychczasowymi stanowiskami pracy
SELECT * FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE e.emp_no = '10009';

-- 6) Wyświetl pracowników z aktualnymi stanowiskami pracy
SELECT e.emp_no, first_name AS Imię, last_name AS Nazwisko, title AS Aktualne_Stanowisko FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01';

-- 7) Wyświetl najlepiej zarabiającego pracownika
SELECT e.emp_no, first_name AS Imię, last_name AS Nazwisko, s.salary AS Płaca FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE salary = (SELECT MAX(salary) FROM salaries);

-- 8) Wyświetl najlepiej i najgorzej zarabiających pracowników
SELECT e.emp_no, first_name AS Imię, last_name AS Nazwisko, s.salary AS Płaca FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE salary = (SELECT MAX(salary) FROM salaries)
OR salary = (SELECT MIN(salary) FROM salaries);

-- 9) Wyświetl imię i nazwisko pracownika oraz imię i nazwisko managera jego działu

-- SELECT e.emp_no, e.first_name, e.last_name, de.dept_no, (SELECT e.first_name FROM employees WHERE e.emp_no = dm.emp_no)
SELECT e.emp_no, e.first_name, e.last_name, de.dept_no, dm.emp_no AS Manager_No
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN dept_manager dm ON de.dept_no = dm.dept_no
WHERE dm.to_date = '9999-01-01'
ORDER BY e.emp_no;

-- 10) Wyświetl wszystkie stanowiska w firmie. Usuń powtórzenia.
SELECT DISTINCT title AS Stanowisko FROM titles;