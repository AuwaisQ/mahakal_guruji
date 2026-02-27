class PlayListModel {
  final List<Datum> data;

  PlayListModel({required this.data});

  factory PlayListModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    List<Datum> data = dataList.map((i) => Datum.fromJson(i)).toList();
    return PlayListModel(data: data);
  }
}

class Datum {
  final int categoryId;
  final int subcategoryId;
  final String? listType;
  final String? playlistName;
  final int status;
  final List<Video> videos;

  Datum({
    required this.categoryId,
    required this.subcategoryId,
    this.listType,
    this.playlistName,
    required this.status,
    required this.videos,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    var videoList = json['videos'] as List<dynamic>;
    List<Video> videos = videoList.map((i) => Video.fromJson(i)).toList();
    return Datum(
      categoryId: json['category_id'] as int,
      subcategoryId: json['subcategory_id'] as int,
      listType: json['list_type'] as String?,
      playlistName: json['playlist_name'] as String?,
      status: json['status'] as int,
      videos: videos,
    );
  }
}

class Video {
  final String title;
  final String url;
  final String image;
  final dynamic urlStatus;

  Video({
    required this.title,
    required this.url,
    required this.image,
    required this.urlStatus,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'] as String,
      url: json['url'] as String,
      image: json['image'] as String,
      urlStatus: json['url_status'],
    );
  }
}
