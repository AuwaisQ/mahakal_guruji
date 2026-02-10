import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../utill/flutter_toast_helper.dart';
import '../all_pandit/city_picker_model.dart';
import 'lalkitab.dart';

class LalKitabForm extends StatefulWidget {
  const LalKitabForm({super.key});

  @override
  State<LalKitabForm> createState() => _LalKitabFormState();
}

class _LalKitabFormState extends State<LalKitabForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _timeController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  String? latitude;

  String? longitude;

  String? selectedLocation;

  String? timeHour;

  String? timeMinute;

  int _maleValue = 1;

  //model list
  List<CityPickerModel> cityListModel = <CityPickerModel>[];

  final numeroFormKey = GlobalKey<FormState>();

  Country _selectedCountry = Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India',
    displayNameNoCountryCode: 'India',
    e164Key: '91-IN-0',
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
    print('serchbox $searchbox');
  }

  // country picker api
  void getCityPick() async {
    print('object');
    cityListModel.clear();
    var response = await http.post(
      Uri.parse('https://geo.vedicrishi.in/places/'),
      body: {
        'country': _selectedCountry.name,
        'name': countryController.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var result = json.decode(response.body);
        print('Api response $result');
        List listLocation = result;
        cityListModel
            .addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));
      });
    } else {
      print('Failed Api Rresponse');
    }
  }

  // button functionality
  void _submitForm() {
    print('Submit button pressed');
    print('Name: ${_nameController.text}');
    print('Date of Birth: ${_dateController.text}');
    print('Time: ${_timeController.text}');
    print('Country: ${_selectedCountry.name}');
    print('Location: ${countryController.text}');
    print('lati: $latitude');
    print('longi: $longitude');
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        countryController.text.isEmpty ||
        _nameController.text.trim().isEmpty ||
        _nameController.text.length < 4) {
      numeroFormKey.currentState!.validate();
      ToastHelper.showToast(message: 'Form fields required!');
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => LalKitab(
                  name: _nameController.text,
                  date: _dateController.text,
                  time: '${timeHour.toString()}:${timeMinute.toString()}',
                  country: _selectedCountry.name,
                  city: countryController.text,
                  lati: latitude.toString(),
                  longi: longitude.toString(),
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laal Kitab',
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
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
                        key: numeroFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 10.0,
                            ),

                            const Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // name
                            TextFormField(
                              validator: (value) {
                                if (_nameController.text.length < 4 ||
                                    _nameController.text.isEmpty) {
                                  return 'Name must be 4 characters';
                                }
                                return null;
                              },
                              cursorColor: Colors.orange,
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: const TextStyle(color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1),
                                ),
                                suffixIcon: const Icon(Icons.person_outline,
                                    color: Colors.grey, size: 30),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const Text(
                              'Gender',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: Colors.orange,
                                  value: 1, // Value assigned to "Male"
                                  groupValue: _maleValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _maleValue = value
                                          as int; // Cast as int for safety
                                    });
                                  },
                                ),
                                const Row(
                                  children: [
                                    Text('Male'),
                                    Icon(
                                      Icons.male,
                                      size: 15,
                                    )
                                  ],
                                ),
                                Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: 2, // Value assigned to "Female"
                                  activeColor: Colors.orange,
                                  groupValue: _maleValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _maleValue = value
                                          as int; // Cast as int for safety
                                    });
                                  },
                                ),
                                const Row(
                                  children: [
                                    Text('Female'),
                                    Icon(
                                      Icons.female,
                                      size: 15,
                                    )
                                  ],
                                ),
                                Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: 3, // Value assigned to "Female"
                                  activeColor: Colors.orange,
                                  groupValue: _maleValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _maleValue = value
                                          as int; // Cast as int for safety
                                    });
                                  },
                                ),
                                const Row(
                                  children: [
                                    Text('Other'),
                                    Icon(
                                      Icons.person_2_outlined,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            const Text(
                              'Date Of Birth',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Birth Date
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors.white,
                                            onPrimary: Colors.orange,
                                            surface: Color(0xFFFFF7EC),
                                            onSurface: Colors.orange,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.orange,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          dialogTheme: const DialogThemeData(
                                              backgroundColor:
                                                  Color(0xFFFFF7EC)),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  alignment: Alignment.centerLeft,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _dateController.text.isEmpty
                                        ? const Text(
                                            'Select Date',
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
                            const SizedBox(height: 10.0),

                            const Text(
                              'Time Of Birth',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Birth Timing
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          timePickerTheme:
                                              const TimePickerThemeData(
                                            dialHandColor: Colors.grey,
                                            dialTextColor: Colors.orange,
                                            dialBackgroundColor: Colors.white,
                                            dayPeriodColor: Colors.white,
                                            dayPeriodTextColor: Colors.orange,
                                            backgroundColor: Color(0xFFFFF7EC),
                                            hourMinuteTextColor: Colors.orange,
                                            hourMinuteColor: Colors.white,
                                            inputDecorationTheme:
                                                InputDecorationTheme(
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintStyle: TextStyle(
                                                  color: Colors.orange),
                                              labelStyle: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.orange,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
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
                                          .padLeft(2, '0');
                                      timeMinute = pickedTime.minute
                                          .toString()
                                          .padLeft(2, '0');
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  alignment: Alignment.centerLeft,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _timeController.text.isEmpty
                                        ? const Text(
                                            'Select Time',
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
                            const SizedBox(height: 10.0),

                            // Text("Country"),
                            // // country
                            // InkWell(
                            //   onTap: () {
                            //     showCountryPicker(
                            //       context: context,
                            //       showPhoneCode:
                            //       false, // optional. Shows phone code before the country name.
                            //       onSelect: (Country country) {
                            //         setState(() {
                            //           _selectedCountry = country;
                            //         });
                            //       },
                            //     );
                            //   },
                            //   child: Container(
                            //     height: 50,
                            //     margin: const EdgeInsets.only(top: 2),
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(8),
                            //       border: Border.all(color: Colors.grey),
                            //     ),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 10.0),
                            //           child: Row(
                            //             mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Text(
                            //                 _selectedCountry != null
                            //                     ? '${_selectedCountry!.name}'
                            //                     : 'No country selected',
                            //               ),
                            //               Icon(
                            //                 Icons.location_pin,
                            //                 color: Colors.grey,
                            //                 size: 30,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 8.0),
                            //
                            // Text("State"),
                            // Container(
                            //     height: 50,
                            //     padding: EdgeInsets.symmetric(horizontal: 10.0),
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(8),
                            //       border: Border.all(color: Colors.grey),
                            //     ),
                            //     child: TextFormField(
                            //       controller: countryController,
                            //       onChanged: (value) => updateValue(value),
                            //       decoration: InputDecoration(
                            //         // Add relevant hints or labels for better user experience
                            //         hintText: 'Select City',
                            //         border: InputBorder.none,
                            //       ),
                            //     )),
                            Row(
                              children: [
                                // country
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Country',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold)),
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
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.orange),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  _selectedCountry != null
                                                      ? _selectedCountry
                                                          .flagEmoji
                                                      : 'No country selected',
                                                  style: const TextStyle(
                                                      fontSize: 20),
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
                                  width: 6.0,
                                ),
                                // location
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('City',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.orange),
                                          ),
                                          child: TextFormField(
                                            controller: countryController,
                                            onChanged: (value) =>
                                                updateValue(value),
                                            decoration: const InputDecoration(
                                                // Add relevant hints or labels for better user experience
                                                hintText: 'Search City',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
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
                                  border: Border.all(color: Colors.grey),
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
                                          countryController.text =
                                              cityListModel[index]
                                                  .place
                                                  .toString();
                                          longitude =
                                              cityListModel[index].longitude;
                                          latitude =
                                              cityListModel[index].latitude;
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
