class Feed {
  /// 피드 아이디(키값)
  String? feedName;

  /// 작성자 이메일
  String authorEMail;

  /// 작성자 닉네임
  String? userName;

  /// 내용
  String content;

  /// 사진의 경로
  String feedImagePath;

  /// 사진의 이름
  String imageName;

  /// 쓴 시간
  DateTime writeTime;

  // 피드 상태 // 게시 숨김
  String feedState;

  /// 삭제된 시간
  DateTime? deleteTime;

  /// 수정된 시간
  DateTime? editTime;

  /// 댓글 리스트
  List? reply;

  Feed({
    this.feedName,
    required this.authorEMail,
    this.userName,
    required this.content,
    required this.feedImagePath,
    required this.imageName,
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
        feedImagePath: res['image'],
        imageName: res['imagename'],
        writeTime: DateTime.parse(res['writetime']),
        feedState: res['state'],
        reply: res['reply']);
  }

  // factory Feed.detailFromMap(Map<String, dynamic> res, String id, String name) {
  //   return Feed(
  //       feedName: id,
  //       authorEMail: res['writer'],
  //       userName: name,
  //       content: res['content'],
  //       feedImagePath: res['image'],
  //       imageName: res['imagename'],
  //       writeTime: DateTime.parse(res['writetime']),
  //       feedState: res['state'],
  //       reply: res['reply']);
  // }
}
