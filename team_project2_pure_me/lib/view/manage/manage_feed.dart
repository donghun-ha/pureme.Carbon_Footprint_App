import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                                TextField(
                                  controller: searchController,
                                ),
                                IconButton(
                                    onPressed: () {
                                      /// 더미데이터. 어떤식으로 검색할지 정해야됨.
                                      /// 지금상황에선 검색기능이 제대로 작동하지않음.
                                      updateSearchFeedWord(
                                          searchController.text);
                                    },
                                    icon: const Icon(Icons.search)),
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
                                            child: Text(vmhandler
                                                .searchFeedList[index].content),
                                          ));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: vmhandler.searchFeedIndex != null
                                      ? Text(vmhandler
                                          .searchFeedList[
                                              vmhandler.searchFeedIndex!]
                                          .content)
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

  updateSearchFeedWord(String text) async {
    // await updateSearchFeedWord(text);
  }
}//End