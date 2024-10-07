import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/reply.dart';

import 'package:team_project2_pure_me/vm/calc_handler.dart';

class FeedHandler extends CalcHandler {
  var feedList = <Feed>[].obs;
  final CollectionReference _feed =
      FirebaseFirestore.instance.collection('post');

  /// feedHome화면에서 쓸 feedList
  List<Reply> replyList = <Reply>[].obs;

  /// feedDetail화면에서 쓸 replyList

  Feed curFeed = Feed(
      feedName: '', // 작성된 feed의 Name
      authorEMail: '', // 작성자 이메일
      content: '', // 내용
      feedImageName: '', // 잠시대기
      writeTime: DateTime(0), // ??
      feedState: '게시' // 기본값
      );

  /// feedDetail화면에서 쓸 Feed

  bool curFeedLike = false;

  String? insertImageName;

  @override
  void onInit() {
    super.onInit();
    _feed.orderBy('writetime', descending: true).snapshots().listen(
      (event) {
        feedList.value = event.docs
            .map(
              (doc) => Feed.fromMap(doc.data() as Map<String, dynamic>, doc.id),
            )
            .toList();
      },
    );
  }

//
//
  fetchFeedList() async {
    String curEMail = curUser.value.eMail;

    /// 다른사람의 피드(curEMail 변수 이용)의 "ImageName"들만 가져와서
    /// feedList에 저장하기만 하면됨.
    // feedList.clear();
    //feedList.addAll(iterable);
    // 등으로 넣을 수 있을것 같은데, 자세한건 확인후 추가바람.
  }

  fetchFeedDetail() {
    /// curFeed에 가져온 feed를 추가 후 update()를 불러오기바람
  }

  fetchLike() {
    String curEMail = curUser.value.eMail;
    // 를 이용해서
    /// Liketable에서 좋아요 숫자를 가져오고,
    /// 내가 좋아요를 눌렀는지도 가져오고
    /// 만약 내가 좋아요를 눌렀다면
    /// 좋아요를 눌렀는지에 따라
    /// bool curFeedLike가 바뀌도록
    curFeedLike = false;
    update();
  }

  changeLike(bool value) {
    /// curFeedLike = value
    /// update()
    String curEMail = curUser.value.eMail;

    /// 를 이용해 데이터베이스에도 같이 업데이트한다
  }

  fetchReply(String id) {
    // fetchFeedList() 와 비슷하게
    /// firebase의 reply에서 reply을 가져온 다움
    /// Reply.fromMap 등을 이용해서 List<Reply>의 형태로 정리한 후
    // replyList.clear();
    //replyList.addAll(iterable);
    //등을 이용해서 replyList를 변형시킨다.
  }

  insertReply(String content) {
    Reply(
        feedName: curFeed.feedName!, // 현재 피드의 이름
        authorEMail: curUser.value.eMail, // 현재 유저의 이메일
        content: content,
        writeTime: DateTime.now(),
        replyState: 0 //기본값
        );
    //를 firebase에 추가하고
    // 추가한 다음 fetchReply()를 다시 불러올 것
  }

  insertFeed(String content) {
    Feed(
        authorEMail: curUser.value.eMail,
        content: content,
        feedImageName: insertImageName!,
        writeTime: DateTime.now(),
        feedState: '게시');

    ///를 firebase에 추가하고
    ///추가한 다음에 insertImageName을 null로 변경할 것.
  }

  feedImagePikcer() {
    // 이미지피커 함수
    // 이미지피커를 한 다음에
    // insertImageName을 추가로 update할것
  }
}
