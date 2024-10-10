import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/reply.dart';
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class FeedDetail extends StatelessWidget {
  FeedDetail({super.key});

  final GetStorage box = GetStorage();
  final TextEditingController replyController = TextEditingController();

  final Feed feedValue = Get.arguments ?? "__";
  final feedHandler = Get.put(FeedHandler());

  @override
  Widget build(BuildContext context) {
    feedHandler.detailFeed(feedValue.feedName!);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'), // 배경 이미지
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(
          () => Center(
            child: Padding(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${feedHandler.curFeed[0].userName}님"),
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
                                        : const SizedBox.shrink(),
                                    IconButton(
                                      onPressed: () {
                                        // 신고 로직
                                      },
                                      icon: const Icon(
                                        Icons.report_problem,
                                        color:
                                            Color.fromARGB(255, 220, 184, 23),
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
                        child:
                            Image.network(feedHandler.curFeed[0].feedImagePath),
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
      ),
    );
  }

  // --- Functions ---
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
                TextField(
                  controller: replyController,
                  decoration: const InputDecoration(
                    labelText: '댓글을 입력해주세요',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    // 추가 로직 미구현
                    feedHandler.addReply(
                        feedValue.feedName!, replyController.text);
                    replyController.clear();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Function ---
  Widget replyList(Reply reply) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reply.userName!),
            Text(reply.content),
          ],
        ),
        reply.authorEMail == box.read('pureme_id')
            ? IconButton(
                onPressed: () {
                  feedHandler.deleteReply(feedValue.feedName!, reply.index);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget buildReplyList(List<Reply> replies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: feedHandler.showReplyList
          .where((reply) => reply.replyState == '게시') // state가 '게시'인 reply만 필터링
          .map((reply) => replyList(reply))
          .toList(),
    );
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
} // End
