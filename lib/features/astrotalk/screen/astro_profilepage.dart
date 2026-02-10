import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/astrotalk/screen/astro_chatscreen.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/utill/razorpay_screen.dart';
import 'package:provider/provider.dart';

import '../../../utill/app_constants.dart';
import '../components/wallet_recharge_screen.dart';

class AstrologerprofileView extends StatefulWidget {
  String id;
  AstrologerprofileView({super.key, required this.id});

  @override
  State<AstrologerprofileView> createState() => _AstrologerprofileViewState();
}

class _AstrologerprofileViewState extends State<AstrologerprofileView> {
  Map<String, dynamic>? astrologerData;
  String userId = '';
  bool _isCalling = false;
  bool _isLoading = true;
  String userName = '';
  String userPhone = '';
  String userEmail = '';
  String walletBalance = '0';

  @override
  void initState() {
    print('Astrologer ID: ${widget.id}');
  
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userPhone =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
    userEmail =
        Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    fetchAstrologerData();
    walletAmount();
    
    super.initState();
  }

  Future<bool> walletAmount() async {
    setState(() {
      _isLoading = true;
    });
    var res =
        await HttpService().getApi('${AppConstants.fetchWalletAmount}$userId');
    if (res['success']) {
      if (res['wallet_balance'] == 0) {
        print('Wallet amount is zero');
        setState(() {
          _isLoading = false;
        });
        return false;
      } else {
        print('Wallet amount is-${res['wallet_balance']}');
        setState(() {
          walletBalance = res['wallet_balance'].toString();
          _isLoading = false;
        });
        return true;
      }
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

  // Get wallet balance as double for pre-request checks
  Future<double> getWalletBalance() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var res = await HttpService().getApi('${AppConstants.fetchWalletAmount}$userId');
      if (res['success'] && res['wallet_balance'] != null) {
        return (res['wallet_balance'] as num).toDouble();
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    return 0.0;
  }

  Future<void> fetchAstrologerData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.astrologersList}/${widget.id}'));
      print('Astrologer URL: ${AppConstants.astrologersList}/${widget.id}');
      print('astrologer Response-${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        setState(() {
          astrologerData = jsonDecode(response.body);
          print('astrologer data-$astrologerData');
        });
      } else {
        // Handle error
        print('Failed to load astrologer data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching astrologer data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> makeCallRequest(String callType) async {
    const String apiUrl = '${AppConstants.expressURI}/api/call-requests';
    setState(() {
      _isCalling = true;
    });

    // Pre-check wallet for 5 minutes based on call type
    final perMin = callType == 'audio'
        ? (astrologerData?['is_astrologer_call_charge'] ?? 0) as num
        : (astrologerData?['is_astrologer_live_stream_charge'] ?? 0) as num;
    final required = perMin.toDouble() * 5.0;
    final balance = await getWalletBalance();
    if (balance < required) {
      // Don't send the request, prompt recharge
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => RechargeBottomSheet(
          userId: userId,
          userEmail: userEmail,
          userName: userName,
          userPhone: userPhone,
        ),
      );
      setState(() {
        _isCalling = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'astrologer_id': widget.id,
          'call_type': callType
        }),
      );
      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print('Call request successful: $responseBody');
        // Show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Call Request Submitted'),
              content: Text('${responseBody['message']}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      } else {
        final responseBody = jsonDecode(response.body);
        print(
            'Failed to make call request: ${response.statusCode} - ${response.body}');
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Call Request Waiting'),
              content: Text('${responseBody['message']}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error making call request: $e');
    } finally {
      setState(() {
        _isCalling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isLoading == true
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white70,
              ),
              child: Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () async {
                        print('Chat Now tapped');

                        final charge = (astrologerData?['is_astrologer_chat_charge'] ?? 0) as num;
                        final required = charge.toDouble() * 5.0;
                        final balance = await getWalletBalance();
                        print('Balance=$balance required=$required');

                        if (balance >= required) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => ChatScreenView(
                                    astrologerId: "${astrologerData?['id']}",
                                    astrologerName: astrologerData?['name'] ?? 'Astrologer',
                                    astrologerImage: "${AppConstants.astrologersImages}${astrologerData?['image']}",
                                    chargePerMin: astrologerData?['is_astrologer_chat_charge'] ?? 0,
                                    userId: userId,
                                      )));
                          return;
                        } else {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => RechargeBottomSheet(
                              userId: userId,
                              userEmail: userEmail,
                              userName: userName,
                              userPhone: userPhone,
                            ),
                          );
                          return;
                        }
                      },
                      child: Text(
                        'Chat\nRs. ${astrologerData?['is_astrologer_chat_charge']}/min',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white,fontSize: 12),
                      )),
                  SizedBox(width: 6,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () async {
                        if (astrologerData != null &&
                            astrologerData!['id'] != null) {
                          final perMin = (astrologerData?['is_astrologer_call_charge'] ?? 0) as num;
                          final required = perMin.toDouble() * 5.0;
                          final balance = await getWalletBalance();
                          if (balance >= required) {
                            makeCallRequest('audio');
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => RechargeBottomSheet(
                                userId: userId,
                                userEmail: userEmail,
                                userName: userName,
                                userPhone: userPhone,
                              ),
                            );
                          }
                        }
                      },
                      child:  Text(
                        'Audio Call\nRs. ${astrologerData?['is_astrologer_call_charge']}/min',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white,fontSize: 12),
                      )),
                  SizedBox(width: 6,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () async {
                        if (astrologerData != null &&
                            astrologerData!['id'] != null) {
                          final perMin = (astrologerData?['is_astrologer_live_stream_charge'] ?? 0) as num;
                          final required = perMin.toDouble() * 5.0;
                          final balance = await getWalletBalance();
                          if (balance >= required) {
                            makeCallRequest('video');
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => RechargeBottomSheet(
                                userId: userId,
                                userEmail: userEmail,
                                userName: userName,
                                userPhone: userPhone,
                              ),
                            );
                          }
                        }
                      },
                      child: _isCalling
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          :  Text(
                              'Video Call\nRs. ${astrologerData?['is_astrologer_live_stream_charge']}/min',
                              textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white,fontSize: 12),
                            )),
                ],
              ),
            ),
      appBar: AppBar(
        title:
            const Text('Profile', style: TextStyle(color: Colors.amber)),
        actions: [
          GestureDetector(
              onTap: () {
                print('userId:$userId');
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => RechargeBottomSheet(
                    userId: userId,
                    userEmail: userEmail,
                    userName: userName,
                    userPhone: userPhone,
                  ),
                );
              },
              child: const Icon(
                    Icons.account_balance_wallet,
                    size: 27,
                    color: Colors.amber,
                  ),),

          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          _isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ---------- TYPE CHECK ----------
                  Builder(builder: (context) {
                    final bool isAstrologer =
                        astrologerData?['is_astrologer_call_charge'] != null ||
                            astrologerData?['is_astrologer_chat_charge'] != null;

                    final bool isPandit =
                        astrologerData?['is_pandit_pooja'] != null ||
                            astrologerData?['is_pandit_offlinepooja'] != null;

                    /// ---------- HEADER ----------
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                Border.all(color: Colors.deepOrange, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: NetworkImage(
                                  "${AppConstants.astrologersImages}${astrologerData?['image']}",
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          astrologerData?['name'] ?? '',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Icon(Icons.verified,
                                          color: Colors.green, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${astrologerData?['experience'] ?? 0} yrs experience",
                                    style: TextStyle(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ---------- ABOUT ----------
                        _aboutCard("About",
                            astrologerData?['bio']),

                        _aboutCard("Qualities",
                            astrologerData?['qualities']),

                        /// ---------- LANGUAGE ----------
                        const SizedBox(height: 12),
                        _sectionTitle('Languages'),
                        Wrap(
                          spacing: 8,
                          children: (() {
                            final langData = astrologerData?['language'];
                            List<dynamic> langs = [];
                            if (langData is String) {
                              try {
                                langs = jsonDecode(langData);
                              } catch (_) {
                                langs = langData.split(',');
                              }
                            } else if (langData is List) {
                              langs = langData;
                            }
                            return langs
                                .map((l) => Chip(
                              label: Text(l.toString().toUpperCase()),
                              backgroundColor:
                              Colors.amber.shade50,
                              side: BorderSide(
                                  color: Colors.amber.shade300),
                            ))
                                .toList();
                          })(),
                        ),

                        /// ---------- ASTROLOGER SERVICES ----------
                        if (isAstrologer) ...[
                          const SizedBox(height: 20),
                          _sectionTitle('Consultation Charges'),
                          _serviceTile("Call",
                              astrologerData?['is_astrologer_call_charge'],
                              Icons.call),
                          _serviceTile("Chat",
                              astrologerData?['is_astrologer_chat_charge'],
                              Icons.chat),
                          _serviceTile("Live",
                              astrologerData?['is_astrologer_live_stream_charge'],
                              Icons.videocam),
                          _serviceTile("Report",
                              astrologerData?['is_astrologer_report_charge'],
                              Icons.description),
                        ],

                        /// ---------- PANDIT DETAILS ----------
                        if (isPandit) ...[
                          const SizedBox(height: 24),

                          _sectionTitle('Pandit Details'),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFFF8E1), // luxury cream
                                  const Color(0xFFFFECB3), // soft gold
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.amber.shade300,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.25),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),

                            child: Column(
                              children: [

                                /// GOTRA
                                _premiumInfoRow(
                                  icon: Icons.account_circle_outlined,
                                  title: "Gotra",
                                  value: astrologerData?['is_pandit_gotra'],
                                ),

                                _premiumDivider(),

                                /// MANDIR
                                _premiumInfoRow(
                                  icon: Icons.temple_hindu,
                                  title: "Primary Mandir",
                                  value: astrologerData?['is_pandit_primary_mandir'],
                                ),

                                _premiumDivider(),

                                /// CHARGES ROW
                                Row(
                                  children: [
                                    Expanded(
                                      child: _chargeCard(
                                        title: "Min Charge",
                                        amount: astrologerData?['is_pandit_min_charge'],
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _chargeCard(
                                        title: "Max Charge",
                                        amount: astrologerData?['is_pandit_max_charge'],
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 60),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style:
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _aboutCard(String title, String? text) {
    if (text == null || text.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(text,
              style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _serviceTile(String title, dynamic price, IconData icon) {
    if (price == null) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text("₹$price",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
        ],
      ),
    );
  }

  Widget _premiumInfoRow({
    required IconData icon,
    required String title,
    dynamic value,
  }) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.shade100,
          ),
          child: Icon(icon, color: Colors.deepOrange, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _premiumDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.amber.shade300.withOpacity(0.6),
      ),
    );
  }

  Widget _chargeCard({
    required String title,
    dynamic amount,
    required Color color,
  }) {
    if (amount == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "₹${NumberFormat('#,##0').format(amount)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

}
