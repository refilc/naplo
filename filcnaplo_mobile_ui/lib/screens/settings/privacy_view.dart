import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'settings_screen.i18n.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  static void show(BuildContext context) => showDialog(context: context, builder: (context) => const PrivacyView(), barrierDismissible: true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("privacy".i18n),
              ),
              SelectableLinkify(
                text: """
A Filc Napló egy kliensalkalmazás, segítségével az e-Kréta rendszeréből letöltheted és felhasználóbarát módon megjelenítheted az adataidat.
Tanulmányi adataid csak közvetlenül az alkalmazás és a Kréta-szerverek között közlekednek, titkosított kapcsolaton keresztül.

A Filc fejlesztői és üzemeltetői a tanulmányi adataidat semmilyen célból nem másolják, nem tárolják és harmadik félnek nem továbbítják. Ezeket így az e-Kréta Informatikai Zrt. kezeli, az ő tájékoztatójukat itt találod: https://tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038.
Azok törlésével vagy módosítával kapcsolatban keresd az osztályfőnöködet vagy az iskolád rendszergazdáját.

Az alkalmazás névtelen használati statisztikákat gyűjt, ezek alapján tudjuk meghatározni a felhasználók és a telepítések számát. Ezt a beállításokban kikapcsolhatod.
Kérünk, hogy ha csak teheted, hagyd ezt a funkciót bekapcsolva.

Amikor az alkalmazás hibába ütközik, lehetőség van hibajelentés küldésére.
Ez személyes- vagy tanulmányi adatokat nem tartalmaz, viszont részletes információval szolgál a hibáról és eszközödről.
A küldés előtt megjelenő képernyőn a te felelősséged átnézni a továbbításra kerülő adatsort.
A hibajelentéseket a Filc fejlesztői felületén és egy privát Discord szobában tároljuk, ezekhez csak az app fejlesztői férnek hozzá.
Az alkalmazás belépéskor a GitHub API segítségével ellenőrzi, hogy elérhető-e új verzió, és kérésre innen is tölti le a telepítőt.

Ha az adataiddal kapcsolatban bármilyen kérdésed van (törlés, módosítás, adathordozás), keress minket a filcnaplo@filcnaplo.hu címen.

Az alkalmazás használatával jelzed, hogy ezt a tájékoztatót tudomásul vetted.

Utolsó módosítás: 2021. 09. 25.
              """,
                onOpen: (link) => launch(link.url,
                    customTabsOption: CustomTabsOption(
                      toolbarColor: Theme.of(context).scaffoldBackgroundColor,
                      showPageTitle: true,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
