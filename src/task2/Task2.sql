-- 0) Tworzy schemat
CREATE SCHEMA homework2;
USE homework2;

-- 1) Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko).
CREATE TABLE pracownik (
	id INT auto_increment PRIMARY KEY,
	imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
	wyplata INTEGER,
    data_urodzenia DATE,
    stanowisko VARCHAR(50) NOT NULL
);

-- 2) Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO pracownik(imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES('Jan', 'Kowalski', 10000, '1980-12-02', 'Developer'),
('Adam', 'Nowak', 8400, '1985-03-22', 'Developer'),
('Anna', 'Malinowska', 12500, '1975-11-16', 'Project Manager'),
('Barbara', 'Janiec', 5000, '1992-05-10', 'Quality Assurance'),
('Zenon', 'Czarny', 11000, '1975-11-11', 'Quality Assurance'),
('Zofia', 'Goniec', 7500, '1990-07-18', 'Analyst');

-- 3) Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM pracownik
ORDER BY nazwisko;

-- 4) Pobiera pracowników na wybranym stanowisku
SELECT * FROM pracownik
WHERE stanowisko = 'Quality Assurance';

-- 5) Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM pracownik
WHERE (SELECT DATEDIFF(CURDATE(), data_urodzenia) > 30*365);

-- 6) Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
-- Wymaga wyłączenia opcji Safe Updates w Edit > Preferences
UPDATE pracownik
SET wyplata = wyplata * 1.1
WHERE stanowisko = 'Analityk';

-- 7) Usuwa najmłodszego pracownika
-- Nie dziala w mySQL!!!
-- https://bugs.mysql.com/bug.php?id=79286
DELETE FROM pracownik
WHERE data_urodzenia = (SELECT MIN(data_urodzenia) FROM pracownik);

-- 8) Usuwa tabelę pracownik
DROP TABLE pracownik;

-- 9) Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
	id INT auto_increment PRIMARY KEY,
	nazwa VARCHAR(50) NOT NULL,
    opis VARCHAR(100),
	wyplata INTEGER
);

-- 10) Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE adres (
	id INT auto_increment PRIMARY KEY,
	ulica_numer VARCHAR(50) NOT NULL,
    kod_pocztowy VARCHAR(50) NOT NULL,
	miejscowosc VARCHAR(50) NOT NULL
);

-- 11) Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE pracownik (
	id INT auto_increment PRIMARY KEY,
	imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
	stanowisko_id INT,
    adres_id INT,
    CONSTRAINT FK_PracownikStanowisko FOREIGN KEY (stanowisko_id) REFERENCES stanowisko(id),
    CONSTRAINT FK_PracownikAdres FOREIGN KEY (adres_id) REFERENCES adres(id)
);

-- 12) Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO stanowisko (nazwa, opis, wyplata)
VALUES('Developer','To jest developer',10000),
('Senior Developer','To jest senior developer',14000),
('Project Manager', 'To jest project managera', 12500),
('Quality Assurance', 'To jest qulity assurance', 7500),
('Junior Quality Assurance', 'To jest junior qulity assurance', 5000),
('Analyst', 'To jest analyst', 11000),
('Senior Analyst', 'To jest senior analyst', 14000);


INSERT INTO adres (ulica_numer, kod_pocztowy, miejscowosc)
VALUES('Jagiellońska','43-232','Katowice'),
('Strzegomska','54-332','Wrocław'),
('pl. Powstańców','00-223','Warszawa'),
('pl. Dominikański','50-111','Wrocław'),
('Traugutta','23-222','Tarnów'),
('Conrada','34-111','Kraków');

INSERT INTO pracownik (imie, nazwisko, stanowisko_id, adres_id)
VALUES('Jan','Kowalski',1, 1),
('Adam','Nowak',2, 2),
('Anna','Malinowska',2, 3),
('Barbara','Janiec',3, 4),
('Zenon','Czarny',4, 5),
('Zofia','Goniec',5, 6),
('Bolesław','Słodowy',7, 6);

-- 13) Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT p.id, imie, nazwisko, nazwa, opis, wyplata, ulica_numer, kod_pocztowy, miejscowosc FROM pracownik p
JOIN stanowisko s ON p.stanowisko_id = s.id
JOIN adres a ON p.adres_id = a.id;

-- 14) Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT SUM(s.wyplata) AS Suma_Wyplat FROM pracownik p
JOIN stanowisko s ON p.stanowisko_id = s.id;

-- 15) Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 00-223
SELECT p.id,  imie, nazwisko, nazwa, opis, wyplata, ulica_numer, kod_pocztowy, miejscowosc FROM pracownik p
JOIN stanowisko s ON p.stanowisko_id = s.id
JOIN adres a ON p.adres_id = a.id
WHERE kod_pocztowy = '00-223';