import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../core/theme/app_theme.dart';

/// Result returned when user selects a contact.
class ContactPickerResult {
  final String number;
  final String name;
  const ContactPickerResult({required this.number, required this.name});
}

/// Full-screen contact picker: request permission, list contacts, select one.
/// Pops with [ContactPickerResult] on select, or null on back.
class ContactPickerPage extends StatefulWidget {
  const ContactPickerPage({super.key});

  @override
  State<ContactPickerPage> createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage> {
  List<Contact> _contacts = [];
  List<Contact> _filtered = [];
  final _searchController = TextEditingController();
  bool _loading = true;
  String? _error;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(_contacts);
      } else {
        _filtered = _contacts.where((c) {
          final name = c.displayName.toLowerCase();
          final numbers = c.phones.map((p) => p.number.replaceAll(RegExp(r'\D'), '')).where((n) => n.contains(q) || q.contains(n));
          return name.contains(q) || numbers.any((n) => n.contains(q));
        }).toList();
      }
    });
  }

  Future<void> _loadContacts() async {
    setState(() {
      _loading = true;
      _error = null;
      _permissionDenied = false;
    });

    final status = await Permission.contacts.request();
    if (!status.isGranted) {
      setState(() {
        _loading = false;
        _permissionDenied = true;
        _contacts = [];
        _filtered = [];
      });
      return;
    }

    try {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );
      if (!mounted) return;
      setState(() {
        _contacts = contacts..sort((a, b) => a.displayName.compareTo(b.displayName));
        _filtered = List.from(_contacts);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onContactTap(Contact contact) {
    final phones = contact.phones;
    if (phones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No phone number')));
      return;
    }
    final number = phones.first.number.replaceAll(RegExp(r'\D'), '');
    if (number.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid number')));
      return;
    }
    final name = contact.displayName;
    Navigator.of(context).pop(ContactPickerResult(number: number, name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Select contact'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or number',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          if (_permissionDenied)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.contacts_rounded, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  const Text(
                    'Contacts access is needed to select a number.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => openAppSettings(),
                    child: const Text('Open settings'),
                  ),
                ],
              ),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: AppColors.accentRed)),
            )
          else if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final c = _filtered[i];
                  final number = c.phones.isNotEmpty ? c.phones.first.number : '—';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryBlueLight.withValues(alpha: 0.3),
                      child: Text(
                        c.displayName.isNotEmpty ? c.displayName.substring(0, 1).toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.primaryBlue),
                      ),
                    ),
                    title: Text(c.displayName),
                    subtitle: Text(number),
                    onTap: () => _onContactTap(c),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
