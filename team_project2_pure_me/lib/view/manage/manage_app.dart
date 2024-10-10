import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageApp extends StatelessWidget {
  ManageApp({super.key});

  final vmhandler = Get.put(ManageHandler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("안녕하세요"),
        ),

        /// update 추적을 위한 겟빌더
        body: GetBuilder<ManageHandler>(builder: (controller) {
          //// async를 위한 퓨처빌더
          return FutureBuilder(

              ///signInUserList, madeFeedList 를 가져오는 함수
              future: vmhandler.fetchAppManage(),
              builder: (ccc, snapshot) {
                //// if문: 예외처리들
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                } else {
                  return Column(
                    children: [
                      /// List observing을 위한 Obx, Listview당 하나.
                      Obx(() {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView.builder(
                            ////
                            itemCount: vmhandler
                                .signInUserList.length, //// 일, 주, 월간 사용자 생성 평균
                            itemBuilder: (context, index) {
                              return Text("${vmhandler.signInUserList[index]}");
                            },
                          ),
                        );
                      }),
                      Obx(() {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView.builder(
                            itemCount: vmhandler
                                .madeFeedList.length, //// 일, 주, 월간 사용자 피드 수 평균
                            itemBuilder: (context, index) {
                              return Text("${vmhandler.madeFeedList[index]}");
                            },
                          ),
                        );
                      }),
                    ],
                  );
                }
              });
        }));
  }
}
