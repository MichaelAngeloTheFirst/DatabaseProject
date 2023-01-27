import psycopg2
from DatabaseProject.config import config


def connect():
    """ Funkcja do laczenia uzytkownia z serverem bazy danych postgres"""
    conn = None
    try:

        params = config()
        print('Laczenie z baza danych PostgreSQL...')
        conn = psycopg2.connect(**params)

    # create a cursor
        cur = conn.cursor()

        # execute a statement
        print('PostgreSQL database version:')
        cur.execute('SELECT version()')

    # display the PostgreSQL database server version
        db_version = cur.fetchone()
        print(db_version)

        # close the communication with the PostgreSQL
        cur.close()
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return 0


# ------------- zamkniecie bazy
def disconnect(conn):
    """Funkcja do rozlaczania uzytkownika i servera bazy danych postgres"""
    if conn is not None:
        conn.close()
        print('Database connection closed.')
