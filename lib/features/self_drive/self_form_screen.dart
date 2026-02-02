import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/features/self_drive/self_car_screen.dart';

class TripBookingPage extends StatefulWidget {
  const TripBookingPage({super.key});

  @override
  State<TripBookingPage> createState() => _TripBookingPageState();
}

class _TripBookingPageState extends State<TripBookingPage> {
  // Form variables

  String _selectedHour = '4';
  String _tripType = 'one-way'; // 'one-way' or 'two-way or 'local' or 'self'
  String _fromLocation = '';
  String _toLocation = '';
  String? _returnLocation;
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  DateTime? _returnDate;
  TimeOfDay? _returnTime;



  String name = '';
  String phone = '';
  String aadhaar = '';
  String license = '';

  // Sample location suggestions
  final List<String> _locationSuggestions = [
    'New York City, NY',
    'Los Angeles, CA',
    'Chicago, IL',
    'Houston, TX',
    'Phoenix, AZ',
    'Philadelphia, PA',
    'San Antonio, TX',
    'San Diego, CA',
    'Dallas, TX',
    'San Jose, CA',
    'Austin, TX',
    'Jacksonville, FL',
    'Fort Worth, TX',
    'Columbus, OH',
    'San Francisco, CA',
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _fabTab(
                icon: Icons.trending_flat,
                label: 'One Way',
                type: 'one-way'
            ),
            _fabTab(
                icon: Icons.swap_horiz,
                label: 'Round Way',
                type: 'two-way'
            ),
            _fabTab(
                icon: Icons.location_city,
                label: 'Local',
                type: 'local'
            ),
            _fabTab(
                icon: Icons.directions_car,
                label: 'Self',
                type: 'self'
            ),
          ],
        ),
      ),

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
        title: Text(
          _tripType == 'self' ? 'Self Driving' : _tripType == 'local' ? 'Local Booking' : 'Trip Booking',
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
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 140),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade100,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip type selector
              if (_tripType == 'one-way' || _tripType == 'two-way')...[
                const SizedBox(height: 10),
                _buildTripTypeSelector(),
                // Main form
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // From location
                      _buildLocationField(
                        label: 'From Location',
                        icon: Icons.location_on_outlined,
                        value: _fromLocation,
                        onChanged: (value) {
                          setState(() {
                            _fromLocation = value;
                          });
                        },
                        onSaved: (value) {
                          _fromLocation = value ?? '';
                        },
                      ),


                      // To location
                      const SizedBox(height: 20),
                      _buildLocationField(
                        label: 'To Location',
                        icon: Icons.location_on,
                        value: _toLocation,
                        onChanged: (value) {
                          setState(() {
                            _toLocation = value;
                          });
                        },
                        onSaved: (value) {
                          _toLocation = value ?? '';
                        },
                      ),


                      // Return location (only for two-way)
                      const SizedBox(height: 20),
                      if (_tripType == 'two-way')
                        _buildLocationField(
                          label: 'Return Location',
                          icon: Icons.location_on_outlined,
                          value: _returnLocation ?? '',
                          onChanged: (value) {
                            setState(() {
                              _returnLocation = value;
                            });
                          },
                          onSaved: (value) {
                            _returnLocation = value ?? '';
                          },
                          optional: true,
                        ),


                      // Date and time pickers in a row
                      if (_tripType == 'two-way') const SizedBox(height: 20),
                      Row(
                        children: [
                          // Pickup date
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Pickup Date',
                              value: _pickupDate,
                              onPressed: () => _selectDate(context, isPickup: true),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Pickup time
                          Expanded(
                            child: _buildTimePicker(
                              label: 'Pickup Time',
                              value: _pickupTime,
                              onPressed: () => _selectTime(context, isPickup: true),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Return date and time (only for two-way)
                      if (_tripType == 'two-way')
                        Row(
                          children: [
                            // Return date
                            Expanded(
                              child: _buildDatePicker(
                                label: 'Return Date',
                                value: _returnDate,
                                onPressed: () => _selectDate(context, isPickup: false),
                              ),
                            ),

                            const SizedBox(width: 15),

                            // Return time
                            Expanded(
                              child: _buildTimePicker(
                                label: 'Return Time',
                                value: _returnTime,
                                onPressed: () => _selectTime(context, isPickup: false),
                              ),
                            ),
                          ],
                        ),

                      if (_tripType == 'two-way') const SizedBox(height: 30),

                      // Submit button
                      _buildSubmitButton(),
                    ],
                  ),
                )
              ],

              if(_tripType == 'local')
                _buildLocalTripForm(context),

              if(_tripType == 'self')
                _buildSelfDrivingForm()
            ],
          ),
        ),
      ),
    );
  }

  Widget _fabTab({
    required IconData icon,
    required String label,
    required String type,
  }) {
    final bool isActive = _tripType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tripType = type;
            _fromLocation = '';
            _toLocation = '';
             _returnLocation = null;
             _pickupDate = null;
             _pickupTime = null;
             _returnDate = null;
             _returnTime = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.deepOrange.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with scale animation
              AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: Icon(
                  icon,
                  size: 24,
                  color: isActive
                      ? Colors.deepOrange
                      : Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 6),

              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.deepOrange
                      : Colors.grey.shade700,
                ),
                child: Text(label),
              ),

              const SizedBox(height: 6),

              // Bottom indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                height: 3,
                width: isActive ? 24 : 0,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSelfDrivingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pickup Location
        _buildLocationField(
          label: 'Pickup Location',
          icon: Icons.my_location_rounded,
          value: _toLocation,
          onChanged: (val) {
            setState(() {
              _toLocation = val;
            });
          },
          onSaved: (val) => _toLocation = val ?? '',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                label: 'Pickup Date',
                value: _pickupDate,
                onPressed: () => _selectDate(context, isPickup: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimePicker(
                label: 'Pickup Time',
                value: _pickupTime,
                onPressed: () => _selectTime(context, isPickup: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                label: 'Return Date',
                value: _returnDate,
                onPressed: () => _selectDate(context, isPickup: false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimePicker(
                label: 'Return Time',
                value: _returnTime,
                onPressed: () => _selectTime(context, isPickup: false),
              ),
            ),
          ],
        ),


        SizedBox(height: 20,),
        _buildSubmitButton(),
      ],
    );
  }



  // Trip type selector (One-way / Two-way)
  Widget _buildTripTypeSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          /// Sliding background
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _tripType == 'one-way'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFE844F), Color(0xFFFEC300)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          /// Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _switchOption(
                  type: 'one-way',
                  label: 'One Way',
                  icon: Icons.arrow_forward,
                ),
              ),
              Expanded(
                child: _switchOption(
                  type: 'two-way',
                  label: 'Round Trip',
                  icon: Icons.compare_arrows,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _switchOption({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _tripType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tripType = type;
        });
      },
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _hourTab(String label) {
    final bool isActive = _selectedHour == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedHour = label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
              colors: [
                Color(0xFFFE844F),
                Color(0xFFFEC300),
              ],
            )
                : null,
            color: isActive ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: Colors.orange.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLocalTripForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              _hourTab('4 HRS | 40KM'),
              const SizedBox(width: 6),
              _hourTab('8 HRS | 80KM'),
              const SizedBox(width: 6),
              _hourTab('12 HRS | 120KM'),
            ],
          ),
          const SizedBox(height: 20),

          // From Location
          // Pickup Location
          _buildLocationField(
            label: 'Pickup Location',
            icon: Icons.my_location_rounded,
            value: _toLocation,
            onChanged: (val) {
              setState(() {
                _toLocation = val;
              });
            },
            onSaved: (val) => _toLocation = val ?? '',
          ),

          const SizedBox(height: 16),

          // Date & Time Row
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  label: 'Pickup Date',
                  value: _pickupDate,
                  onPressed: ()=> _selectDate(context, isPickup: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePicker(
                  label: 'Pickup Time',
                  value: _pickupTime,
                  onPressed: ()=> _selectTime(context, isPickup: true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Optional Drop Location
          // _buildLocationField(
          //   label: 'Drop Location',
          //   icon: Icons.location_on_outlined,
          //   value: _dropLocation,
          //   optional: true,
          //   onChanged: (val) {
          //     setState(() {
          //       _dropLocation = val;
          //     });
          //   },
          //   onSaved: (val) => _dropLocation = val ?? '',
          // ),

          const SizedBox(height: 28),

          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }


  // Location input field with autocomplete suggestions
  Widget _buildLocationField({
    required String label,
    required IconData icon,
    required String value,
    required Function(String?) onSaved,
    required Function(String) onChanged,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          '$label${optional ? ' (Optional)' : ''}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),

        /// Field Container (Soft Card)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _locationSuggestions.where((option) =>
                  option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ));
            },
            onSelected: (selection) => onChanged(selection),

            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              textEditingController.text = value;

              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: onChanged,
                onSaved: onSaved,
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                  hintText: 'Enter $label',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: Colors.deepOrange,
                    size: 20,
                  ),

                  /// Soft borders
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 1.5,
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 14,
                  ),
                ),
                validator: (value) {
                  if (!optional && (value == null || value.isEmpty)) {
                    return 'Please enter $label';
                  }
                  return null;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Date picker widget
  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),

        /// Date Picker Field
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                /// Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.deepOrange,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                /// Date Text
                Expanded(
                  child: Text(
                    value != null
                        ? DateFormat('dd-MM-yy').format(value!)
                        : 'Select Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      value != null ? FontWeight.w600 : FontWeight.w400,
                      color:
                      value != null ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                ),

                /// Arrow
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Time picker widget
  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? value,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),

        /// Time Picker Field
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                /// Icon background
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.deepOrange,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                /// Time Text
                Expanded(
                  child: Text(
                    value != null
                        ? value!.format(context)
                        : 'Select Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      value != null ? FontWeight.w600 : FontWeight.w400,
                      color:
                      value != null ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                ),

                /// Arrow
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => CarSelectionPage(type: _tripType,),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF7A18), // warm orange
                Color(0xFFFF5722), // deep orange
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Book Trip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Trip summary card
  Widget _buildTripSummary() {
    if (_fromLocation.isEmpty && _toLocation.isEmpty && _pickupDate == null) {
      return const SizedBox();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF7A18),
                    Color(0xFFFF5722),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: const Text(
                'Trip Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            /// Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _summaryRow(
                    icon: Icons.trip_origin,
                    iconColor: Colors.grey,
                    text:
                    _tripType == 'one-way' ? 'One-Way Trip' : 'Two-Way Trip',
                    bold: true,
                  ),

                  const SizedBox(height: 14),

                  _summaryRow(
                    icon: Icons.arrow_upward,
                    iconColor: Colors.green,
                    text: _fromLocation.isNotEmpty
                        ? _fromLocation
                        : 'From location not specified',
                    muted: _fromLocation.isEmpty,
                  ),

                  const SizedBox(height: 8),

                  _summaryRow(
                    icon: Icons.arrow_downward,
                    iconColor: Colors.red,
                    text: _toLocation.isNotEmpty
                        ? _toLocation
                        : 'To location not specified',
                    muted: _toLocation.isEmpty,
                  ),

                  if (_tripType == 'two-way' &&
                      _returnLocation != null &&
                      _returnLocation!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _summaryRow(
                      icon: Icons.compare_arrows,
                      iconColor: Colors.orange,
                      text: 'Return to $_returnLocation',
                    ),
                  ],

                  const SizedBox(height: 14),
                  const Divider(),

                  const SizedBox(height: 10),

                  _summaryRow(
                    icon: Icons.date_range,
                    iconColor: Colors.blueGrey,
                    text: _pickupDate != null
                        ? DateFormat('MMM dd, yyyy').format(_pickupDate!)
                        : 'Pickup date not set',
                    trailing: _pickupTime != null
                        ? 'at ${_pickupTime!.format(context)}'
                        : null,
                    muted: _pickupDate == null,
                  ),

                  if (_tripType == 'two-way' &&
                      (_returnDate != null || _returnTime != null)) ...[
                    const SizedBox(height: 8),
                    _summaryRow(
                      icon: Icons.keyboard_return,
                      iconColor: Colors.deepOrange,
                      text: _returnDate != null
                          ? 'Return: ${DateFormat('MMM dd, yyyy').format(_returnDate!)}'
                          : 'Return date not set',
                      trailing: _returnTime != null
                          ? 'at ${_returnTime!.format(context)}'
                          : null,
                      muted: _returnDate == null,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _summaryRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    String? trailing,
    bool bold = false,
    bool muted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: muted ? Colors.grey : Colors.black87,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              ),
              children: [
                TextSpan(text: text),
                if (trailing != null)
                  TextSpan(
                    text: ' $trailing',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  // Date selection method
  Future<void> _selectDate(BuildContext context, {required bool isPickup}) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 1));
    final DateTime lastDate = DateTime(now.year + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickup ? (_pickupDate ?? now) : (_returnDate ?? now.add(const Duration(days: 1))),
      firstDate: isPickup ? now : (_pickupDate ?? now),
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  // Time selection method
  Future<void> _selectTime(BuildContext context, {required bool isPickup}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isPickup
          ? (_pickupTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_returnTime ?? const TimeOfDay(hour: 17, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = picked;
        } else {
          _returnTime = picked;
        }
      });
    }
  }

}

