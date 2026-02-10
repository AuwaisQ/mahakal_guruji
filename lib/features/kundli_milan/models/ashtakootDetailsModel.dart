import 'dart:convert';

AshtakootDetailModel ashtakootDetailModelFromJson(String str) =>
    AshtakootDetailModel.fromJson(json.decode(str));

String ashtakootDetailModelToJson(AshtakootDetailModel data) =>
    json.encode(data.toJson());

class AshtakootDetailModel {
  int status;
  AshtakootData ashtakootData;

  AshtakootDetailModel({
    required this.status,
    required this.ashtakootData,
  });

  factory AshtakootDetailModel.fromJson(Map<String, dynamic> json) =>
      AshtakootDetailModel(
        status: json["status"],
        ashtakootData: AshtakootData.fromJson(json["ashtakootData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "ashtakootData": ashtakootData.toJson(),
      };
}

class AshtakootData {
  Bhakut varna;
  Bhakut vashya;
  Bhakut tara;
  Bhakut yoni;
  Bhakut maitri;
  Bhakut gan;
  Bhakut bhakut;
  Bhakut nadi;
  Total total;
  Conclusion conclusion;

  AshtakootData({
    required this.varna,
    required this.vashya,
    required this.tara,
    required this.yoni,
    required this.maitri,
    required this.gan,
    required this.bhakut,
    required this.nadi,
    required this.total,
    required this.conclusion,
  });

  factory AshtakootData.fromJson(Map<String, dynamic> json) => AshtakootData(
        varna: Bhakut.fromJson(json["varna"]),
        vashya: Bhakut.fromJson(json["vashya"]),
        tara: Bhakut.fromJson(json["tara"]),
        yoni: Bhakut.fromJson(json["yoni"]),
        maitri: Bhakut.fromJson(json["maitri"]),
        gan: Bhakut.fromJson(json["gan"]),
        bhakut: Bhakut.fromJson(json["bhakut"]),
        nadi: Bhakut.fromJson(json["nadi"]),
        total: Total.fromJson(json["total"]),
        conclusion: Conclusion.fromJson(json["conclusion"]),
      );

  Map<String, dynamic> toJson() => {
        "varna": varna.toJson(),
        "vashya": vashya.toJson(),
        "tara": tara.toJson(),
        "yoni": yoni.toJson(),
        "maitri": maitri.toJson(),
        "gan": gan.toJson(),
        "bhakut": bhakut.toJson(),
        "nadi": nadi.toJson(),
        "total": total.toJson(),
        "conclusion": conclusion.toJson(),
      };
}

class Bhakut {
  String description;
  String maleKootAttribute;
  String femaleKootAttribute;
  int totalPoints;
  double receivedPoints;

  Bhakut({
    required this.description,
    required this.maleKootAttribute,
    required this.femaleKootAttribute,
    required this.totalPoints,
    required this.receivedPoints,
  });

  factory Bhakut.fromJson(Map<String, dynamic> json) => Bhakut(
        description: json["description"],
        maleKootAttribute: json["male_koot_attribute"],
        femaleKootAttribute: json["female_koot_attribute"],
        totalPoints: json["total_points"],
        receivedPoints: json["received_points"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "male_koot_attribute": maleKootAttribute,
        "female_koot_attribute": femaleKootAttribute,
        "total_points": totalPoints,
        "received_points": receivedPoints,
      };
}

class Conclusion {
  bool status;
  String report;

  Conclusion({
    required this.status,
    required this.report,
  });

  factory Conclusion.fromJson(Map<String, dynamic> json) => Conclusion(
        status: json["status"],
        report: json["report"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "report": report,
      };
}

class Total {
  int totalPoints;
  double receivedPoints;
  int minimumRequired;

  Total({
    required this.totalPoints,
    required this.receivedPoints,
    required this.minimumRequired,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        totalPoints: json["total_points"],
        receivedPoints: json["received_points"]?.toDouble(),
        minimumRequired: json["minimum_required"],
      );

  Map<String, dynamic> toJson() => {
        "total_points": totalPoints,
        "received_points": receivedPoints,
        "minimum_required": minimumRequired,
      };
}
