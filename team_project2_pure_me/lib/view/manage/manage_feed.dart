import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/view/manage/manage_feed_detial.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageFeed extends StatelessWidget {
  const ManageFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final vmhandler = Get.put(ManageHandler());
    final searchController = TextEditingController();



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
                'Feed 관리',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
            ),
            //// update()를 위한 겟빌더
            body: GetBuilder<ManageHandler>(builder: (context) {
              /// async처리를 위한 퓨처빌더
              return SingleChildScrollView(
                child: FutureBuilder(
                    future: vmhandler.fetchFeeds(),
                    builder: (context, snapshot) {
                      // if문: 예외처리
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(
                                      value: 0, 
                                      groupValue: vmhandler.radioFeedIndex, 
                                      onChanged: (value) {
                                        vmhandler.feedRadioChanged(value);                                       
                                      },
                                    ),
                                    const Text("게시"),
                                    Radio(
                                      value: 1, 
                                      groupValue: vmhandler.radioFeedIndex, 
                                      onChanged: (value) {
                                        vmhandler.feedRadioChanged(value);                                       
                                      },
                                    ),
                                    const Text("숨김"),
                                    Radio(
                                      value: 2, 
                                      groupValue: vmhandler.radioFeedIndex, 
                                      onChanged: (value) {
                                        vmhandler.feedRadioChanged(value);                                       
                                      },
                                    ),
                                    const Text("삭제"),
                                  ],
                                ),
                                TextField(
                                  controller: searchController,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: ListView.builder(
                                    itemCount: vmhandler.searchFeedList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            vmhandler.changeFeedIndex(index);
                                          },
                                          child: Card(
                                            child: Text('작성자 : ${vmhandler.searchFeedList[index].authorEMail}'),
                                          ));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: vmhandler.searchFeedIndex != null
                                      ? ElevatedButton(
                                        onPressed: (){
                                          Get.to(()=> ManageFeedDetail(), arguments: vmhandler.searchFeedList[vmhandler.searchFeedIndex!]);
                                        }, 
                                        child: const Text("게시글 보기")
                                      )
                                      : null,
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: vmhandler.searchFeedIndex != null
                                      ? ElevatedButton(
                                        onPressed: (){
                                          deleteAlert(vmhandler);
                                        }, 
                                        child: const Text("게시글 처리하기")
                                      )
                                      : null,
                                )
                              ],
                            );
                          },
                        );
                      }
                    }),
              );
            }),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  deleteAlert(ManageHandler vmhandler) {
    Get.defaultDialog(
      title: '게시글 처리',
      middleText: '게시글 상태를 골라주십시오.',
      actions: [
        GetBuilder<ManageHandler>(
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(value: 0, groupValue: vmhandler.radioChangeFeedIndex, onChanged: (value)=> vmhandler.dailogFeedRadioChanged(value)),
                const Text("게시"),
                Radio(value: 1, groupValue: vmhandler.radioChangeFeedIndex, onChanged: (value) => vmhandler.dailogFeedRadioChanged(value)),
                const Text("숨김"),
                Radio(value: 2, groupValue: vmhandler.radioChangeFeedIndex, onChanged: (value) => vmhandler.dailogFeedRadioChanged(value)),
                const Text("삭제"),
              ],
            );
          }
        ),
        TextButton(
          onPressed: ()async {
            final box = GetStorage();
            String manager_manageEMail = await box.read('manager');
            if(vmhandler.radioChangeFeedIndex == 0){
              vmhandler.revealFeed(vmhandler.searchFeedList[vmhandler.searchFeedIndex!].feedName!, manager_manageEMail, '게시');
            }else
            if(vmhandler.radioChangeFeedIndex == 1){
              vmhandler.reportFeed(vmhandler.searchFeedList[vmhandler.searchFeedIndex!].feedName!, manager_manageEMail, '숨김');
            }else
            if(vmhandler.radioChangeFeedIndex == 2){
              vmhandler.deleteFeed(vmhandler.searchFeedList[vmhandler.searchFeedIndex!].feedName!, manager_manageEMail, '삭제');
            }
            Get.back();
            vmhandler.dailogFeedRadioChanged(0);
          },
          child: const Text('처리'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('취소'),
        ),
      ],
    );
  }

}//End