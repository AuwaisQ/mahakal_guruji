class SupportTicketBody {
  String? _type;
  String? _issue;
  String? _subject;
  String? _description;
  String? _priority;

  SupportTicketBody(String type, String issue, String subject,
      String description, String priority) {
    _type = type;
    _issue = issue;
    _subject = subject;
    _description = description;
    _priority = priority;
  }

  String? get type => _type;
  String? get issue => _issue;
  String? get subject => _subject;
  String? get description => _description;
  String? get priority => _priority;

  SupportTicketBody.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _issue = json['issue_id'];
    _subject = json['subject'];
    _description = json['description'];
    _priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    data['issue_id'] = _issue;
    data['subject'] = _subject;
    data['description'] = _description;
    data['priority'] = _priority;
    return data;
  }
}
