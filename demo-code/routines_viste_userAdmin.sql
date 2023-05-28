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
    FROM prenotazioni
    WHERE id_aula IN (SELECT id_aula
                      FROM aule
                      WHERE id_edificio IN (SELECT id_edificio
                                            FROM edifici
                                            WHERE id_universita = universityId)
                        AND capacita >= capacity)
      AND data = bookingDate
      AND ora_inizio < endTime;

    SELECT MIN(ora_fine)
    INTO endTimeOverlap
    FROM prenotazioni
    WHERE id_aula IN (SELECT id_aula
                      FROM aule
                      WHERE id_edificio IN (SELECT id_edificio
                                            FROM edifici
                                            WHERE id_universita = universityId)
                        AND capacita >= capacity)
      AND data = bookingDate
      AND ora_fine > startTime;

    -- Ottieni le aule disponibili
    SELECT *
    FROM aule
    WHERE id_edificio IN (SELECT id_edificio
                          FROM edifici
                          WHERE id_universita = universityId)
      AND capacita >= capacity
      AND id_aula NOT IN (SELECT id_aula
                          FROM prenotazioni
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


--CALL AuleDisponibili('Universita degli Studi di Milano', 100, '2023-05-10', '14:00:00', '16:00:00');

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
    -- Verifica se l'aula è disponibile per la prenotazione
    IF NOT EXISTS(
            SELECT *
            FROM prenotazioni
            WHERE id_aula = AulaID
              AND prenotazioni.data = data
              AND (
                    (prenotazioni.ora_inizio >= OraInizio AND ora_inizio < OraFine)
                    OR (prenotazioni.ora_fine > OraInizio AND prenotazioni.ora_fine <= OraFine)
                    OR (ora_inizio <= OraInizio AND prenotazioni.ora_fine >= OraFine)
                )
        )
    THEN

        -- Inserisci la nuova prenotazione
        INSERT INTO prenotazioni(id_prenotazione,id_aula,data,ora_inizio,ora_fine,descrizione,id_utente,id_corso)
        VALUES (null, AulaID, data, OraInizio, OraFine, Descr, UtenteID, CorsoID);

        SELECT 'Prenotazione effettuata con successo.' AS Messaggio;
    ELSE
        SELECT 'Prenotazione fallita' AS Messaggio;
    END IF;
END //

DELIMITER ;

--CALL PrenotaAula(3, '2025-05-16', '09:00:00', '12:00:00', 'Descrizione dell\'aula', 1, 2);

DELIMITER //

CREATE PROCEDURE AnnullaPrenotazione(IN PrenotazioneID INT)
BEGIN
    DECLARE numRows INT;

    -- Controlla se la prenotazione esiste
    SELECT COUNT(*) INTO numRows
    FROM prenotazioni
    WHERE id_prenotazione = PrenotazioneID;

    IF numRows = 0 THEN
        SELECT 'La prenotazione specificata non esiste.' AS Message;
    ELSE
        -- Elimina la prenotazione
        DELETE FROM prenotazioni
        WHERE id_prenotazione = PrenotazioneID;

        SELECT 'Prenotazione annullata con successo.' AS Message;
    END IF;
END //


DELIMITER ;

--CALL AnnullaPrenotazione(6);

DELIMITER //

CREATE PROCEDURE ElencoPrenotazioniAula(
    IN DataInizio DATE,
    IN DataFine DATE,
    IN AulaID INT
)
BEGIN
    SELECT *
    FROM prenotazioni
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
    FROM prenotazioni
    WHERE id_utente=UtenteID
        AND data BETWEEN DataInizio AND DataFine;
END //

DELIMITER ;

--CALL ElencoPrenotazioniUtente('2010-05-16', '2023-05-18', 2);

--CALL ElencoPrenotazioniAula('2010-05-16', '2023-05-18', 2);

DELIMITER //


DELIMITER ;


CREATE VIEW ElencoPrenotazioni AS
SELECT prenotazioni.data AS Data,prenotazioni.ora_inizio AS OraInizio, prenotazioni.ora_fine AS OraFine,prenotazioni.descrizione AS Descrizione, aule.nome AS Aula, edifici.nome AS Edificio,universita.nome As Universita , c.nome AS Corso, concat(utenti.nome,' ',utenti.cognome ) AS UtenteResponsabile
FROM prenotazioni
JOIN aule ON prenotazioni.id_aula = aule.id_aula
JOIN edifici ON aule.id_edificio = edifici.id_edificio
JOIN utenti ON prenotazioni.id_utente = utenti.id_utente
LEFT JOIN corsi c on utenti.id_utente = c.id_utente
JOIN universita ON edifici.id_universita = universita.id_universita;

CREATE VIEW ElencoAule AS
SELECT aule.nome AS Aula, edifici.nome AS Edificio, universita.nome AS Universita, CONCAT(edifici.via,' ' ,edifici.civico,', ', edifici.cap) AS Indirizzo
FROM aule
JOIN edifici ON aule.id_edificio = edifici.id_edificio
JOIN universita ON edifici.id_universita = universita.id_universita;

CREATE VIEW ElencoDocenti AS
SELECT utenti.nome AS Nome, utenti.cognome AS Cognome, utenti.email AS Email, utenti.matricola AS Matricola, universita.nome AS UniversitaAffiliazione
FROM utenti
LEFT JOIN universita ON utenti.id_universita = universita.id_universita
WHERE utenti.tipo = 'Docente';

CREATE VIEW ElencoNonDocenti AS
SELECT utenti.nome AS Nome, utenti.cognome AS Cognome, utenti.email AS Email, utenti.matricola AS Matricola, universita.nome AS UniversitaAffiliazione
FROM utenti
LEFT JOIN universita ON utenti.id_universita = universita.id_universita
WHERE utenti.tipo = 'Altro';

CREATE VIEW ElencoCorsi AS
SELECT c.nome AS nomeCorso, c.descrizione, CONCAT(u.nome, ' ', u.cognome) AS docente, un.nome AS UniversitaAffiliazione
FROM corsi c
JOIN utenti u ON c.id_utente = u.id_utente
JOIN universita un ON u.id_universita = un.id_universita;

CREATE VIEW ElencoDipendenti AS
SELECT dipendenti.nome AS Nome, dipendenti.cognome AS Cognome, dipendenti.email AS Email, u.nome AS UniversitaAffiliazione
FROM dipendenti
JOIN universita u on u.id_universita = dipendenti.id_universita;

CREATE VIEW ElencoEdifici AS
SELECT edifici.nome AS Edificio, universita.nome AS Universita, CONCAT(edifici.via,' ' ,edifici.civico,', ', edifici.cap) AS Indirizzo
FROM edifici
JOIN universita ON edifici.id_universita = universita.id_universita;

CREATE View ElencoUniversita AS
SELECT universita.nome AS Universita, CONCAT(universita.via,' ' ,universita.civico,', ', universita.cap) AS Indirizzo
FROM universita;

create user 'utente'@'localhost' identified by 'password';
grant all privileges on PrenotazioneAuleUniversitarie.* to 'utente'@'localhost';
flush privileges;
