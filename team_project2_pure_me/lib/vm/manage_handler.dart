import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/calc_handler.dart';
import 'package:http/http.dart' as http;

class ManageHandler extends CalcHandler {
  // List<User> searchedUserList = <User>[].obs;

  var signInUserList = <int>[].obs;

  var madeFeedList = <int>[].obs;

  String manageUrl = 'http://10.0.2.2:8000/manage';

  final CollectionReference _manageFeed =
    FirebaseFirestore.instance.collection('post');


  // SearchUser(String userEMail) async {
  //   /// userEMail을 통해 user를 검색, List로 반환할 수 있는 class
  //   /// searchUserList 에 List<User>를 넣을수 있도록
  //   ///
  // }

  fetchUserAmount() async {
    var url = Uri.parse("$manageUrl/userperday");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    print(result);
    await fetchFeedAmount();

    signInUserList.value = [
      result[0]['count'], 
      result[1]['count'], 
      result[2]['count']
    ];
  }



  fetchFeedAmount()async{
    List tempList = [];
    
    Timestamp yesterday = Timestamp.fromDate(DateTime.now()
    .subtract(Duration(days: 1))
    );
    Timestamp lastweek = Timestamp.fromDate(DateTime.now()
    .subtract(Duration(days: 7))
    );
    Timestamp lastmonth = Timestamp.fromDate(DateTime.now()
    .subtract(Duration(days: 30))
    );


    dynamic yesterdaysnp =  await _manageFeed
        .where('state', isEqualTo: '테스트')
        .where('testtime', isGreaterThan: yesterday)
        .get();
    tempList.add(yesterdaysnp.size);

    dynamic lastweeksnp =  await _manageFeed
        .where('state', isEqualTo: '테스트')
        .where('testtime', isGreaterThan: lastweek)
        .get();
    tempList.add(lastweeksnp.size);
    
    dynamic lastmonthsnp =  await _manageFeed
        .where('state', isEqualTo: '테스트')
        .where('testtime', isGreaterThan: lastmonth)
        .get();
    tempList.add(lastmonthsnp.size);
    
    madeFeedList.value = [
      tempList[0],
      tempList[1],
      tempList[2],
    ];

  }

  test2()async{

    Timestamp timestamp = Timestamp.fromDate(DateTime.now()
    .subtract(Duration(days: 1))
    );
    FirebaseFirestore.instance.collection('post').add({
      'writer': 'pureme_id',
      'state': '테스트',
      'content': 'content',
      'testtime':
          timestamp,
      'reply': [],
      'image': 'image',
      'imagename': 'imageName',
    });
  }










}//End
