class User {
  String eMail; // 이메일
  String nickName; // 닉네임
  String password; // 패스워드
  String phone; // 핸드폰
  DateTime createDate; // 생성일
  double point; //레벨에 따른 점수
  String? profileImage; // 이미지이름

  User({
    required this.eMail,
    required this.nickName,
    required this.password,
    required this.phone,
    required this.createDate,
    required this.point,
    this.profileImage,
  });

  User.fromMap(Map<String, dynamic> res)
      : eMail = res['eMail'],
        nickName = res['nickName'],
        password = res['password'],
        phone = res['phone'],
        createDate = DateTime.parse(res['createDate']),
        point = double.parse(res['point']) ,
        profileImage =
            res['profileImage'] == 'null' ? null : res['profileImage'];
}
