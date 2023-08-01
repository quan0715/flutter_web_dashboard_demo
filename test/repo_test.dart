import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/models/repo/monitoring_device.dart';

import 'repo_test.mocks.dart';



@GenerateMocks([http.Client]) 
void main() {
  group('fetch repo data', (){
    test('fetch monitoring device data', () async {
      final client = MockClient();
      when(
        client.get(
          Uri.parse(BaseRepo.baseURI + '/' + MonitoringDeviceModel.index + '_search'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': BaseRepo.apiKey
          },
        )).thenAnswer((_) async => http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));
      //expect(await MonitoringDeviceModel.testRepo(client: client),  isA<List<MonitoringDeviceModel>>());
    });
  });
}
