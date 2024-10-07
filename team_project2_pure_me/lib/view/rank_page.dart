import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/rank_handler.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/view/background_green.dart';

class RankPage extends StatelessWidget {
  final RankHandler rankHandler = Get.find<RankHandler>();

  RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundGreen(
      content: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Ranking'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: rankHandler.refreshRankings,
          child: Column(
            children: [
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: rankHandler.rankList.length,
                      itemBuilder: (context, index) {
                        User user = rankHandler.rankList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                              backgroundColor: _getRankColor(index),
                            ),
                            title: Text(user.nickName),
                            subtitle: Text('Points: ${user.point}'),
                            trailing: user.profileImage != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.profileImage!))
                                : null,
                          ),
                        );
                      },
                    )),
              ),
              Obx(() => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Your Rank: ${rankHandler.myrank}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey[300]!;
      case 2:
        return Colors.brown[300]!;
      default:
        return Colors.blue[100]!;
    }
  }
}
