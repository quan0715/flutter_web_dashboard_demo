interface class RepoModel{
  String index = "";
  String? repoId;
  Map<String, dynamic>? toJson(){}
  fromJson(Map<String, dynamic> json){}
  static getInstance(){
    return RepoModel();
  }
}

