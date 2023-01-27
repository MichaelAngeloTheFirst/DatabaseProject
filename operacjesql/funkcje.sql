CREATE OR REPLACE VIEW wystepujacy AS 
    SELECT DISTINCT t.pseudonim AS Pseudonim_tresera,t.nazwisko AS Nazwisko_tresera,
    z.gatunek || ' ' || z.imie AS Podopieczny_tresera
    FROM  treser t, zwierze z WHERE z.treser_id = t.treser_id;   

CREATE OR REPLACE VIEW pracownicy AS
    SELECT t.treser_id, t.nazwisko, t.pseudonim FROM treser t
    UNION
    SELECT a.akrobata_id, a.nazwisko, a.pseudonim FROM akrobata a
    UNION
    SELECT  o.obsluga_id, o.nazwisko, o.zajecie FROM obsluga o;




CREATE OR REPLACE FUNCTION rezerwacja(id_wystepu int,miasto VARCHAR, data_wystepu DATE, ulgowy int, normalny int, premium int)
RETURNS TEXT AS
$$
DECLARE
    odp TEXT := 'ODPOWIEDZ:... ';
    rec_ulgowy RECORD;
    rec_normalny RECORD;
    rec_premium RECORD;
    zaplata INTEGER := 0;
    maks INTEGER := 0;
BEGIN 
    IF (ulgowy <=0) AND (normalny <=0) AND (premium <=0) THEN
        odp := 'Nie wybrano biletu lub podano nieprawidlowe wartosci!';
    ELSE
        SELECT b.cena, b.ilosc INTO rec_ulgowy FROM bilet b, wystep w, wystep_to_bilet_relation wbr WHERE  w.wystep_id=id_wystepu AND  w.lokalizacja = miasto AND w.data = data_wystepu AND  wbr.wystep_id = w.wystep_id AND b.bilet_id = wbr.bilet_id AND b.typ='ulgowy';
        SELECT b.cena, b.ilosc INTO rec_normalny FROM bilet b, wystep w, wystep_to_bilet_relation wbr WHERE w.wystep_id=id_wystepu AND w.lokalizacja = miasto AND w.data = data_wystepu AND  wbr.wystep_id = w.wystep_id AND b.bilet_id = wbr.bilet_id AND b.typ='normalny';
        SELECT b.cena, b.ilosc INTO rec_premium FROM bilet b, wystep w, wystep_to_bilet_relation wbr WHERE w.wystep_id=id_wystepu AND w.lokalizacja = miasto AND w.data = data_wystepu AND  wbr.wystep_id = w.wystep_id AND b.bilet_id = wbr.bilet_id AND b.typ='premium';
        
        -- odp := odp || miasto || ' koniec    ';

        IF ulgowy >0 THEN
            IF ulgowy <= rec_ulgowy.ilosc  THEN
                UPDATE bilet SET ilosc = ilosc - ulgowy WHERE bilet.typ = 'ulgowy';
                zaplata := zaplata + ulgowy*rec_ulgowy.cena;
                maks := maks + ulgowy;
            END IF;
        END IF;
        IF normalny >0 THEN
            IF normalny <= rec_normalny.ilosc THEN
                UPDATE bilet SET ilosc = ilosc - normalny WHERE bilet.typ = 'normalny';
                zaplata := zaplata + normalny*rec_normalny.cena;
                maks := maks + normalny;
            END IF;
        END IF;
        IF premium >0 THEN
            IF premium <= rec_premium.ilosc THEN
                UPDATE bilet SET ilosc = ilosc - premium WHERE bilet.typ = 'premium';
                zaplata := zaplata + premium*rec_premium.cena;
                maks = maks + premium;
            END IF;
        END IF;
        IF maks =0 THEN 
            odp := ' Poproszono o zbyt duzo biletow';
        ELSE
            odp :=odp|| ' Kupiono: ' || maks || 'biletow za: ' || zaplata;
        END IF;
    END IF;
    RETURN odp;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION dodaj_bilet()
RETURNS TRIGGER AS
$$
DECLARE
    odp TEXT := 'ODPOWIEDZ:... ';
BEGIN
    IF NEW.ilosc < 0 THEN
        RAISE EXCEPTION 'Liczba biletow jest ujemna';
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';  



CREATE TRIGGER sprawdz_ilosc 
BEFORE INSERT OR UPDATE OF ilosc ON bilet
FOR EACH ROW
EXECUTE FUNCTION dodaj_bilet();




CREATE OR REPLACE FUNCTION dodaj_lokalizacje(miasto VARCHAR, data_wystepu VARCHAR, insert_id INTEGER)
RETURNS TEXT AS
$$
DECLARE
    odp TEXT := 'Dodano wystep: ';
    mydata DATE := TO_DATE(data_wystepu,'YYYYMMDD');
BEGIN
    IF EXISTS (SELECT * FROM wystep WHERE lokalizacja = miasto AND data=data_wystepu::DATE) THEN
        odp:= 'podany termin z lokalizacja juz istnieje';
        RETURN odp;
    END IF;
    INSERT INTO wystep(wystep_id, lokalizacja, data) VALUES(insert_id,miasto,mydata);
    INSERT INTO wystep_to_bilet_relation(wystep_id,bilet_id) VALUES(insert_id, 701);
    INSERT INTO wystep_to_bilet_relation(wystep_id,bilet_id) VALUES(insert_id, 702);
    INSERT INTO wystep_to_bilet_relation(wystep_id,bilet_id) VALUES(insert_id, 703);
    odp := odp || miasto || ' ' || mydata;
    RETURN odp;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION pracownicy_w_wydarzeniu(id_wystepu INTEGER)
RETURNS TABLE(id INTEGER, nazwisko VARCHAR, pseudonim VARCHAR) AS
$$
DECLARE
BEGIN
    RETURN QUERY(
    SELECT t.treser_id, t.nazwisko, t.pseudonim FROM treser t, treser_to_wystep_relation ter WHERE ter.wystep_id = id_wystepu AND ter.treser_id = t.treser_id
    UNION
    SELECT a.akrobata_id, a.nazwisko, a.pseudonim FROM akrobata a, akrobata_to_wystep_relation ter WHERE ter.wystep_id = id_wystepu AND ter.akrobata_id = a.akrobata_id
    UNION
    SELECT  o.obsluga_id, o.nazwisko, o.zajecie FROM obsluga o, obsluga_to_wystep_relation ter WHERE ter.wystep_id = id_wystepu AND ter.obsluga_id = o.obsluga_id
    );
END;
$$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION pracownicy_dla_klienta(id_wystepu INTEGER)
RETURNS TABLE(nazwisko VARCHAR, pseudonim VARCHAR) AS
$$
DECLARE
BEGIN
    RETURN QUERY(
    SELECT t.nazwisko, t.pseudonim FROM treser t, treser_to_wystep_relation ter WHERE ter.wystep_id = id_wystepu AND ter.treser_id = t.treser_id
    UNION
    SELECT a.nazwisko, a.pseudonim FROM akrobata a, akrobata_to_wystep_relation ter WHERE ter.wystep_id = id_wystepu AND ter.akrobata_id = a.akrobata_id
    UNION
    SELECT  o.nazwisko, o.zajecie FROM obsluga o, obsluga_to_wystep_relation ter WHERE ter.wystep_id = id_wystepu AND ter.obsluga_id = o.obsluga_id
    );
END;
$$
LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION terminarz(id_pracownika INTEGER, id_wystepu INTEGER)
RETURNS TEXT AS 
$$
DECLARE
    odp TEXT := '';
BEGIN 
    IF EXISTS(SELECT * FROM wystep WHERE  wystep_id = id_wystepu) THEN
        IF id_pracownika/100 = 1 THEN
            IF EXISTS( SELECT * FROM treser WHERE treser_id = id_pracownika) THEN
                INSERT INTO treser_to_wystep_relation(treser_id,wystep_id) VALUES(id_pracownika,id_wystepu);
                odp :=odp || 'tresera ';
            ELSE
                odp := odp || 'nie ma w bazie podanego tresera ';
            END IF;
        ELSEIF id_pracownika/100  = 2 THEN
            IF EXISTS( SELECT * FROM akrobata WHERE akrobata_id = id_pracownika) THEN
                INSERT INTO akrobata_to_wystep_relation(akrobata_id ,wystep_id) VALUES(id_pracownika,id_wystepu);
                odp :=odp || 'akrobate ';
            ELSE
                odp := odp || 'nie ma w bazie podanego akrobaty ';
            END IF;
        ELSEIF id_pracownika/100  = 3 THEN
            IF EXISTS( SELECT * FROM obsluga WHERE obsluga_id = id_pracownika) THEN
                INSERT INTO obsluga_to_wystep_relation(obsluga_id,wystep_id) VALUES(id_pracownika,id_wystepu);
                odp :=odp || 'pracownika obslugi ';
            ELSE
                odp := odp || 'nie ma w bazie podanego pracownika obslugi ';
            END IF;
        ELSE 
            odp := odp || 'nie ma w bazie podanego pracownika';
        END IF;

    ELSE 
        odp := odp || 'podany wystep nie istnieje ';
    END IF;
    
    RETURN odp;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION zwierzeta_w_wydarzeniu(id_wystepu INTEGER)
RETURNS TEXT AS
$$
DECLARE
    odp TEXT := 'Zwierzeta w wystepie:';
    cur CURSOR FOR SELECT z.gatunek, z.imie FROM zwierze z, treser t, treser_to_wystep_relation twr, wystep w WHERE 
    w.wystep_id = id_wystepu AND twr.wystep_id = w.wystep_id AND t.treser_id = twr.treser_id AND z.treser_id =t.treser_id; 
    rec RECORD;
BEGIN
    IF EXISTS(SELECT z.gatunek, z.imie FROM zwierze z, treser t, treser_to_wystep_relation twr, wystep w WHERE 
    w.wystep_id = id_wystepu AND twr.wystep_id = w.wystep_id AND t.treser_id = twr.treser_id AND z.treser_id =t.treser_id) THEN
        OPEN cur;
        LOOP
            FETCH cur INTO rec;
            EXIT WHEN NOT FOUND;
            odp := odp || rec.gatunek || ' ' || rec.imie || ', '; 
        END LOOP;
        CLOSE cur;
    ELSE
        odp :=odp || 'Brak zwierzat w wystepie,';
    END IF;

    RETURN odp;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE VIEW smakolyki_dla_zwierzat AS 
    SELECT  'id : ' ||smakolyk_id || ', nazwa: ' || nazwa || ', cena :' || cena || CHR(10) FROM smakolyk;   

CREATE OR REPLACE FUNCTION kupno_smakolyku(imie_zwierzecia VARCHAR, id_smakolyk INTEGER)
RETURNS TEXT  AS
$$
DECLARE 
    odp TEXT := 'Informacja... ';
    rec_smakolyk RECORD;
    gatunek_zwierze VARCHAR;
BEGIN
    IF EXISTS(SELECT FROM smakolyk_to_zwierze_relation szr, zwierze z WHERE szr.smakolyk_id = id_smakolyk AND z.imie = imie_zwierzecia AND szr.zwierze_id = z.zwierze_id ) THEN
        SELECT * INTO rec_smakolyk FROM smakolyk WHERE smakolyk_id = id_smakolyk;
        SELECT gatunek INTO gatunek_zwierze FROM zwierze WHERE imie = imie_zwierzecia;
        odp:= odp || 'Mozna kupic: ' || rec_smakolyk.nazwa || ' dla ' || gatunek_zwierze || ' ' || imie_zwierzecia || ' za ' || rec_smakolyk.cena;
    ELSE
        SELECT * INTO rec_smakolyk FROM smakolyk WHERE smakolyk_id = id_smakolyk;
        SELECT gatunek INTO gatunek_zwierze FROM zwierze WHERE imie = imie_zwierzecia;
        odp:= odp || 'Nie mozna kupic: ' || rec_smakolyk.nazwa || ' dla ' || gatunek_zwierze || ' ' || imie_zwierzecia;
        SELECT * INTO rec_smakolyk FROM smakolyk s,zwierze z, smakolyk_to_zwierze_relation szr WHERE z.imie = imie_zwierzecia AND szr.zwierze_id = z.zwierze_id AND s.smakolyk_id = szr.smakolyk_id;
        odp:= odp || CHR(10) || 'Mozna natomiast kupic dla tego zwierzecia: ' ||  rec_smakolyk.nazwa || ' za ' || rec_smakolyk.cena;
    END IF;
    RETURN odp;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE VIEW lokalizacje_powtorzone AS 
    SELECT lokalizacja, COUNT(lokalizacja) AS ilosc FROM wystep GROUP BY lokalizacja HAVING COUNT(lokalizacja)>1 ORDER BY ilosc DESC ;

CREATE OR REPLACE VIEW dorobek AS
        SELECT SUM(cena*ilosc) FROM bilet;

CREATE OR REPLACE VIEW pula_biletow AS
        SELECT typ, SUM(ilosc) FROM bilet GROUP BY bilet_id ORDER BY cena ASC; 