import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Market accent – purple used on stocks screens
const Color _marketPurple = Color(0xFF6C63FF);

/// Search Stock – Auto type
/// Search bar with live suggestions as user types
class SearchStockScreen extends StatefulWidget {
  const SearchStockScreen({super.key});

  @override
  State<SearchStockScreen> createState() => _SearchStockScreenState();
}

class _SearchStockScreenState extends State<SearchStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  static const List<_StockItem> _allStocks = [
    _StockItem(symbol: 'AAPL', name: 'Apple, Inc.', price: '\$145,19.00', change: 3.10, logoLetter: 'A', logoColor: Color(0xFF555555)),
    _StockItem(symbol: 'ABNB', name: 'Airbnb, Inc.', price: '\$112,72.00', change: 0.33, logoLetter: 'A', logoColor: Color(0xFFFF5A5F)),
    _StockItem(symbol: 'AMZN', name: 'Amazon, Inc.', price: '\$112,85.00', change: 0.35, logoLetter: 'a', logoColor: Color(0xFFFF9900)),
    _StockItem(symbol: 'AMD', name: 'Advance Micro Devices', price: '\$57,46', change: -0.90, logoLetter: 'A', logoColor: Color(0xFFED1C24)),
    _StockItem(symbol: 'GOOGL', name: 'Alphabet Inc.', price: '\$142,30', change: 0.85, logoLetter: 'G', logoColor: Color(0xFF4285F4)),
    _StockItem(symbol: 'MSFT', name: 'Microsoft Corp.', price: '\$378,90', change: -0.22, logoLetter: 'M', logoColor: Color(0xFF00A4EF)),
    _StockItem(symbol: 'META', name: 'Meta Platforms, Inc.', price: '\$485,20', change: 1.12, logoLetter: 'f', logoColor: Color(0xFF0668E1)),
    _StockItem(symbol: 'TSLA', name: 'Tesla, Inc.', price: '\$248,60', change: -0.56, logoLetter: 'T', logoColor: Color(0xFFCC0000)),
    _StockItem(symbol: 'NVDA', name: 'NVIDIA Corp.', price: '\$495,00', change: 2.45, logoLetter: 'N', logoColor: Color(0xFF76B900)),
  ];

  List<_StockItem> get _filteredStocks {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _allStocks;
    return _allStocks
        .where((s) =>
            s.symbol.toLowerCase().contains(q) || s.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Search Stock - Auto type',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (_) => setState(() {}),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            // Results
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _filteredStocks.isEmpty
                    ? Center(
                        key: const ValueKey('empty'),
                        child: Text(
                          'No results for "${_searchController.text}"',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      )
                    : ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredStocks.length,
                        itemBuilder: (context, i) {
                          final s = _filteredStocks[i];
                          return _SearchResultTile(
                            symbol: s.symbol,
                            name: s.name,
                            price: s.price,
                            change: s.change,
                            logoLetter: s.logoLetter,
                            logoColor: s.logoColor,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockItem {
  final String symbol;
  final String name;
  final String price;
  final double change;
  final String logoLetter;
  final Color logoColor;

  const _StockItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.logoLetter,
    required this.logoColor,
  });
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;
        return Container(
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: focusNode.hasFocus
                  ? _marketPurple
                  : Theme.of(context).colorScheme.outlineVariant,
              width: focusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                        onClear();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        );
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final double change;
  final String logoLetter;
  final Color logoColor;

  const _SearchResultTile({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.logoLetter,
    required this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final changeColor = isPositive ? AppColors.accentGreen : AppColors.accentRed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: logoColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    logoLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                          color: changeColor,
                          size: 20,
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: changeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
