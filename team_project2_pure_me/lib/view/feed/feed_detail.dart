import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:like_button/like_button.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/reply.dart';
import 'package:team_project2_pure_me/vm/convert/convert_email_to_name.dart';
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class FeedDetail extends StatelessWidget {
  FeedDetail({super.key});

  final GetStorage box = GetStorage();

  ///박상범 수정
  final TextEditingController reportController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  final Feed feedValue = Get.arguments ?? "__";
  final feedHandler = Get.put(FeedHandler());

  final ConvertEmailToName convertEmailToName = ConvertEmailToName();

  @override
  Widget build(BuildContext context) {
    // 초기 값을 위한 기본 피드 데이터
    feedHandler.curFeed.value = [feedValue];
    // 자세한 피드 데이터를 위한 검색 기능
    feedHandler.detailFeed(feedValue.feedName!);
    // 피드의 좋아요 정보 가져오기
    feedHandler.getFeedLike();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'),
        ),
      ),
      child: Obx(
        () => Center(
          child: feedHandler.curFeed.isEmpty
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(25, 100, 25, 25),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Card(
                      elevation: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => Get.back(),
                                          icon: const Icon(
                                              Icons.arrow_back_ios_new),
                                        ),
                                        Text(
                                            "${feedHandler.curFeed[0].userName}님"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        // 로그인한 이용자와 게시글의 작성자가 같을경우 보이게
                                        box.read("pureme_id") ==
                                                feedValue.authorEMail
                                            ? IconButton(
                                                onPressed: () {
                                                  // 삭제로직
                                                  deleteAlert();
                                                },
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  ///박상범 수정
                                                  reportAlart();
                                                },
                                                icon: const Icon(
                                                  Icons.report_problem,
                                                  color: Color.fromARGB(
                                                      255, 220, 184, 23),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.21,
                            color: Colors.grey[300],
                            child: Image.network(
                                feedHandler.curFeed[0].feedImagePath),
                          ),
                          Text(
                            '${feedHandler.curFeed[0].writeTime.year}-${feedHandler.curFeed[0].writeTime.month.toString().padLeft(2, '0')}-${feedHandler.curFeed[0].writeTime.day.toString().padLeft(2, '0')} ${feedHandler.curFeed[0].writeTime.hour.toString().padLeft(2, '0')}:${feedHandler.curFeed[0].writeTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '게시물 작성 내용 : ${feedHandler.curFeed[0].content}',
                            softWrap: true, // 자동 줄바꿈 활성화 (기본값이 true)
                            overflow: TextOverflow.visible, // 텍스트가 잘리지 않도록 설정
                          ),
                          Row(
                            // 하트랑 댓글 들어갈 자리
                            children: [
                              LikeButton(
                                likeCount:
                                    feedHandler.likeCount.value, // 값을 받아와야함
                                isLiked: feedHandler.isLike.value, // 값을 받아와야함
                                onTap: feedHandler.onLikeButtonTapped,
                              ),
                              IconButton(
                                onPressed: () =>
                                    replyBottomSheet(context, feedHandler),
                                icon: const Icon(Icons.mode_comment_rounded),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: feedHandler.showReplyList.isEmpty
                                ? const Text("첫 댓글을 작성해보세요!")
                                : Text(
                                    '${feedHandler.showReplyList[feedHandler.showReplyList.length - 1].userName}\n${feedHandler.showReplyList[feedHandler.showReplyList.length - 1].content}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // --- Functions ---
  /// 피드의 댓글 시트
  replyBottomSheet(context, FeedHandler feedHandler) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Center(
                    child: Text(
                      '댓글',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      buildReplyList(feedHandler.replyList),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 340,
                      child: TextField(
                        controller: replyController,
                        decoration: const InputDecoration(
                          labelText: '댓글을 입력해주세요',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          insertReply();
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => insertReply(),
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).then(
      (value) {
        feedHandler.isReply.value = true;
        feedHandler.replyIndex.value = 0;
        replyController.clear();
      },
    );
  }

  // --- Function ---

  // 댓글 생성
  Widget replyList(Reply reply) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 댓글
        GestureDetector(
          onTap: () {
            feedHandler.isReply.value = false;
            feedHandler.replyIndex.value = reply.index;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reply.userName!),
                  Text(reply.content),
                  // IconButton(
                  //   onPressed: () {
                  //     print(reply.reply);
                  //   },
                  //   icon: const Icon(Icons.circle),
                  // ),
                ],
              ),
              reply.authorEMail == box.read('pureme_id')
                  ? IconButton(
                      onPressed: () {
                        feedHandler.deleteReply(
                            feedValue.feedName!, reply.index);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        // 대댓글
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            children: List.generate(
              reply.reply!.length,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(convertEmailToName
                            .changeAction(reply.reply![index]['writer'])),
                        Text(reply.reply![index]['content']),
                      ],
                    ),
                    reply.reply![index]['writer'] == box.read('pureme_id')
                        ? IconButton(
                            onPressed: () {
                              feedHandler.deleteRereply(
                                  feedValue.feedName!, reply.index, index);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 댓글 리스트 생성
  Widget buildReplyList(List<Reply> replies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: feedHandler.showReplyList
          .where((reply) => reply.replyState == '게시') // state가 '게시'인 reply만 필터링
          .map((reply) => replyList(reply))
          .toList(),
    );
  }

  insertReply() {
    if (feedHandler.isReply.value) {
      // 댓글 추가
      feedHandler.addReply(feedValue.feedName!, replyController.text);
      replyController.clear();
    } else {
      // 대댓글 추가
      feedHandler.addReReply(feedValue.feedName!, replyController.text);
      replyController.clear();
    }
  }

  deleteAlert() {
    Get.defaultDialog(
      title: '경고',
      middleText: '게시글을 삭제하시겠습니까?',
      actions: [
        TextButton(
          onPressed: () {
            feedHandler.deleteFeed(feedValue.feedName!);
            Get.back();
            Get.back();
          },
          child: const Text('삭제'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('취소'),
        ),
      ],
    );
  }

  //// 박상범 수정
  reportAlart() {
    Get.defaultDialog(
      title: '게시글 신고',
      middleText: '게시글을 신고하시겠습니까?',
      content: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ////// 다이얼로그 내용
            Text('신고자 : ${box.read("pureme_id")}'),
            const Divider(),
            Text('게시자 eMail : ${feedHandler.curFeed[0].authorEMail}'),
            const Divider(),
            const Text('신고 사유(최대 20)'),
            const SizedBox(
              height: 10,
            ),
            //// 텍스트필드쪽 데코레이션
            Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TextField(
                controller: reportController,
                maxLength: 20,

                /// MySQL의 틀에 맞춰 최대갯수 20개로 제한함
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            /// 신고자 이메일
            String eMail = box.read("pureme_id");
            if (reportController.text.trim().isEmpty) {
              /// null값 처리
              Get.snackbar(
                '경고',
                '신고사유를 입력해주세요',
                backgroundColor: Colors.red,
                colorText: Colors.yellow,
              );
              return;
            }
            String result = await feedHandler.reportFeed(
                eMail, feedValue.feedName!, reportController.text.trim());
            //////// 완료 로직: 텍스트필드 제거
            reportController.clear();
            //// 신고는 한게시글당 하나만 가능하기 때문에 그를 위한 로직
            if (result == 'OK') {
              Get.back();
              Get.back();

              /// 신고하면 그즉시 피드화면으로 나가지도록 로직 구현
              reportComplete();
            } else {
              Get.back();
              reportFailed();
            }
          },
          child: const Text('신고'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('취소'),
        ),
      ],
    );
  }

  /// 신고 성공시 띄우는 Dialog
  reportComplete() {
    Get.defaultDialog(
      title: '신고 완료',
      middleText: '정상적으로 신고되었습니다.',
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }

  /// 신고 실패시 띄우는 Dialog
  reportFailed() {
    Get.defaultDialog(
      title: '신고 실패',
      middleText: '이전에 한번 신고하셨습니다.',
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
} // End
