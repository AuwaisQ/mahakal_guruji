
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../profile/controllers/profile_contrroller.dart';

class BookingConfirmationPage extends StatefulWidget {
  final String type;
  const BookingConfirmationPage({super.key, required this.type});

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentOption = 'pay-now'; // 'pay-now', 'pay-25', 'pay-100', 'pay-0'

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();


  // Trip details
  final TripDetails _tripDetails = TripDetails(
    fromLocation: 'Ahmedabad',
    toLocation: 'Mysore',
    tripType: 'Oneway',
    carType: 'Wagon R or Equivalent',
    pickupDate: DateTime(2026, 1, 16, 7, 0),
    includedKms: 1558,
    perKmRate: 19,
    totalFare: 23608,
    isDieselGuarantee: true,
    isPopular: true,
  );

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _nameController.text =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    _emailController.text =
        Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    _mobileController.text =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF7A18),
                Color(0xFFFF5722),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
          ),
        ),
        title: const Text('Booking Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Summary Card
              _buildTripSummaryCard(),

              const SizedBox(height: 20),

              // Contact & Pickup Details
              _buildContactDetailsForm(),

              const SizedBox(height: 20),

              // Diesel Guarantee & Popular Tag
              _buildDieselGuaranteeCard(),

              const SizedBox(height: 20),

              // Inclusions/Exclusions
              _buildInclusionsExclusionsCard(),

              const SizedBox(height: 20),

              // Payment Options
              _buildPaymentOptionsCard(),

              const SizedBox(height: 20),

              // Pay Now Button
              _buildPayNowButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route
          Text(
            '${_tripDetails.fromLocation} → ${_tripDetails.toLocation} (${_tripDetails.tripType})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Car Type
          Row(
            children: [
              Icon(Icons.directions_car, color: Colors.deepOrange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Car Type: ${_tripDetails.carType}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Pickup Date & Time
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.deepOrange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Pickup Date: ${_formatDateTime(_tripDetails.pickupDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Included KMs
          Row(
            children: [
              Icon(Icons.speed, color: Colors.deepOrange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Kms included: ${_tripDetails.includedKms} kms',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Free Cancellation Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[100]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: Colors.green[700], size: 16),
                const SizedBox(width: 6),
                Text(
                  'Free cancellation till 1 hr of departure',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Contact & Pickup Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),

          const SizedBox(height: 6),

          // Soft divider
          Container(
            height: 2,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 20),

          Form(
            key: _formKey,
            child: Column(
              children: [
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.deepOrange.shade400,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: Colors.deepOrange.shade400, width: 1.4),
                    ),
                  ),
                  validator: (_) {
                    if (_nameController.text.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Mobile Row
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle:
                    TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.deepOrange.shade400,
                    ),
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: Colors.deepOrange.shade400,
                          width: 1.4),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (_) {
                    if (_mobileController.text.trim().isEmpty) {
                      return 'Mobile number is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.deepOrange.shade400,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: Colors.deepOrange.shade400, width: 1.4),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (_) {
                    if (_emailController.text.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                //aadhar
                if(widget.type == 'self')
                TextFormField(
                  controller: _aadhaarController,
                  decoration: InputDecoration(
                    labelText: 'Aadhaar Number',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.deepOrange.shade400,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                      BorderSide(color: Colors.deepOrange.shade400, width: 1.4),
                    ),
                  ),
                  validator: (_) {
                    if (_aadhaarController.text.trim().isEmpty) {
                      return 'Aadhaar is required';
                    }
                    return null;
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDieselGuaranteeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.tune, color: Colors.blue.shade600, size: 18),
              const SizedBox(width: 6),
              Text(
                'Personalize Your Journey',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            'Enhance your travel experience with our premium add-ons',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 14),

          // Diesel Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                // Checkbox
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue),
                    color: _tripDetails.isDieselGuarantee ? Colors.blue : Colors.transparent,
                  ),
                  child: Icon(Icons.check,color: Colors.white,size: 16,),
                ),

                const SizedBox(width: 12),

                // Title + badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diesel Car Guarantee',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),

                // Price
                const Text(
                  '₹1.1/km',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Inclusions
          const Text(
            'Inclusions / Exclusions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInclusionsExclusionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inclusions
          const Text(
            'Inclusions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Column(
            children: [
              _buildInclusionItem('Base Fare and Fuel Charges'),
              _buildInclusionItem('Driver Allowance'),
              _buildInclusionItem('GST (5%)'),
              _buildInclusionItem('State Tax & Toll'),
              _buildInclusionItem('1 bags'),
              _buildInclusionItem('AC'),
            ],
          ),

          const SizedBox(height: 16),

          // Divider
          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 16),

          // Exclusions
          const Text(
            'Exclusions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.close, color: Colors.red[400], size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Beyond package km charged at ₹${_tripDetails.perKmRate}/km after ${_tripDetails.includedKms} km',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Divider
          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 16),

          // Total Fare
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Fare',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '₹${_formatCurrency(_tripDetails.totalFare)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Payment Options Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
            children: [
              _buildPaymentOption(
                'Book at ₹0',
                'pay-0',
                Icons.credit_card,
                Colors.deepOrange,
              ),
              _buildPaymentOption(
                'Pay 25%',
                'pay-25',
                Icons.payment,
                Colors.green,
                amount: _tripDetails.totalFare * 0.25,
              ),
              _buildPaymentOption(
                'Pay 100%',
                'pay-100',
                Icons.account_balance_wallet,
                Colors.purple,
                amount: _tripDetails.totalFare.toDouble(),
              ),
              _buildPaymentOption(
                'PAY NOW',
                'pay-now',
                Icons.flash_on,
                Colors.orange,
                amount: _tripDetails.totalFare.toDouble(),
                isPrimary: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Selected Payment Amount
          if (_selectedPaymentOption.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _getPaymentOptionColor(_selectedPaymentOption).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: _getPaymentOptionColor(_selectedPaymentOption),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getPaymentAmountText(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getPaymentOptionColor(_selectedPaymentOption),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      String title,
      String value,
      IconData icon,
      Color color, {
        double? amount,
        bool isPrimary = false,
      }) {
    final isSelected = _selectedPaymentOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentOption = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey[600], size: 18),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
                if (amount != null)
                  Text(
                    '₹${_formatCurrency(amount.toInt())}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? color.withOpacity(0.8) : Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'CONFIRM & PROCEED TO PAYMENT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInclusionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green[500], size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day;
    String daySuffix;

    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    final month = _getMonthName(dateTime.month);
    final year = dateTime.year;
    final time = DateFormat('h:mm a').format(dateTime);

    return '${day}$daySuffix $month $year, $time';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000) {
      final inThousands = amount / 1000;
      return '${inThousands.toStringAsFixed(inThousands.truncateToDouble() == inThousands ? 0 : 1)}k';
    }
    return amount.toString();
  }

  String _getPaymentAmountText() {
    switch (_selectedPaymentOption) {
      case 'pay-0':
        return 'Pay Later: ₹${_formatCurrency(_tripDetails.totalFare)}';
      case 'pay-25':
        return 'Pay Now: ₹${_formatCurrency((_tripDetails.totalFare * 0.25).toInt())}';
      case 'pay-100':
        return 'Pay Now: ₹${_formatCurrency(_tripDetails.totalFare)}';
      case 'pay-now':
        return 'PAY NOW: ₹${_formatCurrency(_tripDetails.totalFare)}';
      default:
        return 'Select Payment Option';
    }
  }

  Color _getPaymentOptionColor(String option) {
    switch (option) {
      case 'pay-0':
        return Colors.deepOrange;
      case 'pay-25':
        return Colors.green;
      case 'pay-100':
        return Colors.purple;
      case 'pay-now':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Confirmed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dear $_nameController,', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Your booking for ${_tripDetails.carType} has been confirmed.'),
              const SizedBox(height: 8),
              Text('Mobile: $_mobileController'),
              const SizedBox(height: 8),
              Text('Email: $_emailController'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Booking Reference: ABC${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class TripDetails {
  final String fromLocation;
  final String toLocation;
  final String tripType;
  final String carType;
  final DateTime pickupDate;
  final int includedKms;
  final int perKmRate;
  final int totalFare;
  final bool isDieselGuarantee;
  final bool isPopular;

  TripDetails({
    required this.fromLocation,
    required this.toLocation,
    required this.tripType,
    required this.carType,
    required this.pickupDate,
    required this.includedKms,
    required this.perKmRate,
    required this.totalFare,
    required this.isDieselGuarantee,
    required this.isPopular,
  });
}