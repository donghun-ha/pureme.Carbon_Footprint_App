class Reply{
  String? replyName; /// reply의 이름  
  String feedName; /// feed의 이름  
  String authorEMail; /// 작성자 이메일
  String content; /// 내용
  DateTime writeTime; /// 쓴 시간
  int replyState; /// 뭘로할지는 추가예정
  DateTime? deleteTime; /// 삭제된 시간
  DateTime? editTime; /// 수정된 시간

  Reply({
    this.replyName,
    required this.feedName,
    required this.authorEMail,
    required this.content,
    required this.writeTime,
    required this. replyState,
    this.deleteTime,
    this.editTime,
  });

  Reply.fromMap(Map<String, dynamic> res)
  : replyName = res['replyName'],
  feedName = res['feedName'],
  authorEMail = res['authorEMail'],
  content = res['content'],
  writeTime = res['writeTime'],
  replyState = res['replyState'],
  deleteTime = DateTime.parse(res['deleteTime']),
  editTime = DateTime.parse(res['editTime'])
  ;
}
