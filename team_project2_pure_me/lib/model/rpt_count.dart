/// manage_report 에 쓰일 report count를 위한 모델
class RptCount {
  String feedId;
  int feedCount;

  RptCount({
    required this.feedId,
    required this.feedCount,
  });

  factory RptCount.fromMap(Map<String, dynamic> res) {
    return RptCount(feedId: res['feedId'], feedCount: res['feed_count']);
  }
}
