import 'package:flutter/material.dart';
import 'dart:convert';

class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  // Sample JSON data
  final String venueData = '''
  {
    "venue_id": "2",
    "stage_type": "2",
    "total_rows": 8,
    "seats_per_row": 8,
    "aisle_positions": [4, 8],
    "row_start": "A",
    "rows": [
      {"id": 1, "name": "new", "type": "vip", "rowname": "A", "package_id": 7},
      {"id": 2, "name": "b", "type": "vip", "rowname": "B", "package_id": 7},
      {"id": 3, "name": "121", "type": "vip", "rowname": "C", "package_id": 7},
      {"id": 4, "name": "d1", "type": "vip", "rowname": "D", "package_id": 7},
      {"id": 5, "name": "d1", "type": "vip", "rowname": "E", "package_id": 7},
      {"id": 6, "name": "121", "type": "standard", "rowname": "F", "package_id": 9},
      {"id": 7, "name": "121", "type": "standard", "rowname": "G", "package_id": 9},
      {"id": 8, "name": "d1", "type": "accessible", "rowname": "H", "package_id": 9},
      {"id": 9, "name": "d1", "type": "accessible", "rowname": "I", "package_id": 9},
      {"id": 10, "name": "d1", "type": "accessible", "rowname": "J", "package_id": 7}
    ],
    "blocked_seats": [
      {"id": "1-4", "row": 1, "seat": 4},
      {"id": "1-6", "row": 1, "seat": 6},
      {"id": "2-3", "row": 2, "seat": 3},
      {"id": "5-7", "row": 5, "seat": 7},
      {"id": "8-2", "row": 8, "seat": 2}
    ],
    "total_seats": 120,
    "available_seats": 115
  }
  ''';

  Map<String, dynamic>? venue;
  List<Map<String, dynamic>> selectedSeats = [];
  Map<String, Color> seatTypeColors = {
    'vip': Color(0xFFFFD700),
    'standard': Color(0xFF1E88E5),
    'accessible': Color(0xFF4CAF50),
  };

  @override
  void initState() {
    super.initState();
    venue = json.decode(venueData);
  }

  @override
  Widget build(BuildContext context) {
    if (venue == null) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Select Seats',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Screen Preview
          _buildScreenPreview(),

          // Seat Legend
          _buildSeatLegend(),

          // Seat Map
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSeatMap(),
              ),
            ),
          ),

          // Bottom Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildScreenPreview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'SCREEN THIS WAY',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.grey[300]!, Colors.transparent],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF2A2A2A), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Available', Colors.white24),
          _buildLegendItem('Selected', Color(0xFF1E88E5)),
          _buildLegendItem('VIP', Color(0xFFFFD700)),
          _buildLegendItem('Booked', Colors.grey[800]!),
         // _buildLegendItem('Wheelchair', Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildSeatMap() {
    List<dynamic> rows = venue!['rows'];
    int seatsPerRow = venue!['seats_per_row'];
    List<dynamic> aislePositions = venue!['aisle_positions'];
    List<dynamic> blockedSeats = venue!['blocked_seats'];

    return Column(
      children: [
        // Row indicators on left side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row labels column
            Container(
              width: 40,
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: rows.map<Widget>((row) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      row['rowname'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Seat grid
            Expanded(
              child: Column(
                children: rows.map<Widget>((row) {
                  String rowName = row['rowname'];
                  int rowIndex = rows.indexOf(row) + 1;
                  String seatType = row['type'];

                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: List.generate(seatsPerRow, (seatIndex) {
                        int seatNumber = seatIndex + 1;
                        String seatId = '$rowIndex-$seatNumber';

                        bool isBlocked = blockedSeats.any((blocked) =>
                        blocked['row'] == rowIndex && blocked['seat'] == seatNumber);

                        bool isAisle = aislePositions.contains(seatIndex);
                        bool isSelected = selectedSeats.any((seat) => seat['id'] == seatId);

                        Color seatColor = isBlocked
                            ? Colors.grey[800]!
                            : isSelected
                            ? Color(0xFF1E88E5)
                            : seatTypeColors[seatType] ?? Colors.white24;

                        // Add aisle spacing
                        if (isAisle) {
                          return Expanded(
                            child: Row(
                              children: [
                                Expanded(child: _buildSeatWidget(seatColor, seatId, rowIndex, seatNumber, isBlocked)),
                                SizedBox(width: seatIndex == aislePositions[0] ? 24 : 12),
                              ],
                            ),
                          );
                        }

                        return Expanded(
                          child: _buildSeatWidget(seatColor, seatId, rowIndex, seatNumber, isBlocked),
                        );
                      }),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Row labels on right side
            Container(
              width: 40,
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: rows.map<Widget>((row) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      row['rowname'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        // Seat number indicators at bottom
        Container(
          margin: EdgeInsets.only(top: 20, left: 40),
          child: Row(
            children: List.generate(seatsPerRow, (index) {
              bool isAisle = aislePositions.contains(index);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isAisle ? (index == aislePositions[0] ? 24 : 12) : 0),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatWidget(Color color, String seatId, int row, int seatNumber, bool isBlocked) {
    bool isWheelchair = venue!['rows'][row-1]['type'] == 'accessible';

    return GestureDetector(
      onTap: () {
        if (!isBlocked) {
          setState(() {
            if (selectedSeats.any((s) => s['id'] == seatId)) {
              selectedSeats.removeWhere((s) => s['id'] == seatId);
            } else {
              Map<String, dynamic> rowData = venue!['rows'][row-1];
              selectedSeats.add({
                'id': seatId,
                'row': row,
                'seat': seatNumber,
                'rowname': rowData['rowname'],
                'type': rowData['type'],
                'price': _getPriceForType(rowData['type']),
              });
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(2),
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isBlocked ? Colors.transparent : color.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            if (!isBlocked && !selectedSeats.any((s) => s['id'] == seatId))
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                isWheelchair ? Icons.accessible : Icons.chair,
                size: isWheelchair ? 18 : 16,
                color: isBlocked ? Colors.grey[600] : Colors.black.withOpacity(0.7),
              ),
            ),
            if (selectedSeats.any((s) => s['id'] == seatId))
              Positioned(
                right: 4,
                top: 4,
                child: Icon(
                  Icons.check_circle,
                  size: 12,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getPriceForType(String type) {
    switch (type) {
      case 'vip': return 499.0;
      case 'standard': return 299.0;
      case 'accessible': return 249.0;
      default: return 199.0;
    }
  }

  Widget _buildBottomBar() {
    double totalPrice = selectedSeats.fold(0.0, (sum, seat) => sum + seat['price']);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: [
          // Seat details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${selectedSeats.length} Seat${selectedSeats.length != 1 ? 's' : ''} Selected',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                if (selectedSeats.isNotEmpty)
                  Text(
                    selectedSeats.map((s) => '${s['rowname']}${s['seat']}').join(', '),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Price and Proceed button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${totalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              ElevatedButton(
                onPressed: selectedSeats.isNotEmpty
                    ? () {
                  // Proceed to payment
                  print('Selected seats: $selectedSeats');
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}