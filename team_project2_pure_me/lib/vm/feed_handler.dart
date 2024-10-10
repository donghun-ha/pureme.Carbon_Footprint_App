import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/reply.dart';
import 'package:team_project2_pure_me/vm/convert/convert_email_to_name.dart';

import 'package:team_project2_pure_me/vm/image_handler.dart';

class FeedHandler extends ImageHandler {
  final GetStorage box = GetStorage();
  final ConvertEmailToName convertEmailToName = ConvertEmailToName();

  final CollectionReference _feed =
      FirebaseFirestore.instance.collection('post');

  /// feedHome화면에서 쓸 feedList
  final feedList = <Feed>[].obs;

  /// detailFeed
  final curFeed = <Feed>[
    Feed(
        authorEMail: '',
        content: '',
        feedImagePath: '',
        imageName: '',
        writeTime: DateTime.now(),
        reply: [
          {
            'writer': '',
            'content': '',
          },
        ],
        feedState: '')
  ].obs;

  /// feedDetail화면에서 쓸 replyList
  final replyList = <Reply>[].obs;
  final showReplyList = <Reply>[].obs;

  /// user 화면에 보일 FeedList
  final userFeedList = <Feed>[].obs;

  @override
  void onInit() {
    super.onInit();
    _feed
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
  detailFeed(String docId) {
    convertEmailToName.getUserName();

    _feed.doc(docId).snapshots().listen(
      (event) {
        // print(event);
        curFeed.value = [
          Feed.fromMap(event.data() as Map<String, dynamic>, docId)
        ];
        curFeed[0].userName =
            convertEmailToName.changeAction(curFeed[0].authorEMail);
        // replyList.value =
        //     curFeed[0].reply!.map((e) => Reply.fromMap(e)).toList();
        replyList.clear();
        for (int i = 0; i < curFeed[0].reply!.length; i++) {
          replyList.add(Reply.fromMap(curFeed[0].reply![i], i));
          replyList[i].userName =
              convertEmailToName.changeAction(replyList[i].authorEMail);
        }
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
    _feed.doc(docId).update({'state': '삭제'});
  }

  /// 댓글 추가
  /// argument = docId 댓글 작성위치
  /// content = 댓글 내용
  addReply(String docId, String content) {
    Map<String, dynamic> newData = {
      'content': content,
      'state': '게시',
      'writer': box.read('pureme_id'),
      'writetime':
          DateTime.now().toString().substring(0, 19).replaceFirst(' ', 'T'),
    };
    _feed.doc(docId).update({
      'reply': FieldValue.arrayUnion([newData]) // 리스트에 Map 추가
    });
  }

  /// 댓글 삭제
  /// state변경
  deleteReply(String docId, int index) {
    curFeed[0].reply![index]['state'] = '삭제';
    _feed.doc(docId).update({'reply': curFeed[0].reply});
  }
}
