import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/features/Tickit_Booking/view/tickit_selection_layout.dart';

class BookingDetailsPage extends StatefulWidget {
  final String adventureName;
  final String location;
  final int aadharRequired;

  const BookingDetailsPage({
    Key? key,
    required this.adventureName,
    required this.location,
    this.aadharRequired = 0,
  }) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  int _selectedPackageIndex = 0;
  DateTime? _selectedDate;
  String? _selectedTime;
  int _personCount = 1;
  List<Map<String, String>> _verifiedUsers = [];
  List<Map<String, String>> _nonVerifiedUsers = [];
  int _activeTab = 0; // 0 for Non-Verify, 1 for Verify

  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'General',
      'price': 1499,
      'color': Color(0xFF4A6572),
      'lightColor': Color(0xFFF5F7FA),
      'features': ['Basic Access', 'Standard Facilities'],
      'icon': Icons.emoji_events_outlined,
    },
    {
      'name': 'Silver',
      'price': 2499,
      'color': Color(0xFFC0C0C0),
      'lightColor': Color(0xFFFAFAFA),
      'features': ['Priority Access', 'Lunch Included', 'Photo Session'],
      'icon': Icons.workspace_premium_outlined,
    },
    {
      'name': 'Gold',
      'price': 3499,
      'color': Color(0xFFFFD700),
      'lightColor': Color(0xFFFFF9E6),
      'features': ['VIP Access', 'Personal Guide', 'All Meals', 'Souvenir'],
      'icon': Icons.diamond_outlined,
    },
  ];

  final List<String> _availableTimes = [
    '09:00 AM',
    '11:00 AM',
    '01:00 PM',
    '03:00 PM',
    '05:00 PM',
    '07:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 25),

            // Header with Adventure Name & Location
            _buildHeaderSection(),

            SizedBox(height: 20),

            // Change Package Section
            _buildPackageSection(),

            SizedBox(height: 30),

            // Select Date Section
            _buildDateSection(),

            SizedBox(height: 30),

            // Select Time Section
            _buildTimeSection(),

            SizedBox(height: 30),

            // Add Person Section
            _buildPersonSection(),

            SizedBox(height: 30),

            // Choose Your Seat Button
            _buildSeatSelectionButton(),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepOrange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepOrange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.landscape_rounded,
                  color: Colors.deepOrange,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.adventureName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.blue.withOpacity(0.95),
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          // Decorative accent line
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.card_giftcard, color: Color(0xFF667EEA), size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Change Package',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Package Cards
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _packages.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final package = _packages[index];
              bool isSelected = _selectedPackageIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedPackageIndex = index),
                child: Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [package['color'], package['color'].withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? package['color'] : Colors.grey.shade200,
                      width: isSelected ? 3 : 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : package['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            package['icon'],
                            color: isSelected ? package['color'] : package['color'],
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Package Name
                        Text(
                          package['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : package['color'],
                          ),
                        ),
                        SizedBox(height: 8),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white.withOpacity(0.9) : package['color'],
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${package['price']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: isSelected ? Colors.white : package['color'],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.calendar_today_rounded, color: Color(0xFF4CAF50), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Select Your Booking Date',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Date Picker
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF4CAF50),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Tap to select date'
                                : DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _selectedDate == null ? Colors.grey.shade600 : Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _selectedDate == null
                                ? 'Choose your preferred date'
                                : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade400,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Selected Date Display
          if (_selectedDate != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.2), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Selected: ${DateFormat('EEE, d MMM yyyy').format(_selectedDate!)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _selectedDate = null),
                    child: Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF667EEA),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.access_time_rounded, color: Color(0xFF2196F3), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Select Time Slot',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Time Slots
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableTimes.length,
              itemBuilder: (context, index) {
                final time = _availableTimes[index];
                bool isSelected = _selectedTime == time;

                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF2196F3) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Color(0xFF2196F3) : Colors.grey.shade200,
                        width: isSelected ? 2 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isSelected ? 0.1 : 0.03),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: isSelected ? Colors.white : Color(0xFF2196F3),
                          size: 24,
                        ),
                        SizedBox(height: 6),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.people_alt_rounded, color: Color(0xFFFF9800), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Number of Persons',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          if (widget.aadharRequired == 1) ...[
            // Aadhar Required - Add Person Button
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 5,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _showAadharBottomSheet,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Color(0xFFFF9800),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Person (Aadhar Required)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap to add persons with Aadhar verification',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_personCount Person${_personCount > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // No Aadhar Required - Counter
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Persons',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Add or remove persons',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  // Counter
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_rounded, color: Colors.grey.shade600),
                          onPressed: _personCount > 1 ? () => setState(() => _personCount--) : null,
                        ),
                        Container(
                          width: 40,
                          child: Center(
                            child: Text(
                              '$_personCount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_rounded, color: Color(0xFFFF9800)),
                          onPressed: () => setState(() => _personCount++),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeatSelectionButton() {
    return GestureDetector(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> SeatSelectionScreen()));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF667EEA).withOpacity(0.4),
              blurRadius: 25,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chair_alt_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 20),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose Your Seat',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Select your preferred seats from the interactive map',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showAadharBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AadharBottomSheet(
        onAddVerified: (user) {
          setState(() {
            _verifiedUsers.add(user);
            _personCount = _verifiedUsers.length + _nonVerifiedUsers.length + 1;
          });
        },
        onAddNonVerified: (aadhar) {
          setState(() {
            _nonVerifiedUsers.add({
              'name': 'User ${_nonVerifiedUsers.length + 1}',
              'aadhar': aadhar,
              'status': 'pending',
            });
            _personCount = _verifiedUsers.length + _nonVerifiedUsers.length + 1;
          });
        },
        verifiedUsers: _verifiedUsers,
        nonVerifiedUsers: _nonVerifiedUsers,
      ),
    );
  }

  void _selectSeats() {
    // Implement seat selection
  }
}

class AadharBottomSheet extends StatefulWidget {
  final Function(Map<String, String>) onAddVerified;
  final Function(String) onAddNonVerified;
  final List<Map<String, String>> verifiedUsers;
  final List<Map<String, String>> nonVerifiedUsers;

  const AadharBottomSheet({
    Key? key,
    required this.onAddVerified,
    required this.onAddNonVerified,
    required this.verifiedUsers,
    required this.nonVerifiedUsers,
  }) : super(key: key);

  @override
  _AadharBottomSheetState createState() => _AadharBottomSheetState();
}

class _AadharBottomSheetState extends State<AadharBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _aadharController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _aadharController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Persons',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.deepOrange,
              dividerColor: Colors.transparent,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepOrange.withOpacity(0.1),
              ),
              tabs: [
                Tab(text: 'Non-Verified'),
                Tab(text: 'Verified'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Non-Verified Tab
                _buildNonVerifiedTab(),

                // Verified Tab
                _buildVerifiedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonVerifiedTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Input Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Icon(Icons.person_add_rounded, color: Color(0xFFFF9800), size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Add New Person',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Name Input
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                SizedBox(height: 16),

                // Aadhar Input
                TextField(
                  controller: _aadharController,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  decoration: InputDecoration(
                    labelText: 'Aadhar Number',
                    prefixIcon: Icon(Icons.credit_card_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    counterText: '12-digit number',
                  ),
                ),
                SizedBox(height: 24),

                // Verify Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF9800),
                        Color(0xFFFF5722),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF9800).withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        if (_aadharController.text.length == 12 && _nameController.text.isNotEmpty) {
                          widget.onAddNonVerified(_aadharController.text);
                          _aadharController.clear();
                          _nameController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Person added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Add Person',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // List of Non-Verified Users
          if (widget.nonVerifiedUsers.isNotEmpty) ...[
            Text(
              'Pending Verification (${widget.nonVerifiedUsers.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 12),
            ...widget.nonVerifiedUsers.map((user) => _buildUserCard(user, false)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifiedTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.verifiedUsers.isEmpty) ...[
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_rounded,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Verified Users',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Verified users will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'Verified Users (${widget.verifiedUsers.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 16),
            ...widget.verifiedUsers.map((user) => _buildUserCard(user, true)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, String> user, bool isVerified) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVerified ? Color(0xFF4CAF50).withOpacity(0.05) : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVerified ? Color(0xFF4CAF50).withOpacity(0.2) : Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isVerified ? Color(0xFF4CAF50) : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isVerified ? Icons.verified_rounded : Icons.pending_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Aadhar: ${user['aadhar']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isVerified ? 'Verified' : 'Pending',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isVerified ? Color(0xFF4CAF50) : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}