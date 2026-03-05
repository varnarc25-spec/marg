import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockDetailPage extends StatefulWidget {
  const StockDetailPage({
    super.key,
    required this.stockName,
    this.subtitle,
  });

  /// Display name of the stock or index (e.g. "NIFTY 50", "TEJASNET").
  final String stockName;

  /// Optional subtitle (e.g. full description); currently only used in header.
  final String? subtitle;

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  int selectedRange = 2;

  final List<String> ranges = ["1D", "1W", "1M", "3M", "1Y", "3Y"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            print("Bookmark tapped");
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.link),
                          onPressed: () {
                            print("Link tapped");
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            print("Share tapped");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox.shrink(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.stockName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Price
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "₹24,381.65",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(width: 10),

                  Text(
                    "-484.05 (1.95%)",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Chart
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),

                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 3),
                            FlSpot(1, 4),
                            FlSpot(2, 3.5),
                            FlSpot(3, 5),
                            FlSpot(4, 4),
                            FlSpot(5, 3),
                          ],
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Time filters
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ranges.length,
                  itemBuilder: (context, index) {
                    bool selected = selectedRange == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRange = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            ranges[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Icon(Icons.notifications_none),
                      SizedBox(height: 6),
                      Text("Add Alert"),
                    ],
                  ),

                  Column(
                    children: const [
                      Icon(Icons.push_pin_outlined),
                      SizedBox(height: 6),
                      Text("Pin"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Option chain card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stockName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text("NSE"),
                      ],
                    ),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹24,381.65",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "-484.05 (1.95%)",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Price alert card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Price Alerts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Icon(Icons.alarm, size: 80, color: Colors.blue),

                    const SizedBox(height: 10),

                    const Text("No Price Alert are Set"),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        print("Add alert tapped");
                      },
                      child: const Text("Add Alert"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
