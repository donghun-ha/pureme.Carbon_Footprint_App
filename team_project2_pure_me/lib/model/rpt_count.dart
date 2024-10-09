/// manage_report 에 쓰일 report count를 위한 모델
class RptCount{
  String feedId;
  int feed_count;

  RptCount({
    required this.feedId,
    required this.feed_count,
  });

  factory RptCount.fromMap(Map<String, dynamic> res) {
    return RptCount(
        feedId: res['feedId'],
        feed_count: res['feed_count']
    );
  }

}