import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:http/http.dart' as http;

import '../../../utill/flutter_toast_helper.dart';

class UpdatePersonDetails extends StatefulWidget {
  final String billAmount;
  final String packageName;
  final String typePooja;
  final String pjIdOrder;
  final int personCount;
  final String nameMembers;
  final String phoneNumber;
  final String gotra;
  const UpdatePersonDetails(
      {super.key,
      required this.billAmount,
      required this.packageName,
      required this.personCount,
      required this.typePooja,
      required this.pjIdOrder,
      required this.nameMembers,
      required this.phoneNumber,
      required this.gotra});

  @override
  State<UpdatePersonDetails> createState() => _UpdatePersonDetailsState();
}

class _UpdatePersonDetailsState extends State<UpdatePersonDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  List<String> textValues = []; // Create a list to store the text values
  late List<TextEditingController> textControllers = List.generate(
    widget.personCount,
    (index) => TextEditingController(),
  );
  String mess = "";

  final billFormKey = GlobalKey<FormState>();
  ScrollController? scrollController;
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
        widget.typePooja == "pooja"
            ? sendPostRequest("pooja-sankalp")
            : widget.typePooja == "chadhava"
                ? sendPostRequest("chadhava-sankalp")
                : widget.typePooja == "vip"
                    ? sendPostRequest("vip-sankalp")
                    : widget.typePooja == "anushthan"
                        ? sendPostRequest("anushthan-sankalp")
                        : sendPostRequest("anushthan-sankalp");
      }
    } else {
      if (textControllers.isEmpty ||
          gotraController.text.isEmpty ||
          pinController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          houseController.text.isEmpty ||
          areaController.text.isEmpty ||
          landmarkController.text.isEmpty) {
        billFormKey.currentState!.validate();
        ToastHelper.showToast(message: "Form fields required!");
        setState(() {
          isLoading = false;
        });
      } else {
        saveTextValues();
        widget.typePooja == "pooja"
            ? sendPostRequest("pooja-sankalp")
            : widget.typePooja == "chadhava"
                ? sendPostRequest("chadhava-sankalp")
                : widget.typePooja == "vip"
                    ? sendPostRequest("vip-sankalp")
                    : widget.typePooja == "anushthan"
                        ? sendPostRequest("anushthan-sankalp")
                        : sendPostRequest("pooja-details");
        // ... rest of the code remains the same
      }
    }
  }

  Future<void> sendPostRequest(String Url) async {
    // Define the API endpoint
    String orderId = widget.pjIdOrder;
    String apiUrl =
        '${AppConstants.baseUrl}${AppConstants.poojaAllUrl}/$Url/$orderId';

    // Create the data payload
    Map<String, dynamic> data = {
      "newPhone":
          phoneController.text.isEmpty ? "" : int.parse(phoneController.text),
      "gotra": gotraController.text,
      "pincode": isYesNo == false ? "" : int.parse(pinController.text),
      "city": isYesNo == false ? "" : cityController.text,
      "state": isYesNo == false ? "" : stateController.text,
      "house_no": isYesNo == false ? "" : int.parse(houseController.text),
      "area": isYesNo == false ? "" : areaController.text,
      "landmark": isYesNo == false ? "" : landmarkController.text,
      "members": textValues,
      "is_prashad": isYesNo == false ? 0 : 1
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
        pinController.clear();
        cityController.clear();
        stateController.clear();
        houseController.clear();
        areaController.clear();
        landmarkController.clear();
        textControllers.clear();
        textValues.clear();
        log(response.body);
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

  void addMemberList() {
    // The input string
    String names = widget.nameMembers;

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

    // Update the text controllers with the names
    for (int i = 0; i < limit; i++) {
      setState(() {
        textControllers[i].text = finalList[i];
        phoneController.text = widget.phoneNumber;
        gotraController.text = widget.gotra;
      });
    }

    // Printing the final list for debugging
    print(finalList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.nameMembers);
    addMemberList();
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
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.all(10),
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.amber,
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
                margin: const EdgeInsets.all(10),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.amber,
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
          "Update Details",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.packageName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.billAmount,
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 30,
                            color: Colors.amber,
                          ),
                          onTap: () {
                            setState(() {
                              _showText = !_showText;
                            });
                            addMemberList();
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
                              //     Icon(Icons.location_pin ,color: Colors.amber,size: 20,),
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
                                    color: Colors.amber,
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
                                  color: Colors.amber, width: 1.5),
                            ),
                            suffixIcon: const Icon(Icons.person_2,
                                color: Colors.amber, size: 25),
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
                              color: Colors.amber, width: 1.5),
                        ),
                        suffixIcon: const Icon(Icons.report_outlined,
                            color: Colors.amber, size: 25),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.amber,
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
                      "Add your whatsApp number",
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required Phone Number";
                        }
                        return null;
                      },
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
                              color: Colors.amber, width: 1.5),
                        ),
                        suffixIcon: const Icon(Icons.phone,
                            color: Colors.amber, size: 25),
                      ),
                    ),
                  ],
                ),
              ),

              //pooja prasad
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
                      "Do you want Pooja's prasad ?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const Text(
                      "On completion of the pooj, Prasad of worship will be sent..",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isYesNo = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isYesNo ? Colors.amber : Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isYesNo ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isYesNo = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isYesNo ? Colors.white : Colors.amber,
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1.5)),
                            child: Text(
                              "No",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isYesNo ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isYesNo
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your address for prasad delivery",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: pinController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required Pin Code";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontFamily: 'Roboto-Regular'),
                                decoration: InputDecoration(
                                  hintText: "Pin Code ( Compulsory ) ",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: cityController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required City Name";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontFamily: 'Roboto-Regular'),
                                decoration: InputDecoration(
                                  hintText: "City ( Compulsory ) ",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: stateController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required State Name";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontFamily: 'Roboto-Regular'),
                                decoration: InputDecoration(
                                  hintText: "State ( Compulsory ) ",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: houseController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required House Number";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontFamily: 'Roboto-Regular'),
                                decoration: InputDecoration(
                                  hintText: "House Number",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: areaController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required Colony Name";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontFamily: 'Roboto-Regular'),
                                decoration: InputDecoration(
                                  hintText: "Road , Area , Colony",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: landmarkController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required Landmark";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontFamily: 'Roboto-Regular'),
                                decoration: InputDecoration(
                                  hintText: "Enter Landmark",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox()
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
