import 'dart:convert';
import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';
import '../../../utill/completed_order_dialog.dart';
import '../../../utill/flutter_toast_helper.dart';
import '../auth/controllers/auth_controller.dart';
import '../profile/controllers/profile_contrroller.dart';
import 'city_picker_model.dart';


class PersonDetails extends StatefulWidget {
  final String billAmount;
  final String packageName;
  final String typePooja;
  final String pjIdOrder;
  final int personCount;
  final String poojaName;
  final String poojaVenue;
  final String date;
  final tabIndex;
  final String? typeByVendor;
  const PersonDetails({
    super.key,
    required this.billAmount,
    required this.packageName,
    required this.personCount,
    required this.typePooja,
    required this.pjIdOrder,
    required this.poojaName,
    required this.poojaVenue,
    required this.date,
    this.tabIndex = 3,
    this.typeByVendor = "panditVendor",
  });

  @override
  State<PersonDetails> createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
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
  String userNumber = "";
  String latiTude = "";
  String longiTude = "";

  final billFormKey = GlobalKey<FormState>();
  ScrollController? scrollController;
  bool _showText = false;
  bool isYesNo = false;
  bool isChecked = false;
  bool isLoading = false;

  // button functionality
  void _submitForm() {
    print("Pooja Type:${widget.typePooja}");
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
            : ToastHelper.showError("Method Error!");
      }
    } else {
      if (textControllers.isEmpty ||
          gotraController.text.isEmpty ||
          pinController.text.isEmpty ||
          countryController.text.isEmpty ||
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

    final String userToken = Provider.of<AuthController>(context, listen: false).getUserToken();

    String finalUrl = "${AppConstants.baseUrl}${AppConstants.allPanditPersonUrl}";

    // Define the API endpoint
    String orderId = widget.pjIdOrder;
    String apiUrl = '${AppConstants.baseUrl}${AppConstants.poojaAllUrl}/$Url/$orderId';

    // https://sit.resrv.in/api/v1/pooja/pooja-sankalp/
    // https://sit.resrv.in/api/v1/guruji/puja/sankalp/store

    // Create the data payload
    Map<String, dynamic> data = {
      if(widget.typeByVendor == "panditVendor") "order_id" : "${widget.pjIdOrder}",
      "newPhone": phoneController.text.isEmpty ? "" : int.parse(phoneController.text),
      "gotra": gotraController.text,
      "pincode": isYesNo == false ? "" : int.parse(pinController.text),
      "city": isYesNo == false ? "" : countryController.text,
      "state": isYesNo == false ? "" : stateController.text,
      "house_no": isYesNo == false ? "" : int.parse(houseController.text),
      "area": isYesNo == false ? "" : areaController.text,
      "landmark": isYesNo == false ? "" : landmarkController.text,
      "members": textValues,
      "is_prashad": isYesNo == false ? 0 : 1,
      "latitude": latiTude,
      "longitude": longiTude
    };

    print("Api data : $data");
    print("order : $orderId");
    // Make the POST request
    try {
      final response = await http.post(
        Uri.parse(widget.typeByVendor == "panditVendor"  ? finalUrl : apiUrl),
        headers: {
          'Content-Type': 'application/json',
          if(widget.typeByVendor == "panditVendor") 'Authorization': 'Bearer $userToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Request successful');
        print("is_prashad ${isYesNo == false ? 0 : 1}");
        // Navigator.of(context).pushReplacement(CupertinoPageRoute(
        //     builder: (BuildContext context) => const BottomBar(pageIndex: 0)));
        int orderIndex = widget.typePooja == "pooja"
            ? widget.tabIndex
            : widget.typePooja == "chadhava"
            ? 2
            : widget.typePooja == "vip"
            ? 0
            : widget.typePooja == "anushthan"
            ? 1
            : widget.typeByVendor == "panditVendor"
            ? 11
            : 111;
        showDialog(
          context: context,
          builder: (context) => bookingSuccessDialog(
            context: context,
            tabIndex: orderIndex,
            title: 'Pooja Booked!',
            message:
            'Your pooja has been successfully booked. You will receive further details shortly.',
          ),
          barrierDismissible: true,
        );
        isLoading = false;
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
        isLoading = false;
        print('Failed to send request: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle exception
      print('An error occurred: $e');
    }
  }

  Future<void> getAddressFromLatLong(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        stateController.text = place.administrativeArea ?? '';
        pinController.text = place.postalCode ?? '';

        print('lat: $lat  long: $lon');
        print('State: ${stateController.text}');
        print('Pincode: ${pinController.text}');
      } else {
        print('No address found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNumber = Provider.of<ProfileController>(Get.context!, listen: false)
        .userPHONE
        .substring(3);
    phoneController.text = userNumber;
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

  //model list
  List<CityPickerModel> cityListModel = <CityPickerModel>[];

  //Country Picker
  final Country _selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "9123456789",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "91-IN-0",
  );

  void updateValue(String value) {
    // Implement your logic here - e.g., print the value, perform validation, etc.
    print('Entered value: $value');
    getCityPick();
    searchBox();
  }

  //Serach box
  bool searchbox = false;
  void searchBox() {
    if (countryController.text.length > 1) {
      setState(() {
        searchbox = true;
      });
    } else if (countryController.text.isEmpty) {
      setState(() {
        searchbox = false;
      });
    }
    print("serchbox $searchbox");
  }

  // country picker api
  void getCityPick() async {
    print("object");
    cityListModel.clear();
    var response = await http.post(
      Uri.parse('https://geo.vedicrishi.in/places/'),
      body: {
        "country": _selectedCountry.name,
        "name": countryController.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var result = json.decode(response.body);
        print("Api response $result");
        List listLocation = result;
        cityListModel
            .addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));
      });
    } else {
      print("Failed Api Rresponse");
    }
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Confirm Exit"),
        content: const Text("Are you sure you want to go back?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            isDestructiveAction: true, // Red color for emphasis
            child: const Text("Yes"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // int numberOfFields = widget.personCount;
    // final List<TextEditingController> textControllers = List.generate(numberOfFields, (index) => TextEditingController());
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    //DateTime bookingDate = DateTime.parse(widget.date);

    return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await _showExitDialog(context);
        return confirmExit;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isLoading
            ? Container(
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
          automaticallyImplyLeading: false,
          title: const Text(
            "Fill Pooja Form",
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
                      border:
                      Border.all(color: Colors.grey.shade300, width: 1.5),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.poojaName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        widget.packageName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 10,
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
                            child: Icon(
                              _showText
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 30,
                              color: Colors.amber,
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
                                Icons.calendar_month,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    "${widget.date}",
                                    //DateFormat('dd-MMM-yyyy,').format(bookingDate),
                                    style: const TextStyle(
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
                                Icons.location_pin,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    widget.poojaVenue,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 2,
                                  )),
                            ],
                          ),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const Text(
                        "Panditji will take your name along with gotra during pooja.",
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
                            style:
                            const TextStyle(fontFamily: 'Roboto-Regular'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const Text(
                        "gotra will be recited during the pooja.",
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
                        "Add your whatsApp number (Optional)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const Text(
                        "After the completion of the pooja, the prasad will be sent to you within 8–10 days.",
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
                                    color:
                                    isYesNo ? Colors.white : Colors.black),
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
                                    color:
                                    isYesNo ? Colors.black : Colors.white),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // house number
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
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
                                          color: Colors.amber,
                                          width: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: TextFormField(
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
                                          color: Colors.amber,
                                          width: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Colony

                          const SizedBox(
                            height: 10,
                          ),

                          // Landmark
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

                          // location city
                          TextFormField(
                            controller: countryController,
                            onChanged: (value) => updateValue(value),
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
                          AnimatedContainer(
                            duration: const Duration(
                                milliseconds:
                                600), // Adjust animation duration for smooth transition
                            curve: Curves
                                .easeInCirc, // Customize animation curve if needed
                            padding: const EdgeInsets.all(8.0),
                            height: searchbox == false ? 0 : 160,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6.0)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: cityListModel
                                  .length, // Number of items in the list
                              itemBuilder:
                                  (BuildContext context, int index) {
                                // itemBuilder function returns a widget for each item in the list
                                return SingleChildScrollView(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        latiTude = cityListModel[index]
                                            .latitude
                                            .toString();
                                        longiTude = cityListModel[index]
                                            .longitude
                                            .toString();
                                        countryController.text =
                                            cityListModel[index]
                                                .place
                                                .toString();
                                        searchbox = false;
                                      });
                                      getAddressFromLatLong(
                                          double.parse(latiTude),
                                          double.parse(longiTude));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons
                                                .location_on_outlined),
                                            Expanded(
                                              child: Text(
                                                cityListModel[index]
                                                    .place,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }
}
