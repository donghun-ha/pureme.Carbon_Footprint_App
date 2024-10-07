import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';

class FeedDetail extends StatelessWidget {
  FeedDetail({super.key});

  final Feed feedValue = Get.arguments ?? "__";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'), // 배경 이미지
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        // 피드 가져오는 함수: fetchFeedDetail(),
        // 피드가 담겨있는 변수 : curFeed

        // 좋아요 가져오는 함수: fetchLike
        // 좋아요 상태 관리하는 변수 : curFeedLike
        // 좋아요 상태 변경하는 함수 : changelLike
        // 신고 추가해주는 함수 // 추후 추가예정
        // 댓글 리스트 불러오는 함수 : fetchReply()
        // 댓글 insert해주는 함수 : insertReply(String content(내용))
        body: Center(
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
                              Text("${feedValue.authorEMail}님"),
                              Row(
                                children: [
                                  // 로그인한 이용자와 게시글의 작성자가 같을경우 보이게
                                  IconButton(
                                    onPressed: () {
                                      // 삭제로직
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // 신고 로직
                                    },
                                    icon: const Icon(
                                      Icons.report_problem,
                                      color: Color.fromARGB(255, 220, 184, 23),
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
                      child: Image.network(feedValue.feedImageName),
                    ),
                    Text(
                      '${feedValue.writeTime.year}-${feedValue.writeTime.month.toString().padLeft(2, '0')}-${feedValue.writeTime.day.toString().padLeft(2, '0')} ${feedValue.writeTime.hour.toString().padLeft(2, '0')}:${feedValue.writeTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '게시물 작성 내용 : ${feedValue.content}',
                      softWrap: true, // 자동 줄바꿈 활성화 (기본값이 true)
                      overflow: TextOverflow.visible, // 텍스트가 잘리지 않도록 설정
                    ),
                    Row(
                        // 하트랑 댓글 들어갈 자리
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                          '${feedValue.reply![0]['writer']}\n${feedValue.reply![0]['content']}'),
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
}
