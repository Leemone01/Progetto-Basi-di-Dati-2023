-- il popolamento delle tabelle è relativo al periodo 2023/04/01 - 2023/04/10

INSERT INTO Film(Titolo, Genere, Descrizione, Durata, AnnoProduzione, PaeseProduzione, Regista, VM)
VALUES ('Il Padrino','Drammatico','La saga epica di una famiglia mafiosa italo-americana che affronta il potere, la vendetta e la corruzione durante il periodo postbellico fino agli anni \'70.', 175, 1972, 'Stati Uniti', 'Francis Ford Coppola', 1),
		('La La Land', 'Musicale', 'Un pianista jazz e un\'aspirante attrice si innamorano a Los Angeles, affrontando sfide personali e professionali mentre cercano di perseguire i propri sogni.', 128, 2016, 'Stati Uniti', 'Damien Chazelle', 0),
        ('Il Signore degli Anelli: La Compagnia dell\'Anello', 'Fantastico', 'Un giovane hobbit, Frodo Baggins, intraprende un pericoloso viaggio per distruggere un potente anello e salvare la Terra di Mezzo dall\'oscurità del Signore Oscuro Sauron.', 178, 2001, 'Nuova Zelanda', 'Peter Jackson', 0),
        ('Pulp Fiction', 'Thriller', 'Una serie di storie interconnesse che coinvolgono personaggi come due gangster, un pugile, un gangster in pensione e sua moglie, con violenza, umorismo nero e dialoghi brillanti.', 154, 1994, 'Stati Uniti', 'Quentin Tarantino', 1),
        ('Forrest Gump', 'Drammatico', 'La vita straordinaria di Forrest Gump, un uomo semplice ma incredibilmente fortunato, che attraversa alcuni dei momenti più importanti della storia americana.', 142, 1994, 'Stati Uniti', 'Robert Zemeckis', 0),
        ('Schindler\'s List', 'Drammatico', 'La storia vera di Oskar Schindler, un imprenditore tedesco che salva la vita di oltre 1.000 ebrei durante l\'Olocausto, mettendo a rischio la sua stessa vita.', 195, 1993, 'Stati Uniti', 'Steven Spielberg', 0),
        ('Il Buono, il Brutto, il Cattivo', 'Western', 'Tre spietati pistoleri si scontrano nella ricerca di un tesoro nascosto durante la guerra civile americana, in un\'epica battaglia tra il bene e il male.', 178, 1996, 'Italia', 'Sergio Leone', 0),
        ('Inception', 'Fantascienza', 'Un gruppo di ladri esperti si immerge in sogno all\'interno di un sogno, cercando di rubare segreti commerciali preziosi da un sottile sottocoscienza.', 148, 2010, 'Stati Uniti', 'Christopher Nolan', 0),
        ('La Passione di Cristo', 'Religioso', 'Una rappresentazione intensa e dettagliata degli ultimi giorni di Gesù Cristo sulla Terra, incentrata sulla sua passione, morte e risurrezione secondo la tradizione cristiana.', 127, 2004, 'Stati Uniti', 'Mel Gibson', 0),
        ('Natale in India', 'Commedia', 'Le avventure di una famiglia italiana che decide di trascorrere le vacanze natalizie in India anzichè nella tradizionale atmosfera festiva a casa', 96, 2003, 'Italia', 'Neri Parenti', 0);

INSERT INTO Lingua
VALUES ('Italiano'), ('Inglese'), ('Francese'), ('Tedesco'), ('Spagnolo'), ('Russo'), ('Cinese'), ('Hindi'), ('Giapponese'), ('Coreano');

INSERT INTO Attore(Nome, Cognome)
VALUES ('Marlon', 'Brando'), ('Al', 'Pacino'), ('Ryan', 'Gosling'), ('Emma', 'Stone'), ('Elijah', 'Wood'), ('Viggo', 'Mortensen'),  ('John', 'Travolta'), ('Samuel', 'Jackson'), ('Tom', 'Hanks'), ('Robin', 'Wright'), 
		('Liam', 'Neeson'), ('Ben', 'Kingsley'), ('Clint', 'Eastwood'), ('Eli', 'Wallach'), ('Leonardo', 'DiCaprio'), ('Joseph', 'Gordon-Levitt'), ('Jim', 'Caviezel'), ('Maia', 'Morgenstern'), ('Massimo', 'Boldi'),
        ('Christian', 'De Sica');

INSERT INTO Cliente(Nome, Cognome, IndirizzoEmail, Password, DataIscrizione, VM)
VALUES ('Alice', 'Rossi', 'alice.rossi@gmail.com', 'Alice2023!', '2023-04-01', 1),
		('Marco', 'Bianchi', 'marco.bianchi@alice.it', 'Marco1234@', '2023-04-02', 1),
		('Sofia', 'Russo', 'sofia.russo@libero.it', 'Sofia!Pass', '2023-04-03', 0),
		('Matteo', 'Esposito', 'matteo.esposito@tiscali.it', 'P@ssw0rdMatteo', '2023-04-03', 1),
		('Giulia', 'Romano', 'giulia.romano@studenti.unipi.it', 'RomanoGiulia789!', '2023-04-04', 1),
		('Alessandro', 'Ferrara', 'alessandro.ferrara@gmail.com', 'Ferrara2023#', '2023-04-04', 1),
		('Martina', 'Marchetti', 'martina.marchetti@live.com', 'MarchettiMartina2023', '2023-04-04', 1),
		('Luca', 'Gentile', 'luca.gentile@email.it', 'GentileLuca!123', '2023-04-06', 1),
		('Chiara', 'Moretti', 'chiara.moretti@hotmail.it', 'MorettiC2023$', '2023-04-07', 1),
		('Francesco', 'De Luca', 'francesco.deluca@gmail.com', 'DeLucaFrancesco#23', '2023-04-07', 1);
        
INSERT INTO AreaGeografica
VALUES ('Europa'), ('Asia'), ('Africa'), ('America settentrionale'), ('America meridionale'), ('Oceania'), ('Antartide'); 

INSERT INTO Sottotitoli
VALUES (1, 'Inglese'), (1, 'Italiano'), (2, 'Inglese'), (2, 'Francese'), (3, 'Inglese'), (3, 'Spagnolo'),
		(4, 'Inglese'), (4, 'Cinese'), (5, 'Inglese'), (5, 'Coreano'), (6, 'Inglese'), (6, 'Tedesco'),
        (7, 'Italiano'), (7, 'Russo'), (8, 'Inglese'), (8, 'Giapponese'), (10, 'Italiano'), (10, 'Hindi');
        
INSERT INTO Audio
VALUES (1, 'Inglese'), (2, 'Inglese'), (3, 'Inglese'), (3, 'Italiano'), (4, 'Inglese'), (4, 'Hindi'),
		(5, 'Inglese'), (5, 'Spagnolo'), (6, 'Inglese'), (6, 'Russo'), (7, 'Inglese'), (7, 'Italiano'),
        (8, 'Inglese'), (8, 'Giapponese'), (9, 'Italiano'), (10, 'Italiano');

INSERT INTO Partecipazione
VALUES (1, 1), (1, 2), (2, 3), (2, 4), (3, 5), (3, 6), (4, 7), (4, 8), (5, 9), (5, 10), (6, 11), (6, 12),
		(7, 13), (7, 14), (8, 15), (8, 16), (9, 17), (9, 18), (10, 19), (10, 20);
        
INSERT INTO Votazione
VALUES (1, 2, 9), (3, 9, 6), (4, 3, 10), (4, 4, 9), (5, 6, 9), (5, 8, 7), (6, 7, 9), (7, 10, 10), 
		(9, 1, 5), (10, 1, 9), (10, 10, 9);
        
INSERT INTO DisponibilitaFilm
VALUES (1, 'Europa'), (2, 'Europa'), (2, 'America settentrionale'), (3, 'Europa'), (3, 'America settentrionale'),
		(3, 'America meridionale'), (4, 'Asia'), (5, 'Asia'), (5, 'America meridionale'), (6, 'Europa'), (6, 'Asia'),
        (6, 'Oceania'), (7, 'Europa'), (7, 'America settentrionale'), (7, 'Africa'), (8, 'America settentrionale'), 
        (8, 'Antartide'), (9, 'Europa'), (9, 'America settentrionale'), (9, 'America meridionale'), (9, 'Africa'),
        (10, 'Europa'), (10, 'Asia'), (10, 'Africa'), (10, 'America settentrionale'), (10, 'America meridionale'),
        (10, 'Oceania'), (10, 'Antartide');
        
INSERT INTO Formato
VALUES ('MPEG-2', 448, 10000000, '4:3', '1995-01-01'),
		('MPEG-4', 192, 30000000, '16:9', '1999-01-01'),
		('H.264', 512, 80000000, '16:9', '2003-01-01'),
		('VP9', 320, 100000000, '16:9', '2012-01-01'),
		('AV1', 320, 200000000, '16:9', '2018-01-01');
        
INSERT INTO File
VALUES ('Il_Padrino.mp2', 1, 'MPEG-2', 1500, 176, '1920 × 1440'),
	   ('La_La_Land.mp4', 2, 'MPEG-4', 1200, 128, '1920 X 1080'),
       ('Il_Signore_degli_Anelli:_La_Compagnia_dell\'Anello.mp4', 3, 'H.264', 2500, 178, '1920 X 1080'),
       ('Pulp_Fiction.webm', 4, 'VP9', 1200, 154, '1280 x 720'),
       ('Forrest_Gump.mp2', 5, 'MPEG-2', 1800, 142, '1920 x 1440'),
       ('Schindler\'s_List.webm', 6, 'VP9', 2300, 195, '1920 x 1080'),
       ('Il Buono,_il Brutto,_il Cattivo.mp4', 7, 'MPEG-4', 1900, 179, '1920 x 1080'),
       ('Inception.mp4', 8, 'H.264', 1600, 148, '1920 x 1080'),
       ('La_Passione_di_Cristo.mp4', 9, 'MPEG-4', 1000, 127, '1280 x 720'),
       ('Natale_in_India.mp2', 10, 'MPEG-2', 600, 97, '1280 × 960'),
       ('Natale_in_India.mp4', 10, 'MPEG-4', 900, 97, '1280 x 720');

INSERT INTO Dispositivo
VALUES ('Smartphone'), ('Computer'), ('Smart TV'), ('Tablet');

INSERT INTO Supporto
VALUES ('Computer', 'MPEG-2'), ('Computer', 'MPEG-4'), ('Computer', 'H.264'), ('Computer', 'VP9'), ('Computer', 'AV1'), 
		('Smart TV', 'MPEG-2'), ('Smart TV', 'MPEG-4'), ('Smart TV', 'H.264'), ('Smart TV', 'VP9'),
        ('Tablet', 'MPEG-4'), ('Tablet', 'H.264'), ('Tablet', 'VP9'),
        ('Smartphone', 'MPEG-4'), ('Smartphone', 'H.264');
        
        
INSERT INTO DisponibilitaFormato
VALUES ('MPEG-2', 'Europa'), ('MPEG-2', 'Asia'), ('MPEG-2', 'Africa'), ('MPEG-2', 'America settentrionale'), ('MPEG-2', 'America meridionale'), ('MPEG-2', 'Oceania'), ('MPEG-2', 'Antartide'),
		('MPEG-4', 'Europa'), ('MPEG-4', 'Asia'), ('MPEG-4', 'Africa'), ('MPEG-4', 'America settentrionale'), ('MPEG-4', 'America meridionale'), ('MPEG-4', 'Oceania'),
        ('H.264', 'Europa'), ('H.264', 'Asia'), ('H.264', 'America settentrionale'), ('H.264', 'America meridionale'), ('H.264', 'Oceania'),
        ('VP9', 'Europa'), ('VP9', 'Asia'), ('VP9', 'America settentrionale'), ('VP9', 'Oceania'),
        ('AV1', 'Europa'), ('AV1', 'America settentrionale'), ('AV1', 'Oceania');

INSERT INTO PianoAbbonamento
VALUES ('Basic', 5, 20, 30),
	   ('Premium', 7, 30, 40),
       ('Pro', 10, 50, 80),
       ('Deluxe', 15, 100, 120),
       ('Ultimate', 20, 120, 150);
       
INSERT INTO Abbonamento
VALUES ('2023-04-01', 1, 'Basic', NULL),
	   ('2023-04-02', 2, 'Premium', NULL),
       ('2023-04-03', 3, 'Pro', NULL),
       ('2023-04-03', 4, 'Deluxe', NULL),
       ('2023-04-04', 5, 'Basic', NULL),
       ('2023-04-04', 6, 'Premium', NULL),
       ('2023-04-04', 7, 'Pro', NULL),
       ('2023-04-06', 8, 'Basic', NULL),
       ('2023-04-07', 9, 'Premium', NULL),
       ('2023-04-07', 10, 'Basic', NULL);

INSERT INTO Server(AreaGeografica, LarghezzaBanda, CapacitaMaxTrasmissione)
VALUES  ('Europa', 1000, 100),  					
		('Europa', 1500, 150),  					
        ('Asia', 1500, 150),						
        ('Africa', 900, 90),						
		('America settentrionale', 2000, 200),		
		('America meridionale', 1200, 120),			
		('Oceania', 1000, 100),						
		('Antartide', 900, 90);	

INSERT INTO Sessione
VALUES ('192.0.2.1', '2023-04-01 08:15:00', 1, 'Computer', 'Europa', '2023-04-01 11:30:00'),
  ('203.0.113.1', '2023-04-01 14:22:00', 1, 'Smart TV', 'Europa', '2023-04-01 18:10:00'),
  ('198.51.100.10', '2023-04-02 18:45:00', 2, 'Tablet', 'Asia', '2023-04-02 21:45:00'),
  ('203.0.113.100', '2023-04-03 22:50:00', 3, 'Computer', 'Africa', '2023-04-04 02:05:00'),
  ('200.0.1.5', '2023-04-04 05:15:00', 4, 'Computer', 'Oceania', '2023-04-04 08:50:00'),
  ('192.0.2.15', '2023-04-05 11:40:00', 1, 'Tablet', 'Europa', '2023-04-05 11:55:00'),
  ('203.0.113.20', '2023-04-05 16:00:00', 5, 'Tablet', 'America meridionale', '2023-04-05 19:15:00'), 
  ('192.0.2.50', '2023-04-06 20:30:00', 2, 'Computer', 'Asia', '2023-04-06 23:45:00'), 
  ('203.0.113.200', '2023-04-07 02:10:00', 3, 'Tablet', 'Africa', '2023-04-07 02:15:00'), 
  ('198.51.100.5', '2023-04-07 07:55:00', 6, 'Tablet', 'Oceania', '2023-04-07 11:10:00'), 
  ('200.0.2.3', '2023-04-08 13:20:00', 7, 'Computer', 'Europa', '2023-04-08 16:35:00'), 
  ('192.0.2.20', '2023-04-08 17:45:00', 8, 'Smart TV', 'America settentrionale', '2023-04-08 20:00:00'),  
  ('198.51.100.5', '2023-04-09 21:10:00', 2, 'Computer', 'Asia', '2023-04-10 00:25:00'),  
  ('203.0.113.200', '2023-04-09 01:35:00', 3, 'Computer', 'Africa', '2023-04-09 04:50:00'),  
  ('200.0.1.10', '2023-04-10 06:50:00', 4, 'Tablet', 'Oceania', '2023-04-10 10:05:00'),   
  ('192.0.2.30', '2023-04-10 10:15:00', 1, 'Computer', 'Europa', '2023-04-10 13:30:00'), 
  ('203.0.113.50', '2023-04-10 14:45:00', 9, 'Smart TV', 'America meridionale', '2023-04-10 18:05:00'),  
  ('198.51.100.20', '2023-04-10 18:10:00', 10, 'Smart TV', 'Asia', '2023-04-10 20:25:00');

INSERT INTO Visualizzazione
VALUES ('La_La_Land.mp4', '2023-04-01 08:20:00', '192.0.2.1', '2023-04-01 08:15:00', '2023-04-01 10:30:00'),
	   ('Il_Signore_degli_Anelli:_La_Compagnia_dell\'Anello.mp4', '2023-04-01 14:25:00', '203.0.113.1', '2023-04-01 14:22:00', '2023-04-01 18:00:00'),
       ('Pulp_Fiction.webm', '2023-04-02 18:50:00', '198.51.100.10', '2023-04-02 18:45:00', '2023-04-02 21:30:00'),
       ('Natale_in_India.mp2', '2023-04-03 22:55:00', '203.0.113.100', '2023-04-03 22:50:00', '2023-04-04 01:00:00'),
       ('Schindler\'s_List.webm', '2023-04-04 05:20:00', '200.0.1.5', '2023-04-04 05:15:00', '2023-04-04 08:40:00'),
       ('La_Passione_di_Cristo.mp4', '2023-04-05 16:10:00', '203.0.113.20', '2023-04-05 16:00:00', '2023-04-05 17:20:00'),
       ('Forrest_Gump.mp2', '2023-04-06 20:35:00', '192.0.2.50', '2023-04-06 20:30:00', '2023-04-06 22:50:00'),
       ('Schindler\'s_List.webm', '2023-04-07 08:00:00', '198.51.100.5', '2023-04-07 07:55:00', '2023-04-07 11:05:00'),
       ('Il_Padrino.mp2', '2023-04-08 13:25:00', '200.0.2.3', '2023-04-08 13:20:00', '2023-04-08 15:40:00'),
       ('Inception.mp4', '2023-04-08 17:50:00', '192.0.2.20', '2023-04-08 17:45:00', '2023-04-08 19:55:00'),
       ('Schindler\'s_List.webm', '2023-04-09 21:15:00', '198.51.100.5', '2023-04-09 21:10:00', '2023-04-10 00:20:00'),
       ('Il Buono,_il Brutto,_il Cattivo.mp4', '2023-04-09 01:40:00', '203.0.113.200', '2023-04-09 01:35:00', '2023-04-09 04:40:00'),
       ('Schindler\'s_List.webm', '2023-04-10 07:00:00', '200.0.1.10', '2023-04-10 06:50:00', '2023-04-10 10:00:00'),
       ('Il Buono,_il Brutto,_il Cattivo.mp4', '2023-04-10 10:20:00', '192.0.2.30', '2023-04-10 10:15:00', '2023-04-10 13:20:00'),
       ('Il_Signore_degli_Anelli:_La_Compagnia_dell\'Anello.mp4', '2023-04-10 14:50:00', '203.0.113.50', '2023-04-10 14:45:00', '2023-04-10 18:00:00'),
       ('Natale_in_India.mp2', '2023-04-10 18:20:00', '198.51.100.20', '2023-04-10 18:10:00', '2023-04-10 20:20:00');

INSERT INTO Funzionalita
VALUES ('Visione dei film', 'Puoi vedere i film disponibili sul catalogo.'),
	   ('Niente pubblicità', 'Non ci saranno pubblicità durante la tua permanenza su FilmSphere.'),
       ('Download', 'Puoi salvare in locale i tuoi film preferiti, per guardarli senza essere connesso ad Internet.');

INSERT INTO Fattura
VALUES ('FAT1234', 5, '2023-04-01', 1, '2023-04-01', '2023-05-01', '2023-04-01', '1234567890123456', '12/25', '123'),
    ('FAT2345', 7, '2023-04-02', 2, '2023-04-02', '2023-05-02', '2023-04-04', '2345678901234567', '12/26', '234'),
    ('FAT3456', 10, '2023-04-03', 3, '2023-04-03', '2023-05-03', '2023-04-04', '3456789012345678', '06/27', '345'),
    ('FAT4567', 15, '2023-04-03', 4, '2023-04-03', '2023-05-03', NULL, NULL, NULL, NULL),
    ('FAT5678', 5, '2023-04-04', 5, '2023-04-04', '2023-05-04', '2023-04-07', '5678901234567890', '04/25', '567'),
    ('FAT6789', 7, '2023-04-04', 6, '2023-04-04', '2023-05-04', '2023-04-07', '6789012345678901', '08/23', '678'),
    ('FAT7890', 10, '2023-04-04', 7, '2023-04-04', '2023-05-04', NULL, NULL, NULL, NULL),
    ('FAT8901', 5, '2023-04-06', 8, '2023-04-06', '2023-05-06', NULL, NULL, NULL, NULL),
    ('FAT9012', 7, '2023-04-07', 9, '2023-04-07', '2023-05-07', '2023-04-09', '9012345678901234', '01/24', '901'),
    ('FAT0123', 5, '2023-04-07', 10, '2023-04-07', '2023-05-07', '2023-04-10', '0123456789012345', '11/25', '012');
    
    
INSERT INTO Abilitazione
VALUES ('Basic', 'Visione dei film'),
	   ('Premium', 'Visione dei film'), ('Premium', 'Niente pubblicità'),
	   ('Pro', 'Visione dei film'), ('Pro', 'Niente pubblicità'),
       ('Deluxe', 'Visione dei film'), ('Deluxe', 'Niente pubblicità'),
       ('Ultimate', 'Visione dei film'), ('Ultimate', 'Niente pubblicità'), ('Ultimate', 'Download');					
        