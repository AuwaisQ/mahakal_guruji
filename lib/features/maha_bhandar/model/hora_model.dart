class HoraModel {
  int? status;
  List<AllData>? allData;

  HoraModel({this.status, this.allData});

  HoraModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['all_data'] != null) {
      allData = <AllData>[];
      json['all_data'].forEach((v) {
        allData!.add(AllData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (allData != null) {
      data['all_data'] = allData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllData {
  String? startTime;
  String? endTime;
  String? hora;
  String? horaDetail;
  String? horaAnukul;
  String? horaPratikul;
  String? rang;
  String? bhojan;
  String? ratna;
  String? fool;
  String? sankhya;
  String? vahan;
  String? dhatu;
  String? horaImage;

  AllData(
      {this.startTime,
      this.endTime,
      this.hora,
      this.horaDetail,
      this.horaAnukul,
      this.horaPratikul,
      this.rang,
      this.bhojan,
      this.ratna,
      this.fool,
      this.sankhya,
      this.vahan,
      this.dhatu,
      this.horaImage});

  AllData.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    hora = json['hora'];
    horaDetail = json['hora_detail'];
    horaAnukul = json['hora_anukul'];
    horaPratikul = json['hora_pratikul'];
    rang = json['rang'];
    bhojan = json['bhojan'];
    ratna = json['ratna'];
    fool = json['fool'];
    sankhya = json['sankhya'];
    vahan = json['vahan'];
    dhatu = json['dhatu'];
    horaImage = json['hora_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['hora'] = hora;
    data['hora_detail'] = horaDetail;
    data['hora_anukul'] = horaAnukul;
    data['hora_pratikul'] = horaPratikul;
    data['rang'] = rang;
    data['bhojan'] = bhojan;
    data['ratna'] = ratna;
    data['fool'] = fool;
    data['sankhya'] = sankhya;
    data['vahan'] = vahan;
    data['dhatu'] = dhatu;
    data['hora_image'] = horaImage;
    return data;
  }
}
