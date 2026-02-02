import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/auth/controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/utill/loading_datawidget.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../main.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/flutter_toast_helper.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../../support/screens/support_ticket_screen.dart';
import '../../model/trackchadhava_model.dart';
import 'track_chadhava_screen.dart';

class ChadhavaMahakalTrackOrder extends StatefulWidget {
  final String poojaId;
  const ChadhavaMahakalTrackOrder({
    super.key,
    required this.poojaId,
  });

  @override
  State<ChadhavaMahakalTrackOrder> createState() =>
      _ChadhavaMahakalTrackOrderState();
}

class _ChadhavaMahakalTrackOrderState extends State<ChadhavaMahakalTrackOrder> {
  ChadhavaTrackModel? trackModelData;

  final billFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  List<String> textValues = []; // Create a list to store the text values
  late List<TextEditingController> textControllers = List.generate(
    noPerson,
    (index) => TextEditingController(),
  );
  final TextEditingController _suggestionsController = TextEditingController();

  int _selectedRating = 3; // Initially all options are unchecked
  int noPerson = 1;

  String userName = "";
  String userNumber = "";
  String userToken = "";

  bool _showText = false;
  bool isYesNo = false;
  bool isChecked = false;
  bool isLoading = false;

  List<String> options = [
    "The online puja was beautifully performed, making me feel connected to the divine right from my home. A truly peaceful and blessed experience! 🙏✨",
    "Did the puja meet your expectations in terms of rituals and authenticity?",
    "Were all your spiritual and religious needs fulfilled during the puja? If not, what more can we do?",
    "Looking for a specific puja or spiritual service? Share your suggestions with us",
    "The Panditji should explain the significance of each step during the puja.",
    "The booking process should be more user-friendly.",
    "I should receive post-puja guidance on what to do next.",
    // ... more options
  ];

  int _selectedIndex = 0; // -1 means no option is selected

  void _handleCheckboxChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String extractNames(String? jsonString) {
    // Handle null input
    if (jsonString == null || jsonString.isEmpty) {
      return ''; // Return an empty string if the input is null or empty
    }

    // Parse JSON and cast to List<String>
    try {
      List<String> names = List<String>.from(jsonDecode(jsonString));

      // Join the names into one string and return
      return names.join(', ');
    } catch (e) {
      // If JSON decoding fails, return an empty string
      print('Error decoding JSON: $e');
      return '';
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'cancel':
        return Colors.red;
      case 'rejected':
        return Colors.red;
      case 'confirmed':
        return Colors.green;
      default:
        return Colors.orange; // Default color for unknown statuses
    }
  }

  String convertDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Invalid date"; // Or any default message you prefer
    }

    try {
      final dateTime = DateFormat('yyyy-MM-dd').parse(date);
      final formattedDate = DateFormat("dd-MMMM-yyyy").format(dateTime);
      return formattedDate;
    } catch (e) {
      return "Invalid format"; // Handle parsing errors
    }
  }

  String formatCreatedAt(String createdAt) {
    try {
      // Parse the ISO 8601 string to a DateTime object
      DateTime dateTime = DateTime.parse(createdAt);

      // Format the DateTime object to the desired format
      String formattedDate =
          DateFormat('dd-MMMM-yyyy').format(dateTime).toLowerCase();

      return formattedDate; // Return the formatted date
    } catch (e) {
      // Handle invalid input gracefully
      return "Invalid date";
    }
  }

  // button functionality
  void submitForm() {
    isLoading = true;
    if (!isYesNo) {
      if (textControllers.isEmpty || gotraController.text.isEmpty) {
        billFormKey.currentState!.validate();

// For general toast
        ToastHelper.showToast(message: "Form fields required!");
        setState(() {
          isLoading = false;
        });
      } else {
        saveTextValues();
        sendPostRequest("chadhava-sankalp-update");
      }
    }
  }

  Future<void> sendPostRequest(String Url) async {
    // Define the API endpoint
    String orderId = "${trackModelData?.order.orderId}";
    String apiUrl =
        '${AppConstants.baseUrl}${AppConstants.poojaAllUrl}/$Url/$orderId';

    // Create the data payload
    Map<String, dynamic> data = {
      "newPhone": int.parse(phoneController.text),
      "gotra": gotraController.text,
      "reason": "aise hi",
      "members": textValues,
    };

    // Make the POST request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Request successful');

        Navigator.pop(context);
        nameController.clear();
        gotraController.clear();
        phoneController.clear();
        textControllers.clear();
        textValues.clear();
        getTrackData(widget.poojaId);
        print(response.body);
      } else {
        // Handle error
        print('Failed to send request: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle exception
      print('An error occurred: $e');
    }
  }

  // Method to print the text from each TextEditingController
  void saveTextValues() {
    // Iterate over the textControllers and add the text to the list
    for (int i = 0; i < textControllers.length; i++) {
      setState(() {
        textValues.add(textControllers[i].text);
      });
    }
    print(textValues); // Print the list
  }

  void addMemberList() {
    String names = "${trackModelData?.order.members}";
    print("Members are $names");
    // Removing [ and ] symbols and extra spaces
    names = names.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');

    // Splitting the cleaned string into a list of names using ','
    List<String> nameList = names.split(',');

    // Trimming each name to remove any extra spaces
    List<String> finalList = nameList.map((name) => name.trim()).toList();

    // Ensure the number of names does not exceed the number of controllers
    int limit = textControllers.length < finalList.length
        ? textControllers.length
        : finalList.length;

    for (int i = 0; i < limit; i++) {
      setState(() {
        textControllers[i].text = finalList[i];
        phoneController.text = "${trackModelData?.order.newphone}";
        gotraController.text = "${trackModelData?.order.gotra}";
      });
    }
    // Printing the final list for debugging
    print(finalList);
  }

  void showInfoBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        AppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          leading: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                CupertinoIcons.chevron_back,
                                color: Colors.red,
                              )),
                          title: const Text(
                            'Update Details',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Form(
                            key: billFormKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),

                                Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1.5),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${trackModelData?.order.chadhava.name}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                            color: Colors.grey),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "₹${trackModelData?.order.payAmount}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 30,
                                              color: Colors.orange,
                                            ),
                                            onTap: () {
                                              modalSetter(() {
                                                _showText = !_showText;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                      _showText
                                          // _showMore
                                          ? Column(
                                              children: [
                                                const Divider(
                                                  color: Colors.grey,
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Icon(Icons.location_pin ,color: Colors.orange,size: 20,),
                                                //     SizedBox(
                                                //         width: screenWidth * 0.7,
                                                //         child: Text(
                                                //           "Navgrah Shani Mandir,Ujjain,Madhaya Pradesh",
                                                //           style: TextStyle(
                                                //               fontSize: 14,
                                                //               fontWeight: FontWeight.w400,
                                                //               fontFamily: 'Roboto',
                                                //               overflow:
                                                //               TextOverflow.ellipsis),
                                                //           maxLines: 1,
                                                //         )),
                                                //   ],
                                                // ),
                                                // SizedBox(height: screenWidth * 0.01),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.orange,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          formatCreatedAt(
                                                              "${trackModelData?.order.bookingDate}"),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Roboto',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                          maxLines: 1,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),

                                // name Textfiels
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Name of member participating in pooja",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      const Text(
                                        "Panditji will take your name along with gotra duing pooja.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Dynamic list of TextFields based on numberOfFields
                                      for (int i = 0; i < noPerson; i++)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15.0),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Enter your Name";
                                              }
                                              return null;
                                            },
                                            controller: textControllers[i],
                                            style: const TextStyle(
                                                fontFamily: 'Roboto-Regular'),
                                            decoration: InputDecoration(
                                              hintText: "Member Name ${i + 1}",
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.5),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.5),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 1.5),
                                              ),
                                              suffixIcon: const Icon(
                                                  Icons.person_2,
                                                  color: Colors.orange,
                                                  size: 25),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // Gotra Textfiels
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Fill participant's gotra",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      const Text(
                                        "Gorta will be recited during the pooja.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: gotraController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required Gotra Name";
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(
                                            fontFamily: 'Roboto-Regular'),
                                        decoration: InputDecoration(
                                          hintText: "Gotra",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 1.5),
                                          ),
                                          suffixIcon: const Icon(
                                              Icons.report_outlined,
                                              color: Colors.orange,
                                              size: 25),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.orange,
                                            value: isChecked,
                                            onChanged: (bool? newValue) {
                                              modalSetter(() {
                                                isChecked = newValue!;
                                                isChecked
                                                    ? gotraController.text =
                                                        "Kashyap"
                                                    : gotraController.clear();
                                              });
                                            },
                                          ),
                                          Text(
                                            "I do not know my gotra",
                                            style: TextStyle(
                                                color: isChecked
                                                    ? Colors.black
                                                    : Colors.grey,
                                                fontSize: 14,
                                                letterSpacing: 1),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                                // Whatsapp Textfiels
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Add your whatsApp number",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      const Text(
                                        "To get order related updates.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required Phone Number";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: phoneController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly, // Allow only digits
                                          LengthLimitingTextInputFormatter(
                                              10), // Limit to 10 digits
                                        ],
                                        style: const TextStyle(
                                            fontFamily: 'Roboto-Regular'),
                                        decoration: InputDecoration(
                                          hintText: "+91 000-000-0000",
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 1.5),
                                          ),
                                          suffixIcon: const Icon(Icons.phone,
                                              color: Colors.orange, size: 25),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                isLoading
                                    ? Container(
                                        padding: const EdgeInsets.all(4.0),
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.orange.shade400,
                                        ),
                                        child: const Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.white,
                                        )))
                                    : InkWell(
                                        onTap: () {
                                          modalSetter(() {
                                            isLoading = true;
                                          });
                                          submitForm();
                                        },
                                        child: Container(
                                          height: 45,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.orange,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 60,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void showFeedbackBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              CupertinoIcons.chevron_back,
                              color: Colors.red,
                            )),
                        title: const Text(
                          'Please provide your feedback',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${trackModelData?.order.chadhava.name}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                            Text(
                              "${trackModelData?.order.type}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),

                      // Star Rating
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "How many stars will you give us for your Puja booking on Mahakal.com",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < _selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    modalSetter(() {
                                      _selectedRating = index + 1;
                                    });
                                  },
                                );
                              }),
                            ),
                            Center(
                              child: Text(
                                _selectedRating == 1
                                    ? "Poor"
                                    : _selectedRating == 2
                                        ? "Below Average"
                                        : _selectedRating == 3
                                            ? "Average"
                                            : _selectedRating == 4
                                                ? "Good"
                                                : "Excellent",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Improvement Options
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "What can we improve ?",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: List.generate(options.length, (index) {
                                return CheckboxListTile(
                                  checkColor: Colors.white,
                                  activeColor: Colors.orange,
                                  title: Text(
                                    options[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  value: _selectedIndex ==
                                      index, // Key change: Compare index
                                  onChanged: (value) {
                                    if (value == true) {
                                      //Only allow selection if value is true. Prevents unchecking
                                      modalSetter(() {
                                        _handleCheckboxChange(index);
                                        _suggestionsController.text =
                                            options[index];
                                        print(
                                            "suggestion controller ${_suggestionsController.text}");
                                      });
                                    }
                                  },
                                );
                              }),
                            ),
                            // Column(
                            //   children: [
                            //     "I should get more updates about the Puja",
                            //     "My name and gotra should be taken properly",
                            //     "I should have received the puja video earlier",
                            //     "Panditji should follow the Puja rituals properly",
                            //     "Assistance should be provided to find the right Puja for me",
                            //     "Customer support should be more responsive",
                            //   ].asMap().entries.map((entry) {
                            //     return CheckboxListTile(
                            //       title: Text(entry.value,style: TextStyle(fontSize: 14),),
                            //       value: _improvementOptions[entry.key],
                            //       onChanged: (bool? value) {
                            //         modalSetter(() {
                            //           _improvementOptions[entry.key] = value ?? false;
                            //
                            //         });
                            //       },
                            //     );
                            //   }).toList(),
                            // ),
                          ],
                        ),
                      ),

                      // Suggestions
                      const SizedBox(height: 10),
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Please provide your suggestions",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _suggestionsController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orange)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orange)),
                                hintText: "Write here...",
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      // Submit Button
                      isLoading
                          ? Container(
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(4.0),
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.orange.shade400,
                              ),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              )))
                          : GestureDetector(
                              onTap: () {
                                modalSetter(() {
                                  isLoading = true;
                                });
                                // Submit feedback logic
                                print("Rating: $_selectedRating");
                                // print("Improvements: ${_improvementOptions.toString()}");
                                print(
                                    "Suggestions: ${_suggestionsController.text}");
                                setReviewData();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.orange,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void setReviewData() async {
    final url = Uri.parse(AppConstants.baseUrl +
        AppConstants.setChadhavaReviewUrl); // Replace with your API endpoint
    final Map<String, dynamic> data = {
      "order_id": "${trackModelData?.order.orderId}",
      "astro_id": "${trackModelData?.order.pandit?.id}",
      "service_id": "${trackModelData?.order.serviceId}",
      "comment": _suggestionsController.text,
      "service_type": "${trackModelData?.order.type}",
      "rating": "$_selectedRating"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print("Rating: ${trackModelData?.order.orderId}");
        print("Rating: ${trackModelData?.order.pandit?.id}");
        print("Rating: ${trackModelData?.order.serviceId}");
        print("Rating: ${_suggestionsController.text}");
        print("Rating: ${trackModelData?.order.type}");
        print("Rating: $_selectedRating");
        setState(() {
          isLoading = false;
          _suggestionsController.clear();
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Thank you for your feedback!",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        // Handle error response
        Fluttertoast.showToast(
            msg: "Add Failed",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (error) {
      print('Error posting data: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrackData(widget.poojaId);
    _suggestionsController.text = options[0];
    userToken =
        Provider.of<AuthController>(Get.context!, listen: false).getUserToken();
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userNumber =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
  }

  void getTrackData(String id) async {
    var res = await HttpService().getApi(AppConstants.trackChadhavaUrl + id);
    print("api response $res");
    setState(() {
      trackModelData = chadhavaTrackModelFromJson(jsonEncode(res));
    });
    fetchInvoice(context, "${trackModelData!.order.id}", userToken);
  }

  static String? chadhavaInvoicePath;
  static String invoiceUrl = "";

  /// **Fetch Chadhava Invoice**
  static Future<void> fetchInvoice(
      BuildContext context, String invoiceId, String userToken) async {
    String apiUrl =
        AppConstants.baseUrl + AppConstants.fetchChadhavaInvoiceUrl + invoiceId;

    try {
      Response response = await Dio().get(
        apiUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Authorization": "Bearer $userToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/invoice_$invoiceId.pdf';
        invoiceUrl = apiUrl;
        // ⚠ Delete old invoice file if exists
        if (chadhavaInvoicePath != null &&
            File(chadhavaInvoicePath!).existsSync()) {
          await File(chadhavaInvoicePath!).delete();
        }

        File file = File(filePath);
        await file.writeAsBytes(response.data);

        chadhavaInvoicePath = filePath; // ✅ Save new file path
      } else {}
    } catch (e) {
      print("Error: $e");
    }
  }

  /// **Open Chadhava Invoice**
  static Future<void> openInvoice(BuildContext context, url) async {
    if (chadhavaInvoicePath == null ||
        !File(chadhavaInvoicePath!).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Invoice not found!")),
      );
      return;
    }
    //
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => InvoiceViewer(
    //       pdfPath: chadhavaInvoicePath!,
    //       invoiceUrl: url,
    //     ),
    //   ),
    // );
  }

  /// **Share Chadhava Invoice**
  static Future<void> shareInvoice(BuildContext context) async {
    if (chadhavaInvoicePath != null &&
        File(chadhavaInvoicePath!).existsSync()) {
      // var splashController = Provider.of<SplashController>(context, listen: false);
      //
      // String playStoreUrl = splashController.configModel?.userAppVersionControl?.forAndroid?.link ??
      //     "https://play.google.com/store/apps/details?id=manal.mahakal.com";
      // String appStoreUrl = splashController.configModel?.userAppVersionControl?.forIos?.link ??
      //     "https://apps.apple.com/app/idyourappid";

      String shareUrl = '';
      shareUrl = "${AppConstants.baseUrl}/download";

      String shareText = "🧾 **आपका चढ़ावा इनवॉइस** 🎉\n\n"
          "अब देखें Mahakal.com ऐप पर 🙏\n\n"
          "🔹Download App Now: $shareUrl";

      await Share.shareXFiles([XFile(chadhavaInvoicePath!)], text: shareText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please download the invoice first!")),
      );
    }
  }

  @override
  void dispose() {
    chadhavaInvoicePath = null; // Clear on screen dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return trackModelData?.order.orderId == null
        ? MahakalLoadingData(onReload: () {})
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageAnimationTransition(
                        page: ChadhavaTrackingPage(userID: widget.poojaId),
                        pageAnimationType: RightToLeftTransition()));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Center(
                  child: Text(
                    "Track",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.grey.shade50,
              title: Column(
                children: [
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Order -",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    TextSpan(
                        text: " #${trackModelData?.order.orderId}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: " Your Order is - ",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    TextSpan(
                        text: "${trackModelData?.order.orderStatus}",
                        style: TextStyle(
                            color: getStatusColor(
                                "${trackModelData?.order.orderStatus}"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(convertDate("${trackModelData?.order.bookingDate}"),
                      style: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black)),
                ],
              ),
              centerTitle: true,
              toolbarHeight: 100,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getTrackData(widget.poojaId);
              },
              color: Colors.white, // Progress indicator color
              backgroundColor: Colors
                  .deepOrange, // Background color of the refresh indicator
              displacement: 40.0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/map_bg.png"),
                              fit: BoxFit.fill)),
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.article,
                                        color: Colors.deepOrange,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("User Info",
                                          style: TextStyle(
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange))
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.deepOrange.shade200,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          trackModelData?.order.customer.name ==
                                                  null
                                              ? "Not-Available"
                                              : "${trackModelData?.order.customer.name}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.deepOrange.shade200,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${trackModelData?.order.customer.email}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.deepOrange.shade200,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${trackModelData?.order.customer.phone}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (trackModelData?.order.members == null)
                            Container(
                              // padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.article,
                                          color: Colors.deepOrange,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Sankalp Details",
                                            style: TextStyle(
                                                fontSize: 20,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange)),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Center(
                                        child: Text(
                                      "Data Not-Available",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.blueGrey),
                                    )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showInfoBottomSheet();
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Add",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Share Button (Only Show if Not Refunded)
                                        // if (tourOrderData?.data!.refundStatus != 1)
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              shareInvoice(context);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors
                                                    .white, // Background color                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        Colors.green.shade100,
                                                    blurRadius: 4,
                                                    spreadRadius: 2,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.share,
                                                      color: Colors.black,
                                                      size:
                                                          16), // Refund policy icon
                                                  SizedBox(width: 8), // Spacing
                                                  Text(
                                                    "Share Invoice",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  //SizedBox(width: 5),
                                                  // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        // Share Button (Only Show if Not Refunded)
                                        // if (tourOrderData?.data!.refundStatus != 1)
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              openInvoice(context, invoiceUrl);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors
                                                    .white, // Background color                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue.shade100,
                                                    blurRadius: 4,
                                                    spreadRadius: 2,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.remove_red_eye,
                                                      color: Colors.black,
                                                      size:
                                                          16), // Refund policy icon
                                                  SizedBox(width: 8), // Spacing
                                                  Text(
                                                    "View Invoice",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  //SizedBox(width: 5),
                                                  // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(width: 8,),
                                        //  tourOrderData?.data!.refundStatus == 1
                                        //  ?
                                        //const SizedBox(),
                                        // :
                                        // InkWell(
                                        //   onTap: () {
                                        //     showRefundPolicyBottomSheet(context);
                                        //   },
                                        //   child: Container(
                                        //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        //     decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.circular(8),
                                        //       border: Border.all(color: Colors.red),
                                        //       color: Colors.white, // Background color
                                        //       boxShadow:  [
                                        //         BoxShadow(
                                        //           color: Colors.red.shade100,
                                        //           blurRadius: 4,
                                        //           spreadRadius: 2,
                                        //           offset: Offset(2, 2),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //     child: const Row(
                                        //       mainAxisSize: MainAxisSize.min,
                                        //       children: [
                                        //         Icon(Icons.policy, color: Colors.black, size: 16), // Refund policy icon
                                        //         SizedBox(width: 4), // Spacing
                                        //         Text(
                                        //           "Refund Policy",
                                        //           style: TextStyle(
                                        //             color: Colors.red,
                                        //             fontSize: 14,
                                        //             fontWeight: FontWeight.w600,
                                        //           ),
                                        //         ),
                                        //         //SizedBox(width: 5),
                                        //         //Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              // padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.article,
                                          color: Colors.deepOrange,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Sankalp Details",
                                            style: TextStyle(
                                                fontSize: 20,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange))
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 0,
                                            child: Icon(
                                              Icons.groups,
                                              color: Colors.deepOrange.shade100,
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "${trackModelData?.order.members}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 2,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 0,
                                            child: Icon(
                                              Icons.swipe_down_alt_outlined,
                                              color: Colors.deepOrange.shade100,
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Gotra ( ${trackModelData?.order.gotra} )",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 2,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.deepOrange.shade100,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            trackModelData?.order.newphone ==
                                                    null
                                                ? userNumber
                                                : "+91-${trackModelData?.order.newphone}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    trackModelData?.order.isEdited == 1
                                        ? const SizedBox.shrink()
                                        : InkWell(
                                            onTap: () {
                                              addMemberList();
                                              showInfoBottomSheet();
                                              // Navigator.push(
                                              //     context,
                                              //     PageAnimationTransition(
                                              //         page: UpdatePersonDetails(
                                              //           billAmount: "${trackModelData?.order?.payAmount}",
                                              //           packageName: "${trackModelData?.order?.leads?.packageName}",
                                              //           personCount: int.parse("${trackModelData?.order?.leads?.noperson}"),
                                              //           typePooja: "${trackModelData?.order?.type}",
                                              //           pjIdOrder: "${trackModelData?.order?.orderId}",
                                              //           nameMembers: "${trackModelData?.order?.members}",
                                              //           phoneNumber: "${trackModelData?.order?.newphone}",
                                              //           gotra: "${trackModelData?.order?.gotra}",
                                              //         ),
                                              //         pageAnimationType: RightToLeftTransition())
                                              // );
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: Colors.deepOrange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Edit",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Icon(
                                                      Icons.edit_square,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Share Button (Only Show if Not Refunded)
                                        // if (tourOrderData?.data!.refundStatus != 1)
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              shareInvoice(context);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors
                                                    .white, // Background color                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        Colors.green.shade100,
                                                    blurRadius: 4,
                                                    spreadRadius: 2,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.share,
                                                      color: Colors.black,
                                                      size:
                                                          16), // Refund policy icon
                                                  SizedBox(width: 8), // Spacing
                                                  Text(
                                                    "Share Invoice",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  //SizedBox(width: 5),
                                                  // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        // Share Button (Only Show if Not Refunded)
                                        // if (tourOrderData?.data!.refundStatus != 1)
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              openInvoice(context, invoiceUrl);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors
                                                    .white, // Background color                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue.shade100,
                                                    blurRadius: 4,
                                                    spreadRadius: 2,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.remove_red_eye,
                                                      color: Colors.black,
                                                      size:
                                                          16), // Refund policy icon
                                                  SizedBox(width: 8), // Spacing
                                                  Text(
                                                    "View Invoice",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  //SizedBox(width: 5),
                                                  // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(width: 8,),
                                        //  tourOrderData?.data!.refundStatus == 1
                                        //  ?
                                        //const SizedBox(),
                                        // :
                                        // InkWell(
                                        //   onTap: () {
                                        //     showRefundPolicyBottomSheet(context);
                                        //   },
                                        //   child: Container(
                                        //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        //     decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.circular(8),
                                        //       border: Border.all(color: Colors.red),
                                        //       color: Colors.white, // Background color
                                        //       boxShadow:  [
                                        //         BoxShadow(
                                        //           color: Colors.red.shade100,
                                        //           blurRadius: 4,
                                        //           spreadRadius: 2,
                                        //           offset: Offset(2, 2),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //     child: const Row(
                                        //       mainAxisSize: MainAxisSize.min,
                                        //       children: [
                                        //         Icon(Icons.policy, color: Colors.black, size: 16), // Refund policy icon
                                        //         SizedBox(width: 4), // Spacing
                                        //         Text(
                                        //           "Refund Policy",
                                        //           style: TextStyle(
                                        //             color: Colors.red,
                                        //             fontSize: 14,
                                        //             fontWeight: FontWeight.w600,
                                        //           ),
                                        //         ),
                                        //         //SizedBox(width: 5),
                                        //         //Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // your product
                          const Row(
                            children: [
                              Icon(
                                Icons.redeem,
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Your Chadhava",
                                  style: TextStyle(
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.2), // Slightly transparent black for better aesthetics
                                  blurRadius:
                                      4, // Controls the softness of the shadow
                                  spreadRadius:
                                      1, // Spread the shadow a little// X=0 (centered horizontally), Y=4 (downwards)
                                ),
                              ],
                            ),
                            child: trackModelData?.order.chadhava == null
                                ? const Center(child: Text("Not-Available"))
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 0,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              child: Image.network(
                                                "${trackModelData?.order.chadhava.thumbnail}",
                                                fit: BoxFit.fill,
                                                height: 100,
                                              ))),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${trackModelData?.order.chadhava.name} ( ${trackModelData?.order.chadhava.hiName} )",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 4,
                                            ),

                                            // Text.rich(
                                            //     TextSpan(
                                            //         children: [
                                            //           TextSpan(text: "Price : ",style: TextStyle(color: Colors.black,fontSize: 16)),
                                            //           trackModelData?.order.type == "counselling"
                                            //               ? TextSpan(text: "₹${trackModelData?.order.payAmount}",style: TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold))
                                            //               : TextSpan(text: "₹${trackModelData?.order.packagePrice}",style: TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold)),
                                            //           TextSpan(text: " (Tax include)",style: TextStyle(color: Colors.black,fontSize: 16)),
                                            //         ]
                                            //     )
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                          ),

                          // total bill container
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.2), // Slightly transparent black for better aesthetics
                                  blurRadius:
                                      4, // Controls the softness of the shadow
                                  spreadRadius:
                                      1, // Spread the shadow a little// X=0 (centered horizontally), Y=4 (downwards)
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text("Sub total",
                                        style: TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.green)),
                                    const Spacer(),
                                    Text("₹${trackModelData?.order.payAmount}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.green)),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Row(children: [
                                //
                                //   Text("Discount",style: TextStyle(fontSize: 14,overflow: TextOverflow.ellipsis,color: Colors.grey)),
                                //   Spacer(),
                                //   Text("₹300.00",style: TextStyle(fontSize: 16,overflow: TextOverflow.ellipsis)),
                                //
                                // ],),
                                //
                                // Row(children: [
                                //
                                //   Text("Coupon & voucher",style: TextStyle(fontSize: 14,overflow: TextOverflow.ellipsis,color: Colors.grey)),
                                //   Spacer(),
                                //   Text("₹20.00",style: TextStyle(fontSize: 16,overflow: TextOverflow.ellipsis)),
                                //
                                // ],),
                                trackModelData?.order.productLeads == null ||
                                        trackModelData!
                                            .order.productLeads.isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: trackModelData
                                            ?.order.productLeads.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "${trackModelData?.order.productLeads[index].productName}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                      color: Colors.black,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              const Spacer(),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  "₹${trackModelData?.order.productLeads[index].productPrice} x ${trackModelData?.order.productLeads[index].qty} =",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      color: Colors.black,
                                                      decorationColor:
                                                          Colors.grey,
                                                      decorationThickness: 2),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  "₹${trackModelData?.order.productLeads[index].finalPrice}.0",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Roboto',
                                                      color: Colors.blue,
                                                      decorationColor:
                                                          Colors.grey,
                                                      decorationThickness: 2),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),

                                Row(
                                  children: [
                                    const Text("Total",
                                        style: TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text("₹${trackModelData?.order.payAmount}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Row(
                            children: [
                              const Text("Payment Id",
                                  style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black)),
                              const Spacer(),
                              Text("${trackModelData?.order.paymentId}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),

                          trackModelData?.order.orderStatus == "Complete"
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    trackModelData?.isReview == 1
                                        ? Container(
                                            height: 50,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 2),
                                            ),
                                            child: const Row(children: [
                                              Text(
                                                "Review added successfully ✨",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey),
                                              ),
                                              Spacer(),
                                              Center(
                                                  child: Icon(
                                                CupertinoIcons
                                                    .checkmark_circle_fill,
                                                color: Colors.green,
                                              )),
                                            ]),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showFeedbackBottomSheet();
                                            },
                                            child: Container(
                                              height: 50,
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: Colors.grey.shade400,
                                                    width: 2),
                                              ),
                                              child: const Row(children: [
                                                Text(
                                                  "Write Your Experience",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Spacer(),
                                                Center(
                                                    child: Icon(
                                                  CupertinoIcons
                                                      .arrow_right_circle_fill,
                                                  color: Colors.blue,
                                                )),
                                              ]),
                                            ),
                                          ),
                                  ],
                                )
                              : const SizedBox.shrink(),

                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                              "If you need any kind of help or support regarding Chadhava booking kindly contact us.",
                              style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.grey)),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageAnimationTransition(
                                        page: const SupportTicketScreen(),
                                        pageAnimationType:
                                            RightToLeftTransition()));
                              },
                              child: const Text("Support Center",
                                  style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.deepOrange))),

                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
