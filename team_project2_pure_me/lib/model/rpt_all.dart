class RptAll{
  String feedId;
  int feed_count;

  RptAll({
    required this.feedId,
    required this.feed_count,
  });

  factory RptAll.fromMap(Map<String, dynamic> res) {
    return RptAll(
        feedId: res['feedId'],
        feed_count: res['feed_count']
    );
  }

}