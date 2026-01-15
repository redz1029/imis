import 'package:flutter/material.dart';
import 'package:imis/character/services/character_service.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CharacterPage createState() => _CharacterPage();
}

class _CharacterPage extends State<CharacterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  List<Map<String, dynamic>> _savedItems = <Map<String, dynamic>>[];
  int? _editingId;

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
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    final remarks = _remarksController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await CharacterService.saveCharacter(name, remarks, id: _editingId);
      if (!mounted) return;
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
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to save: $msg'),
        ),
      );
    }
  }

  Future<void> _deleteCharacter(int id) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await CharacterService.deleteCharacter(id: id);
      if (!mounted) return;
      await _loadSaved();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(const SnackBar(content: Text('Character deleted')));
    } catch (e) {
      final msg = e is Exception ? e.toString() : 'Unknown error';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      final messenger = ScaffoldMessenger.of(context);
                      if (!mounted) return;
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
                                      // enter edit mode
                                      setState(() {
                                        _editingId = id;
                                        _nameController.text = item['name']?.toString() ?? '';
                                        _remarksController.text = item['remarks']?.toString() ?? '';
                                      });
                                      // scroll to top not implemented — user can see inputs above
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
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
