import 'package:flutter/material.dart';

/// Screen 105: Transfer Balance - List Contact (Address Book)
const Color _listPurple = Color(0xFF6C63FF);

/// Contact model used in transfer flow (shared with transfer_balance_screen and confirmation).
class TransferContact {
  final String name;
  final String phone;
  final String initial;
  final bool isFavorite;
  const TransferContact({
    required this.name,
    required this.phone,
    required this.initial,
    this.isFavorite = false,
  });
}

class TransferBalanceListContactScreen extends StatefulWidget {
  const TransferBalanceListContactScreen({super.key});

  @override
  State<TransferBalanceListContactScreen> createState() =>
      _TransferBalanceListContactScreenState();
}

class _TransferBalanceListContactScreenState
    extends State<TransferBalanceListContactScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  static const List<TransferContact> _favorites = [
    TransferContact(
      name: 'Aileen Fullbright',
      phone: '+17896 8797 908',
      initial: 'A',
      isFavorite: true,
    ),
    TransferContact(
      name: 'Leif Floyd',
      phone: '+7 445 553 3864',
      initial: 'L',
      isFavorite: true,
    ),
  ];

  static const List<TransferContact> _allContacts = [
    TransferContact(name: 'Tyra Dhillon', phone: '+995 940 555 766', initial: 'T'),
    TransferContact(
        name: 'Marielle Wigington', phone: '+56 955 588 939', initial: 'M'),
    TransferContact(name: 'Freida Varnes', phone: '+226 755 558 14', initial: 'F'),
    TransferContact(name: 'Thad Eddings', phone: '+7 445 556 8337', initial: 'T'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _query = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(TransferContact c) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return c.name.toLowerCase().contains(q) || c.phone.contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    final filteredFavorites = _favorites.where(_matches).toList();
    final filteredAll = _allContacts.where(_matches).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Address Book'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _listPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 22, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (filteredFavorites.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Favorites',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    ...filteredFavorites.map((c) => _ContactTile(
                          contact: c,
                          onTap: () => _selectContact(c),
                        )),
                    const SizedBox(height: 20),
                  ],
                  if (filteredAll.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'All Contacts',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    ...filteredAll.map((c) => _ContactTile(
                          contact: c,
                          onTap: () => _selectContact(c),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectContact(TransferContact contact) {
    Navigator.of(context).pop(TransferContact(
      name: contact.name,
      phone: contact.phone,
      initial: contact.initial,
    ));
  }
}

class _ContactTile extends StatelessWidget {
  final TransferContact contact;
  final VoidCallback onTap;

  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _listPurple.withValues(alpha: 0.2),
              child: Text(
                contact.initial,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6C63FF),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.phone,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
