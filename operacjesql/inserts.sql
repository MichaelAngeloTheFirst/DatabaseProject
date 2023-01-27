-- tabele z wartościami

INSERT INTO treser(treser_id, pseudonim,nazwisko) VALUES(101, 'Poskramiacz','Lwowski');
INSERT INTO treser(treser_id, pseudonim,nazwisko) VALUES(102,'Fokaczino','Fokowski');
INSERT INTO treser(treser_id, pseudonim,nazwisko) VALUES(103, 'Birdman' ,'Papuzka');

INSERT INTO zwierze(zwierze_id,gatunek, imie,treser_id) VALUES(501,'Foka','Lusia',102);
INSERT INTO zwierze(zwierze_id,gatunek, imie,treser_id) VALUES(502,'Lew','Leo',101);
INSERT INTO zwierze(zwierze_id,gatunek, imie,treser_id) VALUES(503,'Papuga','Nara',103);

INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(1,'Las Vegas','2022-02-02');
INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(2,'New York','2022-03-03');
INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(3,'Krakow','2022-04-04');
INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(4,'New York','2022-05-05');
INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(5,'New York','2022-06-06');
INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(6,'Las Vegas','2022-07-07');


INSERT INTO akrobata(akrobata_id,pseudonim,nazwisko) VALUES(201,'Guma','Gumowski');
INSERT INTO akrobata(akrobata_id,pseudonim,nazwisko) VALUES(202,'Szaman','Szamowski');
INSERT INTO akrobata(akrobata_id,pseudonim,nazwisko) VALUES(203,'Ironman','Twardowski');

INSERT INTO bilet(bilet_id, cena, ilosc, typ) VALUES(701, 10, 5, 'ulgowy');
INSERT INTO bilet(bilet_id, cena, ilosc, typ) VALUES(702, 15, 5, 'normalny');
INSERT INTO bilet(bilet_id, cena, ilosc, typ) VALUES(703, 20, 5, 'premium');

INSERT INTO obsluga(obsluga_id, nazwisko, zajecie) VALUES(301,'Kowalski', 'bileter');
INSERT INTO obsluga(obsluga_id, nazwisko, zajecie) VALUES(302,'Imadlo', 'ochroniarz');
INSERT INTO obsluga(obsluga_id, nazwisko, zajecie) VALUES(303,'Czysty', 'sprzatacz');


INSERT INTO smakolyk(smakolyk_id, nazwa,cena) VALUES(801, 'sledzik',20);
INSERT INTO smakolyk(smakolyk_id, nazwa,cena) VALUES(802, 'stek',25);
INSERT INTO smakolyk(smakolyk_id, nazwa,cena) VALUES(803, 'ziarenka',20);


-- tabele asocjacyjne
INSERT INTO treser_to_wystep_relation( treser_id, wystep_id) VALUES( 101, 1);
INSERT INTO treser_to_wystep_relation( treser_id, wystep_id)VALUES( 102, 1);

INSERT INTO akrobata_to_wystep_relation( akrobata_id, wystep_id) VALUES( 201, 1);
INSERT INTO akrobata_to_wystep_relation( akrobata_id, wystep_id) VALUES( 202, 2);
INSERT INTO akrobata_to_wystep_relation( akrobata_id, wystep_id) VALUES( 203, 2);

INSERT INTO obsluga_to_wystep_relation( obsluga_id, wystep_id) VALUES( 301, 1);
INSERT INTO obsluga_to_wystep_relation( obsluga_id, wystep_id) VALUES( 302, 1);
INSERT INTO obsluga_to_wystep_relation( obsluga_id, wystep_id) VALUES( 303, 1);
INSERT INTO obsluga_to_wystep_relation( obsluga_id, wystep_id) VALUES( 303, 2);

INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(1,701);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(1,702);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(1,703);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(2,701);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(2,702);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(2,703);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(3,701);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(3,702);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(3,703);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(4,701);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(4,702);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(4,703);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(5,701);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(5,702);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(5,703);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(6,701);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(6,702);
INSERT INTO wystep_to_bilet_relation( wystep_id, bilet_id) VALUES(6,703);



INSERT INTO smakolyk_to_zwierze_relation(smakolyk_to_zwierze_id, zwierze_id, smakolyk_id) VALUES(8501, 501,801 );
INSERT INTO smakolyk_to_zwierze_relation(smakolyk_to_zwierze_id, zwierze_id, smakolyk_id) VALUES(8502, 502,802 );
INSERT INTO smakolyk_to_zwierze_relation(smakolyk_to_zwierze_id, zwierze_id, smakolyk_id) VALUES(8503, 503,803 );







 