import psycopg2
from itertools import chain
import datetime


def treserInfo(conn):
    """
     Funkcja zwracjaca treserow
     :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
     :return out: informacja o treserach 
    """
    cur = conn.cursor()
    cur.execute('SELECT * FROM treser')
    out = cur.fetchall()
    cur.close()
    return out


def terminInfo(conn):
    """
    Funkcja zwraca informacje o terminie
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return out3: informacja o terminie 
    """
    cur = conn.cursor()
    cur.execute('SELECT wystep_id, lokalizacja, data FROM wystep')
    out = cur.fetchall()
    cur.close()
    out2 = [str(e) for e in list(chain.from_iterable(out))]
    return [', '.join(x) for x in zip(out2[0::3], out2[1::3], out2[2::3])]


def pracownikInfo(conn):
    """
    Funkcja korzystajaca z widoku pracownikow cyrku
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return out3: informacja o pracownikach
    """

    cur = conn.cursor()
    cur.execute('SELECT * FROM pracownicy')
    out = cur.fetchall()
    cur.close()
    out2 = [str(e) for e in list(chain.from_iterable(out))]
    return [', '.join(x) for x in zip(out2[0::3], out2[1::3])]


def order(conn, wystep, ulgowy, normalny, premium):
    """
    Funkcja zamawiajaca bilety
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param wystep: id wystepu
    :param ulgowy: ilosc biletow ulgowych
    :param normalny: ilosc biletow normalnych
    :param premium: ilosc biletow premium
    :return out: komunikat o dokonanym zakupie lub o bledzie ktory wystapil w trakcie
    """
    cur = conn.cursor()
    wystStr = ''.join(wystep)
    wystList = wystStr.split(', ')
    cur.callproc(
        'rezerwacja', (wystList[0], wystList[1], wystList[2], ulgowy, normalny, premium))
    conn.commit()
    out = cur.fetchall()
    cur.close()
    return out


def dodaj_termin(conn, lokalizacja, rok, miesiac, dzien, id):
    """
    Funkcja dodajaca nowy termin (lokalizaje +date) do listy wystepow
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param lokalizacja: miejsce wystepu
    :param rok: rok
    :param miesiac: miesiac
    :param dzien: dzien
    :param id: zmienna ulatwijaca insertowanie 
    :return komunikat o dodanym terminie lub o bledzie ktory wystapil w trakcie
    """
    cur = conn.cursor()
    if (len(miesiac) == 1):
        miesiac = '0'+miesiac
    if (len(dzien) == 1):
        dzien = '0'+dzien
    cur.callproc('dodaj_lokalizacje', (lokalizacja, rok+miesiac+dzien, id+1))
    conn.commit()
    out = cur.fetchall()
    cur.close()
    return out


def uzupelnij_pule(conn, ulgowy, normalny, premium):
    """
    Funkcja uzupelniajaca ilosc biletow o podana ilosc
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param ulgowy: ilosc biletow ulgowych
    :param normalny: ilosc biletow normalnych
    :param premium: ilosc biletow premium
    :return informacja: informaja o powodzeniu operacji
    """
    cur = conn.cursor()
    try:
        cur.execute(
            'UPDATE bilet SET ilosc = ilosc + %s WHERE typ = \'ulgowy\';', ulgowy)
        conn.commit()
        cur.execute(
            'UPDATE bilet SET ilosc = ilosc + %s WHERE typ = \'normalny\';', normalny)
        conn.commit()
        cur.execute(
            'UPDATE bilet SET ilosc = ilosc + %s WHERE typ = \'premium\';', premium)
        conn.commit()
    except Exception as err:
        return 'Proba dodania wartosci ujemnej... Prosze podac wartosc dodatnia'

    cur.close()
    return 'Dodano bilety do puli'


def pokaz_pracownikow(conn, id):
    """
    Funkcja do pokazywania pracownikow w konkretnym wystepie z perspektywy szefa cyrku
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param id: id wystepu
    :return out5: stosowna informacja o pracownikach w danym wystepie
    """

    cur = conn.cursor()
    cur.callproc('pracownicy_w_wydarzeniu', (id,))
    conn.commit()
    out = cur.fetchall()
    cur.close()
    if (out):
        out2 = [str(e) for e in list(chain.from_iterable(out))]
        out3 = [', '.join(x) for x in zip(out2[0::3], out2[1::3], out2[2::3])]
        return '\n'.join(out3)
    return 'brak pracownikow'


def pokaz_pracownikow_klient(conn, id):
    """
    Funkcja do pokazywania pracownikow w konkretnym wystepie z perspektywy klienta
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param id: id wystepu
    :return out5: stosowna informacja o pracownikach w danym wystepie
    """

    cur = conn.cursor()
    cur.callproc('pracownicy_dla_klienta', (id,))
    conn.commit()
    out = cur.fetchall()
    cur.close()
    if (out):
        out2 = [str(e) for e in list(chain.from_iterable(out))]
        out3 = [', '.join(x) for x in zip(out2[0::2], out2[1::2])]
        return '\n'.join(out3)
    return 'brak pracownikow'


def pokaz_zwierzeta(conn, id_wystepu):
    """
    Funkcja pokazujaca zwierzeta w danym przedstawieniu
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param id_wystepu: id wystepu
    :return out3: stosowna informacja o zwierzetach w danym wystepie
    """
    cur = conn.cursor()
    cur.callproc('zwierzeta_w_wydarzeniu', (id_wystepu,))
    conn.commit()
    odp = cur.fetchall()
    cur.close()
    out2 = [str(e) for e in list(chain.from_iterable(odp))]
    out3 = (', ').join(out2[0].split(':')[1].split(',')[:-1])
    return out3


def dodaj_pracownika(conn, id_pracownika, id_wystepu):
    """
    Funkcja dodajaca pracownika o kokretnym id do wystepu o konkretnym id
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :param id_pracownika: id pracownika
    :param id_wystepu: id wystepu
    :return out: stosowna informacja o powodzeniu dodawania pracownika
    """
    cur = conn.cursor()
    cur.callproc('terminarz', (id_pracownika, id_wystepu))
    conn.commit()
    out = cur.fetchall()
    cur.close()
    return out


def smakolyki(conn):
    """
    Funkcja pokazujaca dostepne smakolyki
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return out4: stosowna informacja o dostepnych smakolykach    
    """

    cur = conn.cursor()
    cur.execute('SELECT * FROM smakolyki_dla_zwierzat')
    out = cur.fetchall()
    cur.close()
    out2 = [str(e) for e in list(chain.from_iterable(out))]
    out3 = [' '.join(x) for x in zip(out2[0::3], out2[1::3], out2[2::3])]
    return out3[0]


def kup_smakolyk(conn, zwierze, id_smakolyk):
    """
    Funkcja pokazujaca czy danych smakolyk o podanym id jest dla wybranego zwierzecia o podanym id
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return informacja: stosowna informacja czy podany smakolyk pasuje dla danego zwierzecia, jesli nie pasuje to zwroci propozycje smakolyka    
    """

    cur = conn.cursor()
    cur.callproc('kupno_smakolyku', (zwierze, id_smakolyk))
    conn.commit()
    odp = cur.fetchall()
    cur.close()
    return ('').join([str(e) for e in list(chain.from_iterable(odp))])


def wystepy_powtorzone(conn):
    """
    Funkcja pokazujaca powtarzajace sie wystepy
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return out4: stosowna informacja o powtarzajacych sie wystepach   
    """

    cur = conn.cursor()
    cur.execute('SELECT * FROM lokalizacje_powtorzone')
    odp = cur.fetchall()
    cur.close()
    out2 = [str(e) for e in list(chain.from_iterable(odp))]
    out3 = [', '.join(x) for x in zip(out2[0::2], out2[1::2])]
    return ['\n '.join(x) for x in zip(out3[0::2], out3[1::2])][0]


def ilosc_biletow(conn):
    """
    Funkcja pokazujaca ilosc dostepnych biletow
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return out4: stosowna informacja o puli biletow    
    """
    cur = conn.cursor()
    cur.execute('SELECT * FROM pula_biletow')
    out = cur.fetchall()
    cur.close()
    out2 = [str(e) for e in list(chain.from_iterable(out))]
    out3 = [', '.join(x) for x in zip(out2[0::2], out2[1::2])]
    return '\n'.join(out3)


def dorobek(conn):
    """
    Funkcja pokazujaca przewidywany dorobek za sprzedarz wszystkich biletow w bazie
    :param conn: zmienna odpowiadajaca za przesylanie danych do bazy danych
    :return out2: stosowna informacja o przewidywanym dorobku   
    """
    cur = conn.cursor()
    cur.execute('SELECT * FROM dorobek')
    out = cur.fetchall()
    cur.close()
    return out[0][0]
