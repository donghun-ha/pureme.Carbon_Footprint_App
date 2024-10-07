
class CalcHandler extends UserHandler {
  double curTotalCarbon = 0; // 현재 TotalCarborn의 양을 나타내는 변수

  List transDropdown = <String>['버스', '지하철'].obs;
  String? curtransDropValue;

  fetchTotalCarbon() {
    /// DB에서 식을 구현해 myCarbon이 어느정도인지 알아온다
    ///
    curTotalCarbon = 0;
    update();
  }

  insertCarbonGen(String kind, double amount) {
    // CarbonGen table에 kind와 amount, datetime.now()로 날짜까지 넣는다.
  }

  transDropChange(value) {
    curtransDropValue = value;
    update();
    // 수정 불필요
  }
}
