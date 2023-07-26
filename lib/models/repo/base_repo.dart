abstract class BaseRepo{
  static String baseURI = "http://es.lab.nick983.app";
  static String apiKey = "ApiKey YWdxZGpZa0JJUV90ZlhMR3AwMlc6Z1RGdW1DR1dTLTZGMWN1dDZkWEJsdw==";
  Map<String, dynamic> toJson();
  static fromJson(Map<String, dynamic> json){}
  static Future getFromRepo()async{}
}