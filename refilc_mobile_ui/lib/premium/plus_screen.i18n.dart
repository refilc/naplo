import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {},
        "hu_hu": {
          "even_more_cheaper": "Még több reFilc, olcsóbban,\nmint bármi más!",
          "support_1": "Támogasd a QwIT",
          "support_2": " csapatát, és szerezz cserébe pár kényelmes jutalmat!",
          "tier_rfp":
              "Több személyre szabás, több fiók, egyszerű feladatfeljegyzés.",
          "tier_rfpgold":
              "Férj hozzá még több funkcióhoz, használj még több profilt és tedd egyszerűbbé mindennapjaid.",
          "faq": "Gyakori kérdések",
          "money": "Mire költitek a pénzt?",
          "m_1": "A támogatásokból kapott pénz elsősorban az Apple",
          "m_2":
              " Developer Program évi \$100-os díját, valamint az API mögött álló szerverek és a reFilc domain címek árát fedezi, a maradékot egyéb fejlesztésekre, fejlesztői fagyizásra fordítjuk.",
          "open": "Még mindig nyílt a forráskód?",
          "o_1":
              "Igen, a reFilc teljesen nyílt forráskódú, és ez így is fog maradni. A reFilc+ funkcióinak forráskódjához bármely támogatónk hozzáférhet, ha ezt Discord-on kérelmezi.",
          "desc": "Magyarázatok",
          "cheaper":
              "A szolgáltatás legalacsonyabb szintje olcsóbb a legtöbb ismert előfizetésnél, viszont előfordulhatnak kivételek.",
          "qwit":
              "A \"QwIT\" a \"QwIT Development\" rövid neve, ez a fejlesztői csapat neve, mely a reFilc és egyéb projektek mögött áll.",
          "apple": "Az \"Apple\" az Apple Inc. védjegye.",
          "eur":
              "Az árak euróban vannak feltüntetve, így az árfolyam befolyásolja, hogy mennyit kell fizetned a szolgáltatásért. 1 EUR ≈ 390 Ft",
        },
        "de_de": {},
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
