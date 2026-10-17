class HelpTopic {
  final List<String> keywords;
  final String question;
  final List<String> steps;
  final String questionEn;
  final List<String> stepsEn;

  const HelpTopic({
    required this.keywords,
    required this.question,
    required this.steps,
    required this.questionEn,
    required this.stepsEn,
  });
}

const List<HelpTopic> helpTopics = [
  HelpTopic(
    keywords: [
      'create deliverable',
      'add deliverable',
      'gumawa ng deliverable',
      'paano gumawa ng deliverable',
      'how to create deliverable',
      'new deliverable',
    ],
    question: 'Paano gumawa ng bagong Deliverable?',
    steps: [
      'Sa sidebar, i-click ang "PGS" para makita ang mga submenu nito.',
      'Piliin ang "Create/View Deliverables".',
      'Sa taas-kanan ng page, i-click ang "+ Add New" button.',
      'Punan ang form (Office, Period, Deliverable details, atbp).',
      'I-save o i-submit para maidagdag ang bagong deliverable sa listahan.',
    ],
    questionEn: 'How do I create a new Deliverable?',
    stepsEn: [
      'In the sidebar, click "PGS" to expand its submenu.',
      'Select "Create/View Deliverables".',
      'At the top-right of the page, click the "+ Add New" button.',
      'Fill out the form (Office, Period, Deliverable details, etc.).',
      'Save or submit to add the new deliverable to the list.',
    ],
  ),
  HelpTopic(
    keywords: ['edit deliverable', 'update deliverable', 'baguhin deliverable'],
    question: 'Paano i-edit ang isang Deliverable?',
    steps: [
      'Pumunta sa "PGS" > "Create/View Deliverables".',
      'Hanapin ang deliverable sa listahan (pwede ring gamitin ang filters sa taas).',
      'I-click ang pencil/edit icon sa "Actions" column ng row nito.',
      'I-update ang mga field na gusto mong baguhin.',
      'I-save ang mga pagbabago.',
    ],
    questionEn: 'How do I edit a Deliverable?',
    stepsEn: [
      'Go to "PGS" > "Create/View Deliverables".',
      'Find the deliverable in the list (you can also use the filters at the top).',
      'Click the pencil/edit icon in the "Actions" column of that row.',
      'Update the fields you want to change.',
      'Save your changes.',
    ],
  ),
  HelpTopic(
    keywords: [
      'delete deliverable',
      'alisin deliverable',
      'burahin deliverable',
    ],
    question: 'Paano mag-delete ng Deliverable?',
    steps: [
      'Pumunta sa "PGS" > "Create/View Deliverables".',
      'Hanapin ang deliverable na gusto mong tanggalin.',
      'I-click ang trash/delete icon sa "Actions" column.',
      'Kumpirmahin ang pag-delete sa lalabas na dialog.',
    ],
    questionEn: 'How do I delete a Deliverable?',
    stepsEn: [
      'Go to "PGS" > "Create/View Deliverables".',
      'Find the deliverable you want to remove.',
      'Click the trash/delete icon in the "Actions" column.',
      'Confirm the deletion in the dialog that appears.',
    ],
  ),
  HelpTopic(
    keywords: ['swot', 'gumawa ng swot', 'create swot'],
    question: 'Paano gumawa ng SWOT Analysis?',
    steps: [
      'Sa sidebar, i-click ang "PGS".',
      'Piliin ang "Create/View SWOT".',
      'I-click ang "+ Add New" o katumbas na button.',
      'Punan ang Department, Objective Statement, Internal at External Context.',
      'I-save ang SWOT Analysis.',
    ],
    questionEn: 'How do I create a SWOT Analysis?',
    stepsEn: [
      'In the sidebar, click "PGS".',
      'Select "Create/View SWOT".',
      'Click the "+ Add New" (or equivalent) button.',
      'Fill in the Department, Objective Statement, Internal and External Context.',
      'Save the SWOT Analysis.',
    ],
  ),
  HelpTopic(
    keywords: ['status', 'monitor', 'monitoring', 'track deliverable'],
    question: 'Paano i-monitor ang status ng Deliverables?',
    steps: [
      'Sa sidebar, i-click ang "PGS".',
      'Piliin ang "Deliverable Status Monitoring".',
      'Gamitin ang filters (Service, Office, Period, KRA, Type) para hanapin ang specific deliverables.',
      'I-click ang "Accomplishment" o "Breakthrough" button para makita ang detalye.',
    ],
    questionEn: 'How do I monitor Deliverable status?',
    stepsEn: [
      'In the sidebar, click "PGS".',
      'Select "Deliverable Status Monitoring".',
      'Use the filters (Service, Office, Period, KRA, Type) to find specific deliverables.',
      'Click the "Accomplishment" or "Breakthrough" button to view details.',
    ],
  ),
];

/// Very small set of Tagalog/Taglish marker words. If the query contains
/// none of these (and isn't empty), we treat it as an English query and
/// answer with the English (stepsEn) version instead of the Taglish one.
const List<String> _tagalogMarkers = [
  'paano',
  'gumawa',
  'gawa',
  'bagong',
  'alisin',
  'burahin',
  'baguhin',
  'tanggalin',
  'saan',
  'ano',
  'pano',
  'yung',
  'ung',
  'mo',
  'ko',
  'ang',
  'ng',
  'sa',
  'para',
  'kung',
  'na',
  'dapat',
];

bool _isEnglishQuery(String query) {
  final words = query
      .toLowerCase()
      .split(RegExp(r'[^a-zA-Z]+'))
      .where((w) => w.isNotEmpty);
  if (words.isEmpty) return false;
  return words.every((w) => !_tagalogMarkers.contains(w));
}

class HelpAnswer {
  final String question;
  final List<String> steps;

  const HelpAnswer({required this.question, required this.steps});
}

List<HelpAnswer> searchHelpTopics(String query) {
  final q = query.toLowerCase().trim();
  if (q.isEmpty) return [];

  final matches = helpTopics.where(
    (topic) => topic.keywords.any((k) => q.contains(k) || k.contains(q)),
  );

  final useEnglish = _isEnglishQuery(query);

  return matches
      .map(
        (topic) =>
            useEnglish
                ? HelpAnswer(question: topic.questionEn, steps: topic.stepsEn)
                : HelpAnswer(question: topic.question, steps: topic.steps),
      )
      .toList();
}
