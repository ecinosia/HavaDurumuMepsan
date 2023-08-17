import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mepsan_hava_durumu/components/weather_model.dart';

import 'constants.dart';

class ApiService {
  Future<WeatherTest> getWeatherForTargetCoord() async {
    //adını düzeltti
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        WeatherTest _model = weatherTestFromJson(response.body);
        debugPrint(
            "API 'dan dönen cevap : ${_model.daily!.temperature2MMax![0]}"); //bunu çalıştırıp doğru şekilde çekip çekmediğine bakalım. Aynı zamanda model sınıfını test etmiş oluruz.
        return _model;
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception("Failed");
  }
}
