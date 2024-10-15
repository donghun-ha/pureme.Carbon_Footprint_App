class Report {
  String userEMail;
  String feedId;
  DateTime reportTime;
  String reportReason;

  Report({
    required this.userEMail,
    required this.feedId,
    required this.reportTime,
    required this.reportReason,
  });

  factory Report.fromMap(Map<String, dynamic> res) {
    return Report(
      userEMail: res['user_eMail'],
      feedId: res['feedId'],
      reportTime: DateTime.parse(res['reportTime']),
      reportReason: res['reportReason'],
    );
  }
}
