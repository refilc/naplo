import 'package:intl/intl.dart';

class KretaAPI {
  // IDP API
  static const login = BaseKreta.kretaIdp + KretaApiEndpoints.token;
  static const logout = BaseKreta.kretaIdp + KretaApiEndpoints.revoke;
  static const nonce = BaseKreta.kretaIdp + KretaApiEndpoints.nonce;
  static const clientId = "kreta-ellenorzo-mobile-android";

  // ELLENORZO API
  static String notes(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.notes;
  static String events(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.events;
  static String student(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.student;
  static String grades(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.grades;
  static String absences(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.absences;
  static String groups(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.groups;
  static String groupAverages(String iss, String uid) =>
      BaseKreta.kreta(iss) +
      KretaApiEndpoints.groupAverages +
      "?oktatasiNevelesiFeladatUid=" +
      uid;
  static String averages(String iss, String uid) =>
      BaseKreta.kreta(iss) +
      KretaApiEndpoints.averages +
      "?oktatasiNevelesiFeladatUid=" +
      uid;
  static String timetable(String iss, {DateTime? start, DateTime? end}) =>
      BaseKreta.kreta(iss) +
      KretaApiEndpoints.timetable +
      (start != null && end != null
          ? "?datumTol=" +
              start.toUtc().toIso8601String() +
              "&datumIg=" +
              end.toUtc().toIso8601String()
          : "");
  static String exams(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.exams;
  static String homework(String iss, {DateTime? start, String? id}) =>
      BaseKreta.kreta(iss) +
      KretaApiEndpoints.homework +
      (id != null ? "/$id" : "") +
      (id == null && start != null
          ? "?datumTol=" + DateFormat('yyyy-MM-dd').format(start)
          : "");
  static String capabilities(String iss) =>
      BaseKreta.kreta(iss) + KretaApiEndpoints.capabilities;
  static String downloadHomeworkAttachments(
          String iss, String uid, String type) =>
      BaseKreta.kreta(iss) +
      KretaApiEndpoints.downloadHomeworkAttachments(uid, type);
  static String subjects(String iss, String uid) =>
      BaseKreta.kreta(iss) +
      KretaApiEndpoints.subjects +
      "?oktatasiNevelesiFeladatUid=" + uid;
      // Structure:
      // {
      //   "Uid": 000,
      //   "Tantargy": {
      //       "Uid": 000,
      //       "Nev": "Irodalom",
      //       "Kategoria": {
      //          "Uid": "000,magyar_nyelv_es_irodalom",
      //          "Nev": "magyar_nyelv_es_irodalom",
      //          "Leiras": "Magyar nyelv és irodalom"
      //       },
      //       "SortIndex": 0,
      //    },
      //    "Atlag": null, // float
      //    "AtlagAlakulasaIdoFuggvenyeben": Array[], // no idea what this is
      //    "SulyozottOsztalyzatOsszege": null, // int | float
      //    "SulyozottOsztalyzatSzama": null, // int | float
      //    "SortIndex": 0
      // }
      // refer to https://discord.com/channels/1111649116020285532/1111798771513303102/1148368925969612920

  // ADMIN API
  static const sendMessage =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.sendMessage;
  static String messages(String endpoint) =>
      BaseKreta.kretaAdmin + KretaAdminEndpoints.messages(endpoint);
  static String message(String id) =>
      BaseKreta.kretaAdmin + KretaAdminEndpoints.message(id);
  static const recipientCategories =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.recipientCategories;
  static const availableCategories =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.availableCategories;
  static const recipientsTeacher =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.recipientsTeacher;
  static const uploadAttachment =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.uploadAttachment;
  static String downloadAttachment(String id) =>
      BaseKreta.kretaAdmin + KretaAdminEndpoints.downloadAttachment(id);
  static const trashMessage =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.trashMessage;
  static const deleteMessage =
      BaseKreta.kretaAdmin + KretaAdminEndpoints.deleteMessage;
}

class BaseKreta {
  static String kreta(String iss) => "https://$iss.e-kreta.hu";
  static const kretaIdp = "https://idp.e-kreta.hu";
  static const kretaAdmin = "https://eugyintezes.e-kreta.hu";
  static const kretaFiles = "https://files.e-kreta.hu";
}

class KretaApiEndpoints {
  static const token = "/connect/token";
  static const revoke = "/connect/revocation";
  static const nonce = "/nonce";
  static const notes = "/ellenorzo/V3/Sajat/Feljegyzesek";
  static const events = "/ellenorzo/V3/Sajat/FaliujsagElemek";
  static const student = "/ellenorzo/V3/Sajat/TanuloAdatlap";
  static const grades = "/ellenorzo/V3/Sajat/Ertekelesek";
  static const absences = "/ellenorzo/V3/Sajat/Mulasztasok";
  static const groups = "/ellenorzo/V3/Sajat/OsztalyCsoportok";
  static const groupAverages =
      "/ellenorzo/V3/Sajat/Ertekelesek/Atlagok/OsztalyAtlagok";
  static const averages = "/ellenorzo/V3/idk";
  static const timetable = "/ellenorzo/V3/Sajat/OrarendElemek";
  static const exams = "/ellenorzo/V3/Sajat/BejelentettSzamonkeresek";
  static const homework = "/ellenorzo/V3/Sajat/HaziFeladatok";
  // static const homeworkDone = "/ellenorzo/V3/Sajat/HaziFeladatok/Megoldva"; // Removed from the API
  static const capabilities = "/ellenorzo/V3/Sajat/Intezmenyek";
  static String downloadHomeworkAttachments(String uid, String type) =>
      "/ellenorzo/V3/Sajat/Csatolmany/$uid";
  static const subjects = "/ellenorzo/V3/Sajat/Ertekelesek/Atlagok/TantargyiAtlagok";
}

class KretaAdminEndpoints {
  //static const messages = "/api/v1/kommunikacio/postaladaelemek/sajat";
  static const sendMessage = "/api/v1/kommunikacio/uzenetek";
  static String messages(String endpoint) =>
      "/api/v1/kommunikacio/postaladaelemek/$endpoint";
  static String message(String id) =>
      "/api/v1/kommunikacio/postaladaelemek/$id";
  static const recipientCategories = "/api/v1/adatszotarak/cimzetttipusok";
  static const availableCategories = "/api/v1/kommunikacio/cimezhetotipusok";
  static const recipientsTeacher = "/api/v1/kreta/alkalmazottak/tanar";
  static const uploadAttachment = "/ideiglenesfajlok";
  static String downloadAttachment(String id) =>
      "/api/v1/dokumentumok/uzenetek/$id";
  static const trashMessage = "/api/v1/kommunikacio/postaladaelemek/kuka";
  static const deleteMessage = "/api/v1/kommunikacio/postaladaelemek/torles";
  // profile management
  static const editProfile = "/api/profilapi/saveprofildata";
}
