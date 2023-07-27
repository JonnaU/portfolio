import requests
from pprint import pprint

def työpaikat_tpt():
    """ Haetaan työpaikat työvoimatoimiston APIsta"""
    headers = {
        'sec-ch-ua': '"Not.A/Brand";v="8", "Chromium";v="114", "Microsoft Edge";v="114"',
        'Accept': 'application/json, text/plain, */*',
        'Referer': 'https://paikat.te-palvelut.fi/tpt/',
        'sec-ch-ua-mobile': '?0',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.82',
        'sec-ch-ua-platform': '"Windows"',
    }

    response = requests.get(
        'https://paikat.te-palvelut.fi/tpt-api/v1/tyopaikat?hakusana=python&hakusanakentta=sanahaku&alueet=Tampere&ilmoitettuPvm=1&vuokrapaikka=---&etatyopaikka=---&sort=mainAmmattiRivino%20asc,%20tehtavanimi%20asc,%20tyonantajanNimi%20asc,%20viimeinenHakupaivamaara%20asc&kentat=ilmoitusnumero,tyokokemusammattikoodi,ammattiLevel3,tehtavanimi,tyokokemusammatti,tyonantajanNimi,kunta,ilmoituspaivamaara,hakuPaattyy,tyoaikatekstiYhdistetty,tyonKestoKoodi,tyonKesto,tyoaika,tyonKestoTekstiYhdistetty,hakemusOsoitetaan,maakunta,maa,hakuTyosuhdetyyppikoodi,hakuTyoaikakoodi,hakuTyonKestoKoodi&rows=200&start=0&ss=true&facet.fkentat=hakuTyoaikakoodi,ammattikoodi,aluehaku,hakuTyonKestoKoodi,hakuTyosuhdetyyppikoodi,oppisopimus&facet.fsort=index&facet.flimit=-1',
        headers=headers,
    )
    pprint(response.json())
    return response.json()

def työpaikat_duunitori(haku):
    """ Haetaan työpaikat Duunitorin APIsta"""
    headers = {
        'sec-ch-ua': '"Not.A/Brand";v="8", "Chromium";v="114", "Microsoft Edge";v="114"',
        'Accept': 'application/json, text/plain, */*',
        'Referer': 'https://paikat.te-palvelut.fi/tpt/',
        'sec-ch-ua-mobile': '?0',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.82',
        'sec-ch-ua-platform': '"Windows"',
    }
    response = requests.get(
        f'https://duunitori.fi/carousel/search?alue=Pirkanmaa&amp;haku={haku}',
        headers=headers,
    )
    return response.text