import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';

class ManageReport extends StatelessWidget {
  ManageReport({super.key});

  final vmhandler = Get.put(Vmhandler());

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("안녕하세요"),
      ),
            //// update()를 위한 겟빌더
      body: GetBuilder<Vmhandler>(
        builder: (controller) {
              //// DB에서 async처리를 위한 FutureBuilder
          return FutureBuilder(
            future: vmhandler.queryReportcount(), 
            builder: (context, snapshot) {
              /// if문: 예외처리
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError){
                return Center(child: Text("Error : ${snapshot.error}"),);
              } else{
                return Obx(
                  () {
                    return Column(
                      children: [
                        SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: ListView.builder(
                          itemCount: vmhandler.reportFeedCountList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              /// 선택기능을 위한 GestureDetector,
                              ///  vmhandler.reportFeedIndex와
                              /// vmhandler.reportFeedListById가 바뀜.
                              onTap: ()=> vmhandler.reportFeedIndexChanged(index),
                              child: Card(
                                child: Text(
                                    "${vmhandler.reportFeedCountList[index].feedId} : ${vmhandler.reportFeedCountList[index].feed_count}"
                                  ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: ListView.builder(
                          itemCount: vmhandler.reportFeedListById.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Text(
                                "${vmhandler.reportFeedListById[index].reportReason}"
                              ),
                            );
                          },
                        ),
                      )

                      ],
                    );
                  },
                );
              }

            },
          );
        },
      ),
    );
  }
}