import 'package:flutter/material.dart';
import 'package:mahakal/features/Tickit_Booking/view/tickit_booking_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;
  int selectedCategory = 0; // 0 = All, 1 = Ropeway, 2 = Boat

  final List<BookingItem> bookingItems = [
    BookingItem(
      city: 'Dewas',
      attractionName: 'City Sky Ropeway',
      type: 'Ropeway',
      price: 299,
      peopleCount: 2,
      image: 'https://d26dp53kz39178.cloudfront.net/media/uploads/products/Ropeway-4_result-1658399948632.webp',
      description: 'Panoramic city views from 500ft height',
      rating: 4.8,
      duration: '15 min',
      featured: true,
    ),
    BookingItem(
      city: 'Dewas',
      attractionName: 'River Cruise Boat',
      type: 'Boat',
      price: 199,
      peopleCount: 4,
      image: 'https://www.huntsmarine.com.au/cdn/shop/articles/Quintrex_Trident_2048x2048.jpg?v=1756870720',
      description: 'Leisurely cruise through scenic waterways',
      rating: 4.6,
      duration: '30 min',
      featured: false,
    ),
    BookingItem(
      city: 'Dewas',
      attractionName: 'Mountain Peak Ropeway',
      type: 'Ropeway',
      price: 399,
      peopleCount: 2,
      image: 'https://d26dp53kz39178.cloudfront.net/media/uploads/products/Ropeway-4_result-1658399948632.webp',
      description: 'Breathtaking mountain summit experience',
      rating: 4.9,
      duration: '25 min',
      featured: true,
    ),
    BookingItem(
      city: 'Dewas',
      attractionName: 'Sunset Sail Tour',
      type: 'Boat',
      price: 349,
      peopleCount: 6,
      image: 'https://www.huntsmarine.com.au/cdn/shop/articles/Quintrex_Trident_2048x2048.jpg?v=1756870720',
      description: 'Magical sunset viewing experience',
      rating: 4.7,
      duration: '45 min',
      featured: false,
    ),
    BookingItem(
      city: 'Dewas',
      attractionName: 'Extreme Adventure Ropeway',
      type: 'Ropeway',
      price: 449,
      peopleCount: 3,
      image: 'https://d26dp53kz39178.cloudfront.net/media/uploads/products/Ropeway-4_result-1658399948632.webp',
      description: 'High-speed thrilling ropeway adventure',
      rating: 4.9,
      duration: '20 min',
      featured: true,
    ),
    BookingItem(
      city: 'Dewas',
      attractionName: 'Luxury Yacht Experience',
      type: 'Boat',
      price: 599,
      peopleCount: 8,
      image: 'https://www.huntsmarine.com.au/cdn/shop/articles/Quintrex_Trident_2048x2048.jpg?v=1756870720',
      description: 'Premium yacht with full amenities',
      rating: 4.8,
      duration: '60 min',
      featured: true,
    ),
  ];

  List<BookingItem> get filteredItems {
    if (selectedCategory == 0) return bookingItems;
    if (selectedCategory == 1) {
      return bookingItems.where((item) => item.type == 'Ropeway').toList();
    }
    return bookingItems.where((item) => item.type == 'Boat').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tickit Booking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Adventure Booking',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          // Container(
          //   margin: const EdgeInsets.only(right: 8),
          //   child: IconButton(
          //     icon: Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(0.1),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: const Icon(Icons.search, size: 24),
          //     ),
          //     onPressed: () {},
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isGridView ? Icons.list : Icons.grid_view,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  isGridView = !isGridView;
                });
              },
            ),
          ),
          SizedBox(width: 12,)
        ],
        elevation: 0,
        backgroundColor: Colors.amber,
      ),
      body: CustomScrollView(
        slivers: [

          // Explore by Category Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.amber, Colors.amberAccent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Explore by Category',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final categories = [
                          _buildCategoryItem(Icons.explore_outlined, 'All', const Color(0xFF4361EE)),
                          _buildCategoryItem(Icons.landscape_outlined, 'Adventure', const Color(0xFFF72585)),
                          _buildCategoryItem(Icons.beach_access_outlined, 'Beach', const Color(0xFF4CC9F0)),
                          _buildCategoryItem(Icons.location_city_outlined, 'City', const Color(0xFF7209B7)),
                          _buildCategoryItem(Icons.restaurant_outlined, 'Food', const Color(0xFFF8961E)),
                          _buildCategoryItem(Icons.hotel_outlined, 'Hotels', const Color(0xFF06D6A0)),
                          _buildCategoryItem(Icons.terrain_outlined, 'Mountain', const Color(0xFF38B000)),
                        ];
                        return categories[index];
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Category Filter Header
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 65,
              maxHeight: 65,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryChip('All', 0, Icons.explore, const Color(0xFF4361EE)),
                          const SizedBox(width: 10),
                          _buildCategoryChip('Ropeway', 1, Icons.cable, const Color(0xFF4CC9F0)),
                          const SizedBox(width: 10),
                          _buildCategoryChip('Boat', 2, Icons.sailing, const Color(0xFF06D6A0)),
                          const SizedBox(width: 10),
                          _buildCategoryChip('Mountain', 3, Icons.terrain, const Color(0xFF38B000)),
                          const SizedBox(width: 10),
                          _buildCategoryChip('Beach', 4, Icons.beach_access, const Color(0xFFF72585)),
                          const SizedBox(width: 10),
                          _buildCategoryChip('City', 5, Icons.location_city, const Color(0xFF7209B7)),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Grid/List
          isGridView ? _buildSliverGridView() : _buildSliverListView(),

          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 50)
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper method for compact design
  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Update selection logic here
        });
      },
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ]
                    : [],
              ),
              child: Icon(
                icon,
                size: 30,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, int index, IconData icon, Color color) {
    bool isSelected = selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: isSelected ? color : color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return _buildListItem(filteredItems[index]);
        },
        childCount: filteredItems.length,
      ),
    );
  }

  Widget _buildSliverGridView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: _buildGridItem(filteredItems[index]),
          );
        },
        childCount: filteredItems.length,
      ),
    );
  }

  Widget _buildGridItem(BookingItem item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with Featured Badge
            Stack(
              children: [
                Container(
                  height: 115,
                  width: double.infinity,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          item.type == 'Ropeway'
                              ? Icons.cable
                              : Icons.directions_boat,
                          size: 60,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.type == 'Ropeway'
                              ? const Color(0xFFE8F4FD)
                              : const Color(0xFFE8F7F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: item.type == 'Ropeway'
                                ? Colors.black
                                : Colors.green,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.rating}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Attraction Name
                    Text(
                      item.attractionName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // City
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.city,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price and Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Starting from',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF888888),
                              ),
                            ),
                            Text(
                              '₹${item.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.amber],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                //_showBookingDialog(item);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 8,
                                ),
                                child: const Text(
                                  'Book',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildListItem(BookingItem item) {
    // Define colors based on item type
    Color getTypeColor() {
      switch (item.type.toLowerCase()) {
        case 'ropeway':
          return const Color(0xFF4361EE);
        case 'boat':
          return const Color(0xFF4CC9F0);
        case 'mountain':
          return const Color(0xFF38B000);
        case 'beach':
          return const Color(0xFFF72585);
        default:
          return const Color(0xFF7209B7);
      }
    }

    final typeColor = getTypeColor();

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column with Image and Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with border and shadow
                Container(
                  width: 150,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: typeColor,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${item.price}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '/person',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 18),

            // Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge with icon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: typeColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.type == 'Ropeway'
                              ? Icons.cable
                              : item.type == 'Boat'
                              ? Icons.sailing
                              : Icons.terrain,
                          size: 14,
                          color: typeColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: typeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    item.attractionName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 12),

                  // Book Now Button - FIXED VERSION
                  Material(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketDetailsPage(
                              attractionName: item.attractionName,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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

}

class BookingItem {
  final String city;
  final String attractionName;
  final String type;
  final int price;
  final int peopleCount;
  final String image;
  final String description;
  final double rating;
  final String duration;
  final bool featured;

  BookingItem({
    required this.city,
    required this.attractionName,
    required this.type,
    required this.price,
    required this.peopleCount,
    required this.image,
    required this.description,
    required this.rating,
    required this.duration,
    required this.featured,
  });
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}