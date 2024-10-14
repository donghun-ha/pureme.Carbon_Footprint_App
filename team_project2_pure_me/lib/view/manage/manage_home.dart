import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/view/manage/manage_app.dart';
import 'package:team_project2_pure_me/view/manage/manage_feed.dart';
import 'package:team_project2_pure_me/view/manage/manage_report.dart';
import 'package:team_project2_pure_me/view/manage/manage_user.dart';

class ManageHome extends StatelessWidget {
  ManageHome({super.key});

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/main_background_plain.png'),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                '관리자 페이지',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(200, 100),
                        backgroundColor: const Color(0xFFFFEF9D),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.to(() => ManageApp()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'images/app.png',
                            width: 70,
                          ),
                          const Text(
                            'App',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(200, 100),
                        backgroundColor: const Color(0xffFFE454),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.to(() => const ManageFeed()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'images/manageFeed.png',
                            width: 70,
                          ),
                          const Text(
                            'Feed',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(200, 100),
                        backgroundColor: const Color(0xff91C1F5),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.to(() => ManageUser()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'images/manageUser.png',
                            width: 70,
                          ),
                          const Text(
                            'User',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(200, 100),
                        backgroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.to(() => ManageReport()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'images/manageReport.png',
                            width: 70,
                          ),
                          const Text(
                            'Report',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}//End