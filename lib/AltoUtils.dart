import 'package:alto_staffing/MultiSelectDialogItem.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

class AltoUtils {

  static initTimeZones(){
    tz.initializeTimeZones();
  }

   static const String baseApiUrl = 'http://192.168.1.113:8080/api/mobile';
   //static const String baseApiUrl = 'http://172.20.10.2:8080/api/mobile';
   //static const String baseApiUrl = 'http://altowebbapp.com:8080/api/mobile';
   //static const String baseApiUrl = 'http://webapp.altostaffing.com:8080/api/mobile';

   static const String url1 = 'https://ctms.contingenttalentmanagement.com/CirrusConcept/workforceportal';
   static const String url2 = 'https://m.heartlandcheckview.com/login';
   static const String url3 = 'https://www.altostaffing.com';
   static const String url4 = 'https://www.selectagiftplan.com/altostaffing';



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
       "Contract Travel",
       "ALL Regions",
       "Toledo",
       "Indiana",
       "Akron",
       "Allied Health"
     ];
   }

}