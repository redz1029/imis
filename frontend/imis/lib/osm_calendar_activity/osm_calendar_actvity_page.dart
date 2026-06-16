import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityModel {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Color color;
  final String notes;

  ActivityModel({
    required this.id,
    required this.name,
    required this.date,
    this.startTime,
    this.endTime,
    required this.color,
    this.notes = '',
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDay;
  final Map<String, List<ActivityModel>> _activities = {};

  late AnimationController _formController;
  late Animation<double> _formAnimation;
  bool _formOpen = false;

  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _formDate = DateTime.now();
  TimeOfDay? _formStart;
  TimeOfDay? _formEnd;
  Color _formColor = const Color(0xFF1D9E75);

  static const _palette = [
    Color(0xFF1D9E75),
    Color(0xFF378ADD),
    Color(0xFFD4537E),
    Color(0xFFBA7517),
    Color(0xFFE24B4A),
    Color(0xFF7F77DD),
    Color(0xFF888780),
  ];

  String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _formAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    );
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    final seeds = [
      ActivityModel(
        id: '1',
        name: 'Morning run',
        date: now,
        startTime: const TimeOfDay(hour: 6, minute: 0),
        endTime: const TimeOfDay(hour: 7, minute: 0),
        color: const Color(0xFF1D9E75),
      ),
      ActivityModel(
        id: '2',
        name: 'Team standup',
        date: now,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 30),
        color: const Color(0xFF378ADD),
      ),
      ActivityModel(
        id: '3',
        name: 'Yoga session',
        date: now.subtract(const Duration(days: 2)),
        startTime: const TimeOfDay(hour: 7, minute: 0),
        endTime: const TimeOfDay(hour: 8, minute: 0),
        color: const Color(0xFFD4537E),
        notes: 'Bring mat',
      ),
      ActivityModel(
        id: '4',
        name: 'Birthday party',
        date: now.add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        color: const Color(0xFFBA7517),
        notes: "Ana's birthday",
      ),
      ActivityModel(
        id: '5',
        name: 'Doctor appointment',
        date: now.add(const Duration(days: 5)),
        startTime: const TimeOfDay(hour: 10, minute: 30),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        color: const Color(0xFFE24B4A),
      ),
    ];

    for (final a in seeds) {
      final key = _dayKey(a.date);
      _activities.putIfAbsent(key, () => []).add(a);
    }
    _selectedDay = now;
  }

  @override
  void dispose() {
    _formController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _totalActivities =>
      _activities.values.fold(0, (s, l) => s + l.length);
  int get _activeDays => _activities.keys.length;
  int get _monthActivities {
    return _activities.entries
        .where((e) {
          final parts = e.key.split('-');
          return int.parse(parts[0]) == _focusedMonth.year &&
              int.parse(parts[1]) == _focusedMonth.month;
        })
        .fold(0, (s, e) => s + e.value.length);
  }

  void _toggleForm() {
    setState(() => _formOpen = !_formOpen);
    if (_formOpen) {
      _formDate = _selectedDay ?? DateTime.now();
      _formController.forward();
    } else {
      _formController.reverse();
    }
  }

  void _saveActivity() {
    if (_nameController.text.trim().isEmpty) return;
    final key = _dayKey(_formDate);
    final act = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      date: _formDate,
      startTime: _formStart,
      endTime: _formEnd,
      color: _formColor,
      notes: _notesController.text.trim(),
    );
    setState(() {
      _activities.putIfAbsent(key, () => []).add(act);
      _selectedDay = _formDate;
      _focusedMonth = _formDate;
      _nameController.clear();
      _notesController.clear();
      _formStart = null;
      _formEnd = null;
      _formColor = const Color(0xFF1D9E75);
      _formOpen = false;
    });
    _formController.reverse();
  }

  void _deleteActivity(String dayKey, int index) {
    setState(() {
      _activities[dayKey]?.removeAt(index);
      if (_activities[dayKey]?.isEmpty ?? false) {
        _activities.remove(dayKey);
      }
    });
  }

  String _fmt12(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _buildSummaryStrip(),
                  const SizedBox(height: 14),
                  _buildCalendarCard(),
                  const SizedBox(height: 14),
                  _buildActivityPanel(),
                  const SizedBox(height: 14),
                  SizeTransition(
                    sizeFactor: _formAnimation,
                    axisAlignment: -1,
                    child: _buildAddForm(),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF5F7F6),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1D9E75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Activity Calendar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton.icon(
            onPressed: _toggleForm,
            icon: Icon(_formOpen ? Icons.close : Icons.add, size: 16),
            label: Text(_formOpen ? 'Close' : 'Add'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1D9E75),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStrip() {
    return Row(
      children: [
        _summaryTile('$_totalActivities', 'Total'),
        const SizedBox(width: 10),
        _summaryTile('$_activeDays', 'Active days'),
        const SizedBox(width: 10),
        _summaryTile('$_monthActivities', 'This month'),
      ],
    );
  }

  Widget _summaryTile(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildMonthNav(),
          const SizedBox(height: 16),
          _buildWeekdayRow(),
          const SizedBox(height: 6),
          _buildDayGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _navBtn(Icons.chevron_left_rounded, () {
          setState(() {
            _focusedMonth = DateTime(
              _focusedMonth.year,
              _focusedMonth.month - 1,
            );
          });
        }),
        Text(
          DateFormat('MMMM yyyy').format(_focusedMonth),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.3,
          ),
        ),
        _navBtn(Icons.chevron_right_rounded, () {
          setState(() {
            _focusedMonth = DateTime(
              _focusedMonth.year,
              _focusedMonth.month + 1,
            );
          });
        }),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black.withOpacity(0.07)),
        ),
        child: Icon(icon, size: 20, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildWeekdayRow() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final items = <Widget>[];
    for (int i = 0; i < days.length; i++) {
      items.add(
        SizedBox(
          width: 40,
          child: Text(
            days[i],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
              letterSpacing: 0.4,
            ),
          ),
        ),
      );
      if (i < days.length - 1) items.add(const SizedBox(width: 2));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: items);
  }

  Widget _buildDayGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7;

    final cells = <Widget>[];

    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox());
    }

    final todayStr = _dayKey(DateTime.now());

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, d);
      final key = _dayKey(date);
      final acts = _activities[key] ?? [];
      final isToday = key == todayStr;
      final isSelected = _selectedDay != null && _dayKey(_selectedDay!) == key;

      cells.add(
        _DayCell(
          day: d,
          isToday: isToday,
          isSelected: isSelected && !isToday,
          activities: acts,
          onTap: () => setState(() => _selectedDay = date),
        ),
      );
    }

    const double cellSize = 40.0;
    const double cellHeight = 46.0;
    const double hGap = 2.0;
    const double vGap = 4.0;

    while (cells.length % 7 != 0) {
      cells.add(const SizedBox());
    }

    final rows = <Widget>[];
    for (int r = 0; r < cells.length ~/ 7; r++) {
      final rowCells = cells.sublist(r * 7, r * 7 + 7);
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              rowCells
                  .map(
                    (c) =>
                        SizedBox(width: cellSize, height: cellHeight, child: c),
                  )
                  .toList()
                  .expand((w) => [w, const SizedBox(width: hGap)])
                  .toList()
                ..removeLast(),
        ),
      );
      if (r < cells.length ~/ 7 - 1) rows.add(const SizedBox(height: vGap));
    }

    return Column(children: rows);
  }

  Widget _buildActivityPanel() {
    final key = _selectedDay != null ? _dayKey(_selectedDay!) : null;
    final acts = key != null ? (_activities[key] ?? []) : [];
    final dateLabel =
        _selectedDay != null
            ? DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay!)
            : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (dateLabel != null)
                Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (key == null)
            _emptyState('Tap a day to see activities', Icons.touch_app_rounded)
          else if (acts.isEmpty)
            _emptyState(
              'No activities — add one!',
              Icons.event_available_rounded,
            )
          else
            ...acts.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ActivityChip(
                  activity: e.value,
                  fmt12: _fmt12,
                  onDelete: () => _deleteActivity(key, e.key),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyState(String msg, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              msg,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: Color(0xFF1D9E75),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'New activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _formLabel('Activity name'),
          const SizedBox(height: 6),
          _styledTextField(
            _nameController,
            hint: 'e.g. Morning run, Team standup…',
          ),
          const SizedBox(height: 14),

          _formLabel('Date'),
          const SizedBox(height: 6),
          _dateTile(),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formLabel('Start time'),
                    const SizedBox(height: 6),
                    _timeTile(_formStart, 'Start', (t) {
                      if (t != null) setState(() => _formStart = t);
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formLabel('End time'),
                    const SizedBox(height: 6),
                    _timeTile(_formEnd, 'End', (t) {
                      if (t != null) setState(() => _formEnd = t);
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _formLabel('Color tag'),
          const SizedBox(height: 8),
          Row(
            children:
                _palette.map((c) {
                  final active = c == _formColor;
                  return GestureDetector(
                    onTap: () => setState(() => _formColor = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              active
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow:
                            active
                                ? [
                                  BoxShadow(
                                    color: c.withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ]
                                : [],
                      ),
                      child:
                          active
                              ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              )
                              : null,
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 14),

          _formLabel('Notes (optional)'),
          const SizedBox(height: 6),
          _styledTextField(
            _notesController,
            hint: 'Any extra details…',
            maxLines: 2,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _toggleForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    foregroundColor: Colors.grey.shade600,
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _saveActivity,
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Save activity'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9E75),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _styledTextField(
    TextEditingController ctrl, {
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        color: Color(0xFF1A1A1A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: const Color(0xFFF5F7F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _dateTile() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _formDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder:
              (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF1D9E75),
                  ),
                ),
                child: child!,
              ),
        );
        if (picked != null) setState(() => _formDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: Color(0xFF1D9E75),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('MMMM d, yyyy').format(_formDate),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeTile(TimeOfDay? time, String label, Function(TimeOfDay?) onPick) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
          builder:
              (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF1D9E75),
                  ),
                ),
                child: child!,
              ),
        );
        onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 16,
              color: Color(0xFF1D9E75),
            ),
            const SizedBox(width: 8),
            Text(
              time != null ? _fmt12(time) : label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                color:
                    time != null
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final List<ActivityModel> activities;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.activities,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasActs = activities.isNotEmpty;

    Color bg = Colors.transparent;
    Color textColor = const Color(0xFF1A1A1A);

    if (isToday) {
      bg = const Color(0xFF1D9E75);
      textColor = Colors.white;
    } else if (isSelected) {
      bg = const Color(0xFFE1F5EE);
      textColor = const Color(0xFF0F6E56);
    } else if (hasActs) {
      bg = const Color(0xFFF0FBF7);
      textColor = const Color(0xFF0F6E56);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border:
              isSelected && !isToday
                  ? Border.all(color: const Color(0xFF1D9E75), width: 1.5)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isToday || isSelected ? FontWeight.w700 : FontWeight.w400,
                color: textColor,
              ),
            ),
            if (hasActs) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    activities.take(3).map((a) {
                      return Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color:
                              isToday ? Colors.white.withOpacity(0.8) : a.color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityChip extends StatelessWidget {
  final ActivityModel activity;
  final String Function(TimeOfDay) fmt12;
  final VoidCallback onDelete;

  const _ActivityChip({
    required this.activity,
    required this.fmt12,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr =
        activity.startTime != null && activity.endTime != null
            ? '${fmt12(activity.startTime!)} – ${fmt12(activity.endTime!)}'
            : activity.startTime != null
            ? fmt12(activity.startTime!)
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: activity.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (timeStr != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
                if (activity.notes.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    activity.notes,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: Colors.grey.shade400,
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
