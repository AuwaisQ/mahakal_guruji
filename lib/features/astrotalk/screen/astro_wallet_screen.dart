import 'package:flutter/material.dart';

class WalletAddMoneyScreen extends StatefulWidget {
  const WalletAddMoneyScreen({super.key});

  @override
  State<WalletAddMoneyScreen> createState() => _WalletAddMoneyScreenState();
}

class _WalletAddMoneyScreenState extends State<WalletAddMoneyScreen> {
  int selectedIndex = 1; // ₹100 is selected by default

  final List<Map<String, dynamic>> amounts = [
    {'amount': 50, 'extra': '100% Extra'},
    {'amount': 100, 'extra': '100% Extra'},
    {'amount': 200, 'extra': '50% Extra'},
    {'amount': 500, 'extra': '50% Extra', 'popular': true},
    {'amount': 1000, 'extra': '5% Extra'},
    {'amount': 2000, 'extra': '10% Extra'},
    {'amount': 3000, 'extra': '10% Extra'},
    {'amount': 4000, 'extra': '12% Extra'},
    {'amount': 8000, 'extra': '12% Extra'},
    {'amount': 15000, 'extra': '15% Extra'},
    {'amount': 20000, 'extra': '15% Extra'},
    {'amount': 50000, 'extra': '20% Extra'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle add money action
        },
        label: const Text(
          'Add Money',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      appBar: AppBar(
        title: const Text('Add money to wallet'),
        centerTitle: false,
        leading: const BackButton(),
        actions: const [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined),
              SizedBox(width: 4),
              Text('₹ 0', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: GridView.builder(
          itemCount: amounts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.01,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = amounts[index];
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.yellow[50] : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₹ ${item['amount']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['extra'],
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item['popular'] == true)
                    Positioned(
                      top: 5,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Most Popular',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
