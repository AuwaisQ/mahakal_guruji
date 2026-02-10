import 'dart:convert';

// ignore: unused_import
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../utill/flutter_toast_helper.dart';
import '../all_pandit/city_picker_model.dart';
import '../profile/controllers/profile_contrroller.dart';
import 'kundalimatchingResult.dart';
import 'models/kundlimilansavemodel.dart';

class KundaliMatchingView extends StatefulWidget {
  const KundaliMatchingView({super.key});

  @override
  State<KundaliMatchingView> createState() => _KundaliMatchingState();
}

class _KundaliMatchingState extends State<KundaliMatchingView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    getMilanSaveList(userId);
    getMaleCityPick();
    getFemaleCityPick(); // Initialize with all items;
  }

  TabController? _tabController;

  // Male Information
  final TextEditingController maleNameController = TextEditingController();
  final TextEditingController maleDateController = TextEditingController();
  final TextEditingController maleTimeController = TextEditingController();
  final TextEditingController maleCountryController = TextEditingController();
  String userId = "";
  String maleTimeHour = "";
  String maleTimeMinute = "";
  String maleLatiTude = "";
  String maleLongiTude = "";
  String? maleSelectedLocation;
  final kundaliMactchigKey = GlobalKey<FormState>();
  //model list
  List<CityPickerModel> maleCityListModel = <CityPickerModel>[];
  //Country Picker
  Country _selectedCountryMale = Country(
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

  // Male Information
  final TextEditingController femaleNameController = TextEditingController();
  final TextEditingController femaleDateController = TextEditingController();
  final TextEditingController femaleTimeController = TextEditingController();
  final TextEditingController femaleCountryController = TextEditingController();
  String femaleTimeHour = "";
  String femaleTimeMinute = "";
  String femaleLatiTude = "";
  String femaleLongiTude = "";
  String? femaleSelectedLocation;

  //model list
  List<CityPickerModel> femaleCityListModel = <CityPickerModel>[];
  List<KundliMilanSaveModel> kundaliMilanSaveModelList =
      <KundliMilanSaveModel>[];
  List<KundliMilanSaveModel> milanlastTwoItems = <KundliMilanSaveModel>[];

  //Country Picker
  Country _selectedCountryFemale = Country(
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

  void updateValueMale(String value) {
    print('Entered value: $value');
    getMaleCityPick();
    searchBoxMale();
  }

  void updateValueFemale(String value) {
    print('Entered value: $value');
    getFemaleCityPick();
    searchBoxFemale();
  }

  //maleSerach box
  bool searchboxMale = false;
  void searchBoxMale() {
    if (maleCountryController.text.length > 1) {
      setState(() {
        searchboxMale = true;
      });
    } else if (maleCountryController.text.isEmpty) {
      setState(() {
        searchboxMale = false;
      });
    }
    print("serchbox $searchboxMale");
  }

  // female Serach box
  bool searchboxFemale = false;
  void searchBoxFemale() {
    if (femaleCountryController.text.length > 1) {
      setState(() {
        searchboxFemale = true;
      });
    } else if (femaleCountryController.text.isEmpty) {
      setState(() {
        searchboxFemale = false;
      });
    }
    print("serchbox $searchboxFemale");
  }

  Future<void> getMilanSaveList(String userId) async {
    try {
      var res = await HttpService()
          .getApi("${AppConstants.kundliMilanSaveURL}$userId");
      print("API Response: $res");

      if (res != null && res is List) {
        setState(() {
          kundaliMilanSaveModelList
            ..clear()
            ..addAll(res.map((e) => KundliMilanSaveModel.fromJson(e)));

          // Get last two elements safely
          int length = kundaliMilanSaveModelList.length;
          milanlastTwoItems = length >= 2
              ? kundaliMilanSaveModelList.sublist(length - 2)
              : List.from(kundaliMilanSaveModelList);
        });
      } else {
        print("Invalid response format");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // country picker api
  void getMaleCityPick() async {
    print("object");
    maleCityListModel.clear();
    var response = await http.post(
      Uri.parse('https://geo.vedicrishi.in/places/'),
      body: {
        "country": _selectedCountryMale.name,
        "name": maleCountryController.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var result = json.decode(response.body);
        print("Api response $result");
        List listLocation = result;
        maleCityListModel
            .addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));
      });
    } else {
      print("Failed Api Rresponse");
    }
  }

  // country picker api
  void getFemaleCityPick() async {
    print("object");
    femaleCityListModel.clear();
    var response = await http.post(
      Uri.parse('https://geo.vedicrishi.in/places/'),
      body: {
        "country": _selectedCountryFemale.name,
        "name": femaleCountryController.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var result = json.decode(response.body);
        print("Api response $result");
        List listLocation = result;
        femaleCityListModel
            .addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));
      });
    } else {
      print("Failed Api Rresponse");
    }
  }

  void deleteKundliMilan(int kundliSaveIndex) async {
    try {
      // Store the current list length for verification
      final initialLength = kundaliMilanSaveModelList.length;

      // Optimistically remove the item from local state first
      setState(() {
        kundaliMilanSaveModelList
            .removeWhere((item) => item.id == kundliSaveIndex);
      });

      // Make API call
      final response = await HttpService()
          .deleteApi("${AppConstants.kundliMilanDeleteURL}$kundliSaveIndex");

      // Verify deletion actually occurred
      if (initialLength == kundaliMilanSaveModelList.length) {
        // If list length didn't change, the item wasn't found locally
        await getMilanSaveList(userId); // Force refresh from server
        return;
      }
      ToastHelper.showSuccess("Delete Successfull!");

      // Final verification refresh
      await getMilanSaveList(userId);
    } catch (e) {
      // Revert if error occurs
      await getMilanSaveList(userId);
      ToastHelper.showError("Unable to delete item!");
    }
  }

  // button functionality
  void _submitForm() {
    print("Submit button pressed");
    if (maleNameController.text.isEmpty ||
        femaleCountryController.text.isEmpty ||
        maleDateController.text.isEmpty ||
        femaleDateController.text.isEmpty ||
        maleTimeController.text.isEmpty ||
        femaleTimeController.text.isEmpty ||
        maleCountryController.text.isEmpty ||
        femaleCountryController.text.isEmpty) {
      kundaliMactchigKey.currentState!.validate();
      ToastHelper.showToast(message: "Form fields required!");

      getMilanSaveList(userId);
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => KundliMatchingResultView(
                  maleName: maleNameController.text,
                  maleDate: maleDateController.text,
                  maleTime:
                      "${maleTimeHour.toString()}:${maleTimeMinute.toString()}",
                  maleCountry: _selectedCountryMale.name,
                  maleCity: maleCountryController.text,
                  maleLati: maleLatiTude,
                  maleLongi: maleLongiTude,
                  femaleName: femaleNameController.text,
                  femaleDate: femaleDateController.text,
                  femaleTime:
                      "${femaleTimeHour.toString()}:${femaleTimeMinute.toString()}",
                  femaleCountry: _selectedCountryFemale.name,
                  femaleCity: femaleCountryController.text,
                  femaleLati: femaleLatiTude,
                  femaleLongi: femaleLongiTude,
                )),
      );
      getMilanSaveList(userId);
      _tabController?.animateTo(1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    print('Name: ${maleNameController.text}');
    print('Name: ${femaleNameController.text}');
    print('Date of Birth: ${maleDateController.text}');
    print('Date of Birth: ${femaleDateController.text}');
    print('Time: $maleTimeHour:$maleTimeMinute');
    print('Time: $femaleTimeHour:$femaleTimeMinute');
    print('Location M: ${_selectedCountryMale.name}');
    print('Location F: ${_selectedCountryFemale.name}');
    print('Location M: ${maleCountryController.text}');
    print('Location F: ${femaleCountryController.text}');
    print('Location M: $maleLatiTude');
    print('Location F: $femaleLatiTude');
    print('Location M: $maleLongiTude');
    print('Location F: $femaleLongiTude');
    getMilanSaveList(userId);
    _tabController?.animateTo(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
          key: kundaliMactchigKey,
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/Janam_kundli.jpg",
                    fit: BoxFit.fill,
                  )),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Lets see how many Qualities is matching in both of you",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),

              //Male form
              Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.orange.shade100,
                    border: Border.all(color: Colors.orange)),
                child: const Center(
                    child: Text(
                  "Male",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7EC),
                ),
                child: Container(
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
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Roboto',
                            )),
                        const SizedBox(height: 3),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "name is required";
                            }
                            return null;
                          },
                          cursorColor: Colors.orange,
                          controller: maleNameController,
                          style: const TextStyle(fontFamily: 'Roboto-Regular'),
                          decoration: InputDecoration(
                            hintText: "Male",
                            hintStyle: const TextStyle(color: Colors.grey),
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

                        // Birth Date
                        const Text('Birth Date',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Roboto')),
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
                                          backgroundColor: Color(0xFFFFF7EC)),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  maleDateController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(pickedDate);
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                maleDateController.text.isEmpty
                                    ? const Text(
                                        "Select Date",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto-Regular'),
                                      )
                                    : Text(
                                        maleDateController.text,
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

                        // Birth Timing
                        const Text('Birth Timing',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Roboto')),
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
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        dialHandColor: Colors.orange.shade100,
                                        dialTextColor: Colors.orange,
                                        dialBackgroundColor: Colors.white,
                                        dayPeriodColor: Colors.white,
                                        dayPeriodTextColor: Colors.orange,
                                        backgroundColor:
                                            const Color(0xFFFFF7EC),
                                        hourMinuteTextColor: Colors.orange,
                                        hourMinuteColor: Colors.white,
                                        inputDecorationTheme:
                                            const InputDecorationTheme(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle:
                                              TextStyle(color: Colors.orange),
                                          labelStyle:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.orange,
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
                                  maleTimeController.text =
                                      pickedTime.format(context);
                                  maleTimeHour = pickedTime.hour
                                      .toString()
                                      .padLeft(2, "0");
                                  maleTimeMinute = pickedTime.minute
                                      .toString()
                                      .padLeft(2, "0");
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                maleTimeController.text.isEmpty
                                    ? const Text(
                                        "Select Time",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto-Regular'),
                                      )
                                    : Text(
                                        maleTimeController.text,
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
                                            _selectedCountryMale = country;
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
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.orange),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              _selectedCountryMale != null
                                                  ? _selectedCountryMale
                                                      .flagEmoji
                                                  : 'No country selected',
                                              style:
                                                  const TextStyle(fontSize: 20),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.orange),
                                      ),
                                      child: TextFormField(
                                        controller: maleCountryController,
                                        onChanged: (value) =>
                                            updateValueMale(value),
                                        decoration: const InputDecoration(
                                            // Add relevant hints or labels for better user experience
                                            hintText: 'Search City',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
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
                        AnimatedContainer(
                          duration: const Duration(
                              milliseconds:
                                  600), // Adjust animation duration for smooth transition
                          curve: Curves
                              .easeInCirc, // Customize animation curve if needed
                          padding: const EdgeInsets.all(8.0),
                          height: searchboxMale == false ? 0 : 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(6.0)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: maleCityListModel
                                .length, // Number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              // itemBuilder function returns a widget for each item in the list
                              return SingleChildScrollView(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      maleLatiTude = maleCityListModel[index]
                                          .latitude
                                          .toString();
                                      maleLongiTude = maleCityListModel[index]
                                          .longitude
                                          .toString();
                                      maleCountryController.text =
                                          maleCityListModel[index]
                                              .place
                                              .toString();
                                      searchboxMale = false;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        maleCityListModel[index].place,
                                        style:
                                            const TextStyle(color: Colors.blue),
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
              ),

              //Female form
              Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.orange.shade100,
                    border: Border.all(color: Colors.orange)),
                child: const Center(
                    child: Text(
                  "Female",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7EC),
                ),
                child: Container(
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
                                fontFamily: 'Roboto')),
                        const SizedBox(height: 3),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "name is required";
                            }
                            return null;
                          },
                          cursorColor: Colors.orange,
                          controller: femaleNameController,
                          style: const TextStyle(fontFamily: 'Roboto-Regular'),
                          decoration: InputDecoration(
                            hintText: "Female",
                            hintStyle: const TextStyle(color: Colors.grey),
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

                        // Birth Date
                        const Text('Birth Date',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Roboto')),
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
                                          backgroundColor: Color(0xFFFFF7EC)),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  femaleDateController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(pickedDate);
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                femaleDateController.text.isEmpty
                                    ? const Text(
                                        "Select Date",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto-Regular'),
                                      )
                                    : Text(
                                        femaleDateController.text,
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

                        // Birth Timing
                        const Text('Birth Timing',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Roboto')),
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
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        dialHandColor: Colors.orange.shade100,
                                        dialTextColor: Colors.orange,
                                        dialBackgroundColor: Colors.white,
                                        dayPeriodColor: Colors.white,
                                        dayPeriodTextColor: Colors.orange,
                                        backgroundColor:
                                            const Color(0xFFFFF7EC),
                                        hourMinuteTextColor: Colors.orange,
                                        hourMinuteColor: Colors.white,
                                        inputDecorationTheme:
                                            const InputDecorationTheme(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle:
                                              TextStyle(color: Colors.orange),
                                          labelStyle:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.orange,
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
                                  femaleTimeController.text =
                                      pickedTime.format(context);
                                  femaleTimeHour = pickedTime.hour
                                      .toString()
                                      .padLeft(2, "0");
                                  femaleTimeMinute = pickedTime.minute
                                      .toString()
                                      .padLeft(2, "0");
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                femaleTimeController.text.isEmpty
                                    ? const Text(
                                        "Select Time",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto-Regular'),
                                      )
                                    : Text(
                                        femaleTimeController.text,
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
                                            _selectedCountryFemale = country;
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
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.orange),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              _selectedCountryFemale != null
                                                  ? _selectedCountryFemale
                                                      .flagEmoji
                                                  : 'No country selected',
                                              style:
                                                  const TextStyle(fontSize: 20),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.orange),
                                      ),
                                      child: TextFormField(
                                        controller: femaleCountryController,
                                        onChanged: (value) =>
                                            updateValueFemale(value),
                                        decoration: const InputDecoration(
                                            // Add relevant hints or labels for better user experience
                                            hintText: 'Search City',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
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
                        AnimatedContainer(
                          duration: const Duration(
                              milliseconds:
                                  600), // Adjust animation duration for smooth transition
                          curve: Curves
                              .easeInCirc, // Customize animation curve if needed
                          padding: const EdgeInsets.all(8.0),
                          height: searchboxFemale == false ? 0 : 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(6.0)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: femaleCityListModel
                                .length, // Number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              // itemBuilder function returns a widget for each item in the list
                              return SingleChildScrollView(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      femaleLatiTude =
                                          femaleCityListModel[index]
                                              .latitude
                                              .toString();
                                      femaleLongiTude =
                                          femaleCityListModel[index]
                                              .longitude
                                              .toString();
                                      femaleCountryController.text =
                                          femaleCityListModel[index]
                                              .place
                                              .toString();
                                      searchboxFemale = false;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        femaleCityListModel[index].place,
                                        style:
                                            const TextStyle(color: Colors.blue),
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
              ),

              InkWell(
                onTap: () {
                  _submitForm();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    }

    Widget secondTabview() {
      return kundaliMilanSaveModelList.isEmpty
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
                    //     hintStyle: const TextStyle(fontSize: 18),
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0)
                    //     ),
                    //     prefixIcon: const Icon(Icons.search,color: Colors.black,size: 25,),
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
                        itemCount: milanlastTwoItems.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                      "${milanlastTwoItems[index].maleName.characters.first.toUpperCase()} ${milanlastTwoItems[index].femaleName.characters.first.toUpperCase()}",
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
                                            builder: (context) =>
                                                KundliMatchingResultView(
                                                  maleName:
                                                      milanlastTwoItems[index]
                                                          .maleName,
                                                  maleDate: convertDate(
                                                      milanlastTwoItems[index]
                                                          .maleDob),
                                                  maleTime:
                                                      milanlastTwoItems[index]
                                                          .maleTime
                                                          .substring(0, 5),
                                                  maleCountry:
                                                      milanlastTwoItems[index]
                                                          .maleCountry,
                                                  maleCity:
                                                      milanlastTwoItems[index]
                                                          .maleCity,
                                                  maleLati:
                                                      milanlastTwoItems[index]
                                                          .maleLatitude,
                                                  maleLongi:
                                                      milanlastTwoItems[index]
                                                          .maleLongitude,
                                                  femaleName:
                                                      milanlastTwoItems[index]
                                                          .femaleName,
                                                  femaleDate: convertDate(
                                                      milanlastTwoItems[index]
                                                          .femaleDob),
                                                  femaleTime:
                                                      milanlastTwoItems[index]
                                                          .femaleTime
                                                          .substring(0, 5),
                                                  femaleCountry:
                                                      milanlastTwoItems[index]
                                                          .femaleCountry,
                                                  femaleCity:
                                                      milanlastTwoItems[index]
                                                          .femaleCity,
                                                  femaleLati:
                                                      milanlastTwoItems[index]
                                                          .femaleLatitude,
                                                  femaleLongi:
                                                      milanlastTwoItems[index]
                                                          .femaleLongitude,
                                                )),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${milanlastTwoItems[index].maleName} & ${milanlastTwoItems[index].femaleName}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(
                                            width: 220,
                                            child: Text(
                                                "${convertDate(milanlastTwoItems[index].maleDob)} , ${convertTimeToAmPm(milanlastTwoItems[index].maleTime)} ${milanlastTwoItems[index].maleCity},${milanlastTwoItems[index].maleCountry}")),
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
                                                  deleteKundliMilan(
                                                      milanlastTwoItems[index]
                                                          .id);
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
                                      )),
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
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        //itemCount: kundaliMilanSaveModelList.length,
                        itemCount: kundaliMilanSaveModelList.isEmpty
                            ? 1
                            : kundaliMilanSaveModelList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (kundaliMilanSaveModelList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                    "No saved kundali milan records found"),
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
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "${kundaliMilanSaveModelList[index].maleName.characters.first.toUpperCase()} ${kundaliMilanSaveModelList[index].femaleName.characters.first.toUpperCase()}",
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
                                            builder: (context) =>
                                                KundliMatchingResultView(
                                                  maleName:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleName,
                                                  maleDate: convertDate(
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleDob),
                                                  maleTime:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleTime
                                                          .substring(0, 5),
                                                  maleCountry:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleCountry,
                                                  maleCity:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleCity,
                                                  maleLati:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleLatitude,
                                                  maleLongi:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .maleLongitude,
                                                  femaleName:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleName,
                                                  femaleDate: convertDate(
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleDob),
                                                  femaleTime:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleTime
                                                          .substring(0, 5),
                                                  femaleCountry:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleCountry,
                                                  femaleCity:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleCity,
                                                  femaleLati:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleLatitude,
                                                  femaleLongi:
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .femaleLongitude,
                                                )),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${kundaliMilanSaveModelList[index].maleName} & ${kundaliMilanSaveModelList[index].femaleName}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(
                                            width: 220,
                                            child: Text(
                                                "${convertDate(kundaliMilanSaveModelList[index].maleDob)} , ${convertTimeToAmPm(kundaliMilanSaveModelList[index].maleTime)} ${kundaliMilanSaveModelList[index].maleCity},${kundaliMilanSaveModelList[index].maleCountry}")),
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
                                                  deleteKundliMilan(
                                                      kundaliMilanSaveModelList[
                                                              index]
                                                          .id);
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
                                      )),
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
            "Kundli Matching",
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
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade100, width: 3)),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.white,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontSize: hT * 0.022, fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(
                        6.0) // Set the background color of the indicator
                    ),
                tabs: const [
                  Tab(
                    child: Center(child: Text("New Matching")),
                  ),
                  Tab(
                    child: Center(child: Text("Open Kundli")),
                  ),
                ],
              ),
            ),
            //TAbViewz
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
