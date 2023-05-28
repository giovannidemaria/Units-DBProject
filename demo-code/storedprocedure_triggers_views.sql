use PrenotazioneAuleUniversitarie;

DELIMITER //

CREATE PROCEDURE AuleDisponibili(
    IN universityName VARCHAR(50),
    IN capacity INT,
    IN bookingDate DATE,
    IN startTime TIME,
    IN endTime TIME
)
BEGIN
    DECLARE universityId INT;
    DECLARE startTimeOverlap TIME;
    DECLARE endTimeOverlap TIME;

    -- Ottieni l'ID dell'universita
    SELECT id_universita
    INTO universityId
    FROM universita
    WHERE nome = universityName;

    -- Ottieni l'ora di inizio e l'ora di fine sovrapposte delle prenotazioni
    SELECT MAX(ora_inizio)
    INTO startTimeOverlap
    FROM prenotazione
    WHERE id_aula IN (SELECT id_aula
                      FROM aula
                      WHERE id_edificio IN (SELECT id_edificio
                                            FROM edificio
                                            WHERE id_universita = universityId)
                        AND capacita >= capacity)
      AND data = bookingDate
      AND ora_inizio < endTime;

    SELECT MIN(ora_fine)
    INTO endTimeOverlap
    FROM prenotazione
    WHERE id_aula IN (SELECT id_aula
                      FROM aula
                      WHERE id_edificio IN (SELECT id_edificio
                                            FROM edificio
                                            WHERE id_universita = universityId)
                        AND capacita >= capacity)
      AND data = bookingDate
      AND ora_fine > startTime;

    -- Ottieni le aule disponibili
    SELECT *
    FROM aula
    WHERE id_edificio IN (SELECT id_edificio
                          FROM edificio
                          WHERE id_universita = universityId)
      AND capacita >= capacity
      AND id_aula NOT IN (SELECT id_aula
                          FROM prenotazione
                          WHERE data = bookingDate
                            AND (
                                  (ora_inizio >= startTime AND ora_inizio < endTime)
                                  OR (ora_fine > startTime AND ora_fine <= endTime)
                                  OR (ora_inizio <= startTime AND ora_fine >= endTime)
                                  OR (ora_inizio >= startTimeOverlap AND ora_inizio < endTimeOverlap)
                                  OR (ora_fine > startTimeOverlap AND ora_fine <= endTimeOverlap)
                                  OR (ora_inizio <= startTimeOverlap AND ora_fine >= endTimeOverlap)
                              ));
END //

DELIMITER ;


#CALL AuleDisponibili('universita degli Studi di Milano', 100, '2023-05-10', '14:00:00', '16:00:00');

DELIMITER //

CREATE PROCEDURE PrenotaAula(
    IN AulaID INT,
    IN data DATE,
    IN OraInizio TIME,
    IN OraFine TIME,
    IN Descr VARCHAR(255),
    IN CorsoID INT,
    IN UtenteID INT
)
BEGIN
    DECLARE righe_esistenti INT;
    -- Verifica se l'aula è disponibile per la prenotazione
    IF NOT EXISTS(
            SELECT *
            FROM prenotazione
            WHERE id_aula = AulaID
              AND prenotazione.data = data
              AND (
                    (prenotazione.ora_inizio >= OraInizio AND ora_inizio < OraFine)
                    OR (prenotazione.ora_fine > OraInizio AND prenotazione.ora_fine <= OraFine)
                    OR (ora_inizio <= OraInizio AND prenotazione.ora_fine >= OraFine)
                )
        )
    THEN
       -- Verifica l'esistenza delle righe nella tabella corrispondente per i valori specificati

        SELECT COUNT(*) INTO righe_esistenti
        FROM aula
        WHERE id_aula = AulaID;

        IF righe_esistenti = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La riga con AulaID specificato non esiste nella tabella aula.';
        END IF;

        SELECT COUNT(*) INTO righe_esistenti
        FROM utente
        WHERE id_utente = UtenteID;

        IF righe_esistenti = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La riga con UtenteID specificato non esiste nella tabella utenti.';
        END IF;

        SELECT COUNT(*) INTO righe_esistenti
        FROM corso
        WHERE id_corso = CorsoID;

        IF righe_esistenti = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La riga con CorsoID specificato non esiste nella tabella corsi.';
        END IF;

        -- Inserisci la nuova prenotazione
        INSERT INTO prenotazione(id_prenotazione, id_aula, data, ora_inizio, ora_fine, descrizione, id_utente, id_corso)
        VALUES (null, AulaID, data, OraInizio, OraFine, Descr, UtenteID, CorsoID);

        SELECT 'Prenotazione effettuata con successo.' AS Messaggio;
    ELSE
        SELECT 'Prenotazione fallita' AS Messaggio;
    END IF;
END //

DELIMITER ;

#CALL PrenotaAula(3, '2025-05-16', '09:00:00', '12:00:00', 'Descrizione dell\'aula', 1, 2);

DELIMITER //

CREATE PROCEDURE AnnullaPrenotazione(IN PrenotazioneID INT)
BEGIN
    DECLARE numRows INT;

    -- Controlla se la prenotazione esiste
    SELECT COUNT(*) INTO numRows
    FROM prenotazione
    WHERE id_prenotazione = PrenotazioneID;

    IF numRows = 0 THEN
        SELECT 'La prenotazione specificata non esiste.' AS Message;
    ELSE
        -- Elimina la prenotazione
        DELETE FROM prenotazione
        WHERE id_prenotazione = PrenotazioneID;

        SELECT 'Prenotazione annullata con successo.' AS Message;
    END IF;
END //


DELIMITER ;

#CALL AnnullaPrenotazione(6);

DELIMITER //

CREATE PROCEDURE ElencoPrenotazioniAula(
    IN DataInizio DATE,
    IN DataFine DATE,
    IN AulaID INT
)
BEGIN
    SELECT *
    FROM prenotazione
    WHERE id_aula = AulaID
        AND data BETWEEN DataInizio AND DataFine;
END //

CREATE PROCEDURE ElencoPrenotazioniUtente(
    IN DataInizio DATE,
    IN DataFine DATE,
    IN UtenteID INT
)
BEGIN
    SELECT *
    FROM prenotazione
    WHERE id_utente=UtenteID
        AND data BETWEEN DataInizio AND DataFine;
END //

DELIMITER ;

#CALL ElencoPrenotazioniUtente('2010-05-16', '2023-05-18', 2);

#CALL ElencoPrenotazioniAula('2010-05-16', '2023-05-18', 2);

/*

QUESTA PARTE VIENE COMMENTATA PERCHE' GIA' DEFINITA NEL FILE export.sql. SI INDICA NUOVAMENTE PER CHIAREZZA.

DELIMITER //

CREATE TRIGGER controllo_associazione_corsi_docenti
BEFORE INSERT ON corso
FOR EACH ROW
BEGIN
    DECLARE user_role VARCHAR(255);

    SELECT tipo INTO user_role
    FROM utente
    WHERE id_utente = NEW.id_utente;

    IF user_role <> 'Docente' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo gli utenti con ruolo "Docente" possono essere associati a un corso.';
    END IF;
END //


DELIMITER //

CREATE TRIGGER controllo_piu_prenotazioni_per_utente
BEFORE INSERT ON prenotazione
FOR EACH ROW
BEGIN
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
            SET MESSAGE_TEXT = 'L''utente ha già prenotato un''aula per lo stesso periodo.';
    END IF;
END //

DELIMITER //

CREATE TRIGGER controllo_piu_universita_per_edificio
BEFORE INSERT ON edificio
FOR EACH ROW
BEGIN
    DECLARE num_proprietari INT;

    -- Controlla il numero di proprietari universita attivi per l'edificio
    SELECT COUNT(*) INTO num_proprietari
    FROM edificio
    WHERE id_universita = NEW.id_universita
    AND id_edificio <> NEW.id_edificio;

    IF num_proprietari > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''edificio ha già un proprietario universita associato.';
    END IF;
END //


CREATE TRIGGER aula_edificio
BEFORE INSERT ON aula
FOR EACH ROW
BEGIN
    DECLARE num_edifici INT;

    -- Controlla il numero di edifici associati all'aula
    SELECT COUNT(*) INTO num_edifici
    FROM aula
    WHERE id_aula = NEW.id_aula
    AND id_edificio <> NEW.id_edificio;

    IF num_edifici > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''aula è già associata a un edificio diverso.';
    END IF;
END //

CREATE TRIGGER controllo_universita_utente_aula
BEFORE INSERT ON prenotazione
FOR EACH ROW
BEGIN
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
END;


DELIMITER ;


DELIMITER ;


*/


CREATE VIEW ElencoPrenotazioni AS
SELECT prenotazione.id_prenotazione AS ID,
       prenotazione.data            AS Data,
       prenotazione.ora_inizio      AS OraInizio,
       prenotazione.ora_fine        AS OraFine,
       prenotazione.descrizione     AS Descrizione,aula.nome AS Aula,
       edificio.nome                AS Edificio,universita.nome As universita ,c.nome AS Corso,concat(utente.nome,' ', utente.cognome ) AS UtenteResponsabile
FROM prenotazione
JOIN aula ON prenotazione.id_aula = aula.id_aula
JOIN edificio ON aula.id_edificio = edificio.id_edificio
JOIN utente ON prenotazione.id_utente = utente.id_utente
LEFT JOIN corso c on utente.id_utente = c.id_utente
JOIN universita ON edificio.id_universita = universita.id_universita;

CREATE VIEW ElencoAule AS
SELECT aula.id_aula  AS ID,
       aula.nome     AS Aula,
       edificio.nome AS Edificio,universita.nome AS universita,CONCAT(edificio.via,' ' , edificio.civico,', ', edificio.cap) AS Indirizzo
FROM aula
JOIN edificio ON aula.id_edificio = edificio.id_edificio
JOIN universita ON edificio.id_universita = universita.id_universita;

CREATE VIEW ElencoDocenti AS
SELECT utente.id_utente AS ID ,
       utente.nome      AS Nome,utente.cognome AS Cognome,utente.email AS Email,utente.matricola AS Matricola,universita.nome AS universitaAffiliazione
FROM utente
LEFT JOIN universita ON utente.id_universita = universita.id_universita
WHERE utente.tipo = 'Docente';

CREATE VIEW ElencoNonDocenti AS
SELECT utente.id_utente AS ID,utente.nome AS Nome,utente.cognome AS Cognome,utente.email AS Email,utente.matricola AS Matricola,universita.nome AS universitaAffiliazione
FROM utente
LEFT JOIN universita ON utente.id_universita = universita.id_universita
WHERE utente.tipo = 'Altro';

CREATE VIEW ElencoCorsi AS
SELECT c.id_utente AS ID ,c.nome AS nomeCorso, c.descrizione, CONCAT(u.nome, ' ', u.cognome) AS docente, un.nome AS universitaAffiliazione
FROM corso c
JOIN utente u ON c.id_utente = u.id_utente
JOIN universita un ON u.id_universita = un.id_universita;

CREATE VIEW ElencoDipendenti AS
SELECT dipendente.id_dipendente AS ID,
       dipendente.nome          AS Nome,dipendente.cognome AS Cognome,dipendente.email AS Email,u.nome AS universitaAffiliazione
FROM dipendente
JOIN universita u on u.id_universita = dipendente.id_universita;

CREATE VIEW ElencoEdifici AS
SELECT edificio.id_edificio AS ID ,
       edificio.nome        AS Edificio,universita.nome AS universita,CONCAT(edificio.via,' ' , edificio.civico,', ', edificio.cap) AS Indirizzo
FROM edificio
JOIN universita ON edificio.id_universita = universita.id_universita;

CREATE View ElencoUniversita AS
SELECT universita.id_universita AS ID,universita.nome AS universita, CONCAT(universita.via,' ' ,universita.civico,', ', universita.cap) AS Indirizzo
FROM universita;

create user 'utente'@'localhost' identified by 'password';
grant all privileges on PrenotazioneAuleUniversitarie.* to 'utente'@'localhost';
flush privileges;

