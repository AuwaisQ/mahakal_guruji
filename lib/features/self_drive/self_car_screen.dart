import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/features/self_drive/self_payment_screen.dart';

class CarSelectionPage extends StatefulWidget {
  final String type;
  const CarSelectionPage({super.key, required this.type});

  @override
  State<CarSelectionPage> createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  int _selectedCarIndex = 0;
  final List<Car> _cars = [
    Car(
      name: 'Hatchback',
      price: 20130,
      originalPrice: 22178,
      discount: 9,
      type: '4 seater AC Cab',
      rating: 4.6,
      image: '🚗',
      includedKms: 1558,
      perKmRate: 19,
      features: ['AC', '4 Seats', '5 Bags', 'Fuel Included'],
      color: Colors.deepOrange[50]!,
    ),
    Car(
      name: 'Sedan',
      price: 20548,
      originalPrice: 23000,
      discount: 11,
      type: '4 seater Luxury',
      rating: 4.8,
      image: '🚙',
      includedKms: 1558,
      perKmRate: 20,
      features: ['AC', '4 Seats', '5 Bags', 'Fuel Included', 'Premium Interior'],
      color: Colors.green[50]!,
    ),
    Car(
      name: 'Ertiga',
      price: 26511,
      originalPrice: 29500,
      discount: 10,
      type: '7 seater AC Cab',
      rating: 4.7,
      image: '🚐',
      includedKms: 1558,
      perKmRate: 22,
      features: ['AC', '7 Seats', '8 Bags', 'Fuel Included', 'Spacious'],
      color: Colors.orange[50]!,
    ),
    Car(
      name: 'Wagon R',
      price: 18500,
      originalPrice: 20500,
      discount: 10,
      type: '4 seater AC Cab',
      rating: 4.5,
      image: '🚙',
      includedKms: 1400,
      perKmRate: 18,
      features: ['AC', '4 Seats', '3 Bags', 'Fuel Included', 'Economical'],
      color: Colors.purple[50]!,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCar = _cars[_selectedCarIndex];
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

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
        title: const Text('Select Your Car',
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
        bottom:  PreferredSize(preferredSize: const Size.fromHeight(150),
           child: Container(
             height: 140, // ⬅️ thoda chhota
             margin: EdgeInsets.only(bottom: 10,top: 10),
             padding: const EdgeInsets.symmetric(horizontal: 12),
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: _cars.length,
               itemBuilder: (context, index) {
                 final car = _cars[index];
                 final bool isSelected = index == _selectedCarIndex;

                 return GestureDetector(
                   onTap: () {
                     setState(() {
                       _selectedCarIndex = index;
                     });
                   },
                   child: AnimatedContainer(
                     duration: const Duration(milliseconds: 250),
                     curve: Curves.easeOut,
                     width: 120, // ⬅️ chhota width
                     margin: const EdgeInsets.only(right:8),
                     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                     decoration: BoxDecoration(
                       color: isSelected
                           ? Colors.white
                           : Colors.grey[300],
                       borderRadius: BorderRadius.circular(14),
                       border: Border.all(
                         color: isSelected
                             ? Colors.white
                             : Colors.deepOrange,
                         width: isSelected ? 2.5 : 1,
                       ),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         // Car emoji / image
                         Text(
                           car.image,
                           style: const TextStyle(fontSize: 34), // ⬅️ smaller
                         ),

                         // Name
                         Text(
                           car.name,
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             fontWeight: FontWeight.w600,
                             fontSize: 14,
                             color: isSelected
                                 ? Colors.deepOrange
                                 : Colors.black87,
                           ),
                         ),

                         // Price
                         Text(
                           currencyFormat.format(car.price),
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 15,
                             color: Colors.green[700],
                           ),
                         ),

                         // Selected indicator (NEW DESIGN)
                         AnimatedContainer(
                           duration: const Duration(milliseconds: 200),
                           height: 4,
                           width: isSelected ? 32 : 0,
                           decoration: BoxDecoration(
                             color: Colors.deepOrange,
                             borderRadius: BorderRadius.circular(10),
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               },
             ),
           )),
      ),


      body: Column(
        children: [
          // Car selection cards


          // Selected car details
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Car details card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCar.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedCar.type,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange[400],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${selectedCar.rating} ★',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green[100]!),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${selectedCar.discount}% OFF',
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              currencyFormat.format(selectedCar.originalPrice),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              currencyFormat.format(selectedCar.price),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+ ${currencyFormat.format(1374)} Charges and Taxes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Driver allowance included',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping,
                              color: Colors.deepOrange[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${selectedCar.includedKms} kms included | Post limit: ${currencyFormat.format(selectedCar.perKmRate)}/km',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => BookingConfirmationPage(type: widget.type,),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'SELECT CAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Booking features
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFeature(
                        icon: Icons.money_off,
                        title: 'Book Now\nat Zero Cost',
                        color: Colors.green,
                      ),
                    ),
                    _divider(),
                    Expanded(
                      child: _buildFeature(
                        icon: Icons.cancel_outlined,
                        title: 'Free Cancellation\nTill 1 Hour',
                        color: Colors.deepOrange,
                      ),
                    ),
                    _divider(),
                    Expanded(
                      child: _buildFeature(
                        icon: Icons.support_agent,
                        title: '24 x 7\nCustomer Support',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab content
                  // Column(
                  //   children: [
                  //     // INCLUSIONS
                  //     _buildInclusionsTab(),
                  //     // EXCLUSIONS
                  //     _buildExclusionsTab(),
                  //     // FACILITIES
                  //     _buildFacilitiesTab(selectedCar),
                  //     // T&C
                  //     _buildTermsTab(),
                  //   ],
                  // ),

                  // Travel expert section
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepOrange[50]!,
                          Colors.purple[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepOrange.shade100),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SAY HELLO TO,',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange[800],
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'OUR TRAVEL EXPERT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Get expert advice for smarter travel plans!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          icon: const Icon(Icons.phone, size: 20),
                          label: const Text('Call Expert!'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 48,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.grey.shade300,
    );
  }


  Widget _buildFeature({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInclusionsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Base Fare and Fuel Charges'),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Driver Allowance'),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('State Tax & Toll'),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('GST (5%)'),
        ),
      ],
    );
  }

  Widget _buildExclusionsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        ListTile(
          leading: Icon(Icons.close, color: Colors.red),
          title: Text('Personal Expenses'),
        ),
        ListTile(
          leading: Icon(Icons.close, color: Colors.red),
          title: Text('Night Charges (After 10 PM)'),
        ),
        ListTile(
          leading: Icon(Icons.close, color: Colors.red),
          title: Text('Airport Parking Fees'),
        ),
        ListTile(
          leading: Icon(Icons.close, color: Colors.red),
          title: Text('Inter-state Permit Charges'),
        ),
      ],
    );
  }

  Widget _buildFacilitiesTab(Car car) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3,
      ),
      itemCount: car.features.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check, color: Colors.green[600], size: 16),
              const SizedBox(width: 8),
              Text(
                car.features[index],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTermsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        Text(
          '• Minimum booking duration: 1 day\n'
              '• Free cancellation within 1 hour of booking\n'
              '• Driver Bata as per company policy\n'
              '• Extra km charges applicable beyond included kms\n'
              '• ID proof required at the time of pickup\n'
              '• Security deposit may be applicable\n'
              '• Fuel as per reading at start and end of trip',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}

class Car {
  final String name;
  final String type;
  final double rating;
  final int price;
  final int originalPrice;
  final int discount;
  final String image;
  final int includedKms;
  final int perKmRate;
  final List<String> features;
  final Color color;

  Car({
    required this.name,
    required this.type,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.image,
    required this.includedKms,
    required this.perKmRate,
    required this.features,
    required this.color,
  });
}
