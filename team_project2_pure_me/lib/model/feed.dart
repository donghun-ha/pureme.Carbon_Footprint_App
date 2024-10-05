

class Feed{
  String? feedName; /// 작성자 이메일
  String authorEMail; /// 작성자 이메일

  String content; /// 내용
  String feedImageName; /// 사진의 이름
  DateTime writeTime; /// 쓴 시간
  int feedState; /// 뭘로할지는 추가예정
  DateTime? deleteTime; /// 삭제된 시간
  DateTime? editTime; /// 수정된 시간

  Feed({
    this.feedName,
    required this.authorEMail,
    required this.content,
    required this.feedImageName,
    required this.writeTime,
    required this. feedState,
    this.deleteTime,
    this.editTime,
  });

  Feed.fromMap(Map<String, dynamic> res)
  :feedName = res['feedName'],
  authorEMail = res['authorEMail'],
  content = res['content'],
  feedImageName = res['feedImageName'],
  writeTime = res['writeTime'],
  feedState = res['feedState'],
  deleteTime = DateTime.parse(res['deleteTime']),
  editTime = DateTime.parse(res['editTime'])
  ;
}

