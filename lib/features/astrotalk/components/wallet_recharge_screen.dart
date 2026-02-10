import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart' as http_service;
import 'package:mahakal/utill/app_constants.dart';

import '../../../utill/razorpay_screen.dart';

// ignore: must_be_immutable
class RechargeBottomSheet extends StatefulWidget {
  String userName;
  String userId;
  String userPhone;
  String userEmail;
  RechargeBottomSheet(
      {super.key,
      required this.userName,
      required this.userId,
      required this.userPhone,
      required this.userEmail});

  @override
  State<RechargeBottomSheet> createState() => _RechargeBottomSheetState();
}

class _RechargeBottomSheetState extends State<RechargeBottomSheet> {
  int selectedAmount = 50;
  final List<int> amounts = [50, 100, 200, 500, 1000, 2000, 3000, 4000];

  Future<bool> updateWalletAmount(int amt) async {
    var res = await http_service.HttpService().postApi(
        '/api/v1/customer/wallet/astro-wallet-update',
        {'user_id': widget.userId, 'amount': amt});
    print('Wallet update response: ${res['status']}');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            // Close Button
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 28),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Wallet Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 18),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded,
                            color: Colors.amber, size: 32),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Wallet Balance',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.amber),
                            ),
                            FutureBuilder(
                              future: http_service.HttpService().getApi(
                                  '${AppConstants.fetchWalletAmount}${widget.userId}'),
                              builder: (context, snapshot) {
                                if (snapshot.hasError ||
                                    snapshot.data == null ||
                                    snapshot.data['success'] != true) {
                                  return const Text('Rs. 0',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold));
                                }
                                return Text(
                                  "Rs. ${snapshot.data['wallet_balance']}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Header
                const Text(
                  'Recharge Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                const Text(
                  'At least 5 minutes balance is required to start a session.',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 18),
                // Amount buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: amounts.map((amount) {
                    bool isSelected = selectedAmount == amount;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAmount = amount;
                        });
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.amber : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.amber
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: Colors.amber.withOpacity(0.15),
                                      blurRadius: 6)
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '₹$amount',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      RazorpayPaymentService().openCheckout(
                        amount: selectedAmount,
                        razorpayKey: AppConstants.razorpayLive,
                        onSuccess: (response) {
                          updateWalletAmount(selectedAmount);
                          print(
                              'Payment Successful TXN: ${response.paymentId}');
                        },
                        onFailure: (response) {},
                        onExternalWallet: (response) {
                          print('Wallet: ${response.walletName}');
                        },
                        description: 'Astro',
                      );
                      Navigator.pop(context);
                      print('Paying Rs $selectedAmount');
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Proceed To Pay',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}