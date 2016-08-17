#!/usr/bin/python
# -*- coding: utf-8 -*-

import urllib2
import sys
import pynotify

from BeautifulSoup import BeautifulSoup


def crea_palinsesto():
    palinsesto_url = "https://hyle.appspot.com/palinsesto/serata"
    response = urllib2.urlopen(palinsesto_url)
    soup = BeautifulSoup(response)

    pal = []

    for channel in soup.findAll('div', 'g3'):
        try:
            chan_progs = []
            for program in channel.findAll('span'):
                if program.text >= "21" :
		    riga = program.text[:5] + '~' + program.text[5:]
                    chan_progs.append({"orario" : riga.split('~')[0], "name" : riga.split('~')[1]})

            chan_json = { "name" : channel.find('h3').find('strong').text , "progs" :  sorted(chan_progs, key=lambda program: program['orario']) }
	    print chan_json
            pal.append(chan_json)
        except:
            continue

    return pal

def sendmessage(title, message):
    pynotify.init("Palinsesto Tv")
    notice = pynotify.Notification(title, message)
    notice.show()
    return

def seleziona_canale(pal, regex_name):
    for chan in pal:
        if chan['name'].find(regex_name) != -1:
            programmi = ""
            for program in chan['progs']:
                programmi += program['orario'] + " -> " + program['name'] + "\n"
            sendmessage(chan['name'], programmi)


palinsesto = crea_palinsesto()

parametri = sys.argv
parametri.pop(0)
seleziona_canale(palinsesto, " ".join(parametri))
