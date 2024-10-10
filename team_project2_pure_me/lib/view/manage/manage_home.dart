import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/view/manage/manage_app.dart';
import 'package:team_project2_pure_me/view/manage/manage_feed.dart';
import 'package:team_project2_pure_me/view/manage/manage_report.dart';
import 'package:team_project2_pure_me/view/manage/manage_user.dart';

class ManageHome extends StatelessWidget {
  const ManageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => Get.to(() => ManageApp()),
                child: const Text("앱")),
            ElevatedButton(
                onPressed: () => Get.to(() => const ManageFeed()),
                child: const Text("피드")),
            ElevatedButton(
                onPressed: () => Get.to(() => ManageUser()),
                child: const Text("유저")),
            ElevatedButton(
                onPressed: () => Get.to(() => ManageReport()),
                child: const Text("신고")),
            ElevatedButton(
                onPressed: () {
                  //
                },
                child: const Text("테스트1")),
            ElevatedButton(
                onPressed: () {
                  //
                },
                child: const Text("테스트2")),
          ],
        ),
      ),
    );
  }
}//End