import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';

class ElasticSearchClient<M extends RepoModel>{
  static String baseURI = DBConfig.baseURI;
  static String apiKey = DBConfig.apiKey;
  static int searchMaxSize = DBConfig.searchMaxSize;
  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': apiKey
  };
  ElasticSearchClient({
    required this.index,
    required this.fromJson,
    required this.toJson,
  });
  factory ElasticSearchClient.fromModel(M model){
    return ElasticSearchClient(
      index: model.index,
      fromJson: model.fromJson,
      toJson: model.toJson,
    );
  }
  final String index;
  final Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic>? Function() toJson;
  
  Future<List<M>> search({Map<String, dynamic>? query}) async{
    List<M> result = [];
    // BaseRepo currentType = BaeRepo() as T;
    debugPrint("load data from repo ($index)");
    try{
      final response = await http.post(
        Uri.parse("$baseURI/$index/_search?&size=$searchMaxSize",),
        headers: headers,
        body: jsonEncode(query ?? {"query": {"match_all": {}}}),
      );
      if(response.statusCode == 200){
        // debugPrint(response.body);
        Map<String, dynamic> data = jsonDecode(response.body);
        // debugPrint(data.toString());
        if(data['hits']['total']['value'] == 0){
          return [];
        }
        for(var item in data['hits']['hits']){
          try{
            result.add(fromJson(item));
          } catch (e){
            // delete(item['_id'] as String);
            debugPrint(item.toString());
            debugPrint(e.toString());
            rethrow ;
          }
          // debugPrint(result.toString());
        }
        return result;
      }else{
        debugPrint(response.body);
        return [];
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> post(M data) async {
    debugPrint("testing: update Device data to repo");
    // debugPrint(data.toJson().toString());
    try{
      final response = await http.post(
        Uri.parse("$baseURI/$index/_doc"),
        headers: headers,
        body: jsonEncode(data.toJson()),
      );
      // debugPrint(response.statusCode.toString());
      if(response.statusCode == 201){
        debugPrint(response.body);
      }else{
        debugPrint(response.body);
        throw Exception('Failed to load data');
      }
    } catch(e){
      // debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> delete(String targetId) async {
    try{
      final response = await http.delete(
        Uri.parse("$baseURI/$index/_doc/$targetId"),
        headers: headers
      );
      if(response.statusCode == 200){
        // debugPrint(response.body);
        debugPrint("delete: $targetId");
      } else{
        debugPrint(response.body);
        throw Exception('Failed to delete data');
      }
    } catch(e){
      // debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> updateWholeDocumentToRepo(List<M> data) async {
      List<M> oldData = await search();
      for (M item in oldData) {
        await delete(item.repoId!);
      }
      for (M item in data) {
        await post(item);
      }
  }
  
  Stream<Map<String, dynamic>> test(List<M> data) async*  {
      int missionCount = 0;
      int missionCompleteCount = 0;
      List<M> oldData = await search();
      missionCount = oldData.length + data.length;
      for (M item in oldData) {
        await delete(item.repoId!);
        yield {"missionCount": missionCount, "missionCompleteCount": ++missionCompleteCount, "missionDescription" : "刪除 ${item.repoId}"};
      }
      for (M item in data) {
        await post(item);
        yield {"missionCount": missionCount, "missionCompleteCount": ++missionCompleteCount, "missionDescription" : "上傳中"};
      }
  }
}
