import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/all_pandit/person_details.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utill/razorpay_screen.dart';
import 'Model/all_pandit_details_model.dart';
import 'Model/all_pandit_success_model.dart';

class PanditPoojaDetails extends StatefulWidget {
  final int panditId;
  final String poojaSlug;

  const PanditPoojaDetails(
      {super.key, required this.panditId, required this.poojaSlug});

  @override
  State<PanditPoojaDetails> createState() => _PanditPoojaDetailsState();
}

class _PanditPoojaDetailsState extends State<PanditPoojaDetails> {
  final razorpayService = RazorpayPaymentService();

  List<int> counts = [];
  double totalPrice = 0.0;

  int packageAmount = 0;
  int packageId = 0;
  int serviceId = 0;
  int packagePerson = 0;
  int _currentIndex = 0;
  int selectedIndex = 0;

  final double _cardWidth = 147; // card width + margin

  String packagePooja = "";

  bool isLoading = false;
  bool isProcessing = false;
  bool isExpanded = false;

  DateTime? selectedDate;

  void showPoojaBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      "Pooja ki Tithi Chune",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Date selector
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Select Date"
                                  : DateFormat('dd/MM/yyyy')
                                      .format(selectedDate!),
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedDate == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            const Icon(Icons.calendar_today,
                                color: Colors.deepOrange),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, selectedDate);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 600,
              minWidth: 400,
            ),
            child: Column(
              children: [

                /// Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Confirm Your Booking",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Please review the details before payment",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Bill Section
                        Text(
                          "Bill Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        const SizedBox(height: 14),

                        /// Orange Gradient Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade50,
                                Colors.orange.shade100.withOpacity(0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.orange.shade200, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Pooja Name
                              Text(
                                packagePooja,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.deepOrange.shade800,
                                ),
                              ),
                              const SizedBox(height: 16),

                              /// Date
                              Row(
                                children: [
                                  Icon(Icons.date_range, size: 18, color: Colors.deepOrange.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Date:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.deepOrange.shade900,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    (selectedDate == null || selectedDate.toString().trim().isEmpty)
                                        ? "Please select date"
                                        : DateFormat("dd MMM yyyy").format(DateTime.parse("$selectedDate")),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: (selectedDate == null)
                                          ? Colors.red.shade700
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              /// Person Count
                              Row(
                                children: [
                                  Icon(Icons.person, size: 18, color: Colors.deepOrange.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Qty:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.deepOrange.shade900,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "$packagePerson Persons",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              /// Package Amount
                              Row(
                                children: [
                                  Text(
                                    "Package Amount:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.deepOrange.shade900,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹${NumberFormat('#,##0').format(packageAmount ?? 0)}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// Items List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedItems.length,
                          itemBuilder: (context, index) {
                            final item = selectedItems[index];
                            final totalPay = item['qty'] * (item['price'] ?? 0);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item["title"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    "${item['qty']} × ₹${item['price']} = ₹${totalPay}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),

                        const Divider(height: 28, thickness: 1),

                        /// Total Amount
                        Row(
                          children: [
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹${NumberFormat('#,##0').format(totalPrice + packageAmount)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// Bottom Buttons
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Go Back",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            razorpayService.openCheckout(
                              amount: totalPrice + packageAmount, // ₹100
                              razorpayKey: AppConstants.razorpayLive,
                              onSuccess: (response) {
                                onPoojaSuccess(response.paymentId!);
                              },
                              onFailure: (response) {},
                              onExternalWallet: (response) {
                                print("Wallet: ${response.walletName}");
                              },
                              description: 'All Pandit',
                            );
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Pay Now",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
      },
    );
  }

  final ScrollController _packageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Pandit id: ${widget.panditId}");
    print("Pooja slug: ${widget.poojaSlug}");

    getPanditDetails();
    _packageScrollController.addListener(() {
      final index = (_packageScrollController.offset / _cardWidth).round();

      if (index != _currentIndex) {
        setState(() {
          _currentIndex = index;
        });
      }
    });
  }

  AllPanditDetailsModel? allPanditDetailsModel;
  PanditSuccessModel? allPanditSuccess;

  Future<void> getPanditDetails() async {
    setState(() {
      isLoading = true;
    });

    String url = "${AppConstants.allPanditDetailsUrl}${widget.panditId}&slug=${widget.poojaSlug}";
    print("All Pandit Details Url:$url");
    try {
      final res = await HttpService().getApi("${url}");
      print("Pandit Res:$res");

      if (res != null) {
        setState(() {
          allPanditDetailsModel = AllPanditDetailsModel.fromJson(res);

          // PRODUCTS LIST SAFE CHECK
          final products = allPanditDetailsModel?.products ?? [];
          counts = List<int>.filled(products.length, 0);

          // PACKAGES LIST SAFE CHECK
          final packages = allPanditDetailsModel?.packages ?? [];

          if (packages.isNotEmpty) {
            packageAmount = packages[0].price ?? 0;
            packageId = packages[0].id ?? 0;
            serviceId = packages[0].serviceId ?? 0;
            packagePerson = packages[0].package?.person ?? 0;
            packagePooja = packages[0].package?.title ?? "";
          } else {
            // If no package available, set safe defaults
            packageAmount = 0;
            packageId = 0;
            serviceId = 0;
            packagePerson = 0;
            packagePooja = "N/A";
          }

          print("All PANDIT data: ${packages.length}");
          isLoading = false;
        });
      }
    }
    catch (e) {
      print("Error in all pandit details: $e");
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> selectedItems = [];
  int activeIndex = 0;

  void addOrUpdateItem(int index) {
    final item = allPanditDetailsModel?.products[index];
    if (item == null) return;

    int quantity = counts[index]; // current quantity for this item

    // Check if item already exists in selectedItems
    int selIndex = selectedItems.indexWhere((e) => e['title'] == item.name);

    if (selIndex >= 0) {
      if (quantity == 0) {
        // Remove item if quantity is 0
        selectedItems.removeAt(selIndex);
      } else {
        // Update quantity and totalPrice for this item
        selectedItems[selIndex]['qty'] = quantity;
        selectedItems[selIndex]['totalPrice'] =
            quantity * (item.unitPrice ?? 0);
      }
    } else {
      if (quantity > 0) {
        // Add new item
        selectedItems.add({
          'product_id': item.id,
          'title': item.name,
          'price': item.unitPrice ?? 0,
          'qty': quantity,
          'totalPrice': quantity * (item.unitPrice ?? 0),
        });
      }
    }

    // Calculate total price of all selected items
    totalPrice =
        selectedItems.fold(0.0, (sum, e) => sum + (e['totalPrice'] ?? 0));

    print("Selected Items:");
    for (var i in selectedItems) {
      print("${i['title']} | Qty: ${i['qty']} | Total: ${i['totalPrice']}");
    }

    print("Grand Total: $totalPrice");
  }

  Future<void> onPoojaSuccess(String paymentId) async {

    // Format products with all string values
    List<Map<String, String>> formattedProducts = selectedItems.map((item) {
      return {
        "product_id": item["product_id"].toString(),
        "price": item["price"].toString(),
        "qty": item["qty"].toString(),
      };
    }).toList();

    // Format date with leading zeros for month/day
    String formattedDate = "${selectedDate?.year}/${selectedDate?.month.toString().padLeft(2,'0')}/${selectedDate?.day.toString().padLeft(2,'0')}";

    Map<String, dynamic> data = {
      "payment_id": paymentId,
      "service_id": serviceId.toString(),
      "guruji_id": widget.panditId.toString(),
      "package_id": packageId.toString(),
      "products": formattedProducts,
      "booking_date": formattedDate,
      "final_amount": (totalPrice + packageAmount).toString()
    };

    print("Package Id: $packageId");

    print("Pandit Data: $data");
    print("Pandit Formatted Products: $formattedProducts");

    try {
      setState(() {
        isLoading = true;
      });

      final res = await HttpService().postApi(
          "${AppConstants.allPanditSuccessUrl}", data);
      print("Success Res $res");

      if (res != null) {
        setState(() {
          allPanditSuccess = PanditSuccessModel.fromJson(res);
          isLoading = false;
        });
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => PersonDetails(
                  billAmount: (totalPrice + packageAmount).toString(),
                  personCount: packagePerson,
                  typePooja: "pooja",
                  pjIdOrder: allPanditSuccess?.orderId ?? '',
                  packageName: packagePooja,
                  poojaName: packagePooja,
                  poojaVenue: "${allPanditDetailsModel?.guruji?.address}",
                  date: formattedDate,
                  tabIndex: 11,
                  typeByVendor: "panditVendor",
                )));
      }
    } catch (e) {
      print("Error in all pandit success : $e");
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _packageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Row(
              children: [
                // iOS Style Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 22,
                  ),
                ),

                const Expanded(
                  child: Center(
                    child: Text(
                      "Pooja Details",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 48), // Balance for center title
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Price: ₹${NumberFormat('#,##0').format(totalPrice + packageAmount)}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              onPressed: totalPrice + packageAmount > 0
                  ? () {
                      if (selectedDate != null) {
                        showConfirmationDialog(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a date"),
                          ),
                        );
                        return;
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: totalPrice + packageAmount > 0
                    ? Colors.white
                    : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Book Now",
                style: TextStyle(
                  color: totalPrice + packageAmount > 0
                      ? Colors.deepOrange
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : CustomScrollView(
                slivers: [

                  // SLider
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // SLIDER
                        CarouselSlider.builder(
                          itemCount: allPanditDetailsModel?.images.length,
                          options: CarouselOptions(
                            height: 195,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 900),
                            viewportFraction: 0.9,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              setState(() => activeIndex = index);
                            },
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final imageUrl =
                                allPanditDetailsModel?.images[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  imageUrl ?? '',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),

                        // DOT INDICATOR
                        AnimatedSmoothIndicator(
                          activeIndex: activeIndex,
                          count: allPanditDetailsModel?.images.length ?? 0,
                          effect: ExpandingDotsEffect(
                            dotHeight: 5,
                            dotWidth: 5,
                            activeDotColor: Colors.deepOrange,
                            dotColor: Colors.grey.shade400,
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // Pooja Details
                  SliverToBoxAdapter(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepOrange.shade100,
                                  Colors.deepOrange.shade50
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrange.shade100
                                      .withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            /// 👇 dynamic height — NO FIXED HEIGHT AT ALL
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// DESCRIPTION
                                Text(
                                  "${allPanditDetailsModel?.puja?.metaDescription}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),

                                const SizedBox(height: 12),

                                /// RATINGS + ARROW BUTTON
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: Stack(
                                        children: List.generate(
                                          5,
                                          (index) => Positioned(
                                            left: index * 18.0,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                "https://i.pravatar.cc/50?img=${index + 1}",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "4.8 (250 ratings)",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                            () => isExpanded = !isExpanded);
                                      },
                                      child: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        size: 26,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ],
                                ),

                                /// EXPANDED CONTENT
                                if (isExpanded) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    "${allPanditDetailsModel?.puja?.name}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${allPanditDetailsModel?.puja?.poojaHeading?.toUpperCase()}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.black54),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${allPanditDetailsModel?.puja?.finalVenue}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Pooja Package Title
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Select Your Pooja Package",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Select the best puja package with clear pricing and services.",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),

                 // Horizontal Pooja Package Cards
                 //  SliverToBoxAdapter(
                 //    child: Column(
                 //      children: [
                 //        SizedBox(
                 //          height: 185,
                 //          child: ListView.builder(
                 //            scrollDirection: Axis.horizontal,
                 //            controller: _packageScrollController,
                 //            padding: const EdgeInsets.symmetric(
                 //                horizontal: 16, vertical: 12),
                 //            itemCount: allPanditDetailsModel?.packages.length,
                 //            itemBuilder: (context, index) {
                 //              final item = allPanditDetailsModel?.packages[index];
                 //              final isSelected = selectedIndex == index;
                 //              return GestureDetector(
                 //                onTap: () {
                 //                  setState(() {
                 //                    selectedIndex = index;
                 //                    packageAmount = item?.price ?? 0;
                 //                    packageId = item?.packageId ?? 0;
                 //                    serviceId = item?.serviceId ?? 0;
                 //                    packagePerson = item?.package?.person ?? 0;
                 //                    packagePooja = item?.package?.title ?? '';
                 //                  });
                 //                },
                 //                child: AnimatedContainer(
                 //                  duration: const Duration(milliseconds: 350),
                 //                  margin: const EdgeInsets.only(right: 16),
                 //                  width: 280, // horizontal card
                 //                  height: 130, // card height ~150-200
                 //                  decoration: BoxDecoration(
                 //                    gradient: LinearGradient(
                 //                      colors: isSelected
                 //                          ? [Color(0xFFF0F4FF), Color(0xFFE3F2FD)]
                 //                          : [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                 //                      begin: Alignment.topLeft,
                 //                      end: Alignment.bottomRight,
                 //                    ),
                 //                    borderRadius: BorderRadius.circular(20),
                 //                    boxShadow: [
                 //                      BoxShadow(
                 //                        color: Colors.black.withOpacity(0.12),
                 //                        blurRadius: 12,
                 //                        offset: const Offset(0, 6),
                 //                      ),
                 //                    ],
                 //                    border: isSelected
                 //                        ? Border.all(
                 //                        color: Color(0xFF0E9DF6), width: 2)
                 //                        : Border.all(color: Colors.transparent),
                 //                  ),
                 //                  child: Padding(
                 //                    padding: const EdgeInsets.all(16),
                 //                    child: Row(
                 //                      crossAxisAlignment: CrossAxisAlignment.center,
                 //                      children: [
                 //                        ClipRRect(
                 //                          borderRadius: BorderRadius.circular(16),
                 //                          child: CachedNetworkImage(
                 //                              imageUrl: item?.package?.image ?? '',
                 //                              width: 90,
                 //                              height: 90,
                 //                              fit: BoxFit.cover,
                 //
                 //                              // Placeholder (while loading)
                 //                              placeholder: (context, url) =>
                 //                                  placeholderImage(),
                 //
                 //                              // Error widget (null ya error ho)
                 //                              errorWidget: (context, url, error) =>
                 //                                  NoImageWidget()),
                 //                        ),
                 //
                 //                        const SizedBox(width: 14),
                 //
                 //                        // Right side: Details
                 //                        Expanded(
                 //                          child: Column(
                 //                            mainAxisAlignment:
                 //                            MainAxisAlignment.center,
                 //                            crossAxisAlignment:
                 //                            CrossAxisAlignment.start,
                 //                            children: [
                 //                              // Pooja Name
                 //                              Text(
                 //                                item?.package?.title ?? '',
                 //                                style: TextStyle(
                 //                                  fontSize: 14,
                 //                                  fontWeight: FontWeight.bold,
                 //                                  color: isSelected
                 //                                      ? Colors.red
                 //                                      : Color(0xFFEF6C00),
                 //                                ),
                 //                              ),
                 //                              const SizedBox(height: 5),
                 //
                 //                              // Person count
                 //                              Row(
                 //                                children: [
                 //                                  const Icon(Icons.person,
                 //                                      size: 12,
                 //                                      color: Colors.orange),
                 //                                  const SizedBox(width: 6),
                 //                                  Text(
                 //                                    "${item?.package?.person} Person",
                 //                                    style: TextStyle(
                 //                                        fontSize: 13,
                 //                                        color: isSelected
                 //                                            ? Colors.black
                 //                                            : Colors.grey),
                 //                                  ),
                 //                                ],
                 //                              ),
                 //                              const SizedBox(height: 10),
                 //
                 //                              // Price tag
                 //                              Row(
                 //                                children: [
                 //                                  Container(
                 //                                    padding:
                 //                                    const EdgeInsets.symmetric(
                 //                                        horizontal: 18,
                 //                                        vertical: 6),
                 //                                    decoration: BoxDecoration(
                 //                                      gradient: LinearGradient(
                 //                                        colors: isSelected
                 //                                            ? [
                 //                                          Color(0xFF42A5F5),
                 //                                          Color(0xFF1976D2)
                 //                                        ] // Selected: vibrant blue → deep blue
                 //                                            : [
                 //                                          Color(0xFFFFF3E0),
                 //                                          Color(0xFFFFE0B2)
                 //                                        ], // Unselected: warm cream → light orange
                 //                                        begin: Alignment.topLeft,
                 //                                        end: Alignment.bottomRight,
                 //                                      ),
                 //                                      borderRadius:
                 //                                      BorderRadius.circular(8),
                 //                                      boxShadow: [
                 //                                        BoxShadow(
                 //                                          color: isSelected
                 //                                              ? Colors.grey
                 //                                              : Colors.deepOrange
                 //                                              .shade200
                 //                                              .withOpacity(0.3),
                 //                                          blurRadius: 6,
                 //                                          offset:
                 //                                          const Offset(0, 3),
                 //                                        ),
                 //                                      ],
                 //                                    ),
                 //                                    child: Text(
                 //                                      "₹${NumberFormat('#,##0').format(item?.price ?? 0)}",
                 //                                      style: TextStyle(
                 //                                        fontSize: 16,
                 //                                        fontWeight: FontWeight.bold,
                 //                                        color: isSelected
                 //                                            ? Colors.white
                 //                                            : Colors.red,
                 //                                      ),
                 //                                    ),
                 //                                  ),
                 //                                  SizedBox(
                 //                                    width: 20,
                 //                                  ),
                 //                                  isSelected
                 //                                      ? Container(
                 //                                    padding:
                 //                                    const EdgeInsets.all(
                 //                                        4),
                 //                                    decoration: BoxDecoration(
                 //                                      shape: BoxShape.circle,
                 //                                      color: Colors
                 //                                          .green, // Green background
                 //                                      boxShadow: [
                 //                                        BoxShadow(
                 //                                          color: Colors.green
                 //                                              .withOpacity(
                 //                                              0.5),
                 //                                          blurRadius: 4,
                 //                                          offset:
                 //                                          const Offset(
                 //                                              0, 2),
                 //                                        ),
                 //                                      ],
                 //                                    ),
                 //                                    child: const Icon(
                 //                                      Icons.check,
                 //                                      color: Colors
                 //                                          .white, // White tick
                 //                                      size: 20,
                 //                                    ),
                 //                                  )
                 //                                      : SizedBox()
                 //                                ],
                 //                              ),
                 //                            ],
                 //                          ),
                 //                        ),
                 //                      ],
                 //                    ),
                 //                  ),
                 //                ),
                 //              );
                 //            },
                 //          ),
                 //        ),
                 //
                 //        // Indicator
                 //        Row(
                 //          mainAxisAlignment: MainAxisAlignment.center,
                 //          children: List.generate(
                 //            allPanditDetailsModel?.packages.length ?? 0,
                 //                (index) => AnimatedContainer(
                 //              duration: const Duration(milliseconds: 250),
                 //              margin: const EdgeInsets.symmetric(horizontal: 4),
                 //              width: _currentIndex == index ? 18 : 8,
                 //              height: 8,
                 //              decoration: BoxDecoration(
                 //                color: _currentIndex == index
                 //                    ? Colors.blue
                 //                    : Colors.grey.shade400,
                 //                borderRadius: BorderRadius.circular(10),
                 //              ),
                 //            ),
                 //          ),
                 //        ),
                 //        const SizedBox(height: 10),
                 //      ],
                 //    ),
                 //  ),

                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            controller: _packageScrollController,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            itemCount: allPanditDetailsModel?.packages.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = allPanditDetailsModel?.packages[index];
                              final isSelected = selectedIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                    selectedIndex = index;
                                    packageAmount = item?.price ?? 0;
                                    packageId = item?.id ?? 0;
                                    serviceId = item?.serviceId ?? 0;
                                    packagePerson = item?.package?.person ?? 0;
                                    packagePooja = item?.package?.title ?? '';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.only(right: 14),
                                  width: 145,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isSelected
                                          ? [
                                        Color(0xFFE3F2FD),
                                        Color(0xFF90CAF9),
                                      ]
                                          : [
                                        Color(0xFFFFF8E1),
                                        Color(0xFFFFE0B2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? Color(0xFF1976D2)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? Colors.blue.withOpacity(0.25)
                                            : Colors.black.withOpacity(0.08),
                                        blurRadius: isSelected ? 14 : 8,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(height: 14),

                                          // 🌟 Image with soft glow
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange.withOpacity(0.35),
                                                  blurRadius: 18,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(14),
                                              child: CachedNetworkImage(
                                                imageUrl: item?.package?.image ?? '',
                                                height: 74,
                                                width: 74,
                                                fit: BoxFit.cover,
                                                // placeholder: (context, url) =>
                                                //     placeholderImage(),
                                                // errorWidget: (context, url, error) =>
                                                //     NoImageWidget(),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // 🕉️ Title
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              item?.package?.title ?? '',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected
                                                    ? Color(0xFF0D47A1)
                                                    : Color(0xFFBF360C),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          // 👥 Person count
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.people_alt_rounded,
                                                  size: 14, color: Colors.deepOrange),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${item?.package?.person ?? 0} Persons",
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const Spacer(),

                                          // 💰 Price pill
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 14),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: isSelected
                                                    ? [
                                                  Color(0xFF1976D2),
                                                  Color(0xFF0D47A1)
                                                ]
                                                    : [
                                                  Colors.white,
                                                  Colors.orange.shade100
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              "₹${NumberFormat('#,##0').format(item?.price ?? 0)}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // ✅ Selected Ribbon
                                      if (isSelected)
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                            child: const Icon(Icons.check,
                                                size: 16, color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 6),

                        // 🔘 Premium Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            allPanditDetailsModel?.packages.length ?? 0,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == index ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: _currentIndex == index
                                    ? const LinearGradient(
                                  colors: [
                                    Color(0xFF1976D2),
                                    Color(0xFF64B5F6),
                                  ],
                                )
                                    : null,
                                color: _currentIndex == index
                                    ? null
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),


                  // SliverToBoxAdapter(
                  //   child: Column(
                  //     children: [
                  //       SizedBox(
                  //         height: 185, // compact height
                  //         child: ListView.builder(
                  //           controller: _packageScrollController,
                  //           scrollDirection: Axis.horizontal,
                  //           padding: const EdgeInsets.symmetric(horizontal: 14),
                  //           itemCount: allPanditDetailsModel?.packages.length ?? 0,
                  //           itemBuilder: (context, index) {
                  //             final item = allPanditDetailsModel?.packages[index];
                  //             final isSelected = selectedIndex == index;
                  //
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 setState(() {
                  //                   _currentIndex = index;
                  //                   selectedIndex = index;
                  //                   packageAmount = item?.price ?? 0;
                  //                   packageId = item?.id ?? 0;
                  //                   serviceId = item?.serviceId ?? 0;
                  //                   packagePerson = item?.package?.person ?? 0;
                  //                   packagePooja = item?.package?.title ?? '';
                  //                 });
                  //               },
                  //               child: AnimatedScale(
                  //                 scale: isSelected ? 1.05 : 1.0,
                  //                 duration: const Duration(milliseconds: 300),
                  //                 child: Container(
                  //                   margin: const EdgeInsets.only(right: 12),
                  //                   width: 110, // ⭐ 4–5 cards visible
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(18),
                  //                     gradient: LinearGradient(
                  //                       begin: Alignment.topLeft,
                  //                       end: Alignment.bottomRight,
                  //                       colors: isSelected
                  //                           ? [
                  //                         Color(0xFF2C2C2C),
                  //                         Color(0xFF111111),
                  //                       ]
                  //                           : [
                  //                         Color(0xFFFAFAFA),
                  //                         Color(0xFFF2F2F2),
                  //                       ],
                  //                     ),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: isSelected
                  //                             ? Colors.amber.withOpacity(0.45)
                  //                             : Colors.black.withOpacity(0.08),
                  //                         blurRadius: isSelected ? 20 : 8,
                  //                         offset: const Offset(0, 6),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: Stack(
                  //                     children: [
                  //                       // 🟨 Gold Accent Strip
                  //                       Positioned(
                  //                         left: 0,
                  //                         top: 14,
                  //                         bottom: 14,
                  //                         child: Container(
                  //                           width: 4,
                  //                           decoration: BoxDecoration(
                  //                             borderRadius: BorderRadius.circular(4),
                  //                             gradient: const LinearGradient(
                  //                               colors: [
                  //                                 Color(0xFFFFD700),
                  //                                 Color(0xFFB8860B),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //
                  //                       Column(
                  //                         mainAxisAlignment: MainAxisAlignment.center,
                  //                         children: [
                  //                           // 🖼️ Avatar
                  //                           Container(
                  //                             padding: const EdgeInsets.all(3),
                  //                             decoration: BoxDecoration(
                  //                               shape: BoxShape.circle,
                  //                               gradient: const LinearGradient(
                  //                                 colors: [
                  //                                   Color(0xFFFFD700),
                  //                                   Color(0xFFB8860B),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                             child: CircleAvatar(
                  //                               radius: 28,
                  //                               backgroundColor: Colors.white,
                  //                               backgroundImage: NetworkImage(
                  //                                   item?.package?.image ?? ''),
                  //                             ),
                  //                           ),
                  //
                  //                           const SizedBox(height: 8),
                  //
                  //                           // 🕉️ Title
                  //                           Padding(
                  //                             padding:
                  //                             const EdgeInsets.symmetric(horizontal: 6),
                  //                             child: Text(
                  //                               item?.package?.title ?? '',
                  //                               maxLines: 2,
                  //                               textAlign: TextAlign.center,
                  //                               overflow: TextOverflow.ellipsis,
                  //                               style: TextStyle(
                  //                                 fontSize: 12,
                  //                                 fontWeight: FontWeight.w700,
                  //                                 color: isSelected
                  //                                     ? Colors.amber
                  //                                     : Colors.black87,
                  //                               ),
                  //                             ),
                  //                           ),
                  //
                  //                           const SizedBox(height: 6),
                  //
                  //                           // 💰 Price
                  //                           Text(
                  //                             "₹${NumberFormat('#,##0').format(item?.price ?? 0)}",
                  //                             style: TextStyle(
                  //                               fontSize: 13,
                  //                               fontWeight: FontWeight.bold,
                  //                               color: isSelected
                  //                                   ? Colors.white
                  //                                   : Colors.deepOrange,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //
                  //                       // ✅ Selected Badge
                  //                       if (isSelected)
                  //                         Positioned(
                  //                           top: 8,
                  //                           right: 8,
                  //                           child: Container(
                  //                             padding: const EdgeInsets.all(4),
                  //                             decoration: BoxDecoration(
                  //                               shape: BoxShape.circle,
                  //                               gradient: const LinearGradient(
                  //                                 colors: [
                  //                                   Color(0xFFFFD700),
                  //                                   Color(0xFFB8860B),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                             child: const Icon(Icons.check,
                  //                                 size: 14, color: Colors.black),
                  //                           ),
                  //                         ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //
                  //       const SizedBox(height: 10),
                  //
                  //       // 🔘 Luxury Indicator
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: List.generate(
                  //           allPanditDetailsModel?.packages.length ?? 0,
                  //               (index) => AnimatedContainer(
                  //             duration: const Duration(milliseconds: 300),
                  //             margin: const EdgeInsets.symmetric(horizontal: 3),
                  //             width: _currentIndex == index ? 24 : 6,
                  //             height: 6,
                  //             decoration: BoxDecoration(
                  //               gradient: _currentIndex == index
                  //                   ? const LinearGradient(
                  //                 colors: [
                  //                   Color(0xFFFFD700),
                  //                   Color(0xFFB8860B),
                  //                 ],
                  //               )
                  //                   : null,
                  //               color:
                  //               _currentIndex == index ? null : Colors.grey.shade400,
                  //               borderRadius: BorderRadius.circular(6),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  //Date Selection
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            "Select Pooja Date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Date selector
                          InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );

                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedDate == null
                                        ? "Select Date"
                                        : DateFormat('dd/MM/yyyy')
                                            .format(selectedDate!),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedDate == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.deepOrange),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //  Devotion Title
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Offer Your Devotion",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Along with your Puja you may offer Chadhava or make a donation.",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: const EdgeInsets.all(10),
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [Colors.deepOrange.shade100, Colors.deepOrange.shade50],
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //     ),
                    //     borderRadius: BorderRadius.circular(16),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.deepOrange.shade100.withOpacity(0.5),
                    //         blurRadius: 10,
                    //         offset: const Offset(0, 4),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         "अब तक 10000+ भक्तों Have experienced divine blessings.\nRishi Shriwas Has performed over 10000+ Pujas.",
                    //         style: TextStyle(fontSize: 14, color: Colors.black87),
                    //       ),
                    //       const SizedBox(height: 12),
                    //       Row(
                    //         children: [
                    //           SizedBox(
                    //             width: 100,
                    //             height: 30,
                    //             child: Stack(
                    //               children: List.generate(
                    //                 5,
                    //                     (index) => Positioned(
                    //                   left: index * 18.0,
                    //                   child: CircleAvatar(
                    //                     radius: 15,
                    //                     backgroundImage: NetworkImage("https://i.pravatar.cc/50?img=${index + 1}"),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 8),
                    //           Expanded(
                    //             child: Row(
                    //               children: const [
                    //                 Icon(Icons.star, color: Colors.amber, size: 18),
                    //                 SizedBox(width: 4),
                    //                 Text(
                    //                   "4.8 (250 ratings)",
                    //                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 12),
                    //       Row(
                    //         children: const [
                    //           Icon(Icons.local_fire_department, color: Colors.deepOrange),
                    //           SizedBox(width: 6),
                    //           Text(
                    //             "Dhanters Vishesh",
                    //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 8),
                    //       const Text(
                    //         "Devi Laxmi Pooja",
                    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                    //       ),
                    //       const SizedBox(height: 4),
                    //       Row(
                    //         children: const [
                    //           Icon(Icons.location_on, size: 16, color: Colors.black54),
                    //           SizedBox(width: 4),
                    //           Text(
                    //             "Rishi Shriwas Mandir, Mumbai",
                    //             style: TextStyle(fontSize: 13, color: Colors.black54),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),

                  //Donation Items List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = allPanditDetailsModel?.products[index];
                        if (item == null) return SizedBox();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            height: 85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border(
                                left: BorderSide(
                                  color: counts[index] == 0
                                      ? Colors.deepOrange
                                      : Colors.green,
                                  width: 5,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                        imageUrl: item.thumbnail ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,

                                        // Placeholder (while loading)
                                        // placeholder: (context, url) =>
                                        //     placeholderImage(),
                                        //
                                        // // Error widget (null ya error ho)
                                        // errorWidget: (context, url, error) =>
                                        //     NoImageWidget()
                                      ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange.shade700,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "₹${NumberFormat('#,##0').format(item.unitPrice ?? 0)}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  counts[index] == 0
                                      ? ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              counts[index] = 1;
                                              addOrUpdateItem(index);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            minimumSize: const Size(60, 35),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            "Add",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.redAccent),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    color: Colors.redAccent),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  setState(() {
                                                    if (counts[index] > 0)
                                                      counts[index]--;
                                                    addOrUpdateItem(index);
                                                  });
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                child: Text(
                                                  "${counts[index]}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    color: Colors.green),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  setState(() {
                                                    counts[index]++;
                                                    addOrUpdateItem(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: allPanditDetailsModel?.products.length ?? 0,
                    ),
                  ),

                  // Bill Details
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.2),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bill details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade50,
                                  Colors.orange.shade100.withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                  color: Colors.orange.shade200, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.18),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ⭐ TITLE (Pooja Name)
                                Text(
                                  "$packagePooja",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.deepOrange.shade800,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // 📅 DATE ROW
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        size: 18,
                                        color: Colors.deepOrange.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Pooja Date:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepOrange.shade900,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      (selectedDate == null ||
                                              selectedDate
                                                  .toString()
                                                  .trim()
                                                  .isEmpty)
                                          ? "Please select date"
                                          : DateFormat("dd MMM yyyy").format(
                                              DateTime.parse("$selectedDate")),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: (selectedDate == null ||
                                                selectedDate
                                                    .toString()
                                                    .trim()
                                                    .isEmpty)
                                            ? Colors.red.shade700
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // 👤 PERSON QUANTITY
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        size: 18,
                                        color: Colors.deepOrange.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Person Quantity:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepOrange.shade900,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "$packagePerson Person",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // 💰 PACKAGE AMOUNT
                                Row(
                                  children: [
                                    Text(
                                      "Package Amount:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepOrange.shade900,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "₹${NumberFormat('#,##0').format(packageAmount ?? 0)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Items List
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedItems.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = selectedItems[index];
                              final totalPay =
                                  item['qty'] * (item['price'] ?? 0);

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${item['title']}", // item name
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                          color: Colors.black87,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${item['qty']} x ₹${NumberFormat('#,##0').format(item['price'])} = ₹${NumberFormat('#,##0').format(totalPay)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 24, thickness: 1, color: Colors.grey),

                          // Total Amount
                          Row(
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "₹${NumberFormat('#,##0').format(totalPrice + packageAmount)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                      child: SizedBox(height: 200)), // bottom spacing for FAB
                ],
              ),
      ),
    );
  }
}
