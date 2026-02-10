import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../utill/flutter_toast_helper.dart';
import '../../all_pandit/city_picker_model.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../models/kundlisavemodel.dart';
import 'kundli_Detail.dart';

class KundliForm extends StatefulWidget {
  const KundliForm({super.key});

  @override
  _KundliFormState createState() => _KundliFormState();
}

class _KundliFormState extends State<KundliForm> with TickerProviderStateMixin {
  @override

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    getSaveList(userId);
    countryController.addListener(getCityPick);
    getCityPick(); // Initialize with all items;
  }

  TabController? _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String timeHour = "";
  String timeMinute = "";
  String dateDay = "";
  String dateMonth = "";
  String dateYear = "";
  String latiTude = "";
  String longiTude = "";
  String userId = "";
  //int kundliSaveIndex = 0;
  String? _selectedGender;
  String? selectedLocation;
  final kundaliKey = GlobalKey<FormState>();
  final List<String> genderOptions = ['Male', 'Female', 'Others'];
  int _maleValue = 1;

  //model list
  List<CityPickerModel> cityListModel = <CityPickerModel>[];
  List<KundliSaveModel> kundaliSaveModelList = <KundliSaveModel>[];
  List<KundliSaveModel> lastTwoItems = <KundliSaveModel>[];

  //Country Picker
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

  Future<void> getSaveList(String userId) async {
    final String apiUrl =
        AppConstants.baseUrl + AppConstants.kundliSaveURL + userId;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> res = jsonDecode(response.body);

        setState(() {
          kundaliSaveModelList
            ..clear()
            ..addAll(res.map((e) => KundliSaveModel.fromJson(e)));

          // Ensure at least two elements exist before slicing
          lastTwoItems = kundaliSaveModelList.length >= 2
              ? kundaliSaveModelList.sublist(kundaliSaveModelList.length - 2)
              : List.from(kundaliSaveModelList);
        });
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // void deleteKundli(int kundliSaveIndex) async {
  //   var res =
  //   await HttpService().deleteApi("${AppConstants.kundliDeleteURL}$kundliSaveIndex");
  //   print(res);
  //   showTopSnackBar(
  //     Overlay.of(context),
  //     const CustomSnackBar.success(
  //       textStyle: TextStyle(
  //           fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
  //       message: "Delete Successfull !",
  //     ),
  //   );
  //   getSaveList(userId);
  // }
  void deleteKundli(int kundliSaveIndex) async {
    try {
      // Store the current list length for verification
      final initialLength = kundaliSaveModelList.length;

      // Optimistically remove the item from local state first
      setState(() {
        kundaliSaveModelList.removeWhere((item) => item.id == kundliSaveIndex);
        lastTwoItems = kundaliSaveModelList.length >= 2
            ? kundaliSaveModelList.sublist(kundaliSaveModelList.length - 2)
            : List.from(kundaliSaveModelList);
      });

      // Make API call
      final response = await HttpService()
          .deleteApi("${AppConstants.kundliDeleteURL}$kundliSaveIndex");

      // Verify deletion actually occurred
      if (initialLength == kundaliSaveModelList.length) {
        // If list length didn't change, the item wasn't found locally
        await getSaveList(userId); // Force refresh from server
        return;
      }
      ToastHelper.showSuccess("Delete Successful!");

      // Final verification refresh
      await getSaveList(userId);
    } catch (e) {
      // Revert if error occurs
      await getSaveList(userId);
      ToastHelper.showError("Unable to delete item");
    }
  }

  // button functionality
  void _submitForm() {
    print("Submit button pressed");
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        countryController.text.isEmpty ||
        _nameController.text.trim().isEmpty ||
        _nameController.text.length < 4) {
      kundaliKey.currentState!.validate();
      ToastHelper.showToast(message: "Form fields required!");
      getSaveList(userId);
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => KundliDetails(
                  name: _nameController.text,
                  day: dateDay,
                  month: dateMonth,
                  year: dateYear,
                  hour: timeHour.toString(),
                  mint: timeMinute.toString(),
                  country: _selectedCountry.name,
                  city: countryController.text,
                  lati: latiTude,
                  longi: longiTude,
                )),
      );
      getSaveList(userId);
      _tabController?.animateTo(1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    print('Name: ${_nameController.text}');
    print('Date of Birth: $dateDay/$dateMonth/$dateYear');
    print('Time: $timeHour:$timeMinute');
    print('Gender: $_selectedGender');
    print('Location: ${_selectedCountry.name}');
    print('Location: ${countryController.text}');
    print('Location: $latiTude');
    print('Location: $longiTude');
  }

  // Function to refresh Tab 2
  Future<void> _refreshTab2() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      getSaveList(userId);
    });
  }

  String convertTimeToAmPm(String time) {
    final dateTime = DateFormat('HH:mm:ss').parse(time);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  String convertDate(String date) {
    final dateTime = DateFormat('yyyy-MM-dd').parse(date);
    final formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double hT = MediaQuery.of(context).size.height;

    Widget firstTabview() {
      return SingleChildScrollView(
        child: Form(
          key: kundaliKey,
          child: Column(
            children: [
              // fist container
              Container(
                //padding: const EdgeInsets.all(10),
                color: Colors.brown.shade200,
                child: Center(
                  child: Image.asset(
                    "assets/images/kundli_banner.jpg",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // second container
                    Container(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // name
                            const Text('Name',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3),
                            TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "name is required";
                                }
                                return null;
                              },
                              cursorColor: Colors.orange,
                              controller: _nameController,
                              style:
                                  const TextStyle(fontFamily: 'Roboto-Regular'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
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
                            const SizedBox(height: 10),

                            // // Gender
                            // const Text('Gender',
                            //     style: TextStyle(
                            //         fontSize: 16,
                            //         color: Colors.black,
                            //         fontFamily: 'Roboto')),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                            //   margin: const EdgeInsets.only(top: 2, bottom: 10),
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(8),
                            //     border: Border.all(color: Colors.grey),
                            //   ),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton<String>(
                            //       value: _selectedGender,
                            //       hint: Text('Select Gender'),
                            //       items: genderOptions.map((String value) {
                            //         return DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Text(value),
                            //         );
                            //       }).toList(),
                            //       onChanged: (String? newValue) {
                            //         setState(() {
                            //           _selectedGender = newValue;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),

                            const Text(
                              "Gender",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                                    Text('Others'),
                                    Icon(
                                      Icons.person_2_outlined,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            // Birth Date
                            const Text('Birth Date',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.only(top: 2, bottom: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  final DateTime today = DateTime.now();
                                  final DateTime yesterday =
                                      today.subtract(const Duration(days: 1));

                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        yesterday, // Set initial to yesterday
                                    firstDate: DateTime(1900),
                                    lastDate:
                                        yesterday, // Set last selectable date to yesterday
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
                                      dateDay =
                                          DateFormat('dd').format(pickedDate);
                                      dateMonth =
                                          DateFormat('MM').format(pickedDate);
                                      dateYear =
                                          DateFormat('yyyy').format(pickedDate);
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
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
                                    Text(
                                      _dateController.text,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'Roboto-Regular'),
                                    ),
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Birth Timing
                            const Text('Birth Timing',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.only(top: 2, bottom: 10),
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
                                          .padLeft(2, "0");
                                      timeMinute = pickedTime.minute
                                          .toString()
                                          .padLeft(2, "0");
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
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
                                    Text(
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

                            // country
                            Row(
                              children: [
                                // location
                                Expanded(
                                  flex: 1,
                                  child: Column(
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
                                          margin: const EdgeInsets.only(top: 2),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.orange),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _selectedCountry != null
                                                  ? _selectedCountry.flagEmoji
                                                  : 'No country selected',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  width: 6.0,
                                ),
                                // country
                                Expanded(
                                  flex: 3,
                                  child: Column(
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
                              height: 10.0,
                            ),
                            // location
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
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.location_on_outlined),
                                              Expanded(
                                                child: Text(
                                                  cityListModel[index].place,
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // button
                    ElevatedButton(
                      onPressed: _submitForm,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget secondTabview() {
      return kundaliSaveModelList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 2,
                            color: Colors.orange.shade50)
                      ]),
                  child: Column(
                    children: [
                      const Text(
                        "Create Kundli",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "First create the horoscope and then see it!",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _tabController?.animateTo(0);
                          },
                          child: const Text("+ Create"))
                    ],
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     isDense: true,
                    //     hintText: "Search Kundli by name",
                    //     hintStyle: TextStyle(fontSize: 18),
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0)),
                    //     prefixIcon: Icon(
                    //       Icons.search,
                    //       color: Colors.black,
                    //       size: 25,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.orange,
                          height: 20,
                          width: 4,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "Recently Open",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    // Recent
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lastTwoItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item =
                              lastTwoItems[lastTwoItems.length - 1 - index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                        child: Text(
                                      item.name.length >= 2
                                          ? item.name.substring(0, 2)
                                          : item.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => KundliDetails(
                                                  name: item.name,
                                                  day:
                                                      item.dob.substring(8, 10),
                                                  month:
                                                      item.dob.substring(5, 7),
                                                  year:
                                                      item.dob.substring(0, 4),
                                                  hour:
                                                      item.time.substring(0, 2),
                                                  mint:
                                                      item.time.substring(3, 5),
                                                  country: item.country,
                                                  city: item.city,
                                                  lati: item.latitude,
                                                  longi: item.longitude,
                                                )),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(item.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(
                                            width: 220,
                                            child: Text(
                                                "${convertDate(item.dob)} , ${convertTimeToAmPm(item.time)} ${item.city} , ${item.country}")),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: const Text(
                                            'Confirmation',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          content: const Text(
                                              'Are you sure you want to delete this item?'),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: const Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            CupertinoDialogAction(
                                              isDestructiveAction:
                                                  true, // Red button style
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                // Perform deletion logic
                                                Navigator.pop(context);
                                                deleteKundli(item.id);
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                              )
                            ],
                          );
                        }),

                    // All
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.orange,
                          height: 20,
                          width: 4,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "All",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: kundaliSaveModelList.isEmpty
                            ? 1
                            : kundaliSaveModelList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (kundaliSaveModelList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("No saved kundalis found"),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                        child: Text(
                                      kundaliSaveModelList[index].name.length >=
                                              2
                                          ? kundaliSaveModelList[index]
                                              .name
                                              .substring(0, 2)
                                              .toUpperCase()
                                          : kundaliSaveModelList[index].name,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => KundliDetails(
                                                  name: kundaliSaveModelList[
                                                          index]
                                                      .name,
                                                  day: kundaliSaveModelList[
                                                          index]
                                                      .dob
                                                      .substring(8, 10),
                                                  month: kundaliSaveModelList[
                                                          index]
                                                      .dob
                                                      .substring(5, 7),
                                                  year: kundaliSaveModelList[
                                                          index]
                                                      .dob
                                                      .substring(0, 4),
                                                  hour: kundaliSaveModelList[
                                                          index]
                                                      .time
                                                      .substring(0, 2),
                                                  mint: kundaliSaveModelList[
                                                          index]
                                                      .time
                                                      .substring(3, 5),
                                                  country: kundaliSaveModelList[
                                                          index]
                                                      .country,
                                                  city: kundaliSaveModelList[
                                                          index]
                                                      .city,
                                                  lati: kundaliSaveModelList[
                                                          index]
                                                      .latitude,
                                                  longi: kundaliSaveModelList[
                                                          index]
                                                      .longitude,
                                                )),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(kundaliSaveModelList[index].name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(
                                            width: 220,
                                            child: Text(
                                                "${convertDate(kundaliSaveModelList[index].dob)} , ${convertTimeToAmPm(kundaliSaveModelList[index].time)} ${kundaliSaveModelList[index].city} , ${kundaliSaveModelList[index].country}")),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: const Text(
                                            'Confirmation',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          content: const Text(
                                              'Are you sure you want to delete this item?'),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: const Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            CupertinoDialogAction(
                                              isDestructiveAction:
                                                  true, // Red button style
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                // Perform deletion logic
                                                Navigator.pop(context);
                                                setState(() {});
                                                deleteKundli(
                                                    kundaliSaveModelList[index]
                                                        .id);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            );
    }

    return DefaultTabController(
      length: 2, // Number of inner tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Kundli",
            style: TextStyle(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            //Tabs
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.orange.shade100, width: 3)),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6.0)),
                indicatorColor: Colors.orange,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
                tabs: const [
                  Tab(
                    child: Center(child: Text("Generate New")),
                  ),
                  Tab(
                    child: Center(child: Text("Open Kundli")),
                  ),
                ],
              ),
            ),
            //TAbViewz
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _refreshTab2;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Content for inner Tab 1
                    firstTabview(),
                    // Content for inner Tab 2
                    secondTabview(),
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
