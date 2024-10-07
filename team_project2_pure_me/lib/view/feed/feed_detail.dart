import 'package:flutter/material.dart';

class FeedDetail extends StatelessWidget {
  const FeedDetail({super.key});

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
      ),
    );
  }
}
