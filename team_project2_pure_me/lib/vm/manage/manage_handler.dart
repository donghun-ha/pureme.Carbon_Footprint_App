import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:typed_data';
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
  var singInUserAverageList = <double>[].obs;
  var madeFeedList = <int>[].obs;
  var madeFeedAverageList = <double>[].obs;

  //searchManage에서 쓸 변수들
  /// 나오는 리스트
  var searchFeedList = <Feed>[].obs;
  String searchFeedWord = '';
  int? searchFeedIndex;

  // searchUser에서 쓸 변수들
  var searchUserList = <User>[].obs;
  String serachUserWord = '';
  int? searchUserIndex;
  int searchUserRadio = 7;

  //Report 에서 쓸 변수들
  final CollectionReference _feed =
      FirebaseFirestore.instance.collection('post');

  var feedList = <Feed>[].obs;

  int rptCountAmount = 1;
  var reportFeedCountList = <RptCount>[].obs;
  var reportFeedListById = <Report>[].obs;

  int? reportFeedIndex;

  final String manageUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/manage'
      : 'http://127.0.0.1:8000/manage';

  final String baseUrl =
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
      result[2]['count'],
      result[3]['count']
    ];

    singInUserAverageList.value = [
      result[0]['average'] + 1,
      result[1]['average'] + 1,
      result[2]['average'] + 1,
      result[3]['average'] + 1,
    ];
  }

  acountGen() {
    Map<String, int> aaa = {
      'day': signInUserList[0],
      'week': signInUserList[1],
      'month': signInUserList[2],
      'all': signInUserList[3],
    };

    List<MapEntry<String, int>> bbb = aaa.entries.toList();
    return bbb;
  }

  acountGenAverage() {
    Map<String, double> aaa = {
      'day': singInUserAverageList[0],
      'week': singInUserAverageList[1],
      'month': singInUserAverageList[2],
      'all': singInUserAverageList[3],
    };

    List<MapEntry<String, double>> bbb = aaa.entries.toList();
    return bbb;
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

    dynamic allsnp = await _manageFeed
        .where('state', isEqualTo: '게시')
        .orderBy('writetime', descending: true)
        .get();

    tempList.add(allsnp.size);
    List alldocs = allsnp.docs as List;
    List alltimes = alldocs.map(
      (e) {
        return DateTime.parse((e).data()['writetime']);
      },
    ).toList();

    Duration difference = alltimes[0].difference(alltimes[alltimes.length - 1]);

    int daysDifference = difference.inDays + 1;

    List meanTempList = [
      min(daysDifference, 1),
      min(daysDifference, 7),
      min(daysDifference, 30),
      daysDifference,
    ];

    madeFeedList.value = [
      tempList[0],
      tempList[1],
      tempList[2],
      tempList[3],
    ];
    madeFeedAverageList.value = [
      tempList[0] / meanTempList[0],
      tempList[1] / meanTempList[1],
      tempList[2] / meanTempList[2],
      tempList[3] / meanTempList[3],
    ];
  }

  feedGen() {
    Map<String, int> aaa = {
      'day': madeFeedList[0],
      'week': madeFeedList[1],
      'month': madeFeedList[2],
      'all': madeFeedList[3],
    };

    List<MapEntry<String, int>> bbb = aaa.entries.toList();
    return bbb;
  }

  feedGenAverage() {
    Map<String, double> aaa = {
      'day': madeFeedAverageList[0],
      'week': madeFeedAverageList[1],
      'month': madeFeedAverageList[2],
      'all': madeFeedAverageList[3],
    };

    List<MapEntry<String, double>> bbb = aaa.entries.toList();
    return bbb;
  }

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
    if (idx == searchUserIndex) {
      searchUserIndex = null;
    } else {
      searchUserIndex = idx;
    }
    update();
  }

  searchUserRadioChanged(value) {
    searchUserRadio = value;
    update();
  }

  ceaseUser(String managerEMail, String ceaseReason) async {
    // ignore: invalid_use_of_protected_member
    String user_eMail = searchUserList.value[searchUserIndex!].eMail;
    var url = Uri.parse(
        "$manageUrl/accountCeaseInsert?user_eMail=$user_eMail&manager_manageEMail=$managerEMail&ceaseReason=$ceaseReason&ceasePeroid=$searchUserRadio");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    print(result);
  }

  Future<Uint8List?> fetchImage(String profileImage) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/view/${profileImage}"),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // 바이트 배열로 반환
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
    return null; // 에러 발생 시 null 반환
  }

///////////////////reportFeed에서 쓸 함수들
  rptCountAmountChanged(int value) {
    rptCountAmount = value;
    update();
  }

  ///feed가 report받은 숫자를 전부 씀
  queryReportcount() async {
    var url =
        Uri.parse("$manageUrl/queryReportcount?leastAmount=$rptCountAmount");
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

  reportFeed(
      String docId, String manager_manageEMail, String changeKind) async {
    await _feed.doc(docId).update({'state': '숨김'});
    var url = Uri.parse(
        "$manageUrl/reportFeed?manager_manageEMail=$manager_manageEMail&feedId=$docId&changeKind=$changeKind");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    print(result);
  }

  fetchFeed() {
    _feed
        .where('state', isEqualTo: '게시')
        .orderBy('writetime', descending: true)
        .snapshots()
        .listen(
      (event) {
        feedList.value = event.docs
            .map(
              (doc) => Feed.fromMap(doc.data() as Map<String, dynamic>, doc.id),
            )
            .toList();
      },
    );
  }

  test() async {
    var rawData =
        await _feed.doc(reportFeedCountList[reportFeedIndex!].feedId).get();
    var data = Feed.fromMap(rawData.data() as Map<String, dynamic>,
        reportFeedCountList[reportFeedIndex!].feedId);
    return data;
  }
}//End
