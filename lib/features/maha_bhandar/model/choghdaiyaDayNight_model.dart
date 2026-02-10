class ChoghadiyaDayModel {
  int? status;
  List<DayChaughdiya>? dayChaughdiya;
  List<NightChaughdiya>? nightChaughdiya;

  ChoghadiyaDayModel({this.status, this.dayChaughdiya, this.nightChaughdiya});

  ChoghadiyaDayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['dayChaughdiya'] != null) {
      dayChaughdiya = <DayChaughdiya>[];
      json['dayChaughdiya'].forEach((v) {
        dayChaughdiya!.add(DayChaughdiya.fromJson(v));
      });
    }
    if (json['nightChaughdiya'] != null) {
      nightChaughdiya = <NightChaughdiya>[];
      json['nightChaughdiya'].forEach((v) {
        nightChaughdiya!.add(NightChaughdiya.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (dayChaughdiya != null) {
      data['dayChaughdiya'] = dayChaughdiya!.map((v) => v.toJson()).toList();
    }
    if (nightChaughdiya != null) {
      data['nightChaughdiya'] =
          nightChaughdiya!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DayChaughdiya {
  String? startTime;
  String? endTime;
  String? muhurta;
  String? color;
  String? chaughdiyadetail;

  DayChaughdiya(
      {this.startTime,
      this.endTime,
      this.muhurta,
      this.color,
      this.chaughdiyadetail});

  DayChaughdiya.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    muhurta = json['muhurta'];
    color = json['color'];
    chaughdiyadetail = json['chaughdiyadetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['muhurta'] = muhurta;
    data['color'] = color;
    data['chaughdiyadetail'] = chaughdiyadetail;
    return data;
  }
}

class NightChaughdiya {
  String? startTime;
  String? endTime;
  String? muhurta;
  String? color;
  String? chaughdiyadetail;

  NightChaughdiya(
      {this.startTime,
      this.endTime,
      this.muhurta,
      this.color,
      this.chaughdiyadetail});

  NightChaughdiya.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    muhurta = json['muhurta'];
    color = json['color'];
    chaughdiyadetail = json['chaughdiyadetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['muhurta'] = muhurta;
    data['color'] = color;
    data['chaughdiyadetail'] = chaughdiyadetail;
    return data;
  }
}
