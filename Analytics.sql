-- ANALYTICS 1: CLASSIFICHE

-- CLASSIFICA PER AREA GEOGRAFICA
DROP PROCEDURE IF EXISTS classifica_film_per_area_geografica;

DELIMITER $$
CREATE PROCEDURE classifica_film_per_area_geografica()
	BEGIN
		WITH file_disponibili_per_area_geografica AS(											-- trovo i file disponibili in ogni area geografica (e cioè, i file relativi a film disponibili nell'area geografica e con un formato disponibile nell'area geografica)
			SELECT F.Nome AS File, F.Formato, DF.AreaGeografica
			FROM DisponibilitaFilm DF
				INNER JOIN
				File F ON DF.Film = F.Film
				INNER JOIN 
				DisponibilitaFormato DFO ON F.Formato = DFO.Formato
			WHERE DF.AreaGeografica = DFO.AreaGeografica
		),
        
			NumeroVisualizzazioniFileVisualizzatiPerAreaGeografica AS (							-- trovo, per ogni area geografica, il numero di visualizzazioni di ogni file che è stato visualizzato almeno una volta in tale area geografica
				SELECT V.File, F.Formato, S.AreaGeografica, COUNT(*) AS NVisualizzazioni		
				FROM Visualizzazione V
					INNER JOIN
					Sessione S ON V.IPSessione = S.IP AND V.IstanteInizioSessione = S.IstanteInizio
                    INNER JOIN 
                    File F ON V.File = F.Nome
				WHERE V.IstanteFineVisualizzazione IS NOT NULL
				GROUP BY V.File, S.AreaGeografica
		),
        
			NumeroVisualizzazioniFilePerAreaGeografica AS(										-- trovo, per ogni area geografica, il numero di visualizzazioni di ogni file, considerando solo i file effettivamente disponibili nell'area geografica
				SELECT FDPA.File, FDPA.Formato, FDPA.AreaGeografica AS AreaGeograficaVisualizzazioni, IF(NVFV.File IS NOT NULL, 
																										 NVFV.NVisualizzazioni, 
                                                                                                         0) AS NumVisualizzazioni
                FROM NumeroVisualizzazioniFileVisualizzatiPerAreaGeografica NVFV
					RIGHT OUTER JOIN									-- right outer join, così da considerare anche i file che non sono stati mai visualizzati nell'area geografica
                    file_disponibili_per_area_geografica FDPA ON (NVFV.File = FDPA.File AND NVFV.AreaGeografica = FDPA.AreaGeografica) 
		)
                    
			
			SELECT NVF.*, RANK() OVER(PARTITION BY NVF.AreaGeograficaVisualizzazioni			-- alla fine stampo la classifica
									  ORDER BY NVF.NumVisualizzazioni DESC) As PosizioneClassifica
			FROM NumeroVisualizzazioniFilePerAreaGeografica NVF;
		
    END $$
DELIMITER ;

-- CLASSIFICA PER ABBONAMENTO
DROP PROCEDURE IF EXISTS classifica_film_per_abbonamento;

DELIMITER $$
CREATE PROCEDURE classifica_film_per_abbonamento()
	BEGIN
		
        WITH associazione_file_pianoabbonamento AS (
				SELECT F.Nome AS File, F.Formato, PA.Nome AS PianoAbbonamento
				FROM File F
					CROSS JOIN											-- cross join, così da avere, per ogni piano di abbonamento, tutti i file
					PianoAbbonamento PA
		),
		
			NumeroVisualizzazioniFileVisualizzatiPerPianoAbbonamento AS (						-- trovo, per ogni piano di abbonamento, il numero di visualizzazioni di ogni file che è stato visualizzato almeno una volta da clienti con tale piano di abbonamento
				SELECT V.File, A.PianoAbbonamento, F.Formato, COUNT(*) AS NVisualizzazioni
				FROM Visualizzazione V
					INNER JOIN 
					File F ON V.File = F.Nome
					INNER JOIN
					Sessione S ON V.IPSessione = S.IP AND V.IstanteInizioSessione = S.IstanteInizio
					INNER JOIN
					Abbonamento A ON S.Cliente = A.Cliente
				WHERE V.IstanteFineVisualizzazione IS NOT NULL
					AND DATE(V.IstanteInizioVisualizzazione) >= A.DataInizio 
					AND (DATE(V.IstanteInizioVisualizzazione) <= A.DataFine OR A.DataFine IS NULL)
				GROUP BY V.File, A.PianoAbbonamento
        ),   
        
			NumeroVisualizzazioniFilePerPianoAbbonamento AS (									-- trovo, per ogni piano di abbonamento, il numero di visualizzazioni di ogni file
				SELECT AFP.File, AFP.PianoAbbonamento, AFP.Formato, IF(NVFV.File IS NOT NULL, NVFV.NVisualizzazioni, 0) AS NumVisualizzazioni
                FROM NumeroVisualizzazioniFileVisualizzatiPerPianoAbbonamento NVFV
					RIGHT OUTER JOIN  									-- right outer join, così da considerare anche i file che non sono stati mai visualizzati da clienti con un certo piano di abbonamento 
                    associazione_file_pianoabbonamento AFP ON (NVFV.File = AFP.File AND NVFV.PianoAbbonamento = AFP.PianoAbbonamento)
		)
        
			SELECT NVFPA.*, RANK() OVER(PARTITION BY NVFPA.PianoAbbonamento						-- alla fine stampo la classifica
									    ORDER BY NVFPA.NumVisualizzazioni DESC) AS PosizioneClassifica
            FROM NumeroVisualizzazioniFilePerPianoAbbonamento NVFPA;
        
    END $$
DELIMITER ;


-- ANALYTICS 2: BILANCIAMENTO DEL CARICO
DROP PROCEDURE IF EXISTS suggerimento_spostamenti;

DELIMITER $$
CREATE PROCEDURE suggerimento_spostamenti()
	BEGIN														
		DECLARE FileAttuale varchar(100);
        DECLARE ServerAttuale int;
        DECLARE NUtilizziAttuali int;
        DECLARE MetricaServerAttuale float;
        
        DECLARE ServerScelto int;
        DECLARE CapacitaMaxTrasmissioneServerScelto int;
        DECLARE CapacitaOccupataServerScelto int;
	
        DECLARE finito int default 0;
        
        DECLARE cursore CURSOR FOR
			SELECT U.File, U.Server, COUNT(*) AS NUtilizzi										-- cursore per NUtilizzi correnti dei file per server
            FROM Utilizzo U
            GROUP BY U.File, U.Server;
		
        DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finito = 1;
        
        DROP TABLE IF EXISTS Suggerimento;														-- tabella che conterrà i suggerimenti di spostamenti
        CREATE TABLE Suggerimento(
			File varchar(100),
            ServerAttuale int,
            ServerConsigliato int,
            primary key(File, ServerAttuale)
		);
        
        DROP TABLE IF EXISTS ServerEUtilizziTeorici;											-- tabella che conterrà, per ogni server, la capacità max di trasmissione, la capacità occupata e la metricasovraccarico (vedi documentazione),
        CREATE TABLE ServerEUtilizziTeorici(													-- aggiornate in base ai suggerimenti effettuati.
			Server int primary key,
            Metrica float,
            CapacitaMaxTrasmissione int, 
            CapacitaOccupata int
		);
        
        
        INSERT INTO ServerEUtilizziTeorici														-- riempio ServerEUtilizziTeorici con i dati correnti								
			WITH Capacita_occupata_per_server AS(							
						SELECT S.ID, S.CapacitaMaxTrasmissione, IF(U.Server IS NOT NULL, COUNT(*) * 10, 0) As CapacitaOccupata
						FROM Utilizzo U
							RIGHT OUTER JOIN							-- right outer join, così da considerare anche i server non coinvolti in alcuna visualizzazione
							 Server S ON U.Server = S.ID
						GROUP BY S.ID
			)
			
			SELECT COPS.ID, ((COPS.CapacitaMaxTrasmissione - COPS.CapacitaOccupata)/COPS.CapacitaMaxTrasmissione), COPS.CapacitaMaxTrasmissione, COPS.CapacitaOccupata 
			FROM Capacita_occupata_per_server COPS;
			
        
        OPEN cursore;																			
																								
        scan : LOOP
			FETCH cursore INTO FileAttuale, ServerAttuale, NUtilizziAttuali;					-- scorro ora gli NUtilizzi correnti dei file per server, per vedere se conviene spostare un file in un altro server (e con esso gli utilizzi coinvolti) o meno.
            IF (finito = 1) THEN																-- il server in cui eventualmente effettuare lo spostamento è quello che presenta la metrica massima, tenendo conto anche dei suggerimenti già effettuati
				LEAVE scan;
			END IF;
            
            SELECT SEUT.Metrica INTO MetricaServerAttuale										-- trovo la metrica del server puntato dal cursore (in breve, "server attuale")
            FROM ServerEUtilizziTeorici SEUT
            WHERE SEUT.Server = ServerAttuale;
            
            SELECT SEUT.Server, SEUT.CapacitaMaxTrasmissione, SEUT.CapacitaOccupata INTO ServerScelto, CapacitaMaxTrasmissioneServerScelto, CapacitaOccupataServerScelto	-- trovo informazioni su un solo server con la metrica massima
            FROM ServerEUtilizziTeorici SEUT
            WHERE SEUT.Metrica = (
								  SELECT MAX(SEUT.Metrica)
								  FROM ServerEUtilizziTeorici
                                  )
			LIMIT 1;
            
            -- se il server con la metrica massima è diverso dal server attuale, il server attuale è sovraccarico e, spostando il file nel server con la metrica massima (e con esso gli utilizzi coinvolti), questo non diventa a sua volta sovraccarico, 
            -- allora suggerisco lo spostamento tra i due server. Aggiorno poi ServerEUtilizziTeorici, modificando opportunamente la metrica e la capacità occupata di tali server.
            IF (ServerAttuale <> ServerScelto AND MetricaServerAttuale < 0.2 AND ((CapacitaMaxTrasmissioneServerScelto - (CapacitaOccupataServerScelto + NUtilizziAttuali * 10))/CapacitaMaxTrasmissioneServerScelto) >= 0.2) THEN
				INSERT INTO Suggerimento
                VALUES(FileAttuale, ServerAttuale, ServerScelto);
                
                UPDATE ServerEUtilizziTeorici SEUT
                SET SEUT.Metrica = ((SEUT.CapacitaMaxTrasmissione - (SEUT.CapacitaOccupata - NUtilizziAttuali * 10))/SEUT.CapacitaMaxTrasmissione), SEUT.CapacitaOccupata = SEUT.CapacitaOccupata - 10 * NUtilizziAttuali
                WHERE SEUT.Server = ServerAttuale;
                
                UPDATE ServerEUtilizziTeorici SEUT
                SET SEUT.Metrica = ((SEUT.CapacitaMaxTrasmissione - (SEUT.CapacitaOccupata + NUtilizziAttuali * 10))/SEUT.CapacitaMaxTrasmissione), SEUT.CapacitaOccupata = SEUT.CapacitaOccupata + 10 * NUtilizziAttuali
                WHERE SEUT.Server = ServerScelto;
            END IF;
		
        END LOOP ;
        
        CLOSE cursore;
        
        SELECT*																					-- alla fine stampo i suggerimenti
        FROM Suggerimento;
    END $$
DELIMITER ;