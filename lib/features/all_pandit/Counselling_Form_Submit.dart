import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../utill/app_constants.dart';
import '../../utill/completed_order_dialog.dart';
import '../profile/controllers/profile_contrroller.dart';
import 'Model/all_pandit_counsseccess.dart';
import 'location_search_widget.dart';

class CounsellingFormWidget extends StatefulWidget {
  final String orderId;

  const CounsellingFormWidget({super.key, required this.orderId});

  @override
  State<CounsellingFormWidget> createState() => _CounsellingFormWidgetState();
}

class _CounsellingFormWidgetState extends State<CounsellingFormWidget> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String? gender;
  DateTime? dob;
  TimeOfDay? birthTime;
  String? city;

  GoogleMapController? _controller;

  final List<String> genders = ["Male", "Female", "Other"];

  bool _isLoading = false;
  bool _isSubmitted = false;

  Country? _selectedCountry;
  AllPanditCounsSucess? counsSuccessUrl;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileController>(context, listen: false);
    nameController.text = profile.userNAME;
    phoneController.text = profile.userPHONE;
  }

  // ---------------- PICKERS ----------------
  Future<void> pickDOB() async {
    if (_isSubmitted) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => dob = picked);
    }
  }

  Future<void> pickTime() async {
    if (_isSubmitted) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => birthTime = picked);
    }
  }

  // ---------------- DECORATION ----------------
  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.deepOrange,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
    );
  }

  // ---------------- VALIDATION ----------------
  bool allFieldsFilled() {
    return phoneController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        gender != null &&
        dob != null &&
        birthTime != null &&
        _selectedCountry != null &&
        city != null;
  }

  // ---------------- API ----------------
  Future<void> counsellingSuccess() async {
    setState(() => _isLoading = true);

    final data = {
      "order_id": "${widget.orderId}",
      "name": "${nameController.text}",
      "gender": "${gender}",
      "mobile": "${phoneController.text}",
      "dob": "${dob.toString()}",
      "time": "${birthTime.toString()}",
      "country": "${_selectedCountry?.name}",
      "city": "${city}",
    };

    try {
      final res = await HttpService()
          .postApi(AppConstants.allPanditCounsellingSuccessUrl, data);

      counsSuccessUrl = AllPanditCounsSucess.fromJson(res);
      setState(() => _isSubmitted = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Submission failed"),
          backgroundColor: Colors.red,
        ),
      );
      print("Counselling form submission error $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ---------------- CONFIRM DIALOG ----------------
  Future<bool?> showSubmitConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.help_outline,
                    size: 50, color: Colors.deepOrange),
                const SizedBox(height: 12),
                const Text(
                  "Confirm Submission",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Once submitted, details cannot be changed.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Confirm",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- SUBMIT FLOW ----------------
  Future<void> onSubmitPressed() async {
    if (_isLoading || _isSubmitted) return;

    if (!allFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all details"),
            backgroundColor: Colors.red),
      );
      return;
    }

    final confirm = await showSubmitConfirmationDialog();

    if (confirm == true) {
      await counsellingSuccess();
      //
      // if (counsSuccessUrl != null) {
      //   showDialog(
      //     context: context,
      //     barrierDismissible: true,
      //     builder: (_) => bookingSuccessDialog(
      //       context: context,
      //       tabIndex: 11,
      //       title: 'Pooja Booked!',
      //       message:
      //       'Your pooja has been successfully booked. You will receive further details shortly.',
      //     ),
      //   );
      // }
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _isSubmitted, // back only after submit
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: _isSubmitted,
          leading: _isSubmitted
              ? IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
              : null,
          backgroundColor: Colors.deepOrange,
          title: const Text(
            "Counselling Form",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: phoneController,
                    readOnly: _isSubmitted,
                    decoration: fieldDecoration("Phone"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    readOnly: _isSubmitted,
                    decoration: fieldDecoration("Name"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: fieldDecoration("Gender"),
                    onChanged:
                    _isSubmitted ? null : (v) => setState(() => gender = v),
                    items: genders
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: pickDOB,
                    child: InputDecorator(
                      decoration: fieldDecoration("DOB"),
                      child: Text(dob == null
                          ? "Select Date"
                          : "${dob!.day}-${dob!.month}-${dob!.year}"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: pickTime,
                    child: InputDecorator(
                      decoration: fieldDecoration("Birth Time"),
                      child: Text(birthTime == null
                          ? "Select Time"
                          : birthTime!.format(context)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _isSubmitted
                        ? null
                        : () {
                      showCountryPicker(
                        context: context,
                        onSelect: (c) =>
                            setState(() => _selectedCountry = c),
                      );
                    },
                    child: InputDecorator(
                      decoration: fieldDecoration("Country"),
                      child: Text(_selectedCountry?.name ?? "Select Country"),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// CITY (LOCKED AFTER SUBMIT)
                  IgnorePointer(
                    ignoring: _isSubmitted,
                    child: Opacity(
                      opacity: _isSubmitted ? 0.6 : 1,
                      child: LocationSearchWidget(
                        mapController: _controller,
                        controller: countryController,
                        onLocationSelected: (_, __, address) {
                          setState(() => city = address);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onSubmitPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : _isSubmitted ? InkWell(onTap: (){
                            Navigator.pop(context);
                      },child: const Text("Go Back", style: TextStyle(fontSize: 18, color: Colors.white))) : const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
