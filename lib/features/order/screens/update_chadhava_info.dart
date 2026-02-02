import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../utill/app_constants.dart';
import '../../../utill/flutter_toast_helper.dart';

class UpdateChadhavaPersonDetails extends StatefulWidget {
  final String billAmount;
  final String pjIdOrder;
  final int personCount;
  const UpdateChadhavaPersonDetails(
      {super.key,
      required this.billAmount,
      required this.personCount,
      required this.pjIdOrder});

  @override
  State<UpdateChadhavaPersonDetails> createState() =>
      _UpdateChadhavaPersonDetailsState();
}

class _UpdateChadhavaPersonDetailsState
    extends State<UpdateChadhavaPersonDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  List<String> textValues = []; // Create a list to store the text values
  late List<TextEditingController> textControllers = List.generate(
    widget.personCount,
    (index) => TextEditingController(),
  );
  String mess = "";

  final billFormKey = GlobalKey<FormState>();
  bool _showText = false;
  bool isYesNo = false;
  bool isChecked = false;
  bool isLoading = false;

  // button functionality
  void _submitForm() {
    isLoading = true;
    if (!isYesNo) {
      if (textControllers.isEmpty || gotraController.text.isEmpty) {
        billFormKey.currentState!.validate();
        ToastHelper.showToast(message: "Form fields required!");
        setState(() {
          isLoading = false;
        });
      } else {
        saveTextValues();
        sendPostRequest();
      }
    } else {
      if (textControllers.isEmpty || gotraController.text.isEmpty) {
        billFormKey.currentState!.validate();
        ToastHelper.showToast(message: "Form fields required!");
        setState(() {
          isLoading = false;
        });
      } else {
        saveTextValues();
        sendPostRequest();
        // ... rest of the code remains the same
      }
    }
  }

  Future<void> sendPostRequest() async {
    // Define the API endpoint
    String orderId = widget.pjIdOrder;
    String apiUrl =
        '${AppConstants.baseUrl}${AppConstants.poojaAllUrl}/chadhava-sankalp/$orderId';

    // Create the data payload
    Map<String, dynamic> data = {
      "newPhone":
          phoneController.text.isEmpty ? "" : int.parse(phoneController.text),
      "gotra": gotraController.text,
      "pincode": "",
      "city": "",
      "state": "",
      "house_no": "",
      "area": "",
      "landmark": "",
      "members": textValues,
      "is_prashad": 0
    };

    // Make the POST request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Request successful');
        Navigator.pop(context);
        isLoading = false;
        nameController.clear();
        gotraController.clear();
        phoneController.clear();
        textControllers.clear();
        textValues.clear();
        log(response.body);
        setState(() {
          mess = "sucseeeccc";
        });
      } else {
        // Handle error
        isLoading = false;
        print('Failed to send request: ${response.statusCode}');
        print(response.body);
        setState(() {
          mess = "fail";
        });
      }
    } catch (e) {
      // Handle exception
      print('An error occurred: $e');
      setState(() {
        mess = "error";
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    // int numberOfFields = widget.personCount;
    // final List<TextEditingController> textControllers = List.generate(numberOfFields, (index) => TextEditingController());
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isLoading
          ? Container(
              margin: const EdgeInsets.all(10),
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.orange,
              ),
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )))
          : InkWell(
              onTap: () {
                _submitForm();
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.all(10),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
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
      appBar: AppBar(
        title: const Text(
          "Fill Chadhava Form",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              color: Colors.orange),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: billFormKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: screenWidth * 0.8,
                        child: const Text(
                          "Navgrah shanti puja For Peace of side effect, Amplification positive energy, Commencment of auicious events",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto',
                              overflow: TextOverflow.ellipsis),
                          maxLines: 4,
                        )),
                    SizedBox(
                        width: screenWidth * 0.4,
                        child: const Text(
                          "Individual Puja",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                              color: Colors.grey),
                        )),
                    Row(
                      children: [
                        Text(
                          widget.billAmount,
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
                            setState(() {
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  SizedBox(
                                      width: screenWidth * 0.7,
                                      child: const Text(
                                        "Navgrah Shani Mandir,Ujjain,Madhaya Pradesh",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto',
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 1,
                                      )),
                                ],
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  SizedBox(
                                      width: screenWidth * 0.7,
                                      child: const Text(
                                        "31 May,Friday",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto',
                                            overflow: TextOverflow.ellipsis),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name of member participating in pooja",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                    for (int i = 0; i < widget.personCount; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your Name";
                            }
                            return null;
                          },
                          controller: textControllers[i],
                          style: const TextStyle(fontFamily: 'Roboto-Regular'),
                          decoration: InputDecoration(
                            hintText: "Member Name ${i + 1}",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.orange, width: 1.5),
                            ),
                            suffixIcon: const Icon(Icons.person_2,
                                color: Colors.orange, size: 25),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fill participant's gotra",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                      style: const TextStyle(fontFamily: 'Roboto-Regular'),
                      decoration: InputDecoration(
                        hintText: "Gotra",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orange, width: 1.5),
                        ),
                        suffixIcon: const Icon(Icons.report_outlined,
                            color: Colors.orange, size: 25),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.orange,
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = newValue!;
                              isChecked
                                  ? gotraController.text = "Kashyap"
                                  : gotraController.clear();
                            });
                          },
                        ),
                        Text(
                          "I do not know my gotra",
                          style: TextStyle(
                              color: isChecked ? Colors.black : Colors.grey,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add your whatsApp number (Optional)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                      // validator: (value){
                      //   if(value!.isEmpty){
                      //     return "Required Phone Number";
                      //   }
                      //   return null;
                      // },
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits
                        LengthLimitingTextInputFormatter(
                            10), // Limit to 10 digits
                      ],
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      style: const TextStyle(fontFamily: 'Roboto-Regular'),
                      decoration: InputDecoration(
                        hintText: "+91 000-000-0000",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.orange, width: 1.5),
                        ),
                        suffixIcon: const Icon(Icons.phone,
                            color: Colors.orange, size: 25),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
