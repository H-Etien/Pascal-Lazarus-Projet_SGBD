

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


CREATE DATABASE IF NOT EXISTS `proprio` DEFAULT CHARACTER SET utf8;
USE `proprio`;

-- --------------------------------------------------------



DROP TABLE IF EXISTS `Proprietaire`; 
CREATE TABLE IF NOT EXISTS `Proprietaire` ( 
proprio_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
nom VARCHAR(30) NOT NULL, 
prénom VARCHAR(30) NOT NULL, 
domicile VARCHAR(30)  NULL,
année_naiss SMALLINT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 



INSERT INTO Proprietaire (nom,prénom,domicile,année_naiss) values 
		('Basquin','Alain','Uccle',1963),
		('Dupond','Caroline','Schaerbeek',1942),
		('Jules','Albert','Ixelles',1913),
		('Radke','Hans','Namur',1975),
		('Reeves','Georges','Liège',1943),
		('Virga','Josip','Ostende',1925),
		('Zola','Emile','Brugge',1940),
		('Dufour','Jean','Bruxelles',1970),
		('Von zein','Hubert','Limbourg',1965),
		('Malina','Estelle','Mons',1975);
		
		

-- --------------------------------------------------------



DROP TABLE IF EXISTS `Biens`;
CREATE TABLE IF NOT EXISTS `Biens` (
bien_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
id_proprio INT UNSIGNED NOT NULL,
genre ENUM('Appartement', 'Maison', 'Villa', 'Studio')NULL,
lieu VARCHAR(80) NOT NULL,
prix DECIMAL(10,2) NOT NULL,
superficie INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



INSERT INTO Biens (id_proprio,genre,lieu,prix,superficie) values 
		(5,	'Appartement',	'Ostende',	770,			50),
		(1,	'Maison',				'Namur',		1550,			142),
		(1,'Maison',				'Halle',		1385,			145),
		(6,'Studio',				'Meslin',		4140,			30),
		(2,'Studio',				'Enghien',	1770,			25),
		(4,'Villa',					'Mons',			11968,		230),
		(5,'Villa',					'Ixelles',	8125,			300),
		(7,'Maison',				'Malbeek',	1122.10,	188),
		(3,'Appartement',		'Alma',			11098.90,	75),
		(5,'Appartement',		'Zaventem',	11098,		98),
		(3,'Studio','Woluwé',1135,55)
		;

		


ALTER TABLE `Biens`
  ADD CONSTRAINT `Biens` FOREIGN KEY (`id_proprio`) REFERENCES `Proprietaire` (`proprio_id`) ON DELETE CASCADE;
-- --------------------------------------------------------



DROP TABLE IF EXISTS `locataires`;
CREATE TABLE IF NOT EXISTS `locataires` (
locataire_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(30) NOT NULL,
prénom VARCHAR(30) NOT NULL,
adresse TINYTEXT NOT NULL,
cp MEDIUMINT UNSIGNED NOT NULL,
ville VARCHAR(50) NOT NULL,
tél DECIMAL(10,0) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



INSERT INTO locataires (nom,prénom,adresse,cp,ville,tél) values 
		('Durand','Pierre','rue de l\'arche, 25',1020,'Bruxelles','022198711'),
		('Depere','Marie','avenue des eaux, 25',1030,'Bruxelles', '023216598'),
		('Dupond','Eric','rue de l\'angle, 312',4210,'Namur', '032986524'),
		('Lierre','Carine','avenue du parc, 23',7210,'Tournai', '0658754126'),
		('Devrant','Charles','rue artan, 25',1090,'Bruxelles', '025486932'),
		('Servaes','Paul','rue du marteau, 65',4020,'Namur', '0325412369'),
		('Bichon','Marc','avenue des croix, 12',5021,'Liège', '0355896988'),
		('Dufils','Françoise','rue du pont, 25',5021,'Liège', '0356543215'),
		('Jacques','Elyane','avenue du gland, 32',1020,'Bruxelles', '029876521'),
		('Galand','Eric','rue du pieu, 65',1030,'Bruxelles', '026549827');

-- --------------------------------------------------------



DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
emprunt_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
id_bien INT UNSIGNED NOT NULL,
id_locataire INT UNSIGNED NOT NULL,
date_emprunt DATE NOT NULL,
retard TINYINT UNSIGNED
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



INSERT INTO location (id_bien,id_locataire,date_emprunt,retard) values 
		(3,6,'2001-11-12',0),
		(3,9,'2001-01-01',0),
		(5,3,'2001-03-22',0),
		(5,4,'2001-12-14',1),
		(9,1,'2000-01-25',1),
		(2,8,'2000-12-24',1),
		(2,2,'2001-12-24',0);



ALTER TABLE `location`
  ADD CONSTRAINT FOREIGN KEY (`id_bien`) REFERENCES `Biens` (`bien_id`) ON DELETE CASCADE,
  ADD CONSTRAINT FOREIGN KEY (`id_locataire`) REFERENCES `locataires` (`locataire_id`) ON DELETE CASCADE;

/*
DROP PROCEDURE IF EXISTS `change_prix_bien`;
CREATE PROCEDURE IF NOT EXISTS `change_prix_bien`
(
	IN `num_bien` INT, 
	IN `nvprix` DOUBLE
) 
NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER 
BEGIN
		UPDATE biens 
    SET prix = nvprix 
    WHERE bien_id = num_bien;
END
*/