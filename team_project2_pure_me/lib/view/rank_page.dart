import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RankHandler rankHandler = Get.put(RankHandler());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 랭킹 리스트
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50), // 진한 초록색 배경
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/ranking.png',
                                width: 35, height: 35),
                            const SizedBox(width: 15),
                            const Text(
                              '이번달 환경지킴이 랭킹',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rankHandler.rankList.length > 10
                                ? 10
                                : rankHandler.rankList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final user = rankHandler.rankList[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getColor(index),
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(user.nickName),
                                trailing: Text('${(user.point)} KG',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              );
                            },
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 내 랭킹 정보
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('내 랭킹: ${rankHandler.myrank.value}위',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              '절감량: ${rankHandler.rankList.isNotEmpty && rankHandler.myrank.value > 0 && rankHandler.myrank.value <= rankHandler.rankList.length ? rankHandler.rankList[rankHandler.myrank.value - 1].point : 0}KG',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFCC00);
      case 1:
        return const Color(0xFFC0C0C0);
      case 2:
        return Colors.brown[300]!;
      default:
        return Colors.blue[100]!;
    }
  }
}
