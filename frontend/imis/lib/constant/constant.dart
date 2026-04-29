import 'package:flutter/material.dart';

//REUSABLE CODE//

//Colors
const primaryColor = Color.fromARGB(255, 150, 68, 89);
const secondaryBgButton = Color.fromRGBO(192, 74, 74, 0.226);
const primaryLightColor = Color.fromRGBO(192, 74, 74, 0.644);
const maroon = Color.fromRGBO(117, 38, 38, 1);
const secondaryColor = Color.fromRGBO(253, 252, 250, 1);
const mainBgColor = Color.fromRGBO(245, 245, 245, 1);
const grey = Color.fromRGBO(161, 161, 161, 1);
const lightGrey = Color.fromRGBO(217, 217, 217, 1);
const lightGrey1 = Color.fromRGBO(245, 245, 245, 1);
const primaryTextColor = Color.fromRGBO(65, 65, 65, 1);

const Color kOrange = Color(0xFFF4724A);
const Color kGreen = Color(0xFF4DC688);
const Color kDark = Color(0xFF0F0F0F);
const Color kText = Color(0xFF111827);
const Color kMuted = Color(0xFF6B7280);
const Color kBorder = Color(0xFFE5E7EB);
const Color kBackground = Color(0xFFFAFAFA);
const kDanger = Color(0xFFEF4444);
const kSuccess = Color(0xFF10B981);
const kSuccessLight = Color(0xFFECFDF5);

const kLabel = Color(0xFF374151);
const kHint = Color(0xFF9CA3AF);
const kSurface = Color(0xFFFFFFFF);
const kCardShadow = Color(0x0A000000);
const kPrimaryLight = Color(0xFFEBF2FF);
const kDangerLight = Color(0xFFFEF2F2);

const kPrimaryMedium = Color(0xFFD4919E);
const kPrimaryBg = Color(0xFFF2D5D9);
const kBg = Color(0xFFFAF7F8);
const kTextMid = Color(0xFF6B4E53);
const kTextLight = Color(0xFF9E8285);

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
const kAccentDark = Color(0xFF8B3A4A);

// Job Posiitons
class JobPositions {
  static const List<String> positions = [
    '',
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

Widget getStatusIcon(String status) {
  double iconSize = 12; // smaller size for all icons

  Icon icon;
  Color bgColor = getStatusColor(status);

  switch (status) {
    case 'Draft':
      icon = Icon(Icons.circle, size: iconSize, color: Colors.white);
      break;
    case 'For Approval':
      icon = Icon(Icons.access_time, size: iconSize, color: Colors.white);
      break;
    case 'Approved':
      icon = Icon(Icons.check, size: iconSize, color: Colors.white);
      break;
    case 'Disapproved':
      icon = Icon(Icons.close, size: iconSize, color: Colors.white);
      break;
    default:
      icon = Icon(Icons.circle, size: iconSize, color: Colors.white);
  }

  return Container(
    decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
    child: icon,
  );
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Draft':
      return Colors.grey[800]!;
    case 'For Approval':
      return Colors.orange[800]!;
    case 'Approved':
      return Colors.green[800]!;
    case 'Disapproved':
      return Colors.red[800]!;
    default:
      return Colors.grey[800]!;
  }
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

Color ratingBgColor(double val) {
  if (val == 1.0) return const Color.fromARGB(255, 156, 85, 103);
  if (val == 0.5) return const Color(0xFFE88FA0);
  return const Color(0xFFF2D5D9);
}

Color ratingTextColor(double val) {
  if (val == 1.0) return Colors.white;
  if (val == 0.5) return Colors.white;
  return kText;
}
