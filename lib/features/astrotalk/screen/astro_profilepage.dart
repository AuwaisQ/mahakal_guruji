import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String astrologerImage;
  AstrologerprofileView({super.key, required this.id, required this.astrologerImage});

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isLoading == true
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white70,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
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
                                        astrologerId:
                                            "${astrologerData?['id']}",
                                        astrologerName:
                                            astrologerData?['name'] ??
                                                'Astrologer',
                                        astrologerImage:
                                            widget.astrologerImage,
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
                        style: const TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
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
                        style:const TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
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
                              style: const TextStyle(color: Colors.white),
                            )),
                ],
              ),
            ),
      appBar: AppBar(
        title:
            const Text('Profile', style: TextStyle(color: Colors.deepOrange)),
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
                    color: Colors.deepOrange,
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
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blue),
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: NetworkImage(
                                  widget.astrologerImage,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(astrologerData?['name'] ?? 'Astrologer',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    const SizedBox(width: 5),
                                    const Icon(Icons.verified,
                                        color: Colors.green, size: 16),
                                  ],
                                ),
                                 Text('${astrologerData?['experience'] ?? 0} years exp | Eng, Hindi',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blueGrey)),
                              ],
                            ),
                          ],
                        ),

                        //image container
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // SizedBox(
                        //   height: 170,
                        //   child: ListView.builder(
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis
                        //         .horizontal, // 👈 Makes the list scroll horizontally
                        //     itemCount: 10,
                        //     itemBuilder: (context, index) {
                        //       return Container(
                        //         width: 120,
                        //         margin: const EdgeInsets.all(5),
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.grey),
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: Colors.blueAccent,
                        //           image: const DecorationImage(
                        //             image: NetworkImage(
                        //               'https://img.pikbest.com/photo/20241022/office-boy-in-photo_10993810.jpg!bw700', // Replace with your image URLs
                        //             ),
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //         alignment: Alignment.center,
                        //       );
                        //     },
                        //   ),
                        // ),

                        //Specialization
                        // _sectionTitle('Specialization'),
                        // GridView.builder(
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: 6,
                        //   gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 3,
                        //     mainAxisSpacing: 10,
                        //     crossAxisSpacing: 10,
                        //     childAspectRatio: 3,
                        //   ),
                        //   itemBuilder: (context, index) {
                        //     return Container(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 16, vertical: 5),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(8),
                        //         border: Border.all(
                        //             color: Colors.deepOrange, width: 1.5),
                        //         // color: Colors.deepOrange
                        //       ),
                        //       child: const Center(
                        //           child: Text(
                        //         'Numerology',
                        //         style: TextStyle(color: Colors.black),
                        //       )),
                        //     );
                        //   },
                        // ),

                        // About Astrologers
                        const SizedBox(
                          height: 10,
                        ),
                        _sectionTitle('About Astrologer'),
                        Text(
                          astrologerData?['bio'] ??
                              'No description available.',
                          style: const TextStyle(color: Colors.grey),
                        ),

                        // About Astrologers
                        const SizedBox(
                          height: 10,
                        ),
                        _sectionTitle('Astrologer Quality'),
                        Text(
                          astrologerData?['qualities'] ??
                              'No quality available.',
                          style: const TextStyle(color: Colors.grey),
                        ),


                        // Language
                        const SizedBox(
                          height: 10,
                        ),
                        _sectionTitle('Language'),
                        Wrap(
                          spacing: 8,
                          children: (() {
                            final langData = astrologerData?['language'];
                            List<dynamic> langs = [];
                            if (langData == null) {
                              langs = [];
                            } else if (langData is String) {
                              try {
                                final decoded = jsonDecode(langData);
                                if (decoded is List) {
                                  langs = decoded;
                                } else if (decoded is Map && decoded['language'] is List) {
                                  langs = decoded['language'];
                                } else {
                                  langs = [decoded.toString()];
                                }
                              } catch (e) {
                                langs = langData
                                    .split(',')
                                    .map((s) => s.trim())
                                    .where((s) => s.isNotEmpty)
                                    .toList();
                              }
                            } else if (langData is List) {
                              langs = langData;
                            } else {
                              langs = [langData.toString()];
                            }
                            return langs
                                .map<Widget>((l) => Chip(label: Text(l?.toString() ?? 'HI')))
                                .toList();
                          })(),
                        ),

                        // Reviews Section
                        Row(
                          children: [
                            _sectionTitle('Rreviews'),
                            const Spacer(),
                            TextButton(
                                onPressed: () {},
                                child: const Text('Read All Reviews'))
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            // final review = controller.reviews[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ...List.generate(
                                          5,
                                          (i) => const Icon(Icons.star,
                                              color: Colors.orange, size: 16)),
                                      const Spacer(),
                                      Text('${DateTime.now()}',
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Maxwell',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text('Reviews',
                                      style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 60),
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
                      color: Colors.deepOrange,
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
      padding: const EdgeInsets.only(top: 10,bottom: 5),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.blue, size: 18),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
