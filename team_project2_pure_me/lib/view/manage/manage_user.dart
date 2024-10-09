import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/vmhandler.dart';

class ManageUser extends StatelessWidget {
  ManageUser({super.key});

  final vmhandler = Get.put(Vmhandler());
  final _searchController = TextEditingController();    

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("유저 검색"),
      ),
      body: GetBuilder<Vmhandler>(
        builder: (controller) {
          return Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  vmhandler.searchUserWordchanged(value);
                },
              ),
                FutureBuilder(
                  future: vmhandler.searchUser(vmhandler.serachUserWord), 
                  builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError){
                  return Center(child: Text("Error : ${snapshot.error}"),);
                } else if (snapshot.data == "Noop" || vmhandler.searchUserList.isEmpty){
                  return Text("검색어를 입력해 주십시오");
                }else{
                  return Obx(
                    () => Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: ListView.builder(
                            itemCount: vmhandler.searchUserList.length,
                            itemBuilder: (context, index) {
                              User curUser = vmhandler.searchUserList[index];
                              return GestureDetector(
                                onTap: () {
                                  vmhandler.searchUserIndexChanged(index);
                                },
                                child: Card(
                                  child: Text(
                                    curUser.eMail
                                  ),
                                ),
                              );
                            },
                          ) ,
                        ),
                        SizedBox(
                          child: vmhandler.searchUserIndex != null
                          ? Card(
                            child: Text(
                              vmhandler.searchUserList[vmhandler.searchUserIndex!].eMail
                            ),
                          )
                          : null
                        ),
                      ],
                    )
                  );
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