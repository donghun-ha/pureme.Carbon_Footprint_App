class Report{
  String user_eMail;
  String feedId;
  DateTime reportTime;
  String reportReason;

  

  Report({
    required this.user_eMail,
    required this.feedId,
    required this.reportTime,
    required this.reportReason,
  });

  factory Report.fromMap(Map<String, dynamic> res) {
    return Report(
        user_eMail: res['user_eMail'],
        feedId: res['feedId'],
        reportTime: DateTime.parse(res['reportTime']) ,
        reportReason: res['reportReason'],);
  }


}