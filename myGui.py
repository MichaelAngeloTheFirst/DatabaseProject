import PySimpleGUI as sg
from DatabaseProject.dbConnection import connect
from DatabaseProject.dbConnection import disconnect
import DatabaseProject.functonality as fun

if __name__ == '__main__':

    conn = connect()

    SYMBOL_UP = '▲'
    SYMBOL_DOWN = '▼'

    change = 0

    def collapse(layout, key):
        """ Funkcja do zamykania sekcji szefa i klienta"""
        return sg.pin(sg.Column(layout, key=key))

    sg.theme('DarkAmber')

    mylist = fun.terminInfo(conn)
    pracownikList = fun.pracownikInfo(conn)

    section1 = [[sg.Text('Wybierz przedstawienie')],
                [sg.Listbox(values=mylist, size=(30, 4), key='termin')],
                [sg.Button('Pracownicy w wydarzeniu')],
                [sg.Text('Pokaz zwierzeta w danym przedstawieniu'), sg.Button('Pokaz zwierzeta'),
                sg.Text('Pokaz dostepne smakolyki dla zwierzat'), sg.Button('Pokaz smakolyki')],
                [sg.Text('Nakarm wybrane zwierze!'), sg.Text('Podaj imie zwierzecia'), sg.Input('Lusia', size=(10, 1), key='zwierze'),
                sg.Text('Podaj id smakolyka'), sg.Input(
                    '801', size=(3, 1), key='id_smakolyk'),
                sg.Button('Kup smakolyk')],
                [sg.Text('Bilety Ulgowe:'), sg.Input('0', size=(3, 1), key='ulgowy'), sg.Text('Bilety Normalne:'),
                sg.Input('0', size=(3, 1), key='normalny'),
                sg.Text('Loza Premium:'), sg.Input('0', size=(3, 1), key='premium'), sg.Button('Zamow')],

                ]

    section2 = [
        [sg.Text('Wystaw przedstawienia')],
        [sg.Button('Wystepy w tym samym miescie')],
        [sg.Listbox(values=mylist, size=(30, 4), key='terminSzef'), sg.Text(
            'Pokaz pracownikow dla wybranego miasta z listy'), sg.Button('Pracownicy')],
        [sg.Text('Lokalizacja:'), sg.Input('Tokyo', key='lokalizacjaSzef')],
        [sg.Text('Data w formacie(YYYY-MM-DD): Rok: '), sg.Input('2000', size=(4, 1), key='rokSzef'), sg.Text('Miesiac: '),
         sg.Input('1', size=(2, 1), key='miesiacSzef'), sg.Text('Dzien: '), sg.Input('1', size=(2, 1), key='dzienSzef')],
        [sg.Button('Dodaj termin')],
        [sg.Listbox(values=pracownikList, size=(40, 4), key='pracownikSzef')],
        [sg.Text('Dodaj pracownikow podajac ich id do wybranego przedstawienia')],
        [sg.Text('Dodaj treserow'), sg.Input('0', size=(3, 1), key='treserSzef'), sg.Text('Dodaj akrobatów'),
         sg.Input('0', size=(3, 1), key='akrobataSzef'), sg.Text(
             'Dodaj obsluge'), sg.Input('0', size=(3, 1), key='obslugaSzef'),
         sg.Button('Dodaj pracownikow')],

        [sg.Text('Dodaj bilety do puli')],
        [sg.Text('Bilety Ulgowe:'), sg.Input('0', size=(3, 1), key='ulgowySzef'),
         sg.Text('Bilety Normalne:'), sg.Input(
             '0', size=(3, 1), key='normalnySzef'),
         sg.Text('Lorza Premium:'), sg.Input('0', size=(3, 1), key='premiumSzef'), sg.Button('Dodaj')],
        [sg.Button('Ilosc biletow'), sg.Button(
            'Dorobek przewidywany')],

    ]

    layout = [[sg.Text('Witajcie w Cyrku \'Santino\', gdzie spelniaja sie najskrytsze marzenia!'), sg.Text(size=(20, 1), key='-OUTPUT2-')],
              [sg.Button('Zaladuj', button_color='white on red')],


              #### Section 1 part ####
              [sg.T(SYMBOL_DOWN, enable_events=True, k='-OPEN SEC1-', text_color='yellow'),
               sg.T('Sekcja Klienta', enable_events=True, text_color='yellow', k='-OPEN SEC1-TEXT')],
              [collapse(section1, '-SEC1-')],
              #### Section 2 part ####
              [sg.T(SYMBOL_DOWN, enable_events=True, k='-OPEN SEC2-', text_color='red'),
               sg.T('Sekcja Szefa Cyrku', enable_events=True, text_color='red', k='-OPEN SEC2-TEXT')],
              [collapse(section2, '-SEC2-')],


              [sg.Button('Exit')]

              ]

    window = sg.Window('Cyrk Santino', layout)

    opened1, opened2 = True, True

    while True:  # Event Loop
        event, values = window.read()
        if event == sg.WIN_CLOSED or event == 'Exit' or conn == None:
            break

        # ------------klient akcje
        if event == 'Zamow':
            if (values['termin'] != []):
                text_input2 = fun.order(
                    conn, values['termin'], values['ulgowy'], values['normalny'], values['premium'])
                sg.popup('Rezerwacja', ''.join(text_input2[0]))
            else:
                sg.popup('ERROR', 'Prosze wybrac termin z tabeli terminow klienta')

        if event == 'Pokaz zwierzeta':
            if (values['termin'] != []):
                sg.popup('Zwierzeta w wystepie', fun.pokaz_zwierzeta(
                    conn, values['termin'][0].split(', ')[0]))
            else:
                sg.popup('ERROR', 'Prosze wybrac wystep')

        if event == 'Pracownicy w wydarzeniu':
            if (values['termin'] != []):
                sg.popup('Pracownicy w wydarzeniu', fun.pokaz_pracownikow_klient(
                    conn, values['termin'][0].split(', ')[0]))
            else:
                sg.popup('ERROR', 'Prosze wybrac termin z tabeli terminow')

        if event == 'Pokaz smakolyki':
            sg.popup('Dostepne smakolyki', fun.smakolyki(conn))

        if event == 'Kup smakolyk':
            if (values['zwierze'] != [] and values['id_smakolyk'] != []):
                sg.popup('Smakolyk', fun.kup_smakolyk(
                    conn, values['zwierze'], values['id_smakolyk']))
            else:
                sg.popup('ERROR', 'Wprowadzono bledne dane')

        # ------------szef akcje
        if event == 'Wystepy w tym samym miescie':
            sg.popup('Miasta, w których powtorzyly sie wystepy',
                     fun.wystepy_powtorzone(conn))

        if event == 'Dodaj':
            text_input3 = fun.uzupelnij_pule(
                conn, values['ulgowySzef'], values['normalnySzef'], values['premiumSzef'])
            sg.popup('Dodanie do puli', text_input3)

        if event == 'Dodaj termin':
            if (values['lokalizacjaSzef'] != '' and values['rokSzef'] != '' and values['miesiacSzef'] != '' and values['dzienSzef'] != ''):
                sg.popup('Wystep', fun.dodaj_termin(
                    conn, values['lokalizacjaSzef'], values['rokSzef'], values['miesiacSzef'], values['dzienSzef'], len(mylist)))
                mylist = fun.terminInfo(conn)
                window['terminSzef'].update(fun.terminInfo(conn))
                window['termin'].update(fun.terminInfo(conn))
            else:
                sg.popup('ERROR', 'Sprawdz ponownie przekazywane parametry')

        if event == 'Pracownicy':
            if (values['terminSzef'] != []):
                sg.popup('Pracownicy w wydarzeniu', fun.pokaz_pracownikow(
                    conn, values['terminSzef'][0].split(', ')[0]))
            else:
                sg.popup('ERROR', 'Prosze wybrac termin z tabeli terminow szefa')

        if event == 'Dodaj pracownikow':
            odp = 'Dodano: \n'
            if (values['terminSzef'] != []):
                if (values['treserSzef'] != '0'):
                    odp += fun.dodaj_pracownika(conn, int(values['treserSzef']), int(
                        values['terminSzef'][0].split(', ')[0]))[0][0]
                    odp += '\n'
                if (values['akrobataSzef'] != '0'):
                    odp += fun.dodaj_pracownika(conn, int(values['akrobataSzef']), int(
                        values['terminSzef'][0].split(', ')[0]))[0][0]
                    odp += '\n'
                if (values['obslugaSzef'] != '0'):
                    odp += fun.dodaj_pracownika(conn, int(values['obslugaSzef']), int(
                        values['terminSzef'][0].split(', ')[0]))[0][0]

                sg.popup(odp)
            else:
                sg.popup('ERROR', 'Nie wybrano zadnego wystepu')

        if event == 'Ilosc biletow':
            sg.popup('Ilosc biletow w puli', fun.ilosc_biletow(conn))

        if event == 'Dorobek przewidywany':
            sg.popup('Dorobek w $', fun.dorobek(conn))

        # ---------podzial na sekcje
        if event.startswith('-OPEN SEC1-'):
            opened1 = not opened1
            window['-OPEN SEC1-'].update(SYMBOL_DOWN if opened1 else SYMBOL_UP)
            window['-SEC1-'].update(visible=opened1)

        if event.startswith('-OPEN SEC2-'):
            opened2 = not opened2
            window['-OPEN SEC2-'].update(SYMBOL_DOWN if opened2 else SYMBOL_UP)
            window['-SEC2-'].update(visible=opened2)

        termin = values['termin']
        # print(termin)
        # print(values['ulgowy'])

    window.close()
    disconnect(conn)
