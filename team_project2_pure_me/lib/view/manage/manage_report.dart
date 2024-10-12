import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                  itemCount:
                                      vmhandler.reportFeedCountList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      /// 선택기능을 위한 GestureDetector,
                                      ///  vmhandler.reportFeedIndex와
                                      /// vmhandler.reportFeedListById가 바뀜.
                                      onTap: () => vmhandler
                                          .reportFeedIndexChanged(index),
                                      child: Card(
                                        child: Text(
                                            "${vmhandler.reportFeedCountList[index].feedId} : ${vmhandler.reportFeedCountList[index].feed_count}"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                  itemCount:
                                      vmhandler.reportFeedListById.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Text('${vmhandler.reportFeedListById[index].reportReason}             신고자 : ${vmhandler.reportFeedListById[index].user_eMail}'),
                                    );
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: ()async{
                                  String email = await box.read('manager');
                                  if(vmhandler.reportFeedIndex != null){
                                    vmhandler.reportFeed(vmhandler.reportFeedCountList[vmhandler.reportFeedIndex!].feedId, email, '숨김');
                                  }
                                },  
                                child: const Text("게시글 숨김 처리")
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
      ],
    );
  }
}
