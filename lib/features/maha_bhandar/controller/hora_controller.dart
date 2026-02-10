import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import '../model/city_model.dart';
import '../model/hora_model.dart';

class HoraController extends ChangeNotifier {
  bool isToday = true;
  bool showDayNight = true;
  bool gridList = true;
  bool gridListTomorrow = true;
  bool dayNight = true;
  bool searchbox = false;
  bool dateIncremented = false;
  String latitude = "23.179300";
  String longitude = "75.784912";
  String countryDefault = "Ujjain/Madhya Pradesh";

  Timer? timer;

  final TextEditingController countryController = TextEditingController();
  List<CityPickerModel> cityListModel = <CityPickerModel>[];
  List<AllData> dayModelList = <AllData>[];
  List<AllData> nightModelList = <AllData>[];
  // List<AllData> horaModelList = <AllData>[];
  List<dynamic> todayHora = [];
  List<dynamic> tomorrowHora = [];

  final Country selectedCountry = Country(
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

  void goToNextDate() {
    if (!dateIncremented) {
      now = now.add(const Duration(days: 1));
      dateIncremented = true;
      notifyListeners();
    }
  }

  void goToCurrentDate() {
    now = DateTime.now();
    dateIncremented = false;
    notifyListeners();
  }

  DateTime now = DateTime.now();
}
