-- "Quando un cliente richiede di visualizzare un file, viene scelto il server del CDN più conveniente che ha il contenuto richiesto"
DROP PROCEDURE IF EXISTS scelta_server;

DELIMITER $$
CREATE PROCEDURE scelta_server(IN _File varchar(100), IN _IstanteInizioVisualizzazione timestamp, IN _IPSessione varchar(16), IN _IstanteInizioSessione timestamp)
	BEGIN
		DECLARE AreaGeograficaSessione varchar(30);
        DECLARE ServerScelto int;
        DECLARE MetricaServerScelto float default 0;
        
        SELECT S.AreaGeografica INTO AreaGeograficaSessione
        FROM Sessione S
        WHERE S.IP = _IPSessione AND S.IstanteInizio = _IstanteInizioSessione;
        

		WITH Capacita_occupata_per_server_interessati AS(								-- trovo la capacità occupata dei server che hanno _File memorizzato
				SELECT S.ID, S.CapacitaMaxTrasmissione, S.AreaGeografica, IF(U.Server IS NOT NULL, 
																		     COUNT(*) * 10, 
                                                                             0) As CapacitaOccupata
				FROM Utilizzo U
					RIGHT OUTER JOIN						-- right outer join, così da considerare anche i server non coinvolti in alcuna visualizzazione
					 Server S ON U.Server = S.ID
				WHERE S.ID IN (
							   SELECT MC.Server
                               FROM MemorizzazioneCache MC
                               WHERE MC.File = _File
                               )
				GROUP BY S.ID
		),
        
			metrica_per_server AS(														-- calcolo la metricaopportunità (vedi documentazione) dei server che hanno _File memorizzato 
				SELECT COPS.ID, IF(COPS.AreaGeografica = AreaGeograficaSessione, 
								   ((COPS.CapacitaMaxTrasmissione - COPS.CapacitaOccupata)/COPS.CapacitaMaxTrasmissione), 
                                   ((COPS.CapacitaMaxTrasmissione - COPS.CapacitaOccupata)/COPS.CapacitaMaxTrasmissione) * 0.5) AS Metrica
				FROM Capacita_occupata_per_server_interessati COPS
		)
        
        SELECT MPS.ID, MPS.Metrica INTO ServerScelto, MetricaServerScelto				-- trovo un solo server avente la metrica massima
        FROM metrica_per_server MPS
        WHERE MPS.Metrica = (
						     SELECT MAX(MPS2.Metrica)
                             FROM metrica_per_server MPS2
							)
		LIMIT 1;
        
        IF (MetricaServerScelto > 0) THEN												-- solo se questo server è disponibile ad avere un nuovo utilizzo (metrica > 0, cioè non è sovraccarico), aggiungo l'utilizzo corrente di questo server da parte della visualizzazione in input.
			REPLACE INTO Utilizzo														-- REPLACE INTO servirà per cambio_server, per cambiare periodicamente il server utilizzato dalle visualizzazioni in corso
			VALUES(_IstanteInizioVisualizzazione, _File, _IPSessione, _IstanteInizioSessione, ServerScelto);
		END IF;
    END $$
DELIMITER ;


DROP TRIGGER IF EXISTS aggiunta_utilizzo_a_nuova_visualizzazione;

DELIMITER $$
CREATE TRIGGER aggiunta_utilizzo_a_nuova_visualizzazione  						
AFTER INSERT ON Visualizzazione
FOR EACH ROW
	BEGIN
		IF (NEW.IstanteFineVisualizzazione IS NULL) THEN								-- viene aggiunto un utilizzo corrente da parte di una nuova visualizzazione solo se questa è in corso 
			CALL scelta_server(NEW.File, NEW.IstanteInizioVisualizzazione, NEW.IPSessione, NEW.IstanteInizioSessione);
		END IF;
    END $$
DELIMITER ;



-- "Quando viene avviata una nuova sessione da parte di un cliente, viene fatto caching dei contenuti di cui tale cliente potrebbe richiedere la visualizzazione in opportuni server del CDN".
DROP PROCEDURE IF EXISTS caching;

DELIMITER $$
CREATE PROCEDURE caching(IN _IPSessione varchar(100), IN _IstanteInizioSessione timestamp)
	BEGIN
		DECLARE cliente int;
        DECLARE area_geografica_sessione varchar(30);
        DECLARE dispositivo_sessione varchar(50);
        DECLARE VM_utente tinyint;
        
        SELECT S.AreaGeografica, S.Dispositivo, S.Cliente, C.VM INTO area_geografica_sessione, dispositivo_sessione, cliente, VM_utente
        FROM Sessione S
			INNER JOIN
            Cliente C ON S.Cliente = C.Codice
        WHERE S.IP = _IPSessione AND S.IstanteInizio = _IstanteInizioSessione;
 
        REPLACE INTO MemorizzazioneCache												-- memorizzo i file interessati nei server interessati, se non ci sono già			
        WITH Capacita_occupata_per_server AS(
				SELECT S.ID, S.CapacitaMaxTrasmissione, S.AreaGeografica, IF(U.Server IS NOT NULL, COUNT(*) * 10, 0) As CapacitaOccupata
				FROM Utilizzo U
					RIGHT OUTER JOIN						-- right outer join, così da considerare anche i server non coinvolti in alcuna visualizzazione
					 Server S ON U.Server = S.ID
				GROUP BY S.ID
		),
        
			metrica_per_server AS(
				SELECT COPS.ID, IF(COPS.AreaGeografica = area_geografica_sessione, 
								   ((COPS.CapacitaMaxTrasmissione - COPS.CapacitaOccupata)/COPS.CapacitaMaxTrasmissione), 
                                   ((COPS.CapacitaMaxTrasmissione - COPS.CapacitaOccupata)/COPS.CapacitaMaxTrasmissione) * 0.5) AS Metrica
				FROM Capacita_occupata_per_server COPS
		),
        
			server_bersaglio AS(														-- i server interessati sono quelli con la metrica più alta e > 0 (non sovraccarichi)
				SELECT MPS.ID
				FROM metrica_per_server MPS			
				WHERE MPS.Metrica > 0
				ORDER BY MPS.Metrica DESC
				LIMIT 5
		),
		
			visualizzazioni_per_genere AS (						
				SELECT FILM.Genere, COUNT(*) AS NVisualizzazioni
				FROM Sessione S
					INNER JOIN
					Visualizzazione V ON S.IP = V.IPSessione AND S.IstanteInizio = V.IstanteInizioSessione
					INNER JOIN 
					File FILE ON V.File = FILE.Nome
					INNER JOIN
					Film FILM ON FILE.Film = FILM.Codice
				WHERE S.Cliente = cliente
				GROUP BY FILM.Genere
		),
        
			generi_preferiti AS (
				SELECT VPG.Genere
                FROM visualizzazioni_per_genere VPG
                WHERE VPG.NVisualizzazioni = (
											  SELECT MAX(VPG2.NVisualizzazioni)
                                              FROM visualizzazioni_per_genere VPG2
											 )
		),
        
			file_da_inserire AS (														-- i file interessati sono quelli relativi a film del genere preferito del cliente della sessione e visualizzabili in tale sessione
				SELECT FILE.Nome														
                FROM File FILE
					INNER JOIN
                    Film FILM ON FILE.Film = FILM.Codice
                WHERE FILM.Genere IN (													
									  SELECT* 											
                                      FROM generi_preferiti
									 )
					AND FILE.Formato IN ( 																
								  SELECT DFO.Formato 										
								  FROM DisponibilitaFormato DFO                             
								  WHERE DFO.AreaGeografica = area_geografica_sessione       
								  )
					AND FILE.Formato IN (
								  SELECT SU.Formato
								  FROM Supporto SU
								  WHERE SU.Dispositivo = dispositivo_sessione 
								  )
					AND FILE.Film IN (
								SELECT DFF.Film
								FROM DisponibilitaFilm DFF
								WHERE DFF.AreaGeografica = area_geografica_sessione
							  )
					AND FILE.Film IN (
						   SELECT FFF.Codice
                           FROM Film FFF
                           WHERE FFF.VM <= VM_utente
                           )
				ORDER BY FILM.MediaVoti DESC
                LIMIT 5
		),
        
			combinazioni_file_server AS(			
				SELECT SB.ID, FDI.Nome
                FROM server_bersaglio SB
					CROSS JOIN 								-- cross join, in maniera da avere, per ogni server interessato, i file da inserire in tale server
                    file_da_inserire FDI
		)
        SELECT*
        FROM combinazioni_file_server;
        
    END $$
DELIMITER ;
    
DROP TRIGGER IF EXISTS caching_a_nuova_sessione;

DELIMITER $$
CREATE TRIGGER caching_a_nuova_sessione
AFTER INSERT ON Sessione
FOR EACH ROW
	BEGIN
		IF (NEW.IstanteFine IS NULL) THEN												-- viene fatto caching solo se viene aggiunta una nuova sessione in corso
			CALL caching(NEW.IP, NEW.IstanteInizio);
		END IF;
    END $$
DELIMITER ;



-- "Periodicamente, per ogni visualizzazione in corso, viene rideterminato qual è il server del CDN più conveniente che ha il contenuto richiesto"
DROP EVENT IF EXISTS cambio_server;

DELIMITER $$
CREATE EVENT cambio_server
ON SCHEDULE EVERY 30 MINUTE
DO
	BEGIN									
		DECLARE FileAttuale varchar(100);
        DECLARE IstanteInizioVisualizzazioneAttuale timestamp;
        DECLARE IPSessioneAttuale varchar(16);
        DECLARE IstanteInizioSessioneAttuale timestamp;
        DECLARE finito int default 0;
        
        DECLARE cursore CURSOR FOR
			SELECT File, IstanteInizioVisualizzazione, IPSessione, IstanteInizioSessione			-- cursore per visualizzazioni in corso
            FROM Visualizzazione
            WHERE IstanteFineVisualizzazione IS NULL;
		
        DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finito = 1;
        
        OPEN cursore;
        
        scan : LOOP																													-- per ogni visualizzazione in corso, cambio il server attualmente utilizzato con quello più opportuno che ha il file richiesto memorizzato 
			FETCH cursore INTO FileAttuale, IstanteInizioVisualizzazioneAttuale, IPSessioneAttuale, IstanteInizioSessioneAttuale;	-- (lo faccio per ogni visualizzazione in corso, e non per ogni utilizzo corrente, per non tralasciare le visualizzazioni in corso che attualmente non utilizzano alcun server)    
            IF (finito = 1) THEN
				LEAVE scan;
			END IF;
                    
            CALL scelta_server(FileAttuale, IstanteInizioVisualizzazioneAttuale, IPSessioneAttuale, IstanteInizioSessioneAttuale);
        END LOOP ;
        
        CLOSE cursore;
    END $$
DELIMITER ;
    
    
    
-- "Periodicamente, i server del CDN vengono svuotati dei file non coinvolti in alcuna visualizzazione in corso". 
DROP EVENT IF EXISTS rimozione_file_cache;

DELIMITER $$
CREATE EVENT rimozione_file_cache
ON SCHEDULE EVERY 6 HOUR
DO
	BEGIN
		DELETE FROM MemorizzazioneCache MC			-- Rimuovo dai server i file per cui non c'è alcun utilizzo corrente 
        WHERE NOT EXISTS (
						  SELECT*
                          FROM Utilizzo U
                          WHERE U.File = MC.File
							AND U.Server = MC.Server
						);
    END $$
DELIMITER ;

