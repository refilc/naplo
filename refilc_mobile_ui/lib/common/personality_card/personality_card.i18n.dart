import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          // main
          "unknown": "???",
          "unknown_personality": "Unknown personality...",
          // personalities
          "t_geek": "Know-It-All",
          "d_geek":
              "You learn a lot, but don't worry - Being a know-it-all is a blessing in disguise. You'll be successful in life.",
          "s_geek": "Year-end average",
          "t_sick": "Sick",
          "d_sick":
              "Get well soon, bro. Even if you lied about being sick to skip school.",
          "s_sick": "Absences",
          "t_late": "Late",
          "d_late":
              "The tram's wheel got punctured. The airplane was derailed. Your dog ate your shoe. We believe you.",
          "s_late": "Delays (minutes)",
          "t_quitter": "Skipper",
          "d_quitter": "Supplementary exam incoming.",
          "s_quitter": "Igazolatlan hiányzások",
          "t_healthy": "Healthy",
          "d_healthy":
              "As cool as a cucumber! You almost never missed a class.",
          "s_healthy": "Absences",
          "t_acceptable": "Acceptable",
          "d_acceptable":
              "Final exams are D. But who cares? It's still a grade. Not a good one, but it's definitely a grade.",
          "s_acceptable": "D's",
          "t_fallible": "Failed",
          "d_fallible": "Good luck next year.",
          "s_fallible": "F's",
          "t_average": "It's okay",
          "d_average": "Not good, not bad. The golden mean, if you will...",
          "s_average": "C's",
          "t_diligent": "Hard-worker",
          "d_diligent":
              "You noted everything, you made that presentation, and you lead the group project.",
          "s_diligent": "Class work A's",
          "t_cheater": "Cheater",
          "d_cheater":
              "You enabled the \"Good Student\" mode. Wow. You may have outsmarted me, but I have outsmarted your outsmarting.",
          "s_cheater": "Bitches",
          "t_npc": "NPC",
          "d_npc":
              "You're such a non-player character, we couldn't give you a personality.",
          "s_npc": "In-game playtime (hours)",
          // other
          "year_index": "Lesson Number",
        },
        "hu_hu": {
          // main
          "unknown": "???",
          "unknown_personality": "Ismeretlen személyiség...",
          // personalities
          "t_geek": "Stréber",
          "d_geek":
              "Sokat tanulsz, de ezzel semmi baj! Ez egyben áldás és átok, de legalább az életben sikeres leszel.",
          "s_geek": "Év végi átlagod",
          "t_sick": "Beteges",
          "d_sick":
              "Jobbulást, tesó. Még akkor is, ha hazudtál arról, hogy beteg vagy, hogy ne kelljen suliba menned.",
          "s_sick": "Hiányzásaid",
          "t_late": "Késős",
          "d_late":
              "Kilyukadt a villamos kereke. Kisiklott a repülő. A kutyád megette a cipőd. Elhisszük.",
          "s_late": "Késések (perc)",
          "t_quitter": "Lógós",
          "d_quitter": "Osztályzóvizsga incoming.",
          "s_quitter": "Igazolatlan hiányzások",
          "t_healthy": "Makk",
          "d_healthy":
              "...egészséges vagy! Egész évben alig hiányoztál az iskolából.",
          "s_healthy": "Hiányzásaid",
          "t_acceptable": "Elmegy",
          "d_acceptable":
              "A kettes érettségi is érettségi. Nem egy jó érettségi, de biztos, hogy egy érettségi.",
          "s_acceptable": "Kettesek",
          "t_fallible": "Bukós",
          "d_fallible": "Jövőre több sikerrel jársz.",
          "s_fallible": "Karók",
          "t_average": "Közepes",
          "d_average": "Se jó, se rossz. Az arany középút, ha akarsz...",
          "s_average": "Hármasok",
          "t_diligent": "Szorgalmas",
          "d_diligent":
              "Leírtad a jegyzetet, megcsináltad a prezentációt, és te vezetted a projektmunkát.",
          "s_diligent": "Órai munka ötösök",
          "t_cheater": "Csaló",
          "d_cheater":
              "Bekapcsoltad a “Jó Tanuló” módot. Wow. Azt hitted, túl járhatsz az eszemen, de kijátszottam a kijátszásod.",
          "s_cheater": "Bitches",
          "t_npc": "NPC",
          "d_npc":
              "Egy akkora nagy non-player character vagy, hogy neked semmilyen személyiség nem jutott ezen kívül.",
          "s_npc": "In-game playtime (óra)",
          // other
          "year_index": "Éves óraszám",
        },
        "de_de": {
          // main
          "unknown": "???",
          "unknown_personality": "Unbekannte Persönlichkeit...",
          // personalities
          "t_geek": "Besserwisser",
          "d_geek":
              "Du lernst eine Menge, aber sorge dich nicht - ein Besserwisser zu sein wird sich letzten Endes doch als Segen erweisen. Du wirst erfolgreich sein im Leben.",
          "s_geek": "Durchschnittsschüler",
          "t_sick": "Krank",
          "d_sick":
              "Werd schnell wieder gesund, Brudi. Selbst wenn du gelogen hast, nur um Schule zu schwänzen zu können.",
          "s_sick": "Abwesenheiten",
          "t_late": "Verspätet",
          "d_late":
              "Die Straßenbahn hat eine Reifenpanne. Das Flugzeug ist entgleist. Dein Hund hat deinen Schuh gefressen. Klar, wir glauben dir.",
          "s_late": "Verspätung (Minuten)",
          "t_quitter": "Schulschwänzer",
          "d_quitter": "Ein zusätzlicher Test wird anstehen.",
          "s_quitter": "Unentschuldigte Abwesenheiten",
          "t_healthy": "Gesund",
          "d_healthy":
              "Du bist die Ruhe selbst! Du hast fast nie eine Unterrichtsstunde verpasst.",
          "s_healthy": "Abwesenheiten",
          "t_acceptable": "Akzeptabel",
          "d_acceptable":
              "Die Abschlussprüfungen waren gerade einmal eine 4. Aber wen juckt's? Es ist immer noch positiv. Nicht allzu gut, aber definitiv positiv.",
          "s_acceptable": "4er",
          "t_fallible": "Durchgefallen",
          "d_fallible": "Viel Glück im nächsten Jahr.",
          "s_fallible": "5er",
          "t_average": "Es ist in Ordnung",
          "d_average":
              "Nicht gut, nicht schlecht. Der goldene Durchschnitt, wenn du so willst...",
          "s_average": "3er",
          "t_diligent": "Ein Fleißiger",
          "d_diligent":
              "Du hast bei allem mitgeschrieben, du hast den Vortrag gehalten, und du hast die Gruppenarbeit geleitet.",
          "s_diligent": "1er Schüler",
          "t_cheater": "Geschummelt",
          "d_cheater":
              "Du hast den „Guter Schüler“ Modus aktiviert. Wow. Du magst mich zwar vielleicht überlistet haben, aber ich habe deine Überlistung überlistet.",
          "s_cheater": "Bitches",
          "t_npc": "COM",
          "d_npc":
              "Du bist einfach so sehr wie ein Computer, dass wir dir nicht einmal eine Persönlichkeit geben konnten.",
          "s_npc": "Spielzeit (Stunden)",
          // other
          "year_index": "Ordinalzahl",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
