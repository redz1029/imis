class ClauseItem {
  final int? id;
  final String clause;
  final String group;
  final String title;
  final String requirement;

  const ClauseItem({
    this.id,
    required this.clause,
    required this.group,
    required this.title,
    required this.requirement,
  });

  ClauseItem copyWith({
    int? id,
    String? clause,
    String? group,
    String? title,
    String? requirement,
  }) {
    return ClauseItem(
      id: id ?? this.id,
      clause: clause ?? this.clause,
      group: group ?? this.group,
      title: title ?? this.title,
      requirement: requirement ?? this.requirement,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'clause': clause,
        'group': group,
        'title': title,
        'requirement': requirement,
      };

  factory ClauseItem.fromJson(Map<String, dynamic> json) => ClauseItem(
        id: json['id'] as int?,
        clause: (json['clause'] ?? json['clauseRef'] ?? '').toString(),
        group: (json['group'] ?? '').toString(),
        title: (json['title'] ?? json['description'] ?? '').toString(),
        requirement: (json['requirement'] ?? json['particulars'] ?? '').toString(),
      );
}

/// Natural numeric comparator for ISO clause numbers (e.g. 4.1 < 4.2 < 7.1.1 < 7.2 < 10.1).
int compareClauseNumbers(String a, String b) {
  final aParts = a.trim().split('.');
  final bParts = b.trim().split('.');
  final minLen = aParts.length < bParts.length ? aParts.length : bParts.length;

  for (int i = 0; i < minLen; i++) {
    final aNum = int.tryParse(aParts[i]);
    final bNum = int.tryParse(bParts[i]);

    if (aNum != null && bNum != null) {
      if (aNum != bNum) return aNum.compareTo(bNum);
    } else {
      final comp = aParts[i].compareTo(bParts[i]);
      if (comp != 0) return comp;
    }
  }
  return aParts.length.compareTo(bParts.length);
}

/// All 33 official ISO 9001:2015 standard clauses in exact hierarchical order.
final List<ClauseItem> kDefaultIsoClauses = [
  const ClauseItem(
    clause: '4.1',
    group: '4 - Context of the organization',
    title: 'Understanding the organization and its context',
    requirement:
        "Identify the internal and external issues that affect the organization's ability to deliver its intended results, and keep that picture under review.",
  ),
  const ClauseItem(
    clause: '4.2',
    group: '4 - Context of the organization',
    title: 'Needs and expectations of interested parties',
    requirement:
        "Determine who the interested parties are, what they require, and which of those requirements the QMS has to satisfy. Review this as the parties change.",
  ),
  const ClauseItem(
    clause: '4.3',
    group: '4 - Context of the organization',
    title: 'Scope of the quality management system',
    requirement:
        "Define the boundaries of the QMS, state what it applies to, and justify any requirement judged not applicable.",
  ),
  const ClauseItem(
    clause: '4.4',
    group: '4 - Context of the organization',
    title: 'QMS and its processes',
    requirement:
        "Establish the processes needed for the QMS, their sequence and interaction, the criteria and methods for controlling them, and who is responsible for each.",
  ),
  const ClauseItem(
    clause: '5.1',
    group: '5 - Leadership',
    title: 'Leadership and commitment',
    requirement:
        "Top management takes accountability for the QMS: sets direction, provides resources, promotes the process approach and risk-based thinking, and supports those who make the system work.",
  ),
  const ClauseItem(
    clause: '5.2',
    group: '5 - Leadership',
    title: 'Quality policy',
    requirement:
        "Establish a quality policy suited to the organization, commit to satisfying requirements and to continual improvement, communicate it, and make it available.",
  ),
  const ClauseItem(
    clause: '5.3',
    group: '5 - Leadership',
    title: 'Organizational roles, responsibilities and authorities',
    requirement:
        "Assign, communicate and understand responsibilities and authorities for the QMS, including reporting on performance and maintaining the integrity of the system through change.",
  ),
  const ClauseItem(
    clause: '6.1',
    group: '6 - Planning',
    title: 'Actions to address risks and opportunities',
    requirement:
        "Determine the risks and opportunities arising from the context and interested parties, plan actions to address them, integrate those actions into the processes, and evaluate whether they worked.",
  ),
  const ClauseItem(
    clause: '6.2',
    group: '6 - Planning',
    title: 'Quality objectives and planning to achieve them',
    requirement:
        "Set quality objectives at the relevant functions and levels, make them measurable, monitor them, and plan what will be done, by whom, with what, by when, and how results are evaluated.",
  ),
  const ClauseItem(
    clause: '6.3',
    group: '6 - Planning',
    title: 'Planning of changes',
    requirement:
        "When a change to the QMS is needed, carry it out in a planned way: consider the purpose and consequences, the integrity of the system, resources, and responsibilities.",
  ),
  const ClauseItem(
    clause: '7.1.1',
    group: '7 - Support',
    title: 'Resources - general',
    requirement:
        "Determine and provide the resources needed to establish, maintain and improve the QMS, taking account of what already exists and what must be obtained externally.",
  ),
  const ClauseItem(
    clause: '7.1.2',
    group: '7 - Support',
    title: 'People',
    requirement:
        "Provide the people necessary to operate the processes and control the QMS effectively.",
  ),
  const ClauseItem(
    clause: '7.1.3',
    group: '7 - Support',
    title: 'Infrastructure',
    requirement:
        "Provide and maintain the infrastructure needed for the processes: buildings, utilities, equipment, hardware, software and transport.",
  ),
  const ClauseItem(
    clause: '7.1.4',
    group: '7 - Support',
    title: 'Environment for the operation of processes',
    requirement:
        "Provide and maintain the environment needed for the processes, covering the physical and human factors that affect conformity.",
  ),
  const ClauseItem(
    clause: '7.1.5',
    group: '7 - Support',
    title: 'Monitoring and measuring resources',
    requirement:
        "Where monitoring or measurement is used to verify conformity, provide resources that are fit for purpose and maintained. Where measurement traceability is required, calibrate or verify against traceable standards and keep the records.",
  ),
  const ClauseItem(
    clause: '7.1.6',
    group: '7 - Support',
    title: 'Organizational knowledge',
    requirement:
        "Determine the knowledge needed to operate the processes, maintain it, make it available, and decide how additional knowledge will be acquired when needs change.",
  ),
  const ClauseItem(
    clause: '7.2',
    group: '7 - Support',
    title: 'Competence',
    requirement:
        "Determine the competence needed, ensure people are competent on the basis of education, training or experience, take action where they are not, and retain evidence.",
  ),
  const ClauseItem(
    clause: '7.3',
    group: '7 - Support',
    title: 'Awareness',
    requirement:
        "Ensure people are aware of the quality policy, the objectives relevant to them, their contribution to the system, and the implications of not conforming.",
  ),
  const ClauseItem(
    clause: '7.4',
    group: '7 - Support',
    title: 'Communication',
    requirement:
        "Determine the internal and external communications relevant to the QMS: what is communicated, when, to whom, how, and by whom.",
  ),
  const ClauseItem(
    clause: '7.5',
    group: '7 - Support',
    title: 'Documented information',
    requirement:
        "Maintain the documented information the QMS requires and that the organization decides it needs. Control identification, format, review, approval, distribution, access, storage, retention and disposition.",
  ),
  const ClauseItem(
    clause: '8.1',
    group: '8 - Operation',
    title: 'Operational planning and control',
    requirement:
        "Plan and control the processes needed to meet requirements: determine the requirements, set acceptance criteria, decide the resources, and keep the documented information that shows the processes ran as planned.",
  ),
  const ClauseItem(
    clause: '8.2',
    group: '8 - Operation',
    title: 'Requirements for products and services',
    requirement:
        "Communicate with customers, determine the requirements for the product or service including statutory ones, review those requirements before committing, and manage changes to them.",
  ),
  const ClauseItem(
    clause: '8.3',
    group: '8 - Operation',
    title: 'Design and development',
    requirement:
        "Where design and development is applicable, control it through planning, inputs, controls, outputs and changes.",
  ),
  const ClauseItem(
    clause: '8.4',
    group: '8 - Operation',
    title: 'Externally provided processes, products and services',
    requirement:
        "Ensure externally provided processes, products and services conform. Set criteria for evaluation, selection, monitoring and re-evaluation of external providers, and define the controls applied.",
  ),
  const ClauseItem(
    clause: '8.5',
    group: '8 - Operation',
    title: 'Production and service provision',
    requirement:
        "Carry out provision under controlled conditions: available information, suitable resources, monitoring, competent people, identification and traceability, property belonging to others, preservation, post-delivery activities and control of changes.",
  ),
  const ClauseItem(
    clause: '8.6',
    group: '8 - Operation',
    title: 'Release of products and services',
    requirement:
        "Verify that requirements have been met before release, and keep evidence of conformity with the acceptance criteria and of who authorized the release.",
  ),
  const ClauseItem(
    clause: '8.7',
    group: '8 - Operation',
    title: 'Control of nonconforming outputs',
    requirement:
        "Identify and control outputs that do not conform so they are not used unintentionally, take appropriate action, and keep records of the nonconformity, the action and any concession.",
  ),
  const ClauseItem(
    clause: '9.1',
    group: '9 - Performance evaluation',
    title: 'Monitoring, measurement, analysis and evaluation',
    requirement:
        "Determine what needs monitoring and measuring, the methods, when it is done and when results are analysed, then evaluate performance and effectiveness. Monitor customer perception and analyse the resulting data.",
  ),
  const ClauseItem(
    clause: '9.2',
    group: '9 - Performance evaluation',
    title: 'Internal audit',
    requirement:
        "Conduct internal audits at planned intervals against the organization's own requirements and the standard. Plan a programme accounting for process importance and previous results, define criteria and scope, select objective auditors, report to management, correct what is found, and retain the records.",
  ),
  const ClauseItem(
    clause: '9.3',
    group: '9 - Performance evaluation',
    title: 'Management review',
    requirement:
        "Top management reviews the QMS at planned intervals against a defined set of inputs, and records decisions on improvement, change and resource needs.",
  ),
  const ClauseItem(
    clause: '10.1',
    group: '10 - Improvement',
    title: 'Improvement - general',
    requirement:
        "Determine and select opportunities for improvement and act on them to meet requirements and raise customer satisfaction.",
  ),
  const ClauseItem(
    clause: '10.2',
    group: '10 - Improvement',
    title: 'Nonconformity and corrective action',
    requirement:
        "React to a nonconformity, control and correct it, deal with the consequences, evaluate whether the cause needs eliminating, implement action, review its effectiveness, and update risks and the QMS if needed. Keep records of the nonconformity and the results.",
  ),
  const ClauseItem(
    clause: '10.3',
    group: '10 - Improvement',
    title: 'Continual improvement',
    requirement:
        "Continually improve the suitability, adequacy and effectiveness of the QMS, using the results of analysis, evaluation and management review.",
  ),
];
