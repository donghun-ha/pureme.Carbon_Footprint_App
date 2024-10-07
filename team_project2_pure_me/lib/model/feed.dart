class Feed {
  // 피드 아이디(키값)
  String? feedName;

  /// 작성자 이메일
  String authorEMail;

  /// 내용
  String content;

  /// 사진의 이름
  String feedImageName;

  /// 쓴 시간
  DateTime writeTime;

  // 피드 상태 // 게시 숨김
  String feedState;

  /// 뭘로할지는 추가예정

  /// 삭제된 시간
  DateTime? deleteTime;

  /// 수정된 시간
  DateTime? editTime;

  /// 댓글 리스트
  List? reply;

  Feed({
    this.feedName,
    required this.authorEMail,
    required this.content,
    required this.feedImageName,
    required this.writeTime,
    required this.feedState,
    this.deleteTime,
    this.editTime,
    this.reply,
  });

  factory Feed.fromMap(Map<String, dynamic> res, String id) {
    return Feed(
        feedName: id,
        authorEMail: res['writer'],
        content: res['content'],
        feedImageName: res['image'],
        writeTime: DateTime.parse(res['writetime']),
        feedState: res['state'],
        reply: res['reply']);
  }
  //     : id
  //     feedName = res['feedName'],
  //       authorEMail = res['authorEMail'],
  //       content = res['content'],
  //       feedImageName = res['feedImageName'],
  //       writeTime = res['writeTime'],
  //       feedState = res['feedState']
  // // deleteTime = DateTime.parse(res['deleteTime']),
  // // editTime = DateTime.parse(res['editTime'])
  // ;
}
