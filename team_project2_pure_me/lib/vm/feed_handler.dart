import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/reply.dart';
import 'package:team_project2_pure_me/vm/convert/convert_email_to_name.dart';
import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/image_handler.dart';

class FeedHandler extends ImageHandler {
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
  final GetStorage box = GetStorage();
  final ConvertEmailToName convertEmailToName = ConvertEmailToName();

  final CollectionReference feed =
      FirebaseFirestore.instance.collection('post');

  /// feedHome화면에서 쓸 feedList
  final feedList = <Feed>[].obs;

  /// detailFeed
  final curFeed = <Feed>[].obs;

  /// feedDetail화면에서 쓸 replyList
  final replyList = <Reply>[].obs;
  final showReplyList = <Reply>[].obs;

  /// 대댓글을 작성할 reply의 index
  final replyIndex = 0.obs;

  /// 대댓글과 댓글의 구분을 위함
  final isReply = true.obs;

  /// user 화면에 보일 FeedList
  final userFeedList = <Feed>[].obs;

  /// feed의 좋아요
  final isLike = true.obs; // 좋아요 상태
  final likeCount = 0.obs; // 좋아요 수

  @override
  void onInit() {
    super.onInit();
    fetchFeed();
  }

  fetchFeed() {
    feed
        .where('state', isEqualTo: '게시')
        .orderBy('writetime', descending: true)
        .snapshots()
        .listen(
      (event) {
        feedList.value = event.docs
            .map(
              (doc) => Feed.fromMap(doc.data() as Map<String, dynamic>, doc.id),
            )
            .toList();
        userFeedList.value = feedList
            .where((feed) => feed.authorEMail == box.read('pureme_id'))
            .toList();
      },
    );
  }

  /// 좋아요 버튼 작동시
  ///
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    // !isLiked 가 true 일때 1추가
    // !isLiked 가 false 일때 -1추가
    // print(!isLiked);
    // print(curFeed[0].feedName);
    // print(box.read('pureme_id'));
    int changeLike = isLiked ? -1 : 1;

    var url = Uri.parse(
        "$baseUrl/feed/updateLike?feedId=${curFeed[0].feedName}&userEmail=${box.read('pureme_id')}&heart=$changeLike");
    // ignore: unused_local_variable
    final response = await http.get(url); // GET 요청
    getFeedLike();
    return !isLiked;
  }

  /// 좋아요 정보 가져오기
  ///
  Future<void> getFeedLike() async {
    var url = Uri.parse(
        "$baseUrl/feed/getFeedLike?feedId=${curFeed[0].feedName}&userEmail=${box.read('pureme_id')}");
    final response = await http.get(url); // GET 요청
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    // [유저 아이디, 유저의 좋아요 상태 (null,0,false,true), 전체 좋아요 수]
    var result = dataConvertedJSON['result'];

    isLike.value = result[1] > 0 ? true : false;
    likeCount.value = result[2] ?? 0;
  }

  /// 피드 추가
  ///
  addFeed(String content) async {
    String imageName = '${DateTime.now().toString().replaceAll(' ', 'T')}.png';
    String image = await preparingImage(imageName);

    // firebase의 students에 추가
    FirebaseFirestore.instance.collection('post').add({
      'writer': box.read('pureme_id'),
      'state': '게시',
      'content': content,
      'writetime':
          DateTime.now().toString().substring(0, 19).replaceFirst(' ', 'T'),
      'reply': [],
      'image': image,
      'imagename': imageName,
    });
  }

  /// 피드 추가시 사진추가 밑 사진주소 가져오기
  ///
  preparingImage(String imageName) async {
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('image/') // 폴더 이름
        .child(imageName);
    await firebaseStorage.putFile(imgFile!); // 이미지 저장

    String downloadURL = await firebaseStorage.getDownloadURL();
    return downloadURL;
  }

  /// 피드 상새내용
  /// argument = docId
  detailFeed(String docId) async {
    await convertEmailToName.getUserName();

    feed.doc(docId).snapshots().listen(
      (event) {
        // print(event);
        // 피드 객체 생성
        curFeed.value = [
          Feed.fromMap(event.data() as Map<String, dynamic>, docId)
        ];
        // 피드 유저 이메일 -> 이름으로 변환
        curFeed[0].userName =
            convertEmailToName.changeAction(curFeed[0].authorEMail);

        // 댓글 리스트 추가 및 댓글 작성자 이메일 -> 이름
        replyList.clear();
        for (int i = 0; i < curFeed[0].reply!.length; i++) {
          replyList.add(Reply.fromMap(curFeed[0].reply![i], i));
          replyList[i].userName =
              convertEmailToName.changeAction(replyList[i].authorEMail);
        }

        // 상태가 게시인 리스트만
        showReplyList.value = replyList
            .where(
                (reply) => reply.replyState == '게시') // state가 '게시'인 reply만 필터링
            .map((reply) => (reply))
            .toList();
      },
    );
  }

  /// 피드 삭제
  /// state를 삭제로 변경

  deleteFeed(String docId) {
    feed.doc(docId).update({'state': '삭제'});
  }

  //// 박상범 추가, Feed를 Report함
  reportFeed(String eMail, String docId, String reportReason) async {
    var url = Uri.parse(
        "$baseUrl/feed/updateReport?feedId=$docId&userEmail=$eMail&reportReason=$reportReason");
    final response = await http.get(url); // GET 요청
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    return result;
  }

  /// 댓글 추가
  /// argument = docId 댓글 작성위치
  /// content = 댓글 내용
  addReply(String docId, String content) {
    Map<String, dynamic> newData = {
      'content': content,
      'state': '게시',
      'writer': box.read('pureme_id'),
      'reply': [],
      'writetime':
          DateTime.now().toString().substring(0, 19).replaceFirst(' ', 'T'),
    };
    feed.doc(docId).update({
      'reply': FieldValue.arrayUnion([newData]) // 리스트에 Map 추가
    });
  }

  /// 댓글 삭제
  /// state변경
  deleteReply(String docId, int index) {
    curFeed[0].reply![index]['state'] = '삭제';
    feed.doc(docId).update({'reply': curFeed[0].reply});
  }

  /// 대댓글
  addReReply(String docId, String content) {
    Map<String, dynamic> newData = {
      'content': content,
      'state': '게시',
      'writer': box.read('pureme_id'),
      'writetime':
          DateTime.now().toString().substring(0, 19).replaceFirst(' ', 'T'),
    };

    // reply[index]
    print(curFeed[0].reply![replyIndex.value]['reply']);
    curFeed[0].reply![replyIndex.value]['reply'].add(newData);

    feed.doc(docId).update({
      'reply': curFeed[0].reply! // 리스트에 Map 추가
    });
  }

  /// 대댓글 삭제
  deleteRereply(String docId, int reIndex, int rereIndex) {
    curFeed[0].reply![reIndex]['reply'].removeAt(rereIndex);
    feed.doc(docId).update({'reply': curFeed[0].reply});
  }
}
