drop database if exists FilmSphere;
create database FilmSphere;
use FilmSphere;

-- AREA CONTENUTI

CREATE TABLE Film (
	Codice int auto_increment primary key,
    Titolo varchar(100) not null,
    Genere varchar(50) not null,
    Descrizione varchar(300) not null,
    Durata int not null,
    AnnoProduzione int not null,
    PaeseProduzione varchar(50) not null,
    Regista varchar(40) not null,
    VM tinyint not null,
    NumeroVoti int not null default 0,
    MediaVoti float not null default 0,
    check (Durata > 0 AND AnnoProduzione > 0 AND VM in (0, 1))
    );
    
CREATE TABLE Lingua (
	Nome varchar(20) primary key
    );

CREATE TABLE Attore (
	Codice int auto_increment primary key,
    Nome varchar(20) not null,
    Cognome varchar(20) not null
    );

CREATE TABLE Cliente (
	Codice int auto_increment primary key,
    Password varchar(20) not null,
    Nome varchar(20) not null,
    Cognome varchar(20) not null,
    IndirizzoEmail varchar(40) not null unique,
    VM tinyint not null,
    DataIscrizione date not null,
    check (VM in (0, 1))
    );

CREATE TABLE AreaGeografica (
	Nome varchar(30) primary key
    );
    
CREATE TABLE Sottotitoli (
	Film int,
    Lingua varchar(20),
    primary key(Film, Lingua),
    foreign key (Film) references Film(Codice),
    foreign key (Lingua) references Lingua(Nome)
    );
    
CREATE TABLE Audio (
	Film int,
    Lingua varchar(20),
    primary key(Film, Lingua),
    foreign key (Film) references Film(Codice),
    foreign key (Lingua) references Lingua(Nome)
    );
    
CREATE TABLE Partecipazione (
	Film int,
    Attore int,
    primary key (Film, Attore),
    foreign key (Film) references Film(Codice),
    foreign key (Attore) references Attore(Codice)
    );

CREATE TABLE Votazione (
	Cliente int,
    Film int,
    Voto int not null,
    primary key (Cliente, Film),
    check (Voto in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)),
    foreign key (Cliente) references Cliente(Codice),
    foreign key (Film) references Film(Codice)
    );
    
CREATE TABLE DisponibilitaFilm (
	Film int,
    AreaGeografica varchar(30),
    primary key (Film, AreaGeografica),
    foreign key (Film) references Film(Codice),
    foreign key (AreaGeografica) references AreaGeografica(Nome)
    );
    

-- AREA FORMATI

CREATE TABLE Formato (
	Codice varchar(10) primary key,
    BitrateAudio int not null,
    BitrateVideo int not null,
    RapportoAspetto varchar(10) not null,
    DataRilascio date not null,
    check (BitrateAudio > 0 AND BitrateVideo > 0)
    );
    
CREATE TABLE File (
	Nome varchar(100) primary key,
    Film int not null,
    Formato varchar(10) not null,
    Dimensione int not null,
	Lunghezza int not null,
    Risoluzione varchar(20) not null,
    check (Dimensione > 0 AND Lunghezza > 0),
    foreign key (Film) references Film(Codice),
    foreign key (Formato) references Formato(Codice)
    );
    
CREATE TABLE Dispositivo (
	Tipo varchar(50) primary key
    );
    
CREATE TABLE Supporto (
	Dispositivo varchar(50),
    Formato varchar(10),
    primary key (Dispositivo, Formato),
    foreign key (Dispositivo) references Dispositivo(Tipo),
    foreign key (Formato) references Formato(Codice)
    );
    
CREATE TABLE DisponibilitaFormato (
	Formato varchar(10),
    AreaGeografica varchar(30),
    primary key (Formato, AreaGeografica),
    foreign key (Formato) references Formato(Codice),
    foreign key (AreaGeografica) references AreaGeografica(Nome)
    );


-- AREA CLIENTI

CREATE TABLE Sessione (
	IP varchar(16),
    IstanteInizio timestamp,
    Cliente int not null,
    Dispositivo varchar(50) not null,
    AreaGeografica varchar(30) not null,
    IstanteFine timestamp,
    primary key (IP, IstanteInizio),
    foreign key (Cliente) references Cliente(Codice),
    foreign key (Dispositivo) references Dispositivo(Tipo),
    foreign key (AreaGeografica) references AreaGeografica(Nome)
    );
    
CREATE TABLE Visualizzazione (
	File varchar(100),
    IstanteInizioVisualizzazione timestamp,
    IPSessione varchar(16),
    IstanteInizioSessione timestamp,
    IstanteFineVisualizzazione timestamp,
    primary key (File, IstanteinizioVisualizzazione, IPSessione, IstanteInizioSessione),
    foreign key (File) references File(Nome),
    foreign key (IPSessione, IstanteInizioSessione) references Sessione(IP, IstanteInizio)  -- per qualche motivo non lo visualizza, ma c'è (l'ho testato)
    );
    
CREATE TABLE PianoAbbonamento (
	Nome varchar(100) primary key,
    TariffaMensile int not null,
    NumeroMaxOreMensili int not null,
    NumeroMaxGBMensili int not null,
    check (TariffaMensile > 0 AND NumeroMaxOreMensili > 0 AND NumeroMaxGBMensili > 0)
    );
    
CREATE TABLE Abbonamento (
	DataInizio date,
    Cliente int,
    PianoAbbonamento varchar(100) not null,
    DataFine date,
    primary key (DataInizio, Cliente),
    foreign key (Cliente) references Cliente(Codice),
    foreign key (PianoAbbonamento) references PianoAbbonamento(Nome)
    );
    
CREATE TABLE Funzionalita (
	Nome varchar(100) primary key,
    Descrizione varchar(300) not null
    );
    
CREATE TABLE Fattura (
	Codice varchar(20) primary key,
    Importo int not null,
    DataInizioAbbonamento date not null,
    Cliente int not null,
    DataEmissione date not null,
    DataScadenza date not null,
    DataPagamento date,
    NumeroCarta varchar(16),
    DataScadenzaCarta varchar(5),
    CVC varchar(3),
    check (Importo > 0),
    foreign key (Cliente) references Cliente(Codice),
    foreign key (DataInizioAbbonamento, Cliente) references Abbonamento(DataInizio, Cliente)
    );
    
CREATE TABLE Abilitazione (
	PianoAbbonamento varchar(100),
    Funzionalita varchar(100),
    primary key (PianoAbbonamento, Funzionalita),
    foreign key (PianoAbbonamento) references PianoAbbonamento(Nome),
    foreign key (Funzionalita) references Funzionalita(Nome)
    );


-- AREA SERVER

CREATE TABLE Server (
	ID int auto_increment primary key,
    AreaGeografica varchar(30) not null,
    LarghezzaBanda int not null,
    CapacitaMaxTrasmissione int not null,
    check (LarghezzaBanda > 0 AND CapacitaMaxTrasmissione > 0 AND CapacitaMaxTrasmissione <= LarghezzaBanda),
    foreign key (AreaGeografica) references AreaGeografica(Nome)
    );
    
CREATE TABLE Utilizzo (
    IstanteInizioVisualizzazione timestamp,
    File varchar(100),
    IPSessione varchar(16),
    IstanteInizioSessione timestamp,
    Server int,
    primary key (IstanteInizioVisualizzazione, File, IPSessione, IstanteInizioSessione),
    foreign key (Server) references Server(ID),
    foreign key (File, IstanteInizioVisualizzazione, IPSessione, IstanteInizioSessione) references Visualizzazione(File, IstanteinizioVisualizzazione, IPSessione, IstanteInizioSessione)  -- per qualche motivo non lo visualizza, ma c'è (l'ho testato)
    );
    
CREATE TABLE MemorizzazioneCache (
	Server int,
    File varchar(100),
    primary key (Server, File),
    foreign key (Server) references Server(ID),
    foreign key (File) references File(Nome)
    );


-- TRIGGER PER VINCOLI
DELIMITER $$

-- "l’attributo AnnoProduzione della relazione Film deve assumere un valore ... non maggiore dell’anno corrente"
CREATE TRIGGER controllo_annoproduzione_film
BEFORE INSERT ON Film
FOR EACH ROW
	BEGIN
		IF (NEW.AnnoProduzione > YEAR(CURRENT_DATE)) THEN
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Anno di produzione del film non valido';
		END IF;
	END $$

-- "l’attributo DataIscrizione della relazione Cliente non può essere successivo alla data corrente"
CREATE TRIGGER controllo_dataiscrizione_cliente
BEFORE INSERT ON Cliente
FOR EACH ROW
	BEGIN
		IF (NEW.DataIscrizione > CURRENT_DATE) THEN
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Data di iscrizione del cliente non valida';
		END IF;
    END $$

-- "l’attributo DataRilascio della relazione Formato non può essere successivo alla data corrente"
CREATE TRIGGER controllo_datarilascio_formato
BEFORE INSERT ON Formato
FOR EACH ROW
	BEGIN
		IF (NEW.DataRilascio > CURRENT_DATE) THEN
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Data di rilascio del formato non valida';
		END IF;
    END $$

-- "gli attributi IstanteInizio, IstanteFine della relazione Sessione non possono essere successivi all’istante corrente, e IstanteFine deve essere successivo a IstanteInizio.
-- La sessione, inoltre, è valida solo se il cliente ha un abbonamento in corso nell'istante di inizio della sessione"
CREATE TRIGGER controllo_inserimento_sessione
BEFORE INSERT ON Sessione
FOR EACH ROW
	BEGIN
        DECLARE controllo int;
        
        SELECT COUNT(*) INTO controllo						-- trovo il numero di abbonamenti in corso del cliente della sessione nell'istante di inizio della sessione
        FROM Abbonamento A									-- se questo numero è 0, allora la sessione non è valida.
        WHERE A.Cliente = NEW.Cliente
			AND A.DataInizio <= DATE(NEW.IstanteInizio)
            AND (A.DataFine IS NULL OR A.DataFine >= DATE(NEW.IstanteInizio));
	
		IF (NEW.IstanteInizio > CURRENT_TIMESTAMP OR NEW.IstanteFine <= NEW.IstanteInizio OR controllo = 0) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Sessione non valida';
		END IF;
    END $$

CREATE TRIGGER controllo_aggiornamento_sessione
BEFORE UPDATE ON Sessione
FOR EACH ROW
	BEGIN
        DECLARE controllo int;
        
        SELECT COUNT(*) INTO controllo
        FROM Abbonamento A
        WHERE A.Cliente = NEW.Cliente
			AND A.DataInizio <= DATE(NEW.IstanteInizio)
            AND (A.DataFine IS NULL OR A.DataFine >= DATE(NEW.IstanteInizio));
	
		IF (NEW.IstanteInizio > CURRENT_TIMESTAMP OR NEW.IstanteFine <= NEW.IstanteInizio OR controllo = 0) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Sessione non valida';
		END IF;
    END $$

-- "gli attributi IstanteInizioVisualizzazione, IstanteFineVisualizzazione della relazione Visualizzazione non possono essere successivi all’istante corrente, e IstanteFineVisualizzazione deve essere successivo a IstanteInizioVisualizzazione.
-- IstanteInizioVisualizzazione e IstanteFineVisualizzazione inoltre, devono essere compresi tra l’istante di inizio e l’istante di fine della sessione in cui avviene tale visualizzazione;"
CREATE TRIGGER controllo_inserimentodata_visualizzazione
BEFORE INSERT ON Visualizzazione
FOR EACH ROW
	BEGIN
		DECLARE IstanteFineSessione timestamp;
        SELECT S.IstanteFine INTO IstanteFineSessione
        FROM Sessione S
        WHERE S.IP = NEW.IPSessione AND S.IstanteInizio = NEW.IstanteInizioSessione;
		IF (NEW.IstanteInizioVisualizzazione > CURRENT_TIMESTAMP OR NEW.IstanteFineVisualizzazione <= NEW.IstanteInizioVisualizzazione OR NEW.IstanteInizioVisualizzazione <= NEW.IstanteInizioSessione OR NEW.IstanteFineVisualizzazione > IstanteFineSessione) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Istante di inizio o di fine della visualizzazione non valido';
		END IF;
    END $$

CREATE TRIGGER controllo_aggiornamentodata_visualizzazione
BEFORE UPDATE ON Visualizzazione
FOR EACH ROW
	BEGIN
		DECLARE IstanteFineSessione timestamp;
        SELECT S.IstanteFine INTO IstanteFineSessione
        FROM Sessione S
        WHERE S.IP = NEW.IPSessione AND S.IstanteInizio = NEW.IstanteInizioSessione;
		IF (NEW.IstanteInizioVisualizzazione > CURRENT_TIMESTAMP OR NEW.IstanteFineVisualizzazione <= NEW.IstanteInizioVisualizzazione OR NEW.IstanteInizioVisualizzazione <= NEW.IstanteInizioSessione OR NEW.IstanteFineVisualizzazione > IstanteFineSessione) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Istante di inizio o di fine della visualizzazione non valido';
		END IF;
    END $$

-- "l’attributo File della relazione Visualizzazione deve essere relativo ad un film disponibile nell’area geografica della sessione in cui avviene tale visualizzazione, 
-- deve avere un formato disponibile nell’area geografica, deve essere supportato dal dispositivo usato nella sessione e, se il film è vietato ai minori, l’utente deve essere abilitato a guardarlo"
CREATE TRIGGER controllo_inserimento_visualizzazione
BEFORE INSERT ON Visualizzazione
FOR EACH ROW
	BEGIN
		DECLARE area_geografica_sessione varchar(30);
        DECLARE dispositivo_sessione varchar(50);
        DECLARE VM_utente tinyint;
        DECLARE controllo int default 0;
        
        SELECT S.AreaGeografica, S.Dispositivo, C.VM INTO area_geografica_sessione, dispositivo_sessione, VM_utente
        FROM Sessione S
			INNER JOIN 
            Cliente C ON S.Cliente = C.Codice
        WHERE S.IP = NEW.IPSessione AND S.IstanteInizio = NEW.IstanteInizioSessione;
        
        
        SELECT COUNT(*) INTO controllo													-- prendo il file visualizzato, e finirà nel risultato finale solo se:
        FROM File F 																	--   - il formato è tra quelli disponibili nell'area geografica della sessione;
        WHERE F.Nome = NEW.File 														--   - il formato è tra quelli supportati dal dispositivo della sessione;
			AND F.Formato IN ( 															--   - il film relativo è disponibile nell'area geografica della sessione;
							  SELECT DFO.Formato 										--   - l'utente è abilitato a guardare il film relativo, nel caso in cui fosse vietato ai minori.
                              FROM DisponibilitaFormato DFO                             -- se ciò succede, nel risultato finale avrò un solo record, e quindi count(*) restituirà 1.
                              WHERE DFO.AreaGeografica = area_geografica_sessione       -- Altrimenti, nel risultato finale non avrò alcun record, e quindi count(*) restituirà 0.
                              )															-- In quest'ultimo caso, dunque, la visualizzazione non è valida.
			AND F.Formato IN (
                              SELECT S.Formato
                              FROM Supporto S
                              WHERE S.Dispositivo = dispositivo_sessione 
                              )
			AND F.Film IN (
						    SELECT DFF.Film
                            FROM DisponibilitaFilm DFF
                            WHERE DFF.AreaGeografica = area_geografica_sessione
						  )
			AND F.Film IN (
						   SELECT F.Codice
                           FROM Film F
                           WHERE F.VM <= VM_utente
                           );
		
		IF (controllo = 0) THEN
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Visualizzazione non valida';
		END IF;
		
    END $$
    
CREATE TRIGGER controllo_aggiornamento_visualizzazione
BEFORE UPDATE ON Visualizzazione
FOR EACH ROW
	BEGIN
		DECLARE area_geografica_sessione varchar(30);
        DECLARE dispositivo_sessione varchar(50);
        DECLARE controllo int default 0;
        
        SELECT S.AreaGeografica, S.Dispositivo INTO area_geografica_sessione, dispositivo_sessione
        FROM Sessione S
        WHERE S.IP = NEW.IPSessione AND S.IstanteInizio = NEW.IstanteInizioSessione;
        
        
        SELECT COUNT(*) INTO controllo													
        FROM File F 																	
        WHERE F.Nome = NEW.File 														
			AND F.Formato IN ( 															
							  SELECT DFO.Formato 										
                              FROM DisponibilitaFormato DFO                             
                              WHERE DFO.AreaGeografica = area_geografica_sessione       
                              )
			AND F.Formato IN (
                              SELECT S.Formato
                              FROM Supporto S
                              WHERE S.Dispositivo = dispositivo_sessione 
                              )
			AND F.Film IN (
						    SELECT DFF.Film
                            FROM DisponibilitaFilm DFF
                            WHERE DFF.AreaGeografica = area_geografica_sessione
						  )
            AND F.Film IN (
						   SELECT F.Codice
                           FROM Film F
                           WHERE F.VM <= VM_utente
                           );              
		
		IF (controllo = 0) THEN
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Visualizzazione non valida';
		END IF;
		
    END $$

-- "gli attributi DataInizio, DataFine della relazione Abbonamento non possono essere successivi alla data corrente, e DataFine deve essere successiva a DataInizio.
-- DataInizio, inoltre, non deve essere precedente a DataIscrizione del cliente cui l'abbonamento è relativo"
CREATE TRIGGER controllo_inserimento_abbonamento
BEFORE INSERT ON Abbonamento
FOR EACH ROW
	BEGIN
		DECLARE DataIscrizioneCliente date;						-- trovo la data d'iscrizione del cliente cui l'abbonamento è relativo
        SELECT C.DataIscrizione INTO DataIscrizioneCliente
        FROM Cliente C
        WHERE C.Codice = NEW.Cliente;
        
		IF (NEW.DataInizio > CURRENT_DATE OR NEW.DataInizio < DataIscrizioneCliente OR NEW.DataFine < NEW.DataInizio) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Data di inizio o di fine dell\'abbonamento non valida';
		END IF;
    END $$

CREATE TRIGGER controllo_aggiornamento_abbonamento
BEFORE UPDATE ON Abbonamento
FOR EACH ROW
	BEGIN
		DECLARE DataIscrizioneCliente date;
        SELECT C.DataIscrizione INTO DataIscrizioneCliente
        FROM Cliente C
        WHERE C.Codice = NEW.Cliente;
        
		IF (NEW.DataInizio > CURRENT_DATE OR NEW.DataInizio < DataIscrizioneCliente OR NEW.DataFine < NEW.DataInizio) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Data di inizio o di fine dell\'abbonamento non valida';
		END IF;
    END $$
    
-- "gli attributi DataEmissione, DataPagamento della relazione Fattura non possono essere successivi alla data corrente, e DataPagamento e DataScadenza non possono essere precedenti a DataEmissione.
-- DataEmissione, inoltre, non deve essere precedente a DataInizioAbbonamento"
CREATE TRIGGER controllo_inserimento_fattura
BEFORE INSERT ON Fattura
FOR EACH ROW
	BEGIN
		IF (NEW.DataEmissione > CURRENT_DATE OR NEW.DataEmissione < NEW.DataInizioAbbonamento OR NEW.DataPagamento < NEW.DataEmissione OR NEW.DataScadenza < NEW.DataEmissione) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Data di emissione, di scadenza o di pagamento della fattura non valida';
		END IF;
    END $$

CREATE TRIGGER controllo_aggiornamento_fattura
BEFORE UPDATE ON Fattura
FOR EACH ROW
	BEGIN        
		IF (NEW.DataEmissione > CURRENT_DATE OR NEW.DataEmissione < NEW.DataInizioAbbonamento OR NEW.DataPagamento < NEW.DataEmissione OR NEW.DataScadenza < NEW.DataEmissione) THEN									
			SIGNAL sqlstate '45000'
            SET MESSAGE_TEXT = 'Data di emissione, di scadenza o di pagamento della fattura non valida';
		END IF;
    END $$
    

-- TRIGGER PER RIDONDANZE
-- Trigger che aggiorna le ridondanze Numero voti e Media voti in Film quando viene aggiunta una nuova Votazione
CREATE TRIGGER aggiornamento_nuovovoto_film
AFTER INSERT ON Votazione
FOR EACH ROW
	BEGIN
		DECLARE vecchia_media_voti float;
        DECLARE vecchio_numero_voti int;
        
        SELECT F.MediaVoti, F.NumeroVoti INTO vecchia_media_voti, vecchio_numero_voti
        FROM Film F
        WHERE F.Codice = NEW.Film;
        
        UPDATE Film F
        SET F.NumeroVoti = F.NumeroVoti + 1, F.MediaVoti = ((vecchia_media_voti * vecchio_numero_voti) + NEW.Voto)/(vecchio_numero_voti + 1)
        WHERE F.Codice = NEW.Film;
        
	END $$

-- Trigger che aggiorna le ridondanze Numero voti e Media voti in Film quando viene modificata una Votazione
CREATE TRIGGER aggiornamento_modificavoto_film
AFTER UPDATE ON Votazione
FOR EACH ROW
	BEGIN
		DECLARE vecchia_media_voti float;
        
        SELECT F.MediaVoti INTO vecchia_media_voti
        FROM Film F
        WHERE F.Codice = NEW.Film;
        
        UPDATE Film F
        SET F.MediaVoti = ((vecchia_media_voti * F.NumeroVoti) - OLD.Voto + NEW.Voto)/(F.NumeroVoti)
        WHERE F.Codice = NEW.Film;
        
	END $$
    
    
-- ALTRI TRIGGER

-- Trigger che chiude tutte le visualizzazioni in corso da parte di una sessione quando questa termina
CREATE TRIGGER chiusura_visualizzazioni
AFTER UPDATE ON Sessione
FOR EACH ROW
	BEGIN
		IF (OLD.IstanteFine IS NULL AND NEW.IstanteFine IS NOT NULL) THEN
			UPDATE Visualizzazione V
            SET V.IstanteFineVisualizzazione = NEW.IstanteFine
            WHERE V.IPSessione = NEW.IP AND V.IstanteInizioSessione = NEW.IstanteInizio AND V.IstanteFineVisualizzazione IS NULL;
		END IF;
    END $$

-- Trigger che elimina l'utilizzo di un server da parte di una visualizzazione quando questa termina (l'utilizzo non è più corrente)
CREATE TRIGGER cancellazioni_utilizzi_server
AFTER UPDATE ON Visualizzazione
FOR EACH ROW
	BEGIN
		IF (OLD.IstanteFineVisualizzazione IS NULL AND NEW.IstanteFineVisualizzazione IS NOT NULL) THEN
			DELETE FROM Utilizzo U
            WHERE (U.IstanteInizioVisualizzazione = NEW.IstanteInizioVisualizzazione AND U.File = NEW.File AND U.IPSessione = NEW.IPSessione AND U.IstanteInizioSessione = NEW.IstanteInizioSessione);
		END IF;
    END $$

DELIMITER ;






