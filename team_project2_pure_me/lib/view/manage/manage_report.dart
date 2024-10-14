import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/view/manage/manage_feed_detial.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageReport extends StatelessWidget {
  ManageReport({super.key});

  final vmhandler = Get.put(ManageHandler());

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/main_background_plain.png',
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Report 관리',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.transparent,
              ),
              //// update()를 위한 겟빌더
              body: GetBuilder<ManageHandler>(
                builder: (controller) {
                  //// DB에서 async처리를 위한 FutureBuilder
                  return FutureBuilder(
                    future: vmhandler.queryReportcount(),
                    builder: (context, snapshot) {
                      /// if문: 예외처리
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error : ${snapshot.error}"),
                        );
                      } else {
                        return Obx(
                          () {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: vmhandler.rptCountAmount,
                                      onChanged: (value) =>
                                          vmhandler.rptCountAmountChanged(value!),
                                    ),
                                    const Text('신고수 : 1'),
                                    Radio(
                                      value: 10,
                                      groupValue: vmhandler.rptCountAmount,
                                      onChanged: (value) =>
                                          vmhandler.rptCountAmountChanged(value!),
                                    ),
                                    const Text('신고수 : 10'),
                                    Radio(
                                      value: 50,
                                      groupValue: vmhandler.rptCountAmount,
                                      onChanged: (value) =>
                                          vmhandler.rptCountAmountChanged(value!),
                                    ),
                                    const Text('신고수 : 50'),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: ListView.builder(
                                    itemCount:
                                        vmhandler.reportFeedCountList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: vmhandler.reportFeedIndex == index ? Colors.blue : Colors.transparent, 
                                                  width: 2.0,
                                                ),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            child: ListTile(
                                              onTap: () => vmhandler.reportFeedIndexChanged(index),
                                              title: Text("feed Id :${ vmhandler.reportFeedCountList[index].feedId}, 신고 횟수: ${vmhandler.reportFeedCountList[index].feed_count}"),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: ListView.builder(
                                    itemCount:
                                        vmhandler.reportFeedListById.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Text(
                                            '신고 내용:  ${vmhandler.reportFeedListById[index].reportReason}      신고자 : ${vmhandler.reportFeedListById[index].user_eMail}'),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          // String email =
                                          //     await box.read('manager');
                                          if (vmhandler.reportFeedIndex != null) {
                                            Feed feed = await vmhandler.test();
                                            print(feed.authorEMail);
                                            Get.to(() => ManageFeedDetail(),
                                                arguments: feed);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber[50]
                                        ),
                                        child: const Text("게시글 보러 가기")),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          String email =
                                              await box.read('manager');
                                          if (vmhandler.reportFeedIndex != null) {
                                            vmhandler.reportFeed(
                                                vmhandler
                                                    .reportFeedCountList[vmhandler
                                                        .reportFeedIndex!]
                                                    .feedId,
                                                email,
                                                '숨김');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber[50]
                                        ),
                                        child: const Text("게시글 숨김 처리")),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
