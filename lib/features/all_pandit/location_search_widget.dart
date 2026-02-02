import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationSearchWidget extends StatefulWidget {
  final GoogleMapController? mapController;
  final TextEditingController controller;
  final Function(double lat, double lng, String address) onLocationSelected;

  const LocationSearchWidget({
    Key? key,
    required this.mapController,
    required this.controller,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final String apiKey =
      "AIzaSyA9WZ75akgvEYdJiPK1UQIpYNhiuStGQhA"; // replace with your API key
  List<Map<String, String>> _suggestions = [];
  bool _isLoading = false;

  Future<void> searchLocation(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:in";

    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          if (mounted) {
            setState(() {
              _suggestions = (data["predictions"] as List)
                  .map((p) => {
                "description": p["description"].toString(),
                "placeId": p["place_id"].toString(),
              })
                  .toList();
            });
          }
        } else {
          if (mounted) setState(() => _suggestions = []);
        }
      } else {
        if (mounted) setState(() => _suggestions = []);
      }
    } catch (e) {
      if (mounted) setState(() => _suggestions = []);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> selectPlace(String placeId, String description) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        final location = data["result"]["geometry"]["location"];
        final address = data["result"]["formatted_address"];

        double lat = location["lat"];
        double lng = location["lng"];

        // Move Google Map to location
        widget.mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
        );

        // update text
        widget.controller.text = description;

        // pass values back
        widget.onLocationSelected(lat, lng, address);

        // clear suggestions
        setState(() => _suggestions = []);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            onChanged: searchLocation,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Search location...",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              suffixIcon: _isLoading
                  ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.orange,
                  ),
                ),
              )
                  : widget.controller.text.isEmpty
                  ? Icon(Icons.location_on_outlined,
                  size: 26, color: Colors.orange)
                  : InkWell(
                  onTap: () {
                    widget.controller.clear();
                    setState(() => _suggestions = []);
                  },
                  child: Icon(Icons.cancel,
                      size: 26, color: Colors.orange)),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: _suggestions.isNotEmpty ? 220 : 0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _suggestions.isNotEmpty
              ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return InkWell(
                onTap: () => selectPlace(
                  suggestion["placeId"]!,
                  suggestion["description"]!,
                ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.orange, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          suggestion["description"] ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class AppLocationData {
  static String selectedCityProduct = "";
}
