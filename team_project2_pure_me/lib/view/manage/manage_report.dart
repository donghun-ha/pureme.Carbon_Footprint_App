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
      body: GetBuilder<Vmhandler>(
        builder: (controller) {
          return FutureBuilder(
            future: vmhandler.queryReportAll(), 
            builder: (context, snapshot) {
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
                              onTap: ()=> vmhandler.ReportFeedChanged(index),
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