Create database PrenotazioneAuleUniversitarie;
use PrenotazioneAuleUniversitarie;


-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: university_room_booking_system
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aule`
--

DROP TABLE IF EXISTS `aule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `aule` (
  `id_aula` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `capacita` int NOT NULL,
  `id_edificio` int NOT NULL,
  PRIMARY KEY (`id_aula`),
  KEY `id_edificio` (`id_edificio`),
  CONSTRAINT `aule_ibfk_1` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id_edificio`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aule`
--

LOCK TABLES `aule` WRITE;
/*!40000 ALTER TABLE `aule` DISABLE KEYS */;
INSERT INTO `aule` VALUES (1,'Aula Magna',150,1),(2,'Aula Magna',200,2),(3,'Aula 1',50,2),(4,'Aula 2',70,2),(5,'Aula 3',40,3),(6,'Aula 4',30,3),(7,'Aula Blu',60,2),(8,'Aula Boyle',200,1),(9,'Aula Leibnitz',50,2),(10,'Aula Pareto',30,4);
/*!40000 ALTER TABLE `aule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `corsi`
--

DROP TABLE IF EXISTS `corsi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `corsi` (
  `id_corso` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `id_utente` int NOT NULL,
  PRIMARY KEY (`id_corso`),
  KEY `id_utente` (`id_utente`),
  CONSTRAINT `corsi_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utenti` (`id_utente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corsi`
--

LOCK TABLES `corsi` WRITE;
/*!40000 ALTER TABLE `corsi` DISABLE KEYS */;
INSERT INTO `corsi` VALUES (1,'Introduzione all\'Informatica','Corso introduttivo sull\'informatica',1),(2,'Analisi Matematica 1','Corso introduttivo di Analisi Matematica',1),(3,'Fisica 1','Corso introduttivo di Fisica',2),(4,'Analisi Matematica 4','Corso avanzato di Analisi Matematica',3),(5,'Programmazione Avanzata','Corso di Java per studenti del 3^ anno',6);
/*!40000 ALTER TABLE `corsi` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_associazione_corsi_docenti` BEFORE INSERT ON `corsi` FOR EACH ROW BEGIN
    DECLARE user_role VARCHAR(255);

    SELECT tipo INTO user_role
    FROM Utenti
    WHERE id_utente = NEW.id_utente;

    IF user_role <> 'Docente' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo gli utenti con ruolo "Docenti" possono essere associati a un corso.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dipendenti`
--

DROP TABLE IF EXISTS `dipendenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `dipendenti` (
  `id_dipendente` int NOT NULL,
  `username_login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `id_universita` int NOT NULL,
  PRIMARY KEY (`id_dipendente`),
  KEY `id_universita` (`id_universita`),
  CONSTRAINT `dipendenti_ibfk_1` FOREIGN KEY (`id_universita`) REFERENCES `universita` (`id_universita`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dipendenti`
--

LOCK TABLES `dipendenti` WRITE;
/*!40000 ALTER TABLE `dipendenti` DISABLE KEYS */;
INSERT INTO `dipendenti` VALUES (1,'paolo.viola','p@ssw0rd','Paolo','Viola','paolo.viola@dipendenti.unimi.it',1),(2,'silvia.marrone','pa$$word1','Silvia','Marrone','johndoe@amm.units.it',2),(3,'lucia.lilla','pa$$word2','Lucia','Lilla','janedoe@amm.units.it',2);
/*!40000 ALTER TABLE `dipendenti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `edifici`
--

DROP TABLE IF EXISTS `edifici`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `edifici` (
  `id_edificio` int NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cap` varchar(5) NOT NULL,
  `via` varchar(50) DEFAULT NULL,
  `civico` varchar(5) DEFAULT NULL,
  `id_universita` int NOT NULL,
  PRIMARY KEY (`id_edificio`),
  KEY `id_universita` (`id_universita`),
  CONSTRAINT `edifici_ibfk_1` FOREIGN KEY (`id_universita`) REFERENCES `universita` (`id_universita`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `edifici`
--

LOCK TABLES `edifici` WRITE;
/*!40000 ALTER TABLE `edifici` DISABLE KEYS */;
INSERT INTO `edifici` VALUES (1,'Edificio U6','20133','Via Valerio','19',2),(2,'Dipartimento di Ingegneria e Architettura','34127','Via Valerio','6/1',2),(3,'Dipartimento di Fisica','34127','Via Valerio','2',2),(4,'Edificio 3','34100','Via degli Angeli','3',3);
/*!40000 ALTER TABLE `edifici` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_piu_universita_per_edificio` BEFORE INSERT ON `edifici` FOR EACH ROW BEGIN
    DECLARE num_proprietari INT;

    -- Controlla il numero di proprietari universita attivi per l'edificio
    SELECT COUNT(*) INTO num_proprietari
    FROM edifici
    WHERE id_universita = NEW.id_universita
    AND id_edificio <> NEW.id_edificio;

    IF num_proprietari > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''edificio ha gia un proprietario universita associato.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `elencoaule`
--

DROP TABLE IF EXISTS `elencoaule`;
/*!50001 DROP VIEW IF EXISTS `elencoaule`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencoaule` AS SELECT 
 1 AS `Aula`,
 1 AS `Edificio`,
 1 AS `Universita`,
 1 AS `Indirizzo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elencocorsi`
--

DROP TABLE IF EXISTS `elencocorsi`;
/*!50001 DROP VIEW IF EXISTS `elencocorsi`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencocorsi` AS SELECT 
 1 AS `nomeCorso`,
 1 AS `descrizione`,
 1 AS `docente`,
 1 AS `UniversitaAffiliazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elencodipendenti`
--

DROP TABLE IF EXISTS `elencodipendenti`;
/*!50001 DROP VIEW IF EXISTS `elencodipendenti`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencodipendenti` AS SELECT 
 1 AS `Nome`,
 1 AS `Cognome`,
 1 AS `Email`,
 1 AS `UniversitaAffiliazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elencodocenti`
--

DROP TABLE IF EXISTS `elencodocenti`;
/*!50001 DROP VIEW IF EXISTS `elencodocenti`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencodocenti` AS SELECT 
 1 AS `Nome`,
 1 AS `Cognome`,
 1 AS `Email`,
 1 AS `Matricola`,
 1 AS `UniversitaAffiliazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elencoedifici`
--

DROP TABLE IF EXISTS `elencoedifici`;
/*!50001 DROP VIEW IF EXISTS `elencoedifici`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencoedifici` AS SELECT 
 1 AS `Edificio`,
 1 AS `Universita`,
 1 AS `Indirizzo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elenconondocenti`
--

DROP TABLE IF EXISTS `elenconondocenti`;
/*!50001 DROP VIEW IF EXISTS `elenconondocenti`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elenconondocenti` AS SELECT 
 1 AS `Nome`,
 1 AS `Cognome`,
 1 AS `Email`,
 1 AS `Matricola`,
 1 AS `UniversitaAffiliazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elencoprenotazioni`
--

DROP TABLE IF EXISTS `elencoprenotazioni`;
/*!50001 DROP VIEW IF EXISTS `elencoprenotazioni`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencoprenotazioni` AS SELECT 
 1 AS `Data`,
 1 AS `OraInizio`,
 1 AS `OraFine`,
 1 AS `Descrizione`,
 1 AS `Aula`,
 1 AS `Edificio`,
 1 AS `Universita`,
 1 AS `Corso`,
 1 AS `UtenteResponsabile`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `elencouniversita`
--

DROP TABLE IF EXISTS `elencouniversita`;
/*!50001 DROP VIEW IF EXISTS `elencouniversita`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8 */;
/*!50001 CREATE VIEW `elencouniversita` AS SELECT 
 1 AS `Universita`,
 1 AS `Indirizzo`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prenotazioni`
--

DROP TABLE IF EXISTS `prenotazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `prenotazioni` (
  `id_prenotazione` int NOT NULL AUTO_INCREMENT,
  `id_aula` int NOT NULL,
  `data` date NOT NULL,
  `ora_inizio` time NOT NULL,
  `ora_fine` time NOT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `id_utente` int NOT NULL,
  `id_corso` int DEFAULT NULL,
  PRIMARY KEY (`id_prenotazione`),
  KEY `id_aula` (`id_aula`),
  KEY `id_utente` (`id_utente`),
  KEY `id_corso` (`id_corso`),
  CONSTRAINT `prenotazioni_ibfk_1` FOREIGN KEY (`id_aula`) REFERENCES `aule` (`id_aula`),
  CONSTRAINT `prenotazioni_ibfk_2` FOREIGN KEY (`id_utente`) REFERENCES `utenti` (`id_utente`),
  CONSTRAINT `prenotazioni_ibfk_3` FOREIGN KEY (`id_corso`) REFERENCES `corsi` (`id_corso`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prenotazioni`
--

LOCK TABLES `prenotazioni` WRITE;
/*!40000 ALTER TABLE `prenotazioni` DISABLE KEYS */;
INSERT INTO `prenotazioni` VALUES (1,2,'2023-05-10','10:00:00','12:00:00','Lezione',1,1),(2,2,'2023-05-02','10:00:00','12:00:00','Lezione',2,1),(3,3,'2023-05-03','14:00:00','16:00:00','Esame',3,2),(4,4,'2023-05-04','08:00:00','10:00:00','Lezione',2,1),(5,4,'2020-03-01','11:00:00','12:00:00','Ritrovo di lista \"StudentiPerUnits\"',4,NULL),(6,2,'2023-05-16','09:00:00','12:00:00','Descrizione dell\'aula',2,1),(8,3,'2023-05-16','09:00:00','12:00:00','Descrizione della prenotaz',1,1),(25,10,'2023-05-08','09:18:24','12:19:31','Programmazione Avanzata',6,5);
/*!40000 ALTER TABLE `prenotazioni` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_piu_prenotazioni_per_utente` BEFORE INSERT ON `prenotazioni` FOR EACH ROW BEGIN
    DECLARE num_prenotazioni INT;

    -- Controlla il numero di prenotazioni attive dell'utente per la data e l'ora di inizio
    SELECT COUNT(*) INTO num_prenotazioni
    FROM prenotazioni
    WHERE id_utente = NEW.id_utente
    AND data = NEW.data
    AND (ora_inizio <= NEW.ora_inizio AND ora_fine > NEW.ora_inizio
         OR ora_inizio < NEW.ora_fine AND ora_fine >= NEW.ora_fine);

    IF num_prenotazioni > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''utente ha gia prenotato un''aula per lo stesso periodo.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_universita_utente_aula` BEFORE INSERT ON `prenotazioni` FOR EACH ROW BEGIN
    DECLARE aula_universita INT;
    DECLARE utente_universita INT;

    SELECT un.id_universita INTO aula_universita
    FROM Aule a
    INNER JOIN Edifici e ON a.id_edificio = e.id_edificio
    INNER JOIN universita un on e.id_universita = un.id_universita
    WHERE a.id_aula = NEW.id_aula;

    SELECT ut.id_universita INTO utente_universita
    FROM utenti ut
    WHERE id_utente = NEW.id_utente;

    IF aula_universita <> utente_universita THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''utente e l''aula devono appartenere alla stessa universita.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `universita`
--

DROP TABLE IF EXISTS `universita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `universita` (
  `id_universita` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `cap` varchar(5) NOT NULL,
  `via` varchar(50) DEFAULT NULL,
  `civico` varchar(5) NOT NULL,
  PRIMARY KEY (`id_universita`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `universita`
--

LOCK TABLES `universita` WRITE;
/*!40000 ALTER TABLE `universita` DISABLE KEYS */;
INSERT INTO `universita` VALUES (1,'Universita degli Studi di Milano','20122','Via Festa del Perdono','7'),(2,'Universita degli Studi di Trieste','34127','Via Alfonso Valerio','22'),(3,'Universita dei Geni','34100','Via Leonardo da Vinci','3'),(4,'Universita degli Studi di Udine','33100','Via delle Scienze','206');
/*!40000 ALTER TABLE `universita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `utenti` (
  `id_utente` int NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tipo` enum('Docente','Altro') DEFAULT NULL,
  `matricola` varchar(50) DEFAULT NULL,
  `id_universita` int NOT NULL,
  PRIMARY KEY (`id_utente`),
  KEY `id_universita` (`id_universita`),
  CONSTRAINT `utenti_ibfk_1` FOREIGN KEY (`id_universita`) REFERENCES `universita` (`id_universita`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES (1,'Mario','Rossi','mario.rossi@units.it','Docente','0001',2),(2,'Mariurizio','Arancione','maurizio.arancione@units.it','Docente','0002',2),(3,'Laura','Bianchi','laura.bianchi@units.it','Docente','5557',2),(4,'Pierino','Violetto','pierino.violetto@studenti.units.it','Altro','IN059991',2),(5,'Pierino','Blu','pierino.blu@unimigliori.it','Altro','BEST01',3),(6,'Ada','Lovelace','ada.lovelace@unimigliori.it','Docente','1234',3),(7,'Isaac','Newton','isaac.newton@unimigliori.it','Docente','9810',3),(8,'Bernhard','Riemann','bernhard.riemann@unimigliori.it','Docente','3333',3),(9,'Bernard','Bolzano','bernard.bolzano@unimigliori.it','Docente','2223',3),(10,'Karl','Gauss','karl.gauss@unimigliori.it','Docente','3321',3);
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `elencoaule`
--

/*!50001 DROP VIEW IF EXISTS `elencoaule`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencoaule` AS select `aule`.`nome` AS `Aula`,`edifici`.`nome` AS `Edificio`,`universita`.`nome` AS `Universita`,concat(`edifici`.`via`,' ',`edifici`.`civico`,', ',`edifici`.`cap`) AS `Indirizzo` from ((`aule` join `edifici` on((`aule`.`id_edificio` = `edifici`.`id_edificio`))) join `universita` on((`edifici`.`id_universita` = `universita`.`id_universita`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elencocorsi`
--

/*!50001 DROP VIEW IF EXISTS `elencocorsi`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencocorsi` AS select `c`.`nome` AS `nomeCorso`,`c`.`descrizione` AS `descrizione`,concat(`u`.`nome`,' ',`u`.`cognome`) AS `docente`,`un`.`nome` AS `UniversitaAffiliazione` from ((`corsi` `c` join `utenti` `u` on((`c`.`id_utente` = `u`.`id_utente`))) join `universita` `un` on((`u`.`id_universita` = `un`.`id_universita`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elencodipendenti`
--

/*!50001 DROP VIEW IF EXISTS `elencodipendenti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencodipendenti` AS select `dipendenti`.`nome` AS `Nome`,`dipendenti`.`cognome` AS `Cognome`,`dipendenti`.`email` AS `Email`,`u`.`nome` AS `UniversitaAffiliazione` from (`dipendenti` join `universita` `u` on((`u`.`id_universita` = `dipendenti`.`id_universita`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elencodocenti`
--

/*!50001 DROP VIEW IF EXISTS `elencodocenti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencodocenti` AS select `utenti`.`nome` AS `Nome`,`utenti`.`cognome` AS `Cognome`,`utenti`.`email` AS `Email`,`utenti`.`matricola` AS `Matricola`,`universita`.`nome` AS `UniversitaAffiliazione` from (`utenti` left join `universita` on((`utenti`.`id_universita` = `universita`.`id_universita`))) where (`utenti`.`tipo` = 'Docente') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elencoedifici`
--

/*!50001 DROP VIEW IF EXISTS `elencoedifici`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencoedifici` AS select `edifici`.`nome` AS `Edificio`,`universita`.`nome` AS `Universita`,concat(`edifici`.`via`,' ',`edifici`.`civico`,', ',`edifici`.`cap`) AS `Indirizzo` from (`edifici` join `universita` on((`edifici`.`id_universita` = `universita`.`id_universita`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elenconondocenti`
--

/*!50001 DROP VIEW IF EXISTS `elenconondocenti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elenconondocenti` AS select `utenti`.`nome` AS `Nome`,`utenti`.`cognome` AS `Cognome`,`utenti`.`email` AS `Email`,`utenti`.`matricola` AS `Matricola`,`universita`.`nome` AS `UniversitaAffiliazione` from (`utenti` left join `universita` on((`utenti`.`id_universita` = `universita`.`id_universita`))) where (`utenti`.`tipo` = 'Altro') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elencoprenotazioni`
--

/*!50001 DROP VIEW IF EXISTS `elencoprenotazioni`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencoprenotazioni` AS select `prenotazioni`.`data` AS `Data`,`prenotazioni`.`ora_inizio` AS `OraInizio`,`prenotazioni`.`ora_fine` AS `OraFine`,`prenotazioni`.`descrizione` AS `Descrizione`,`aule`.`nome` AS `Aula`,`edifici`.`nome` AS `Edificio`,`universita`.`nome` AS `Universita`,`c`.`nome` AS `Corso`,concat(`utenti`.`nome`,' ',`utenti`.`cognome`) AS `UtenteResponsabile` from (((((`prenotazioni` join `aule` on((`prenotazioni`.`id_aula` = `aule`.`id_aula`))) join `edifici` on((`aule`.`id_edificio` = `edifici`.`id_edificio`))) join `utenti` on((`prenotazioni`.`id_utente` = `utenti`.`id_utente`))) left join `corsi` `c` on((`utenti`.`id_utente` = `c`.`id_utente`))) join `universita` on((`edifici`.`id_universita` = `universita`.`id_universita`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `elencouniversita`
--

/*!50001 DROP VIEW IF EXISTS `elencouniversita`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `elencouniversita` AS select `universita`.`nome` AS `Universita`,concat(`universita`.`via`,' ',`universita`.`civico`,', ',`universita`.`cap`) AS `Indirizzo` from `universita` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-22  9:54:11