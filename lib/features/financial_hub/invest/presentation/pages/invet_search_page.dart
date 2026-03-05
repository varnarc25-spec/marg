import 'package:flutter/material.dart';
import 'stock_details.dart';

class StockSearchPage extends StatefulWidget {
  const StockSearchPage({super.key});

  @override
  State<StockSearchPage> createState() => _StockSearchPageState();
}

class _StockSearchPageState extends State<StockSearchPage> {
  final List<String> tabs = [
    "All",
    "Stock",
    "Options",
    "Futures",
    "MF",
    "Etf",
    "Indices",
  ];

  int selectedTab = 0;

  final List<Map<String, dynamic>> stocks = [
    {
      "name": "NIFTY",
      "subtitle": "Nifty 50",
      "price": "24,383.25",
      "change": "-482.45 (1.94%)",
      "type": "Index",
      "exchange": "NSE",
      "isPositive": false,
    },
    {
      "name": "SENSEX",
      "subtitle": "BSE Sensex",
      "price": "78,745.18",
      "change": "-1,493.67 (1.86%)",
      "type": "Index",
      "exchange": "BSE",
      "isPositive": false,
    },
    {
      "name": "TATAGOLD",
      "subtitle": "TATAAML-TATAGOLD",
      "price": "15.65",
      "change": "-0.54 (3.34%)",
      "type": "ETF",
      "exchange": "NSE",
      "isPositive": false,
    },
    {
      "name": "TEJASNET",
      "subtitle": "Tejas Networks",
      "price": "508.05",
      "change": "+23.35 (4.82%)",
      "type": "Stock",
      "exchange": "NSE",
      "isPositive": true,
    },
    {
      "name": "BANKNIFTY",
      "subtitle": "Bank Nifty 50",
      "price": "58,479.45",
      "change": "-1,360.20(2.27%)",
      "type": "Index",
      "exchange": "NSE",
      "isPositive": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            onTap: () {},
            decoration: InputDecoration(
              hintText: "Search Stocks",
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  bool active = selectedTab == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontWeight: active
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: active ? Colors.black : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (active)
                            Container(height: 3, width: 20, color: Colors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// Popular Searches
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Popular Searches",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Stock list
            Expanded(
              child: ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StockDetailPage(
                            stockName: stock["name"] as String,
                            subtitle: stock["subtitle"] as String?,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Left side
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                stock["subtitle"],
                                style: const TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  _tag(stock["type"]),
                                  const SizedBox(width: 6),
                                  _tag(stock["exchange"]),
                                ],
                              ),
                            ],
                          ),

                          /// Right side
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                stock["price"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                stock["change"],
                                style: TextStyle(
                                  color: stock["isPositive"]
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }
}
