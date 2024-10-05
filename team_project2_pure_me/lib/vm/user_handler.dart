import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/lev.dart';
import 'package:team_project2_pure_me/model/user.dart';
import 'package:team_project2_pure_me/vm/db_handler.dart';

class UserHandelr extends DbHandler {

  User curUser = User(
    eMail: '1234@gmail.com', 
    nickName: 'TjPureMe', 
    password: '1234', 
    phone: '010-1234-5678', 
    createDate: DateTime.now(), 
    point: 0, 
    profileImage: 'sample.png'
    ); // fetch해오기 위한 User class

    List<Lev> levList = <Lev>[].obs;
    int curLev = 0; // point를 통해 계산한 레벨을 저장할 변수

    bool eMailUnique = false; // 회원가입시 이메일 확인을 위한 변수

    String? profileImageName;  /// 회원정보 수정시 이미지 이름을 바꿔야할때 필요한 변수

  bool loginVerify(String eMail, String password){
    /// ---------------------------------------------------구현해야 할 기능

    /// eMail과 password를 받아서 MySql에서 count함수로 일치하는걸 찾아내서
    /// 만약 일치하는게 없으면 false를 return 하고,
    /// 일치하는게 있다면 
    ///   curUser의 eMail ~ profileImage등 모든 argument에 해당 값들을 넣어주고 
    ///   update()를 실행시킨다음
    ///   true를 return한다.
    
    return eMail == '1234@gmail.com' && password == '1234'; // 로직 구현 후 이 부분은 삭제바람
  }

  eMailVerify(String eMail){
    /// ---------------------------------------------------구현해야 할 기능

    /// eMail을 받아서 MySql에서 count함수로 일치하는걸 찾아내서
    /// 만약 일치하는게 "있"으면 false를 eMailUnique에 넣어주고,
    /// 일치하는게 "없"다면 true를 eMailUnique에 넣어주고 
    /// 업데이트한다 
    
    eMailUnique != '1234@gamil.com'; // 로직 구현 후 이 부분은 삭제바람 
    update(); // 로직 구현 후 이 부분은 삭제바람
  }

  signIn(String eMail, String password, String passwordVerify, String nickName, String phone){

    /// password와 passwordverify가 다르면 false를 return하고
    /// 값이 같다면

    User(
      eMail: eMail, 
      nickName: nickName, 
      password: password, 
      phone: phone, 
      createDate: DateTime.now(), 
      point: 0, 
    );
    // 를 MySql에 집어넣고 true를 return한다.

    return true; // 로직 구현 후 이 부분은 삭제바람
  }

  fetchUserLev(){
    /// firebase의 레벨table을 참조해서 유저의 레벨을 fetch해오는 함수
    /// LevList에 lev들을 저장한다.
  }

  changeCurLev(){
    // curLev를 바꿔준다 LevList에 맞게 바꿔준 뒤 update()하는 로직을 짠다.
  }



  userUpdate(String nickName, String eMail, String phone){
    // 데이터베이스에 curUser를 업데이트하고 아래를 실행시킨다.
    curUser.nickName = nickName;
    curUser.eMail = eMail;
    curUser.phone = phone;
    update();


  }

  userUpdateAll(String profileImage,String nickName, String eMail, String phone){
    // 데이터베이스에 curUser를 업데이트하고 아래를 실행시킨다.
    curUser.profileImage = profileImage;
    curUser.nickName = nickName;
    curUser.eMail = eMail;
    curUser.phone = phone;
  }

  userImagePicker(){
    // user를 위한 ImagePicker, 
    // userimageName을 업데이트한다
  }

  userUpdatePwd(String password){
    /// 비밀번호를 받아서 데이터베이스에 변경만 시킨다.
  }



}