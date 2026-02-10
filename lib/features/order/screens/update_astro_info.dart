import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../utill/app_constants.dart';
import '../../all_pandit/city_picker_model.dart';

class UpdateInformationView extends StatefulWidget {
  final String orderId;
  const UpdateInformationView({super.key, required this.orderId});

  @override
  State<UpdateInformationView> createState() => _UpdateInformationViewState();
}

class _UpdateInformationViewState extends State<UpdateInformationView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  String? latitude;
  String? longitude;
  String? selectedLocation;
  String? timeHour;
  String? timeMinute;
  int _maleValue = 1;
  String gender = "male";
  bool isLoading = false;
  //model list
  List<CityPickerModel> cityListModel = <CityPickerModel>[];
  final infoFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  Country _selectedCountry = Country(
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
    if (cityController.text.length > 1) {
      setState(() {
        searchbox = true;
      });
    } else if (cityController.text.isEmpty) {
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
        "name": cityController.text,
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

  Future<void> getSankalpdata() async {
    // Define the API endpoint
    isLoading = true;
    const String apiUrl = AppConstants.baseUrl + AppConstants.getSankalpDataUrl;

    // Create the data payload
    Map<String, dynamic> data = {
      "order_id": widget.orderId,
      "name": _nameController.text,
      "gender": gender,
      "mobile": _mobileController.text,
      "dob": _dateController.text,
      "time": "$timeHour:$timeMinute",
      "country": _selectedCountry.name,
      "city": cityController.text
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

      if ([200, 201].contains(response.statusCode)) {
        // Handle success
        print('Booking successful pooja ${response.body}');
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to book pooja: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle exception
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Form",
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 4.0,
                        offset: Offset(0, 4), // X, Y
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: infoFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 10.0,
                        ),
                        // name
                        const Text(
                          " Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          cursorColor: Colors.amber,
                          controller: _nameController,
                          style: const TextStyle(fontFamily: 'Roboto-Regular'),
                          decoration: InputDecoration(
                            hintText: "Enter Your Name",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            suffixIcon: const Icon(Icons.person_outline,
                                color: Colors.grey, size: 30),
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        const Text(
                          " Email",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          cursorColor: Colors.amber,
                          controller: _emailController,
                          style: const TextStyle(fontFamily: 'Roboto-Regular'),
                          decoration: InputDecoration(
                            hintText: "Email Address",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            suffixIcon: const Icon(Icons.mail,
                                color: Colors.grey, size: 30),
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        const Text(
                          " Mobile No.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          cursorColor: Colors.amber,
                          controller: _mobileController,
                          style: const TextStyle(fontFamily: 'Roboto-Regular'),
                          decoration: InputDecoration(
                            hintText: "Mobile Number",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.amber, width: 1),
                            ),
                            suffixIcon: const Icon(Icons.numbers,
                                color: Colors.grey, size: 30),
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        const Text("Gender"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: Colors.amber,
                              value: 1, // Value assigned to "Male"
                              groupValue: _maleValue,
                              onChanged: (value) {
                                setState(() {
                                  _maleValue = value as int;
                                  gender = "male"; // Cast as int for safety
                                });
                              },
                            ),
                            const Text('Male '),
                            Radio(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: 2, // Value assigned to "Female"
                              activeColor: Colors.amber,
                              groupValue: _maleValue,
                              onChanged: (value) {
                                setState(() {
                                  _maleValue = value as int;
                                  gender = "female"; // Cast as int for safety
                                });
                              },
                            ),
                            const Text('Female '),
                            Radio(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: 3, // Value assigned to "Female"
                              activeColor: Colors.amber,
                              groupValue: _maleValue,
                              onChanged: (value) {
                                setState(() {
                                  _maleValue = value as int;
                                  gender = "order"; // Cast as int for safety
                                });
                              },
                            ),
                            const Text('Other'),
                          ],
                        ),
                        // Birth Date
                        const Text(
                          " Birth Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.white,
                                        onPrimary: Colors.amber,
                                        surface: Color(0xFFFFF7EC),
                                        onSurface: Colors.amber,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.amber,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      dialogTheme: const DialogThemeData(
                                          backgroundColor: Color(0xFFFFF7EC)),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _dateController.text.isEmpty
                                    ? const Text(
                                        "Select Date",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto-Regular'),
                                      )
                                    : Text(
                                        _dateController.text,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: 'Roboto-Regular'),
                                      ),
                                const Icon(Icons.calendar_month_outlined,
                                    color: Colors.grey, size: 30),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        // Birth Timing
                        const Text(
                          " Birth Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      timePickerTheme:
                                          const TimePickerThemeData(
                                        dialHandColor: Colors.amber,
                                        dialTextColor: Colors.amber,
                                        dialBackgroundColor: Colors.white,
                                        dayPeriodColor: Colors.white,
                                        dayPeriodTextColor: Colors.amber,
                                        backgroundColor: Color(0xFFFFF7EC),
                                        hourMinuteTextColor: Colors.amber,
                                        hourMinuteColor: Colors.white,
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle:
                                              TextStyle(color: Colors.amber),
                                          labelStyle:
                                              TextStyle(color: Colors.amber),
                                        ),
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.amber,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                      dialogTheme: const DialogThemeData(
                                          backgroundColor: Colors.white),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _timeController.text =
                                      pickedTime.format(context);
                                  timeHour = pickedTime.hour
                                      .toString()
                                      .padLeft(2, "0");
                                  timeMinute = pickedTime.minute
                                      .toString()
                                      .padLeft(2, "0");
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _timeController.text.isEmpty
                                    ? const Text(
                                        "Select Time",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto-Regular'),
                                      )
                                    : Text(
                                        _timeController.text,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: 'Roboto-Regular'),
                                      ),
                                const Icon(Icons.timelapse_outlined,
                                    color: Colors.grey, size: 30),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        Row(
                          children: [
                            // country
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Country',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'Roboto')),
                                  InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode:
                                            false, // optional. Shows phone code before the country name.
                                        onSelect: (Country country) {
                                          setState(() {
                                            _selectedCountry = country;
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.amber),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                _selectedCountry != null
                                                    ? _selectedCountry.flagEmoji
                                                    : 'No country selected',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),
                            // location
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('City',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'Roboto')),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.amber),
                                      ),
                                      child: TextFormField(
                                        controller: cityController,
                                        onChanged: (value) =>
                                            updateValue(value),
                                        decoration: const InputDecoration(
                                            // Add relevant hints or labels for better user experience
                                            hintText: 'Enter your City',
                                            border: InputBorder.none),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        //location box
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
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(6.0)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: cityListModel
                                .length, // Number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              // itemBuilder function returns a widget for each item in the list
                              return SingleChildScrollView(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      cityController.text =
                                          cityListModel[index].place.toString();
                                      longitude =
                                          cityListModel[index].longitude;
                                      latitude = cityListModel[index].latitude;
                                      searchbox = false;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_pin),
                                          Text(
                                            cityListModel[index].place,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // button
                isLoading
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
                    : ElevatedButton(
                        onPressed: () {
                          // _submitForm();
                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => const MyOrderView(tabIndex: 0, subTabIndex: 0,)));
                          getSankalpdata();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.amber,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.28),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
