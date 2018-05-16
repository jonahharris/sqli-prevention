-- SQLi Prevention import file
-- Dominika Regeciova
-- xregec00@stud.fit.vutbr.cz

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

CREATE DATABASE `sqli-prevention`;

CREATE TABLE `authors` (
  `ID` int(11) NOT NULL,
  `Active` tinyint(1) NOT NULL,
  `Name` varchar(42) NOT NULL,
  `Surname` varchar(42) NOT NULL,
  `Born` year(4) NOT NULL,
  `Email` varchar(42) NOT NULL,
  `Password` varchar(42) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `authors` (`ID`, `Active`, `Name`, `Surname`, `Born`, `Email`, `Password`) VALUES
(1, 1, 'Terry', 'Pratchett', 1948, 'pratchett@email.com', 'GreatA\'Tuin'),
(2, 1, 'Umberto', 'Eco', 1932, 'eco@email.com', 'SuperStrongPassword18'),
(3, 1, 'John', 'Irvning', 1942, 'irving@email.com', 'Pass1942'),
(4, 0, 'Arthur C.', 'Doyle', 1959, 'doyle@email.com', 'Elementary'),
(6, 1, 'Neil', 'Gaiman', 1960, 'gaiman@email.com', 'Sandman'),
(7, 0, 'Stephen', 'King', 1947, 'king@email.com', 'yWg47iAy'),
(8, 1, 'Caitlin', 'Doughty', 1984, 'doughty@email.com', 'DeathIsMyLife'),
(9, 0, 'Stephen', 'Hawking', 1942, 'hawking@email.com', 'TheBigBangTheory');

ALTER TABLE `authors`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `authors`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

-- CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';

-- GRANT ALL ON sqli_prevention.* TO 'test'@'localhost';
