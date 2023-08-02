interface class RepoModel{
  String index = "";
  String? repoId;
  Map<String, dynamic>? toJson(){
    return null;
  }
  RepoModel? fromJson(Map<String, dynamic> json){
    return null;
  }
  static getInstance(){
    return RepoModel();
  }
}

