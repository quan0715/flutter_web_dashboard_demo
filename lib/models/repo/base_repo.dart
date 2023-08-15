interface class RepoModel{
  String index = "";
  String? repoId;

  @override
  String toString() {
    return toJson()?.entries.map((e) => '${e.key}: ${e.value}').join('\n') ?? "";
  }
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

