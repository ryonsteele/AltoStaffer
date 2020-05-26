import 'package:alto_staffing/MultiSelectDialogItem.dart';

class AltoUtils {

   //static const String baseApiUrl = 'http://192.168.1.98:8080/api/mobile';
   //static const String baseApiUrl = 'http://192.168.43.121:8080/api/mobile';
   static const String baseApiUrl = 'http://altowebbapp.com:8080/api/mobile';
   static const String baseHcsUrl = 'https://ctms.contingenttalentmanagement.com/CirrusConcept/clearConnect/2_0/index.cfm';
   static const String suCreds = '&username=rsteele&password=altoApp1!';

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

//    static getSpecs() {
//      return [
//        'MA 8+ yrs exp',
//        'MA 3-7 yrs exp',
//        'ER',
//        'ICU',
//        'CCU',
//        'Tele',
//        'Med/Surg',
//        'OR',
//        'Post-Op',
//        'PACU',
//        'Pre-Op',
//        'Float',
//        'Rehab',
//        'Ortho',
//        'Cardio',
//        'Onocology',
//        'CVICU',
//        'Out-PT',
//        'Acute',
//        'LTAC',
//        'Peds',
//        'Geriatric',
//        'Home Care',
//        'Doc Office',
//        'HOSPICE',
//        'MRDD',
//        'Mental Health',
//        'Burns',
//        'Drug',
//        'Alcohol',
//        'MICU',
//        'SICU',
//        'MACU',
//        'ACU',
//        'GI Lab',
//        'Step down',
//        'Or-Scrub',
//        'Pulm',
//        'Trauma',
//        'Renal',
//        'Family Health',
//        'Discharge Planning',
//        'LTC',
//        'OB',
//        'Labor & Delivery',
//        'Behavioral Health',
//        'Neuro',
//        'Myofascial Release',
//        'Wound Care',
//        'Kinesio Taping',
//        'SNF',
//        'ECF',
//        'Sub-Acute',
//        'ATC',
//        'Sports Medicine',
//        'Hospital',
//        'CLT',
//        'Work Hardening',
//        'Cognitive Retaining',
//        'Chronic Pain Management',
//        'Outpatient Rehab',
//        'Pharmacy',
//        'Out-Pat Surgery',
//        'Case Management',
//        'PTO',
//        'Low census',
//        'Administrative Assistant',
//        'Customer Service',
//        'Medical Assistant',
//        'Dental Assistant',
//        'Dental Hygienist',
//        'X-Ray License',
//        'Outpatient',
//        'Medical Transcriptionist',
//        'Therapist II',
//        'Therapist III',
//        'Associate Therapists',
//        'Therapist II/III',
//        'Support Staff',
//        'Dialysis',
//        'Clinic',
//        'Medical Office',
//        'Coder',
//        'Claims',
//        'CNA',
//        'Mother Baby',
//        'Cardiac Cath Lab',
//        'Finance and Accounting',
//        'Information Technology',
//        'Opthamology Tech',
//        'Data Entry',
//        'NICU I',
//        'NICU II/III',
//        'MA 0-2 yrs exp',
//        'On Call',
//        'Urgent Care',
//        'Vascular',
//        'Health Info Tech',
//        'Epidemiology',
//        'Psychiatric',
//        'Med/Tel',
//        'Admin',
//        'Sales',
//        'Assisted Living',
//        'LPN Temp to Hire',
//        'RN Temp To Hire',
//        'Cert. Phleb.',
//        'Sitter',
//        'MA 6-9 yrs. exp.',
//        'MA 10+ years',
//        'Orientation',
//        'Orientation 2',
//        'MA 3-5 yrs exp',
//        'MA',
//        'Cook',
//        'Class',
//        'RN < 5 years exp',
//        'RN 5 + yrs exp.',
//        'Electrophysiology Lab/ EP Lab',
//        'OnCall STNA',
//        'LPN On Call',
//        'CVOR',
//        'Cath Lab RN',
//        'OT',
//        'PT',
//        'OTA',
//        'PTA',
//        'SLP',
//        'Rad Tech',
//        'IR Tech',
//        'CT Tech',
//        'See Description',
//        'PCU',
//        'ORT',
//        'Infusion',
//        'Stepdown',
//        'Long Term Care',
//        'Sleep Tech',
//        'RT',
//        'Cath Lab Tech',
//        'First Assist',
//        'Interventional Radiology',
//        'MS Tele',
//        'Endoscopy',
//        'Antepartum',
//        'Flight RN',
//        'Postpardum',
//        'RN Cath Lab Winter',
//        'PICU',
//        'Lab',
//        'Nurse Anesthetist',
//        'Infection Control',
//        'Nurse Manager',
//        'Employee Health',
//        'RN Supervisor',
//        'RN Charge',
//        'Surg Tech',
//        'RNFA',
//        'LISW/LPCC/LICDC',
//        'Public Health',
//        'Office Staff',
//        'Incentive pay',
//        'STNA1',
//        'STNA2',
//        'Occupational Health',
//      ];
//   }

}