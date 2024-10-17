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
        Center(
          child: GetBuilder<ManageHandler>(builder: (context) {
            return Obx(() {
              return vmhandler.searchUserList.isEmpty
                  ? const Text("검색어를 입력해 주십시오")
                  : const Text("메롱");
            });
          }),
        ),
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text("검색:     "),
                          SizedBox(
                            width: Get.width * 0.8,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                vmhandler.searchUserWordchanged(
                                    value); /////검색어를 바꿔주는함수
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GetBuilder<ManageHandler>(
                    builder: (controller) {
                      return FutureBuilder(
                          future: vmhandler.searchUser(),
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
                              return const Center(child: Text("검색어를 입력해 주십시오"));
                            } else {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.1,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Text("검색:     "),
                                  //     SizedBox(
                                  //       width: Get.width * 0.8,
                                  //       child: TextField(
                                  //         controller: _searchController,
                                  //         onChanged: (value) {
                                  //           vmhandler.searchUserWordchanged(value); /////검색어를 바꿔주는함수
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  //// DB에서 async처리를 위한 FutureBuilder
                                  FutureBuilder(
                                    future: vmhandler.searchUser(),

                                    /// 검색어에 따라 DB에서 끌어오는 함수
                                    builder: (context, snapsho) {
                                      // if절: 예외처리
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text("Error : ${snapshot.error}"),
                                        );
                                      } else if (snapshot.data == "Noop" ||
                                          vmhandler.searchUserList.isEmpty) {
                                        return const Center(
                                            child: Text("검색어를 입력해 주십시오"));
                                      } else {
                                        return Obx(() => Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  child: ListView.builder(
                                                    itemCount: vmhandler
                                                        .searchUserList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      User curUser = vmhandler
                                                              .searchUserList[
                                                          index];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: vmhandler
                                                                        .searchUserIndex ==
                                                                    index
                                                                ? Colors.blue
                                                                : Colors
                                                                    .transparent,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: ListTile(
                                                          onTap: () {
                                                            /// 특정한 User를 선택하기 위한 함수. vmhandler.searchUserIndex가 update됨
                                                            vmhandler
                                                                .searchUserIndexChanged(
                                                                    index);
                                                          },
                                                          title: Text(
                                                              curUser.eMail),
                                                          leading: const Icon(
                                                              Icons.person),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 3,
                                                  child: SizedBox(
                                                      height: Get.height * 0.17,
                                                      child: vmhandler
                                                                  .searchUserIndex !=
                                                              null
                                                          ? Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  child: vmhandler
                                                                              .searchUserList[vmhandler
                                                                                  .searchUserIndex!]
                                                                              .profileImage ==
                                                                          null
                                                                      ? const CircleAvatar(
                                                                          radius:
                                                                              50,
                                                                          foregroundImage:
                                                                              AssetImage("images/co2.png"),
                                                                        )
                                                                      : FutureBuilder(
                                                                          future: vmhandler.fetchImage(vmhandler
                                                                              .searchUserList[vmhandler
                                                                                  .searchUserIndex!]
                                                                              .profileImage!),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return CircleAvatar(
                                                                                radius: 50,
                                                                                foregroundImage: MemoryImage(snapshot.data!),
                                                                              );
                                                                            } else {
                                                                              return const CircleAvatar(
                                                                                radius: 50,
                                                                                foregroundImage: AssetImage("images/co2.png"),
                                                                              );
                                                                            }
                                                                          }),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        'eMail: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].eMail}'),
                                                                    Text(
                                                                        'Phone: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].phone}'),
                                                                    Text(
                                                                        '생성일: ${vmhandler.searchUserList[vmhandler.searchUserIndex!].createDate.toString().substring(0, 10)}'),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          : null),
                                                ),
                                                Visibility(
                                                  visible: vmhandler
                                                          .searchUserIndex !=
                                                      null,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                              "정지 기간 : "),
                                                          Radio(
                                                              value: 1,
                                                              groupValue: vmhandler
                                                                  .searchUserRadio,
                                                              onChanged:
                                                                  (value) {
                                                                vmhandler
                                                                    .searchUserRadioChanged(
                                                                        value);
                                                              }),
                                                          const Text('하루'),
                                                          Radio(
                                                              value: 7,
                                                              groupValue: vmhandler
                                                                  .searchUserRadio,
                                                              onChanged:
                                                                  (value) {
                                                                vmhandler
                                                                    .searchUserRadioChanged(
                                                                        value);
                                                              }),
                                                          const Text('일주일'),
                                                          Radio(
                                                              value: 30,
                                                              groupValue: vmhandler
                                                                  .searchUserRadio,
                                                              onChanged:
                                                                  (value) {
                                                                vmhandler
                                                                    .searchUserRadioChanged(
                                                                        value);
                                                              }),
                                                          const Text('30일'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: Get.width *
                                                                    0.2 -
                                                                8,
                                                            child: const Text(
                                                                "정지 사유:"),
                                                          ),
                                                          SizedBox(
                                                            width: Get.width *
                                                                    0.8 -
                                                                8,
                                                            child: TextField(
                                                              controller:
                                                                  reportReasonController,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            String mEmail =
                                                                await box.read(
                                                                    'manager');
                                                            vmhandler.ceaseUser(
                                                                mEmail,
                                                                reportReasonController
                                                                    .text
                                                                    .trim());
                                                            Get.defaultDialog(
                                                                title: '계정 정지',
                                                                middleText:
                                                                    '계정 정지가 완료되었습니다.',
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        vmhandler
                                                                            .update();
                                                                      },
                                                                      child: const Text(
                                                                          "확인"))
                                                                ]);
                                                            reportReasonController
                                                                .clear();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.amber[
                                                                          50]),
                                                          child: const Text(
                                                              "계정 정지"))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }
                                    },
                                  ),
                                ],
                              );
                            }
                          });
                    },
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
