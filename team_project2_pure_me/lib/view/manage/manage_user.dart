import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageUser extends StatelessWidget {
  ManageUser({super.key});

  final vmhandler = Get.put(ManageHandler());
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("유저 검색"),
      ),
      //// update()를 위한 겟빌더
      body: GetBuilder<ManageHandler>(
        builder: (controller) {
          return Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  vmhandler.searchUserWordchanged(value); /////검색어를 바꿔주는함수
                },
              ),
              //// DB에서 async처리를 위한 FutureBuilder
              FutureBuilder(
                future: vmhandler.searchUser(),

                /// 검색어에 따라 DB에서 끌어오는 함수
                builder: (context, snapshot) {
                  // if절: 예외처리
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error : ${snapshot.error}"),
                    );
                  } else if (snapshot.data == "Noop" ||
                      vmhandler.searchUserList.isEmpty) {
                    return const Text("검색어를 입력해 주십시오");
                  } else {
                    return Obx(() => Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ListView.builder(
                                itemCount: vmhandler.searchUserList.length,
                                itemBuilder: (context, index) {
                                  User curUser =
                                      vmhandler.searchUserList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      /// 특정한 User를 선택하기 위한 함수. vmhandler.searchUserIndex가 update됨
                                      vmhandler.searchUserIndexChanged(index);
                                    },
                                    child: Card(
                                      child: Text(curUser.eMail),
                                    ),
                                  );
                                },
                              ),
                            ),

                            /// 이부분은 필요한 기능에 따라 버튼등을 만들어주세요.
                            SizedBox(
                                child: vmhandler.searchUserIndex != null
                                    ? Card(
                                        child: Text(vmhandler
                                            .searchUserList[
                                                vmhandler.searchUserIndex!]
                                            .eMail),
                                      )
                                    : null),
                          ],
                        ));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
