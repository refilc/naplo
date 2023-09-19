import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'settings_screen.i18n.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  static void show(BuildContext context) => showDialog(
      context: context,
      builder: (context) => const PrivacyView(),
      barrierDismissible: true);

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
  • A reFilc (továbbiakban alkalmazás) egy mobilos, asztali és webes kliensalkalmazás, segítségével az e-Kréta rendszeréből letöltheted és felhasználóbarát módon megjelenítheted az adataidat. Tanulmányi adataid csak közvetlenül az alkalmazás és a Kréta-szerverek között közlekednek, titkosított kapcsolaton keresztül.

  • A reFilc fejlesztői és/vagy üzemeltetői, valamint az alkalmazás a tanulmányi és személyes adataidat semmilyen célból és semmilyen körülmények között nem másolják, nem tárolják és harmadik félnek nem továbbítják. Ezeket így az Educational Development Informatikai Zrt. kezeli, az Ő adatkezeléssel kapcsolatos tájékoztatójukat itt találod: https://tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038

  • Azok törlésével vagy módosítával kapcsolatban keresd az osztályfőnöködet vagy az iskolád rendszergazdáját.

  • Az alkalmazás névtelen használati statisztikákat gyűjt, ezek alapján tudjuk meghatározni a felhasználók és a telepítések számát, valamint az eszközük platformját. Ezt a beállításokban kikapcsolhatod. Kérünk, hogy ha csak teheted, hagyd ezt a funkciót bekapcsolva, hogy pontosabb információnk legyen a felhasználóink platform-megoszlásáról.

  • Amikor az alkalmazás hibába ütközik, lehetőség van hibajelentés küldésére. Ez személyes- és/vagy tanulmányi adatokat nem tartalmaz, viszont részletes információval szolgál a hibáról, annak okáról és eszközödről. A küldés előtt megjelenő képernyőn a te felelősséged átnézni a továbbításra kerülő adatsort. A hibajelentéseket a reFilc fejlesztői felületén és egy privát Discord szobában tároljuk, ezekhez csak az app fejlesztői férnek hozzá.

  • Az alkalmazás (az alábbi platformokon: Android, Linux, Windows) minden egyes indításakor a reFilc API, valamint a Github API segítségével ellenőrzi, hogy elérhető-e új verzió, és kérésre innen letölti és telepíti a frissítést.

  • Amennyiben az adataiddal kapcsolatban bármilyen kérdésed van (megtekintés, törlés, módosítás, adathordozás), keress minket a social@refilc.hu e-mail címen, vagy Discord szerverünkön!
  
  • A kliensalkalmazás bármely eszközön és platformon történő használatával tudomásul vetted és elfogadod a jelen adatkezelési tájékoztatót. A reFilc csapata fenntartja a jogot a tájékoztató módosítására és a módosításokról nem köteles értesíteni a felhasználóit!
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
