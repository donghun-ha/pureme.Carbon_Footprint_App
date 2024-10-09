class Reply {
  // String? replyName;

  /// reply의 이름
  // String feedName;

  /// 댓글의 index
  int index;

  /// 작성자 이메일
  String authorEMail;

  /// 댓글 내용
  String content;

  /// 작성 시간
  DateTime writeTime;

  /// 댓글 상태
  String replyState;

  /// 뭘로할지는 추가예정
  /// 삭제된 시간
  DateTime? deleteTime;

  /// 수정된 시간
  DateTime? editTime;

  Reply({
    // this.replyName,
    // required this.feedName,
    required this.index,
    required this.authorEMail,
    required this.content,
    required this.writeTime,
    required this.replyState,
    this.deleteTime,
    this.editTime,
  });

  Reply.fromMap(Map<String, dynamic> res, int replyIndex)
      : index = replyIndex,
        authorEMail = res['writer'],
        content = res['content'],
        writeTime = DateTime.parse(res['writetime']),
        replyState = res['state'];
  // deleteTime = DateTime.parse(res['deleteTime']),
  // editTime = DateTime.parse(res['editTime']);
}
