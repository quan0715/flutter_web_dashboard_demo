import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_dashboard/models/repo/base_repo.dart';

class ElasticSearchClient<model extends RepoModel>{
  static String baseURI = "http://es.lab.nick983.app";
  static String apiKey = "ApiKey YWdxZGpZa0JJUV90ZlhMR3AwMlc6Z1RGdW1DR1dTLTZGMWN1dDZkWEJsdw==";
  static int searchMaxSize = 1000;
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
          result.add(fromJson(item));
          debugPrint(result.toString());
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
  Stream<Map<String, int>> test(List<model> data) async*  {
      List<model> oldData = await search();
      for (model item in oldData) {
        await delete(item.repoId!);
        yield {"missionCount": missionCount, "missionCompleteCount": missionCompleteCount++};
      }
      missionCount = 0;
      missionCompleteCount = 0;
      for (model item in data) {
        await post(item);
        yield {"missionCount": missionCount, "missionCompleteCount": missionCompleteCount++};
      }
  }
}