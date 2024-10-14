import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/* 
**UserDonation 클래스**

• 이 클래스는 사용자가 기부를 할 수 있는 웹 페이지를 표시하는 화면입니다.
• Flutter의 StatelessWidget을 상속받아 구현되었으며, WebView를 사용하여 외부 웹 페이지를 로드합니다.

**Author**: 하동훈
**Date**: 2024-10-14
*/

class UserDonation extends StatelessWidget {
  const UserDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기부하기'), // 앱바에 표시될 제목
      ),
      body: FutureBuilder<WebViewController>(
        future:
            _createWebViewController(), // WebViewController 생성하는 Future 함수 호출
        builder: (context, snapshot) {
          // Future의 상태에 따라 다른 위젯을 반환
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터가 로드 중일 때 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러가 발생한 경우 에러 메시지 표시
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final controller = snapshot.data!; // 성공적으로 WebViewController를 가져옴
            return Stack(
              children: [
                WebViewWidget(controller: controller), // WebView를 표시
              ],
            );
          }
        },
      ),
    );
  }

  /// WebViewController를 생성하는 비동기 함수
  Future<WebViewController> _createWebViewController() async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript 실행 허용
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          // 페이지 로딩 진행률을 처리하는 콜백
        },
        onPageStarted: (url) {
          // 페이지 로딩 시작 시 호출되는 콜백
        },
        onPageFinished: (url) {
          // 페이지 로딩 완료 시 호출되는 콜백
        },
        onWebResourceError: (error) {
          // 웹 리소스 오류 발생 시 호출되는 콜백
        },
      ))
      ..loadRequest(Uri.parse(
          "https://m.happybean.naver.com/donations/H000000168782")); // 기부 URL을 로드

    return controller; // 생성한 WebViewController를 반환
  }
}
