import 'package:alto_staffing/MultiSelectDialogItem.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

class AltoUtils {

  static initTimeZones(){
    tz.initializeTimeZones();
  }

   //static const String baseApiUrl = 'http://192.168.1.111:8080/api/mobile';
   //static const String baseApiUrl = 'http://192.168.1.74:8080/api/mobile';
   static const String baseApiUrl = 'http://altowebbapp.com:8080/api/mobile';
   static const String baseHcsUrl = 'https://ctms.contingenttalentmanagement.com/CirrusConcept/clearConnect/2_0/index.cfm';
   static const String suCreds = '&username=rsteele&password=altoApp1!';

   static const String url1 = 'https://ctms.contingenttalentmanagement.com/CirrusConcept/workforceportal';
   static const String url2 = 'https://www.heartlandcheckview.com';
   static const String url3 = 'https://www.altostaffing.com';
   static const String url4 = 'https://na3.docusign.net/Member/PowerFormSigning.aspx?PowerFormId=9beecada-941b-47b2-a437-afffd9418790&env=na3&acct=fc47ba0d-8c13-4f6f-80b7-e0469555391a';



   static String formatDates(String sDate){
     if (sDate == null || sDate.isEmpty) return "";
     DateTime dateTime =  DateTime.parse(sDate);
     var ny = getLocation('US/Eastern');
     var date = TZDateTime.from(dateTime, ny);
     return DateFormat.yMd().add_jm().format(date);
   }

   static getCerts() {
     return [
       "CMA",
       "CNA",
       "Certified Clinical Med Asst.",
       "Clerical",
       "Dietary",
       "LCDC",
       "LICDC",
       "LISW",
       "LPN",
       "LSW",
       "Medical Assistant",
       "NP",
       "OT",
       "PT",
       "RMA",
       "RN",
       "RT",
       "STNA",
       "MLT"
     ];
   }

   static getRegions() {
     return [
       "Cincinnati",
       "Dayton",
       "Columbus",
       "Medical Business",
       "Contract Travel"
     ];
   }

}