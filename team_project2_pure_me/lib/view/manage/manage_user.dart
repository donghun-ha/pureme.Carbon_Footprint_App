import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageUser extends StatelessWidget {
  ManageUser({super.key});

  final vmhandler = Get.put(ManageHandler());
  final _searchController = TextEditingController();

  final box = GetStorage();

  final reportReasonController = TextEditingController();

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
                'USER 관리',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: ListView.builder(
                                      itemCount:
                                          vmhandler.searchUserList.length,
                                      itemBuilder: (context, index) {
                                        User curUser =
                                            vmhandler.searchUserList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            /// 특정한 User를 선택하기 위한 함수. vmhandler.searchUserIndex가 update됨
                                            vmhandler
                                                .searchUserIndexChanged(index);
                                          },
                                          child: Card(
                                            child: Text(curUser.eMail),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      child: vmhandler.searchUserIndex != null
                                          ? 
                                          Card(
                                              child: 
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child:
                                                        vmhandler.searchUserList[vmhandler.searchUserIndex!].profileImage == null 
                                                          ? CircleAvatar(
                                                            radius: 50,
                                                            foregroundImage: AssetImage("images/co2.png"),
                                                            )
                                                          : FutureBuilder(
                                                            future: vmhandler.fetchImage(vmhandler.searchUserList[vmhandler.searchUserIndex!].profileImage!),
                                                            builder: (context,snapshot) {
                                                              if (snapshot.hasData){
                                                                return CircleAvatar(
                                                                  radius: 50,
                                                                  foregroundImage: MemoryImage(snapshot.data!),
                                                                  );
                                                              }else{
                                                                return SizedBox();
                                                              }
                                                              
                                                            }
                                                          ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('eMail: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].eMail}'),
                                                          Text('Phone: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].phone}'),
                                                          Text('생성일: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].createDate.toString().substring(0,10)}'),
                                                          Text('포인트: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].point}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            )
                                          : null),
                                  TextField(
                                    controller: reportReasonController,
                                  ),
                                  ElevatedButton(
                                    onPressed: ()async{
                                      String mEmail = await box.read('manager');
                                      vmhandler.ceaseUser(mEmail, reportReasonController.text.trim(), 7);
                                    }, 
                                    child: const Text("계정 정지")
                                  )
                                ],
                          ));
                        }
                      },
                    ),
                  ],
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
