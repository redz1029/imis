import 'package:flutter/material.dart';
import 'package:imis/character/services/character_service.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CharacterPage createState() => _CharacterPage();
}

class _CharacterPage extends State<CharacterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  // Separate controllers for the side-panel editor
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editRemarksController = TextEditingController();
  List<Map<String, dynamic>> _savedItems = <Map<String, dynamic>>[];
  int? _editingId;

  bool _isDuplicateName(String name, [int? excludeId]) {
    final n = name.trim().toLowerCase();
    for (final item in _savedItems) {
      final id = item['id'] is int ? item['id'] as int : null;
      final existing = item['name']?.toString().trim().toLowerCase() ?? '';
      if (existing.isNotEmpty && existing == n && id != excludeId) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final list = await CharacterService.getCharacters();
    if (!mounted) return;
    setState(() {
      _savedItems = list;
      // do not overwrite user input when loading the list; only set controllers
      if (_savedItems.isNotEmpty) {
        final first = _savedItems.last;
        final name = first['name']?.toString() ?? '';
        final remarks = first['remarks']?.toString() ?? '';
        // keep controllers only if they're empty
        if (_nameController.text.isEmpty) _nameController.text = name;
        if (_remarksController.text.isEmpty) _remarksController.text = remarks;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _remarksController.dispose();
    _editNameController.dispose();
    _editRemarksController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    final remarks = _remarksController.text.trim();
    try {
      // ensure we have the latest list before checking duplicates
      await _loadSaved();
      if (_isDuplicateName(name, _editingId)) {
        if (!mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(const SnackBar(content: Text('Name already exists')));
        return;
      }
      await CharacterService.saveCharacter(name, remarks, id: _editingId);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text(_editingId == null ? 'Character saved' : 'Character updated')),
      );
      // reload full list so the new/updated item appears
      await _loadSaved();
      // clear input and editing state after save
      _nameController.clear();
      _remarksController.clear();
      setState(() {
        _editingId = null;
      });
    } catch (e) {
      final msg = e is Exception ? e.toString() : 'Unknown error';
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to save: $msg'),
        ),
      );
    }
  }

  Future<void> _deleteCharacter(int id) async {
    try {
      await CharacterService.deleteCharacter(id: id);
      if (!mounted) return;
      await _loadSaved();
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(const SnackBar(content: Text('Character deleted')));
    } catch (e) {
      final msg = e is Exception ? e.toString() : 'Unknown error';
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text('Failed to delete: $msg')));
    }
  }

  Future<void> _confirmAndDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm delete'),
        content: const Text('Are you sure you want to delete this character?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _deleteCharacter(id);
    }
  }

  Future<void> _openEditDialog(Map<String, dynamic> item) async {
    final id = item['id'] is int ? item['id'] as int : null;
    setState(() {
      _editingId = id;
      _editNameController.text = item['name']?.toString() ?? '';
      _editRemarksController.text = item['remarks']?.toString() ?? '';
    });

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit character'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _editNameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 8),
              TextField(controller: _editRemarksController, decoration: const InputDecoration(labelText: 'Remarks')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final name = _editNameController.text.trim();
                final remarks = _editRemarksController.text.trim();
                // ensure latest items loaded before duplicate check
                await _loadSaved();
                if (_isDuplicateName(name, _editingId)) {
                  if (!mounted) return;
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(const SnackBar(content: Text('Name already exists')));
                  return;
                }
                try {
                  await CharacterService.saveCharacter(name, remarks, id: _editingId);
                  if (!mounted) return;
                  Navigator.of(ctx).pop(true);
                } catch (_) {
                  if (!mounted) return;
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(const SnackBar(content: Text('Character updated')));
      await _loadSaved();
      setState(() {
        _editingId = null;
      });
      _editNameController.clear();
      _editRemarksController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Right-side panel for editing existing items
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit character', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextField(
                  controller: _editNameController,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _editRemarksController,
                  decoration: const InputDecoration(labelText: 'Remarks', border: OutlineInputBorder()),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                              final name = _editNameController.text.trim();
                              final remarks = _editRemarksController.text.trim();
                              try {
                                await CharacterService.saveCharacter(name, remarks, id: _editingId);
                                if (!mounted) return;
                                Navigator.of(context).pop(); // close drawer
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(
                                  SnackBar(content: Text(_editingId == null ? 'Character saved' : 'Character updated')),
                                );
                                await _loadSaved();
                                setState(() {
                                  _editingId = null;
                                });
                                _editNameController.clear();
                                _editRemarksController.clear();
                              } catch (e) {
                                final msg = e is Exception ? e.toString() : 'Unknown error';
                                if (!mounted) return;
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(SnackBar(content: Text('Failed to save: $msg')));
                              }
                            },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Character'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter character data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                child: TextField(
                  controller: _remarksController,
                  decoration: const InputDecoration(
                    labelText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveName(),
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _saveName,
                    child: Text(_editingId == null ? 'Save' : 'Update'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      _nameController.clear();
                      _remarksController.clear();
                      setState(() {
                        _editingId = null;
                      });
                      if (!mounted) return;
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(const SnackBar(content: Text('Input cleared')));
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), 
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 8),
              ..._savedItems.map((item) {
                final id = item['id'] is int ? item['id'] as int : null;
                final name = item['name']?.toString() ?? 'Not set';
                final remarks = item['remarks']?.toString() ?? 'Not set';
                return Card(
                  key: ValueKey(id ?? name),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(remarks, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            OutlinedButton(
                                onPressed: id == null
                                    ? null
                                    : () {
                                        _openEditDialog(item);
                                      },
                              child: const Text('Edit'),
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton(
                              onPressed: id == null
                                  ? null
                                  : () async {
                                      await _confirmAndDelete(id);
                                    },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
