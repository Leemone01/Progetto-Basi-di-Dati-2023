-- OPERAZIONE 1: vedere il voto complessivo di un film
DROP PROCEDURE IF EXISTS voto_film;

DELIMITER $$
CREATE PROCEDURE voto_film(IN _film int)
	BEGIN
		SELECT F.MediaVoti
        FROM Film F
        WHERE F.Codice = _film;
    END $$
DELIMITER ;


-- OPERAZIONE 2: calcolare il numero di minuti di film visualizzati da un cliente
DROP PROCEDURE IF EXISTS minuti_visualizzati;

DELIMITER $$
CREATE PROCEDURE minuti_visualizzati(IN _cliente int)
	BEGIN
		WITH durata_visualizzazione AS (																		-- trovo la durata di ogni visualizzazione.
			SELECT IF(V.IstanteFineVisualizzazione IS NOT NULL, 												-- per una visualizzazione ancora in corso, calcolo la durata come il tempo trascorso tra l'istante d'inizio della visualizzazione e l'istante corrente
					  TIMESTAMPDIFF(MINUTE, V.IstanteInizioVisualizzazione, V.IstanteFineVisualizzazione), 		
                      TIMESTAMPDIFF(MINUTE, V.IstanteInizioVisualizzazione, current_timestamp)) AS Durata
			FROM Sessione S
				INNER JOIN
				Visualizzazione V ON S.IP = V.IPSessione AND S.IstanteInizio = V.IstanteInizioSessione
			WHERE S.Cliente = _cliente
		)
        SELECT SUM(Durata) As Minuti
        FROM durata_visualizzazione;
    END $$
DELIMITER ;


-- OPERAZIONE 3: inserire una nuova visualizzazione
DROP PROCEDURE IF EXISTS inserimento_visualizzazione;

DELIMITER $$
CREATE PROCEDURE inserimento_visualizzazione(IN _IPSessione varchar(16), IN _IstanteInizioSessione timestamp, IN _IstanteInizioVisualizzazione timestamp, IN _File int, IN _IstanteFineVisualizzazione timestamp)
	BEGIN
		INSERT INTO Visualizzazione
        VALUES (_File, _IstanteInizioVisualizzazione, _IPSessione, _IstanteInizioSessione, _IstanteFineVisualizzazione);
    END $$
DELIMITER ;


-- OPERAZIONE 4: calcolare il numero di abbonamenti in corso relativi ad un piano di abbonamento
DROP PROCEDURE IF EXISTS numero_abbonamenti_in_corso;

DELIMITER $$
CREATE PROCEDURE numero_abbonamenti_in_corso(IN _PianoAbbonamento varchar(100))
	BEGIN
		SELECT COUNT(*) As Numero
        FROM Abbonamento
        WHERE PianoAbbonamento = _PianoAbbonamento
			AND DataFine IS NULL;
    END $$
DELIMITER ;

-- OPERAZIONE 5: trovare il codice, la data di emissione e la data di scadenza delle fatture non pagate di un cliente, con indicato nome e cognome
DROP PROCEDURE IF EXISTS fatture_non_pagate;

DELIMITER $$
CREATE PROCEDURE fatture_non_pagate(IN _Cliente int)
	BEGIN
		SELECT F.Codice, F.DataEmissione, F.DataScadenza, F.DataPagamento, C.Nome, C.Cognome
        FROM Fattura F
			INNER JOIN
            Cliente C ON F.Cliente = C.Codice
        WHERE F.Cliente = _Cliente
			AND F.DataPagamento IS NULL;
    END $$
DELIMITER ;

-- OPERAZIONE 6: calcolare da quanti giorni un cliente è iscritto
DROP PROCEDURE IF EXISTS giorni_da_iscrizione;

DELIMITER $$
CREATE PROCEDURE giorni_da_iscrizione(IN _Cliente int)
	BEGIN
		SELECT DATEDIFF(current_date, DataIscrizione) AS NumeroGiorni
        FROM Cliente
        WHERE Codice = _Cliente;
    END $$
DELIMITER ;

-- OPERAZIONE 7: trovare informazioni sui file in cui è memorizzato un film, e informazioni sui rispettivi formati
DROP PROCEDURE IF EXISTS info_file_e_formati;

DELIMITER $$
CREATE PROCEDURE info_file_e_formati(IN _Film int)
	BEGIN
		SELECT FI.Nome, FI.Formato, FI.Dimensione, FI.Lunghezza, FI.Risoluzione, FO.BitrateAudio, FO.BitrateVideo, FO.RapportoAspetto, FO.DataRilascio AS DataRilascioFormato
        FROM File FI
			INNER JOIN
            Formato FO ON FI.Formato = FO.Codice
		WHERE FI.Film = _Film;
    END $$
DELIMITER ;

-- OPERAZIONE 8: trovare i file memorizzati in un server, con codice del formato e codice del film relativi
DROP PROCEDURE IF EXISTS film_memorizzati_in_server;

DELIMITER $$
CREATE PROCEDURE film_memorizzati_in_server(IN _ID int)
	BEGIN
		SELECT F.*
        FROM MemorizzazioneCache MC
			INNER JOIN
            File F ON MC.File = F.Nome
		WHERE MC.Server = _ID;
    END $$
DELIMITER ;
