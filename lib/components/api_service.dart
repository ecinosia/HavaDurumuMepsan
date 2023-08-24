import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mepsan_hava_durumu/components/weather_model.dart';

import 'constants.dart';

class ApiService {
  Future<WeatherTest> getWeatherForTargetCoord(String lat, String long) async {
    //adını düzeltti
    try {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}/v1/forecast?latitude=$lat&longitude=$long&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation_probability,rain,weathercode,surface_pressure,visibility,windspeed_10m,winddirection_10m,uv_index,is_day&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max,windspeed_10m_max,winddirection_10m_dominant&current_weather=true&timezone=auto&forecast_days=14");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        WeatherTest model123 = weatherTestFromJson(response.body);
        debugPrint(
            "API 'dan dönen cevap : ${model123.daily!.temperature2MMax}"); //bunu çalıştırıp doğru şekilde çekip çekmediğine bakalım. Aynı zamanda model sınıfını test etmiş oluruz.
        return model123;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    debugPrint("Apiservice Lat: $lat, Long: $long");
    throw Exception("Failed");
  }
}
