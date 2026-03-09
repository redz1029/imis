import 'package:flutter/material.dart';

//REUSABLE CODE//

//Colors
const primaryColor = Color.fromRGBO(192, 80, 77, 1);
const secondaryBgButton = Color.fromRGBO(192, 74, 74, 0.226);
const primaryLightColor = Color.fromRGBO(192, 74, 74, 0.644);
const maroon = Color.fromRGBO(117, 38, 38, 1);
const secondaryColor = Color.fromRGBO(253, 252, 250, 1);
const mainBgColor = Color.fromRGBO(245, 245, 245, 1);
const grey = Color.fromRGBO(161, 161, 161, 1);
const lightGrey = Color.fromRGBO(217, 217, 217, 1);
const lightGrey1 = Color.fromRGBO(245, 245, 245, 1);
const primaryTextColor = Color.fromRGBO(65, 65, 65, 1);
const Color peachLight = Color.fromARGB(255, 255, 225, 224);
//Sizing
const gap4px = SizedBox(height: 4);
const gap6px = SizedBox(height: 6);
const gap8px = SizedBox(height: 8);
const gap12px = SizedBox(height: 12);
const gap14px = SizedBox(height: 14);
const gap16px = SizedBox(height: 16);
const gap24px = SizedBox(height: 24);
const gap32px = SizedBox(height: 32);
const gap48px = SizedBox(height: 48);
const gap60px = SizedBox(height: 60);
const gap32w = SizedBox(width: 50);

// Job Posiitons
class JobPositions {
  static const List<String> positions = [
    'Chief of Medical Professional Staff II',
    'Medical Center Chief II',
    'Head, Department of Anesthesiology',
    'Head, Cancer Institute',
    'Head, COVID-19 Center',
    'Head, Dental Department',
    'Head, NDD',
    'Head, Delivery Room',
    'Head, EFMD',
    'Head, Emergency Room',
    'Head, Finance Service',
    'Head, HIMD',
    'Head, Human Resource Mngt. Department',
    'Head, IHOMP',
    'Head, Department of Internal Medicine',
    'Nurse VI',
    'Head, Department of OB-GYN',
    'Head, OPD',
    'Head, OR (Cath. Lab)',
    'Head, OSM',
    'Head, Department of Pathology',
    'Head, Department of Pediatrics',
    'Head, PETRU',
    'Head, Pharmacy Deparment',
    'Head, Physical Medicine and Rehabilitation Department',
    'Head, DDTR',
    'Head, Department of Surgery',
    'Head, Trauma Care',
    'Chief Administrative Officer',
    'Nurse V',
    'Chief Nurse',
    'Supervising Administrative Officer',
    'Engineer IV',
    'OIC-Chief Health Program Officer',
    'Head, Cancer Care',
    'Social Welfare Officer IV',
    'Head, HIPCU',
    'Head, Department of Internal Medicine',
    'Head, Department of Surgery',
    'Head, Department of Obstetrics-Gynecology',
    'Head, Department of Pediatrics',
    'Head, Department of Anesthesiology',
    'Head, Physical Medicine and Rehabilitation Department',
    'Head, Out-Patient Department',
    'Head, Emergency Department',
    'Head, Department of Pathology',
    'Head, Department of Diagnostic and Therapeutic Radiology',
    'Head, Dental Department',
    'Head, Health Information Management Department',
    'Head, Medical Social Work Department',
    'Head, Nutrition and Dietetics Department',
    'Head, Pharmacy Department',
    'Head, Medicine Ward',
    'Head, Pediatrics Ward',
    'Head, Surgery Ward',
    'Head, OB-Gynecology Ward',
    'Head, Operating Room',
    'Head, Delivery Room',
    'Head, Pay Ward',
    'Head, Orthopedic, Ophthalmology, and Urology Wards',
    'Head, Oncology Ward',
    'Head, Central Supply and Sterilization Room',
    'Head, Mental Health Unit',
    'Head, Human Resource Management Department',
    'Head, Procurement Department',
    'Head, Materials and Supplies Management Department',
    'Head, Engineering and Facilities Management Department',
    'Head, Budget Department',
    'Head, Accounting Department',
    'Head, Cash Operations Department',
    'Head, Medical Center Chief Office',
    'Head, CMPS Office',
    'Head, Bureau of Quarantine',
    'Head, Chief Nurse Office',
    'Head, TB Ward',
    'Head, CAO Office',
    'Head, Public Health Unit - Health Promotion Unit',
    'Head, Auditor\'s Office',
    'Head, Extension Ward',
    'Head, ICU Complex',
    'Head, Cancer Institute',
    'Head, Women\'s Health Center',
    'Head, College of Medicine Department',
    'Head, Ophthalmology Department',
    'Head, Trauma Center',
    'Head, Burn Center',
    'Head, Cardiovascular Center',
    'Head, Renal Care and Transplant Unit',
    'Head, Hemodialysis Unit',
    'Head, Heart Station',
    'Head, Section of Pulmonary Medicine',
    'Head, Surgery Intensive Care Unit',
    'Head, Burn Unit',
    'Head, OB-Gynecology Intensive Care Unit',
    'Head, Pediatric Intensive Care Unit',
    'Head, Neonatal Intensive Care Unit',
    'Head, Anatomic and Clinical Laboratory',
    'Head, Blood Bank',
    'Head, Billing and Claims Section',
    'Head, Finance Office',
    'Head, Professional Education Training and Research Unit',
    'Head, Legal Unit',
    'Head, Infectious Unit',
    'Head, Hospital Infection Prevention and Control Unit',
    'Head, Social Hygiene and Treatment Hub',
    'Head, Hospital Epidemiology and Surveillance Unit',
    'Head, Plastic Surgery',
    'Head, Clinical Spiritual Care Unit',
    'Head, Physical Therapy Section',
    'Head, Prosthetic and Orthotic Section',
    'Head, Brain and Spine Center',
    'Head, Research Institute',
    'Head, Health Emergency Disaster Management Unit',
    'Head, Toxicology Unit',
    'Head, Patient and Safety Unit',
    'Head, Credit and Collection Section',
    'Head, PACD',
    'HEAD, Family and Community Medicine',
    'HEAD, Eye Care'
        'Head, Soccsksargen Regional Blood Center',
  ];
}

class SwotYear {
  static const List<String> years = ['2026', '2027', '2028', '2029', '2030'];
}
