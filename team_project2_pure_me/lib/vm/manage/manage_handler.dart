import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/report.dart';
import 'package:team_project2_pure_me/model/rpt_count.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:http/http.dart' as http;

class ManageHandler extends GetxController {
  // List<User> searchedUserList = <User>[].obs;

  //appManage에서 쓸 리스트들
  var signInUserList = <int>[].obs;
  var madeFeedList = <int>[].obs;

  //searchManage에서 쓸 변수들
  /// 나오는 리스트
  var searchFeedList = <Feed>[].obs;
  String searchFeedWord = '';
  int? searchFeedIndex;

  // searchUser에서 쓸 변수들
  var searchUserList = <User>[].obs;
  String serachUserWord = '';
  int? searchUserIndex;

  //Report 에서 쓸 변수들
  var reportFeedCountList = <RptCount>[].obs;
  var reportFeedListById = <Report>[].obs;

  int? reportFeedIndex;

  final String manageUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

  final CollectionReference _manageFeed =
      FirebaseFirestore.instance.collection('post');

  fetchAppManage() async {
    await fetchUserAmount();
    await fetchFeedAmount();
  }

  fetchUserAmount() async {
    var url = Uri.parse("$manageUrl/userperday");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    print(result);

    signInUserList.value = [
      result[0]['count'],
      result[1]['count'],
      result[2]['count']
    ];
  }

  fetchFeedAmount() async {
    List tempList = [];

    String yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toString()
        .substring(0, 19)
        .replaceFirst(' ', 'T');

    String lastweek = DateTime.now()
        .subtract(const Duration(days: 7))
        .toString()
        .substring(0, 19)
        .replaceFirst(' ', 'T');

    String lastmonth = DateTime.now()
        .subtract(const Duration(days: 30))
        .toString()
        .substring(0, 19)
        .replaceFirst(' ', 'T');

    // 더미데이터
    // Timestamp yesterday = Timestamp.fromDate(DateTime.now()
    // .subtract(Duration(days: 1))
    // );
    // Timestamp lastweek = Timestamp.fromDate(DateTime.now()
    // .subtract(Duration(days: 7))
    // );
    // Timestamp lastmonth = Timestamp.fromDate(DateTime.now()
    // .subtract(Duration(days: 30))
    // );

    dynamic yesterdaysnp = await _manageFeed
        .where('state', isEqualTo: '게시')
        .where('writetime', isGreaterThan: yesterday)
        .get();
    tempList.add(yesterdaysnp.size);

    dynamic lastweeksnp = await _manageFeed
        .where('state', isEqualTo: '게시')
        .where('writetime', isGreaterThan: lastweek)
        .get();
    tempList.add(lastweeksnp.size);

    dynamic lastmonthsnp = await _manageFeed
        .where('state', isEqualTo: '게시')
        .where('writetime', isGreaterThan: lastmonth)
        .get();
    tempList.add(lastmonthsnp.size);

    madeFeedList.value = [
      tempList[0],
      tempList[1],
      tempList[2],
    ];
  }

  test1() async {}

  test2() async {
    Timestamp timestamp =
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)));
    FirebaseFirestore.instance.collection('post').add({
      'writer': 'pureme_id',
      'state': '테스트',
      'content': 'content',
      'testtime': timestamp,
      'reply': [],
      'image': 'image',
      'imagename': 'imageName',
    });
  }

//////FeedManage쪽에서 쓰는 함수들
  searchFeed(String searchFeedword) async {
    if (searchFeedword.isEmpty) {
      _manageFeed
          .where('state', isEqualTo: '게시')
          .orderBy('writetime', descending: true)
          .snapshots()
          .listen(
        (event) {
          searchFeedList.value = event.docs
              .map(
                (doc) =>
                    Feed.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
        },
      );
    } else {}
  }

  updateSearchFeedWord(String text) {
    searchFeedWord = text;
    update();
  }

  changeFeedIndex(int index) {
    if (index == searchFeedIndex) {
      searchFeedIndex = null;
    } else {
      searchFeedIndex = index;
    }
    update();
  }

///////////////////saerchUser에서 쓸 함수들

  searchUser() async {
    if (serachUserWord.isNotEmpty) {
      var url =
          Uri.parse("$manageUrl/searchUser?serachUserWord=$serachUserWord");
      var response = await http.get(url);
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      List result = dataConvertedJSON['result'];

      searchUserList.value = result.map(
        (e) {
          return User.fromMap(e);
        },
      ).toList();
      return "OK";
    } else {
      return "Noop";
    }
  }

  searchUserWordchanged(String value) {
    serachUserWord = value;
    searchUserIndex = null;
    update();
  }

  searchUserIndexChanged(int idx) {
    print(idx);
    print(searchUserIndex);
    if (idx == searchUserIndex) {
      searchUserIndex = null;
    } else {
      searchUserIndex = idx;
    }
    update();
  }

///////////////////reportFeed에서 쓸 함수들
  ///feed가 report받은 숫자를 전부 씀
  queryReportcount() async {
    var url = Uri.parse("$manageUrl/queryReportcount");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['result'];

    reportFeedCountList.value = result.map(
      (e) {
        return RptCount.fromMap(e);
      },
    ).toList();
    print(reportFeedCountList);
  }

  ///feed 하나의 리포트 이유들을 가져옴
  queryReportReason(String feedId) async {
    var url = Uri.parse("$manageUrl/queryReportReason?feedId=$feedId");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['result'];

    reportFeedListById.value = result.map(
      (e) {
        return Report.fromMap(e);
      },
    ).toList();
    print(reportFeedListById);
  }

  /// 어떤 feed를 가져왔는지를 바꾸기 위한 함수
  reportFeedIndexChanged(int idx) {
    if (idx == reportFeedIndex) {
      reportFeedIndex = null;
      reportFeedListById.value = [];
      update();
    } else {
      reportFeedIndex = idx;
      update();
      queryReportReason(reportFeedCountList[idx].feedId);
    }
  }
}//End
