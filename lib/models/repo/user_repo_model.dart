class User{
  final String account;
  final String password;
  final String name;
  final AccountType type;
  final DateTime expireDate;
  final Duration reloadTime;
  User({
    required this.account, 
    required this.password, 
    required this.name , 
    required this.type,
    required this.expireDate,
    required this.reloadTime
  });
  factory User.fromJson({required Map<String, dynamic> json}){
    return User(
      account: json["account"] as String,
      password: json["password"] as String,
      name: json["name"] as String,
      type: AccountType.getTypeFromName(json["name"] as String) ,
      expireDate: DateTime.parse(json["expireDate"] as String),
      reloadTime: Duration(seconds: json["reloadTime"] as int)
    );
  }
  Map<String, dynamic> toJson(){
    return {
      "account": account,
      "password": password,
      "name": name,
      "type": type.toString(),
      "expireDate": expireDate.toIso8601String(),
      "reloadTime": reloadTime.inSeconds
    };
  }
}

enum AccountType{
  admin(name: "s", displayName: "s"),
  normal(name: "s", displayName: "s"),
  premium(name: "s", displayName: "s");

  final String name;
  final String displayName;

  const AccountType({
    required this.name,
    required this.displayName
  });

  static AccountType getTypeFromName(String name){
    switch(name){
      case "admin":
        return AccountType.admin;
      case "normal":
        return AccountType.normal;
      case "premium":
        return AccountType.premium;
      default:
        return AccountType.normal;
    }
  }

  String get getName => name;
}

enum MissionStage { 
  progress(label: 'progress'), 
  pending(label: 'pending'), 
  close(label: 'close');
  final String label;
  const MissionStage({
    required this.label
  });

  factory MissionStage.fromLabel(String label){
    switch(label){
      case 'progress':
        return MissionStage.progress;
      case 'pending':
        return MissionStage.pending;
      case 'close':
        return MissionStage.close;
      default:
        return MissionStage.progress;
    }
  }
}
