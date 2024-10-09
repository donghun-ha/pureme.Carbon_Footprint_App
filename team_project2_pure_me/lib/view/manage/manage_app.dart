import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/vm/manage_handler.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';

class ManageApp extends StatelessWidget {
  ManageApp({super.key});

  final vmhandler = Get.put(ManageHandler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("안녕하세요"),
      ),
      body: GetBuilder<ManageHandler>(
        builder: (controller) {
          return FutureBuilder(
            future: vmhandler.fetchAppManage(),
            builder: (ccc, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError){
                return Center(child: Text("Error : ${snapshot.error}"),);
              } else{
              return Column(
                children: [
                  Obx(
                    () {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: ListView.builder(
                          itemCount: vmhandler.signInUserList.length,
                          itemBuilder: (context, index) {
                            return Text("${vmhandler.signInUserList[index]}");
                          },
                        ),
                      );
                    }
                  ),
                  Obx(
                    () {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: ListView.builder(
                          itemCount: vmhandler.madeFeedList.length,
                          itemBuilder: (context, index) {
                            return Text("${vmhandler.madeFeedList[index]}");
                          },
                        ),
                      );
                    }
                  ),
                ],
              );
            }
            }
          );
        }
      )
    );
  }
}