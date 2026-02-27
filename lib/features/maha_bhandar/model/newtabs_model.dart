import 'dart:convert';

// Convert from JSON string to DynamicTabs object
DynamicTabs dynamicTabsFromJson(String str) =>
    DynamicTabs.fromJson(json.decode(str));

// Convert from DynamicTabs object to JSON string
String dynamicTabsToJson(DynamicTabs data) => json.encode(data.toJson());

class DynamicTabs {
  int status;
  List<Datum> data;
  List<String> availableListTypes;

  DynamicTabs({
    required this.status,
    required this.data,
    required this.availableListTypes,
  });

  // Factory method to create DynamicTabs from JSON
  factory DynamicTabs.fromJson(Map<String, dynamic> json) => DynamicTabs(
        status: json["status"] ?? 0, // Default to 0 if status is null
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [], // Default to empty list if data is null
        availableListTypes: json["available_list_types"] != null
            ? List<String>.from(json["available_list_types"].map((x) => x))
            : [], // Default to empty list if available_list_types is null
      );

  // Convert DynamicTabs object to JSON map
  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "available_list_types":
            List<dynamic>.from(availableListTypes.map((x) => x)),
      };
}

class Datum {
  int categoryId;
  int subcategoryId;
  String? listType;
  String? playlistName;
  int status;
  List<Video> videos;

  Datum({
    required this.categoryId,
    required this.subcategoryId,
    this.listType,
    this.playlistName,
    required this.status,
    required this.videos,
  });

  // Factory method to create Datum from JSON
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId:
            json["category_id"] ?? 0, // Default to 0 if category_id is null
        subcategoryId: json["subcategory_id"] ??
            0, // Default to 0 if subcategory_id is null
        listType: json["list_type"], // Nullable
        playlistName: json["playlist_name"], // Nullable
        status: json["status"] ?? 0, // Default to 0 if status is null
        videos: json["videos"] != null
            ? List<Video>.from(json["videos"].map((x) => Video.fromJson(x)))
            : [], // Default to empty list if videos is null
      );

  // Convert Datum object to JSON map
  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "list_type": listType,
        "playlist_name": playlistName,
        "status": status,
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
      };
}

class Video {
  String title;
  String url;
  String image;
  int urlStatus;

  Video({
    required this.title,
    required this.url,
    required this.image,
    required this.urlStatus,
  });

  // Factory method to create Video from JSON
  factory Video.fromJson(Map<String, dynamic> json) => Video(
        title: json["title"] ??
            "Unknown Title", // Default to "Unknown Title" if null
        url: json["url"] ?? "", // Default to empty string if url is null
        image: json["image"] ?? "", // Default to empty string if image is null
        urlStatus:
            json["url_status"] ?? 0, // Default to 0 if url_status is null
      );

  // Convert Video object to JSON map
  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "image": image,
        "url_status": urlStatus,
      };
}
