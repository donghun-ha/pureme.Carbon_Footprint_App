import 'dart:convert';

import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/model/report.dart';
import 'package:team_project2_pure_me/model/rpt_count.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:http/http.dart' as http;

class ManageHandler extends GetxController {
  // 글로벌 변수들
  final String manageUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/manage'
      : 'http://127.0.0.1:8000/manage';

  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';

  final CollectionReference _manageFeed =
      FirebaseFirestore.instance.collection('post');

  // ------------------------------------------appManage------------------------------------------

  // 데이터를 각각 저장할 List
  var signInUserList = <int>[].obs;
  var singInUserAverageList = <double>[].obs;
  var madeFeedList = <int>[].obs;
  var madeFeedAverageList = <double>[].obs;

  /////manageApp에서 실행할 함수

  ///처음에 함수 데이터를 끌어올 함수
  fetchAppManage() async {
    await fetchUserAmount();
    await fetchFeedAmount();
  }

  ///처음에 유저쪽 에 쓸 차트 데이터를 끌어올 함수
  fetchUserAmount() async {
    var url = Uri.parse("$manageUrl/userperday");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    signInUserList.value = [
      result[0]['count'],
      result[1]['count'],
      result[2]['count'],
      result[3]['count']
    ];

    singInUserAverageList.value = [
      result[0]['average'],
      result[1]['average'],
      result[2]['average'],
      result[3]['average'],
    ];
  }

  ///처음에 피드쪽에 쓸 차트 데이터를 끌어올 함수
  fetchFeedAmount() async {
    //// 각각 구한 Feed들의 갯수를 저장하는 List
    List tempList = [];

    /// 어제
    String yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toString()
        .substring(0, 19)
        .replaceFirst(' ', 'T');

    /// 지난주
    String lastweek = DateTime.now()
        .subtract(const Duration(days: 7))
        .toString()
        .substring(0, 19)
        .replaceFirst(' ', 'T');

    /// 지난 달
    String lastmonth = DateTime.now()
        .subtract(const Duration(days: 30))
        .toString()
        .substring(0, 19)
        .replaceFirst(' ', 'T');

    /// 어제까지 생성된 피드
    dynamic yesterdaysnp =
        await _manageFeed.where('writetime', isGreaterThan: yesterday).get();
    tempList.add(yesterdaysnp.size);

    /// 지난주까지 생성된피드
    dynamic lastweeksnp =
        await _manageFeed.where('writetime', isGreaterThan: lastweek).get();
    tempList.add(lastweeksnp.size);

    /// 지난달까지 생성된피드
    dynamic lastmonthsnp =
        await _manageFeed.where('writetime', isGreaterThan: lastmonth).get();
    tempList.add(lastmonthsnp.size);

    /// 모든 피드
    dynamic allsnp =
        await _manageFeed.orderBy('writetime', descending: true).get();
    tempList.add(allsnp.size);

    // 생성일이 가장 빠른날부터 가장 늦은날까지의 차이를 구하는 함수
    List alldocs = allsnp.docs as List;
    List alltimes = alldocs.map(
      (e) {
        return DateTime.parse((e).data()['writetime']);
      },
    ).toList();

    Duration difference = alltimes[0].difference(alltimes[alltimes.length - 1]);
    int daysDifference = difference.inDays;

    //// 평균값을 구하기 위해 tempList[3]에서 나눠줄 값들
    List meanTempList = [
      daysDifference + 1,
      daysDifference ~/ 7 + 1,
      daysDifference ~/ 30 + 1,
      1,
    ];

    /// 사실상 tempList와 같음
    madeFeedList.value = [
      tempList[0],
      tempList[1],
      tempList[2],
      tempList[3],
    ];

    //// tempList의 마지막값(전부다 구함)을 각각 maneTempList로 나눔
    madeFeedAverageList.value = [
      tempList[3] / meanTempList[0],
      tempList[3] / meanTempList[1],
      tempList[3] / meanTempList[2],
      tempList[3] / meanTempList[3],
    ];
  }

  /// 데이터를 List<MapEntry>타입으로 바꿔주는 함수
  acountGen() {
    Map<String, int> rowData = {
      'day': signInUserList[0],
      'week': signInUserList[1],
      'month': signInUserList[2],
      'all': signInUserList[3],
    };

    List<MapEntry<String, int>> data = rowData.entries.toList();
    return data;
  }

  /// 데이터를 List<MapEntry>타입으로 바꿔주는 함수
  acountGenAverage() {
    Map<String, double> rowData = {
      'day': singInUserAverageList[0],
      'week': singInUserAverageList[1],
      'month': singInUserAverageList[2],
      'all': singInUserAverageList[3],
    };

    List<MapEntry<String, double>> data = rowData.entries.toList();
    return data;
  }

  /// 데이터를 List<MapEntry>타입으로 바꿔주는 함수
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

  /// 데이터를 List<MapEntry>타입으로 바꿔주는 함수
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

  /// 더미 데이터
  // test2() async {
  //   Timestamp timestamp =
  //       Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)));
  //   FirebaseFirestore.instance.collection('post').add({
  //     'writer': 'pureme_id',
  //     'state': '테스트',
  //     'content': 'content',
  //     'testtime': timestamp,
  //     'reply': [],
  //     'image': 'image',
  //     'imagename': 'imageName',
  //   });
  // }

  // ---------------------------- FeedManage에서 쓸 변수들--------------------------------
  /// 나오는 리스트
  var searchFeedList = <Feed>[].obs;

  //// 피드를 선택했을때 인덱스
  int? searchFeedIndex;

  String? searchWriter;

  /// 게시 radioButton용 인덱스
  int? radioFeedIndex = 0;

  /// 바꿀 radioButton용 인덱스
  int? radioChangeFeedIndex = 0;

//////FeedManage쪽에서 쓰는 함수들
  ///

  searchWriterChanged(String value) {
    searchWriter = value;
    searchFeedIndex = null;
    update();
  }

  fetchFeeds() async {
    if (searchWriter == null || searchWriter!.isEmpty) {
      String state = ['게시', '숨김', '삭제'][radioFeedIndex!];
      _manageFeed
          .where('state', isEqualTo: state)
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
    } else {
      String state = ['게시', '숨김', '삭제'][radioFeedIndex!];
      _manageFeed
          .where('state', isEqualTo: state)
          .where('writer', isEqualTo: searchWriter)
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
    }
  }

  //// 피드페이지 위쪽 라디오버튼을 바꾸기위한 함수
  feedRadioChanged(value) {
    radioFeedIndex = value;
    // 선택한걸 없애기, 선택상태였어도 라디오버튼이 왔다갔다하면 선택된걸 취소해야 함.
    searchFeedIndex = null;
    update();
  }

  /// 피드를 바꾸는걸 선택할때 뭘로바꿀지 선택하는 함수
  dailogFeedRadioChanged(value) {
    radioChangeFeedIndex = value;
    update();
  }

  /// 피드를 선택하는 함수
  changeFeedIndex(int index) {
    if (index == searchFeedIndex) {
      searchFeedIndex = null;
    } else {
      searchFeedIndex = index;
    }
    update();
  }

  /// 피드의 상태를 바꾸고 각각 저장해주는 함수
  changeFeedState(
      String docId, String managerManageEMail, String changeKind) async {
    await _manageFeed.doc(docId).update({'state': changeKind});
    var url = Uri.parse(
        "$manageUrl/reportFeed?manager_manageEMail=$managerManageEMail&feedId=$docId&changeKind=$changeKind");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
  }

  // ////////////////////////////////////////// searchUser에서 쓸 변수들
  /// 나오는 유저들
  var searchUserList = <User>[].obs;

  /// 검색어
  String serachUserWord = '';

  /// 선택한 유저
  int? searchUserIndex;

  /// 정지 일수(기본 7일)을 정하기위한 radio버튼
  int searchUserRadio = 7;

///////////////////saerchUser에서 쓸 함수들

  /// 유저를 검색어에 따라 가져오는 함수
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

///////검색에가 바꼈을때 searchword를 바꾸고, 또 원래 선택했던 user정보를 취소해야함
  searchUserWordchanged(String value) {
    serachUserWord = value;
    searchUserIndex = null;
    update();
  }

  /// 선택한 유저를 바꿔주는함수
  searchUserIndexChanged(int idx) {
    if (idx == searchUserIndex) {
      searchUserIndex = null;
    } else {
      searchUserIndex = idx;
    }
    update();
  }

//// 유저라디오버튼을 바꾸는 함수
  searchUserRadioChanged(value) {
    searchUserRadio = value;
    update();
  }

  /// 유저를 정지시키는 함수
  ceaseUser(String managerEMail, String ceaseReason) async {
    // ignore: invalid_use_of_protected_member
    String userEmail = searchUserList.value[searchUserIndex!].eMail;
    var url = Uri.parse(
        "$manageUrl/accountCeaseInsert?user_eMail=$userEmail&manager_manageEMail=$managerEMail&ceaseReason=$ceaseReason&ceasePeroid=$searchUserRadio");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
  }

/////// USER쪽 이미지를 불러오는 함수.. 자꾸 이미지가 없어서 그걸 바꿔줌
  Future<Uint8List?> fetchImage(String profileImage) async {
    final response = await http.get(
      Uri.parse("$baseUrl/user/view/$profileImage"),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // 바이트 배열로 반환
    }
    return null; // 에러 발생 시 null 반환
  }

  /// ------------------------------------------------------ reportFeed ------------------------------------------------------

  int rptCountAmount = 1;
  var reportFeedCountList = <RptCount>[].obs;

  var reportFeedListById = <Report>[].obs;

  int? reportFeedIndex;

///////////////////reportFeed에서 쓸 함수들
  rptCountAmountChanged(int value) {
    rptCountAmount = value;
    reportFeedListById.value = [];
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

  reportFeed(String docId, String managerManageEMail, String changeKind) async {
    await _manageFeed.doc(docId).update({'state': '숨김'});
    var url = Uri.parse(
        "$manageUrl/reportFeed?manager_manageEMail=$managerManageEMail&feedId=$docId&changeKind=$changeKind");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
  }

  fetchSelectedFeed() async {
    var rawData = await _manageFeed
        .doc(reportFeedCountList[reportFeedIndex!].feedId)
        .get();
    var data = Feed.fromMap(rawData.data() as Map<String, dynamic>,
        reportFeedCountList[reportFeedIndex!].feedId);
    return data;
  }
} //End
