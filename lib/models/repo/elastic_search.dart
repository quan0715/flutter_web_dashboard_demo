import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/models/repo/db_config.dart';

class ElasticSearchClient<model extends RepoModel>{
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
  final String index;
  final model Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function() toJson;
  int missionCount = 0;
  int missionCompleteCount = 0;
  
  
  Future<List<model>> search() async{
    List<model> result = [];
    // BaseRepo currentType = BaeRepo() as T;
    debugPrint("load Device data from repo");
    try{
      final response = await http.get(
        Uri.parse("$baseURI/$index/_search?&size=$searchMaxSize"),
        headers: headers
      );
      if(response.statusCode == 200){
        // debugPrint(response.body);
        Map<String, dynamic> data = jsonDecode(response.body);
        // debugPrint(data.toString());
        if(data['hits']['total']['value'] == 0){
          return [];
        }
        for(var item in data['hits']['hits']){
          debugPrint(item.toString());
          try{
            result.add(fromJson(item));
          } catch (e){
            debugPrint(e.toString());
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

  Future<void> post(model data) async {
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

  Future<void> updateWholeDocumentToRepo(List<model> data) async {
      List<model> oldData = await search();
      for (model item in oldData) {
        await delete(item.repoId!);
      }
      for (model item in data) {
        await post(item);
      }
  }
  
  Stream<Map<String, dynamic>> test(List<model> data) async*  {
      List<model> oldData = await search();
      missionCount = oldData.length + data.length;
      for (model item in oldData) {
        await delete(item.repoId!);
        yield {"missionCount": missionCount, "missionCompleteCount": ++missionCompleteCount, "missionDescription" : "刪除 ${item.repoId}"};
      }
      for (model item in data) {
        await post(item);
        yield {"missionCount": missionCount, "missionCompleteCount": ++missionCompleteCount, "missionDescription" : "上傳中"};
      }
  }
}
