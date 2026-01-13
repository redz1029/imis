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
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final name = await CharacterService.getName();
    if (!mounted) return;
    setState(() {
      _savedName = name;
      if (name != null && name.isNotEmpty) {
        _nameController.text = name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final value = _nameController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    CharacterService.saveName(value).then((_) {
      if (!mounted) return;
      setState(() {
        _savedName = value.isEmpty ? null : value;
      });
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(_savedName == null ? 'Name cleared' : 'Name saved'),
        ),
      );
    });
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
                width: 300 ,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
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
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () async {
                      _nameController.clear();
                      final messenger = ScaffoldMessenger.of(context);
                      await CharacterService.clearName();
                      if (!mounted) return;
                      setState(() {
                        _savedName = null;
                      });
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Input cleared')),
                      );
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Text(
                        'Name:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _savedName ?? 'Not set',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
