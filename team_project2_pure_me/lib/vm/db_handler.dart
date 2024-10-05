import 'package:get/get.dart';

class DbHandler extends GetxController{

  bool initializer = true;

  initiallizeUserDB(){
    if (initializer){
    /// ---------------구현해야 할 기능
    /// 데이터베이스에 접근할 수 있도록 DB를 시작한다.
    initializer = false;
    }
  }



}