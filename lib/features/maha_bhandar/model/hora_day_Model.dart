class HoraDayModel {
  int? status;
  List<DayHora>? dayHora;
  List<NightHora>? nightHora;

  HoraDayModel({this.status, this.dayHora, this.nightHora});

  HoraDayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['dayHora'] != null) {
      dayHora = <DayHora>[];
      json['dayHora'].forEach((v) {
        dayHora!.add(DayHora.fromJson(v));
      });
    }
    if (json['nightHora'] != null) {
      nightHora = <NightHora>[];
      json['nightHora'].forEach((v) {
        nightHora!.add(NightHora.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (dayHora != null) {
      data['dayHora'] = dayHora!.map((v) => v.toJson()).toList();
    }
    if (nightHora != null) {
      data['nightHora'] = nightHora!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DayHora {
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

  DayHora(
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

  DayHora.fromJson(Map<String, dynamic> json) {
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

class NightHora {
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

  NightHora(
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

  NightHora.fromJson(Map<String, dynamic> json) {
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
