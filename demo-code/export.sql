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
-- Table structure for table `aula`
--

DROP TABLE IF EXISTS `aula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `aula` (
  `id_aula` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `capacita` int NOT NULL,
  `id_edificio` int NOT NULL,
  PRIMARY KEY (`id_aula`),
  KEY `aule_ibfk_1` (`id_edificio`),
  CONSTRAINT `aula_ibfk_1` FOREIGN KEY (`id_edificio`) REFERENCES `edificio` (`id_edificio`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aula`
--

LOCK TABLES `aula` WRITE;
/*!40000 ALTER TABLE `aula` DISABLE KEYS */;
INSERT INTO `aula` VALUES (1,'Aula Magna',150,1),(2,'Aula Magna',200,2),(3,'Aula 1',50,2),(4,'Aula 2',70,2),(5,'Aula 3',40,3),(6,'Aula 4',30,3),(7,'Aula Blu',60,2),(8,'Aula Boyle',200,1),(9,'Aula Leibnitz',50,2),(10,'Aula Pareto',30,4);
/*!40000 ALTER TABLE `aula` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aula_edificio` BEFORE INSERT ON `aula` FOR EACH ROW BEGIN
    DECLARE num_edifici INT;

    -- Controlla il numero di edifici associati all'aula
    SELECT COUNT(*) INTO num_edifici
    FROM aula
    WHERE id_aula = NEW.id_aula
    AND id_edificio <> NEW.id_edificio;

    IF num_edifici > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''aula è gia associata a un edificio diverso.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `corso`
--

DROP TABLE IF EXISTS `corso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `corso` (
  `id_corso` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `id_utente` int NOT NULL,
  PRIMARY KEY (`id_corso`),
  KEY `id_utente` (`id_utente`),
  CONSTRAINT `corso_ibfk_1` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corso`
--

LOCK TABLES `corso` WRITE;
/*!40000 ALTER TABLE `corso` DISABLE KEYS */;
INSERT INTO `corso` VALUES (1,'Introduzione all\'Informatica','Corso introduttivo sull\'informatica',1),(2,'Analisi Matematica 1','Corso introduttivo di Analisi Matematica',1),(3,'Fisica 1','Corso introduttivo di Fisica',2),(4,'Analisi Matematica 4','Corso avanzato di Analisi Matematica',3),(5,'Programmazione Avanzata','Corso di Java per studenti del 3^ anno',6);
/*!40000 ALTER TABLE `corso` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_associazione_corsi_docenti` BEFORE INSERT ON `corso` FOR EACH ROW BEGIN
    DECLARE user_role VARCHAR(255);

    SELECT tipo INTO user_role
    FROM utente
    WHERE id_utente = NEW.id_utente;

    IF user_role <> 'Docente' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo gli utenti con ruolo "Docente" possono essere associati a un corso.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dipendente`
--

DROP TABLE IF EXISTS `dipendente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `dipendente` (
  `id_dipendente` int NOT NULL AUTO_INCREMENT,
  `username_login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `id_universita` int NOT NULL,
  PRIMARY KEY (`id_dipendente`),
  KEY `id_universita` (`id_universita`),
  CONSTRAINT `dipendente_ibfk_1` FOREIGN KEY (`id_universita`) REFERENCES `universita` (`id_universita`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dipendente`
--

LOCK TABLES `dipendente` WRITE;
/*!40000 ALTER TABLE `dipendente` DISABLE KEYS */;
INSERT INTO `dipendente` VALUES (1,'paolo.viola','p@ssw0rd','Paolo','Viola','paolo.viola@dipendenti.unimi.it',1),(2,'silvia.marrone','pa$$word1','Silvia','Marrone','johndoe@amm.units.it',2),(3,'lucia.lilla','pa$$word2','Lucia','Lilla','janedoe@amm.units.it',2);
/*!40000 ALTER TABLE `dipendente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `edificio`
--

DROP TABLE IF EXISTS `edificio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `edificio` (
  `id_edificio` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `cap` varchar(5) NOT NULL,
  `via` varchar(50) DEFAULT NULL,
  `civico` varchar(5) DEFAULT NULL,
  `id_universita` int NOT NULL,
  PRIMARY KEY (`id_edificio`),
  KEY `edifici_ibfk_1` (`id_universita`),
  CONSTRAINT `edificio_ibfk_1` FOREIGN KEY (`id_universita`) REFERENCES `universita` (`id_universita`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `edificio`
--

LOCK TABLES `edificio` WRITE;
/*!40000 ALTER TABLE `edificio` DISABLE KEYS */;
INSERT INTO `edificio` VALUES (1,'Edificio U6','20133','Via Valerio','19',2),(2,'Dipartimento di Ingegneria e Architettura','34127','Via Valerio','6/1',2),(3,'Dipartimento di Fisica','34127','Via Valerio','2',2),(4,'Edificio 3','34100','Via degli Angeli','3',3);
/*!40000 ALTER TABLE `edificio` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_piu_universita_per_edificio` BEFORE INSERT ON `edificio` FOR EACH ROW BEGIN
    DECLARE num_proprietari INT;

    -- Controlla il numero di proprietari universita attivi per l'edificio
    SELECT COUNT(*) INTO num_proprietari
    FROM edificio
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
-- Table structure for table `prenotazione`
--

DROP TABLE IF EXISTS `prenotazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `prenotazione` (
  `id_prenotazione` int NOT NULL AUTO_INCREMENT,
  `id_aula` int NOT NULL,
  `data` date NOT NULL,
  `ora_inizio` time NOT NULL,
  `ora_fine` time NOT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `id_utente` int NOT NULL,
  `id_corso` int DEFAULT NULL,
  PRIMARY KEY (`id_prenotazione`),
  KEY `prenotazioni_ibfk_1` (`id_aula`),
  KEY `prenotazioni_ibfk_2` (`id_utente`),
  KEY `prenotazioni_ibfk_3` (`id_corso`),
  CONSTRAINT `prenotazione_ibfk_1` FOREIGN KEY (`id_aula`) REFERENCES `aula` (`id_aula`) ON DELETE CASCADE,
  CONSTRAINT `prenotazione_ibfk_2` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`id_utente`) ON DELETE CASCADE,
  CONSTRAINT `prenotazione_ibfk_3` FOREIGN KEY (`id_corso`) REFERENCES `corso` (`id_corso`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prenotazione`
--

LOCK TABLES `prenotazione` WRITE;
/*!40000 ALTER TABLE `prenotazione` DISABLE KEYS */;
INSERT INTO `prenotazione` VALUES (1,2,'2023-05-10','10:00:00','12:00:00','Lezione',1,1),(2,2,'2023-05-02','10:00:00','12:00:00','Lezione',2,1),(3,3,'2023-05-03','14:00:00','16:00:00','Esame',3,2),(4,4,'2023-05-04','08:00:00','10:00:00','Lezione',2,1),(5,4,'2020-03-01','11:00:00','12:00:00','Ritrovo di lista \"StudentiPerUnits\"',4,NULL),(6,2,'2023-05-16','09:00:00','12:00:00','Descrizione dell\'aula',2,1),(8,3,'2023-05-16','09:00:00','12:00:00','Descrizione della prenotaz',1,1),(25,10,'2023-05-08','09:18:24','12:19:31','Programmazione Avanzata',6,5);
/*!40000 ALTER TABLE `prenotazione` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_piu_prenotazioni_per_utente` BEFORE INSERT ON `prenotazione` FOR EACH ROW BEGIN
    DECLARE num_prenotazioni INT;

    -- Controlla il numero di prenotazioni attive dell'utente per la data e l'ora di inizio
    SELECT COUNT(*) INTO num_prenotazioni
    FROM prenotazione
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_universita_utente_aula` BEFORE INSERT ON `prenotazione` FOR EACH ROW BEGIN
    DECLARE aula_universita INT;
    DECLARE utente_universita INT;

    SELECT un.id_universita INTO aula_universita
    FROM aula a
    INNER JOIN edificio e ON a.id_edificio = e.id_edificio
    INNER JOIN universita un on e.id_universita = un.id_universita
    WHERE a.id_aula = NEW.id_aula;

    SELECT ut.id_universita INTO utente_universita
    FROM utente ut
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
INSERT INTO `universita` VALUES (1,'universita degli Studi di Milano','20122','Via Festa del Perdono','7'),(2,'universita degli Studi di Trieste','34127','Via Alfonso Valerio','22'),(3,'universita dei Geni','34100','Via Leonardo da Vinci','3'),(4,'universita degli Studi di Udine','33100','Via delle Scienze','206');
/*!40000 ALTER TABLE `universita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `utente` (
  `id_utente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tipo` enum('Docente','Altro') DEFAULT NULL,
  `matricola` varchar(50) DEFAULT NULL,
  `id_universita` int NOT NULL,
  PRIMARY KEY (`id_utente`),
  KEY `utenti_ibfk_1` (`id_universita`),
  CONSTRAINT `utente_ibfk_1` FOREIGN KEY (`id_universita`) REFERENCES `universita` (`id_universita`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'Mario','Rossi','mario.rossi@units.it','Docente','0001',2),(2,'Mariurizio','Arancione','maurizio.arancione@units.it','Docente','0002',2),(3,'Laura','Bianchi','laura.bianchi@units.it','Docente','5557',2),(4,'Pierino','Violetto','pierino.violetto@studenti.units.it','Altro','IN059991',2),(5,'Pierino','Blu','pierino.blu@unimigliori.it','Altro','BEST01',3),(6,'Ada','Lovelace','ada.lovelace@unimigliori.it','Docente','1234',3),(7,'Isaac','Newton','isaac.newton@unimigliori.it','Docente','9810',3),(8,'Bernhard','Riemann','bernhard.riemann@unimigliori.it','Docente','3333',3),(9,'Bernard','Bolzano','bernard.bolzano@unimigliori.it','Docente','2223',3),(10,'Karl','Gauss','karl.gauss@unimigliori.it','Docente','3321',3);
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-27 17:48:39
