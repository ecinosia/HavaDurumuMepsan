// To parse this JSON data, do
//
//     late weatherTest = weatherTestFromJson(jsonString);

import 'dart:convert';

WeatherTest weatherTestFromJson(String str) =>
    WeatherTest.fromJson(json.decode(str));

String weatherTestToJson(WeatherTest data) => json.encode(data.toJson());

class WeatherTest {
  late double? latitude;
  late double? longitude;
  late double? generationtimeMs;
  late int? utcOffsetSeconds;
  late String? timezone;
  late String? timezoneAbbreviation;
  late double? elevation;
  late CurrentWeather? currentWeather;
  late HourlyUnits? hourlyUnits;
  late Hourly? hourly;
  late DailyUnits? dailyUnits;
  late Daily? daily;

  WeatherTest({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentWeather,
    this.hourlyUnits,
    this.hourly,
    this.dailyUnits,
    this.daily,
  });

  factory WeatherTest.fromJson(Map<String, dynamic> json) => WeatherTest(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"],
        currentWeather: json["current_weather"] == null
            ? null
            : CurrentWeather.fromJson(json["current_weather"]),
        hourlyUnits: json["hourly_units"] == null
            ? null
            : HourlyUnits.fromJson(json["hourly_units"]),
        hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
        dailyUnits: json["daily_units"] == null
            ? null
            : DailyUnits.fromJson(json["daily_units"]),
        daily: json["daily"] == null ? null : Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "utc_offset_seconds": utcOffsetSeconds,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "elevation": elevation,
        "current_weather": currentWeather?.toJson(),
        "hourly_units": hourlyUnits?.toJson(),
        "hourly": hourly?.toJson(),
        "daily_units": dailyUnits?.toJson(),
        "daily": daily?.toJson(),
      };
}

class CurrentWeather {
  late double? temperature;
  late double? windspeed;
  late int? winddirection;
  late int? weathercode;
  late int? isDay;
  late String? time;

  CurrentWeather({
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.weathercode,
    this.isDay,
    this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
        temperature: json["temperature"],
        windspeed: json["windspeed"]?.toDouble(),
        winddirection: json["winddirection"],
        weathercode: json["weathercode"],
        isDay: json["is_day"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "windspeed": windspeed,
        "winddirection": winddirection,
        "weathercode": weathercode,
        "is_day": isDay,
        "time": time,
      };
}

class Daily {
  late List<DateTime>? time;
  late List<int>? weathercode;
  late List<double>? temperature2MMax;
  late List<double>? temperature2MMin;
  late List<String>? sunrise;
  late List<String>? sunset;
  late List<int?>? precipitationProbabilityMax;
  late List<double>? windspeed10MMax;
  late List<int>? winddirection10MDominant;

  Daily({
    this.time,
    this.weathercode,
    this.temperature2MMax,
    this.temperature2MMin,
    this.sunrise,
    this.sunset,
    this.precipitationProbabilityMax,
    this.windspeed10MMax,
    this.winddirection10MDominant,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        time: json["time"] == null
            ? []
            : List<DateTime>.from(json["time"]!.map((x) => DateTime.parse(x))),
        weathercode: json["weathercode"] == null
            ? []
            : List<int>.from(json["weathercode"]!.map((x) => x)),
        temperature2MMax: json["temperature_2m_max"] == null
            ? []
            : List<double>.from(
                json["temperature_2m_max"]!.map((x) => x?.toDouble())),
        temperature2MMin: json["temperature_2m_min"] == null
            ? []
            : List<double>.from(
                json["temperature_2m_min"]!.map((x) => x?.toDouble())),
        sunrise: json["sunrise"] == null
            ? []
            : List<String>.from(json["sunrise"]!.map((x) => x)),
        sunset: json["sunset"] == null
            ? []
            : List<String>.from(json["sunset"]!.map((x) => x)),
        precipitationProbabilityMax:
            json["precipitation_probability_max"] == null
                ? []
                : List<int?>.from(
                    json["precipitation_probability_max"]!.map((x) => x)),
        windspeed10MMax: json["windspeed_10m_max"] == null
            ? []
            : List<double>.from(
                json["windspeed_10m_max"]!.map((x) => x?.toDouble())),
        winddirection10MDominant: json["winddirection_10m_dominant"] == null
            ? []
            : List<int>.from(json["winddirection_10m_dominant"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null
            ? []
            : List<dynamic>.from(time!.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "weathercode": weathercode == null
            ? []
            : List<dynamic>.from(weathercode!.map((x) => x)),
        "temperature_2m_max": temperature2MMax == null
            ? []
            : List<dynamic>.from(temperature2MMax!.map((x) => x)),
        "temperature_2m_min": temperature2MMin == null
            ? []
            : List<dynamic>.from(temperature2MMin!.map((x) => x)),
        "sunrise":
            sunrise == null ? [] : List<dynamic>.from(sunrise!.map((x) => x)),
        "sunset":
            sunset == null ? [] : List<dynamic>.from(sunset!.map((x) => x)),
        "precipitation_probability_max": precipitationProbabilityMax == null
            ? []
            : List<dynamic>.from(precipitationProbabilityMax!.map((x) => x)),
        "windspeed_10m_max": windspeed10MMax == null
            ? []
            : List<dynamic>.from(windspeed10MMax!.map((x) => x)),
        "winddirection_10m_dominant": winddirection10MDominant == null
            ? []
            : List<dynamic>.from(winddirection10MDominant!.map((x) => x)),
      };
}

class DailyUnits {
  late String? time;
  late String? weathercode;
  late String? temperature2MMax;
  late String? temperature2MMin;
  late String? sunrise;
  late String? sunset;
  late String? precipitationProbabilityMax;
  late String? windspeed10MMax;
  late String? winddirection10MDominant;

  DailyUnits({
    this.time,
    this.weathercode,
    this.temperature2MMax,
    this.temperature2MMin,
    this.sunrise,
    this.sunset,
    this.precipitationProbabilityMax,
    this.windspeed10MMax,
    this.winddirection10MDominant,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        time: json["time"],
        weathercode: json["weathercode"],
        temperature2MMax: json["temperature_2m_max"],
        temperature2MMin: json["temperature_2m_min"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        precipitationProbabilityMax: json["precipitation_probability_max"],
        windspeed10MMax: json["windspeed_10m_max"],
        winddirection10MDominant: json["winddirection_10m_dominant"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "weathercode": weathercode,
        "temperature_2m_max": temperature2MMax,
        "temperature_2m_min": temperature2MMin,
        "sunrise": sunrise,
        "sunset": sunset,
        "precipitation_probability_max": precipitationProbabilityMax,
        "windspeed_10m_max": windspeed10MMax,
        "winddirection_10m_dominant": winddirection10MDominant,
      };
}

class Hourly {
  late List<String>? time;
  late List<double>? temperature2M;
  late List<int>? relativehumidity2M;
  late List<double>? apparentTemperature;
  late List<int?>? precipitationProbability;
  late List<double>? rain;
  late List<int>? weathercode;
  late List<double>? surfacePressure;
  late List<double>? visibility;
  late List<double>? windspeed10M;
  late List<int>? winddirection10M;
  late List<double>? uvIndex;
  late List<int>? isDay;

  Hourly({
    this.time,
    this.temperature2M,
    this.relativehumidity2M,
    this.apparentTemperature,
    this.precipitationProbability,
    this.rain,
    this.surfacePressure,
    this.weathercode,
    this.visibility,
    this.windspeed10M,
    this.winddirection10M,
    this.uvIndex,
    this.isDay,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        surfacePressure: json["surface_pressure"] == null
            ? []
            : List<double>.from(
                json["surface_pressure"]!.map((x) => x?.toDouble())),
        time: json["time"] == null
            ? []
            : List<String>.from(json["time"]!.map((x) => x)),
        temperature2M: json["temperature_2m"] == null
            ? []
            : List<double>.from(
                json["temperature_2m"]!.map((x) => x?.toDouble())),
        relativehumidity2M: json["relativehumidity_2m"] == null
            ? []
            : List<int>.from(json["relativehumidity_2m"]!.map((x) => x)),
        apparentTemperature: json["apparent_temperature"] == null
            ? []
            : List<double>.from(
                json["apparent_temperature"]!.map((x) => x?.toDouble())),
        precipitationProbability: json["precipitation_probability"] == null
            ? []
            : List<int?>.from(json["precipitation_probability"]!.map((x) => x)),
        rain: json["rain"] == null
            ? []
            : List<double>.from(json["rain"]!.map((x) => x)),
        weathercode: json["weathercode"] == null
            ? []
            : List<int>.from(json["weathercode"]!.map((x) => x)),
        visibility: json["visibility"] == null
            ? []
            : List<double>.from(json["visibility"]!.map((x) => x)),
        windspeed10M: json["windspeed_10m"] == null
            ? []
            : List<double>.from(
                json["windspeed_10m"]!.map((x) => x?.toDouble())),
        winddirection10M: json["winddirection_10m"] == null
            ? []
            : List<int>.from(json["winddirection_10m"]!.map((x) => x)),
        uvIndex: json["uv_index"] == null
            ? []
            : List<double>.from(json["uv_index"]!.map((x) => x?.toDouble())),
        isDay: json["is_day"] == null
            ? []
            : List<int>.from(json["is_day"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
        "temperature_2m": temperature2M == null
            ? []
            : List<dynamic>.from(temperature2M!.map((x) => x)),
        "relativehumidity_2m": relativehumidity2M == null
            ? []
            : List<dynamic>.from(relativehumidity2M!.map((x) => x)),
        "apparent_temperature": apparentTemperature == null
            ? []
            : List<dynamic>.from(apparentTemperature!.map((x) => x)),
        "precipitation_probability": precipitationProbability == null
            ? []
            : List<dynamic>.from(precipitationProbability!.map((x) => x)),
        "rain": rain == null ? [] : List<dynamic>.from(rain!.map((x) => x)),
        "weathercode": weathercode == null
            ? []
            : List<dynamic>.from(weathercode!.map((x) => x)),
        "surface_pressure": surfacePressure == null
            ? []
            : List<dynamic>.from(surfacePressure!.map((x) => x)),
        "visibility": visibility == null
            ? []
            : List<dynamic>.from(visibility!.map((x) => x)),
        "windspeed_10m": windspeed10M == null
            ? []
            : List<dynamic>.from(windspeed10M!.map((x) => x)),
        "winddirection_10m": winddirection10M == null
            ? []
            : List<dynamic>.from(winddirection10M!.map((x) => x)),
        "uv_index":
            uvIndex == null ? [] : List<dynamic>.from(uvIndex!.map((x) => x)),
        "is_day": isDay == null ? [] : List<dynamic>.from(isDay!.map((x) => x)),
      };
}

class HourlyUnits {
  late String? time;
  late String? temperature2M;
  late String? relativehumidity2M;
  late String? apparentTemperature;
  late String? precipitationProbability;
  late String? rain;
  late String? weathercode;
  late String? surfacePressure;
  late String? visibility;
  late String? windspeed10M;
  late String? winddirection10M;
  late String? uvIndex;
  late String? isDay;

  HourlyUnits({
    this.time,
    this.temperature2M,
    this.relativehumidity2M,
    this.apparentTemperature,
    this.precipitationProbability,
    this.rain,
    this.weathercode,
    this.surfacePressure,
    this.visibility,
    this.windspeed10M,
    this.winddirection10M,
    this.uvIndex,
    this.isDay,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
        time: json["time"],
        temperature2M: json["temperature_2m"],
        relativehumidity2M: json["relativehumidity_2m"],
        apparentTemperature: json["apparent_temperature"],
        precipitationProbability: json["precipitation_probability"],
        rain: json["rain"],
        weathercode: json["weathercode"],
        surfacePressure: json["surface_pressure"],
        visibility: json["visibility"],
        windspeed10M: json["windspeed_10m"],
        winddirection10M: json["winddirection_10m"],
        uvIndex: json["uv_index"],
        isDay: json["is_day"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "temperature_2m": temperature2M,
        "relativehumidity_2m": relativehumidity2M,
        "apparent_temperature": apparentTemperature,
        "precipitation_probability": precipitationProbability,
        "rain": rain,
        "weathercode": weathercode,
        "surface_pressure": surfacePressure,
        "visibility": visibility,
        "windspeed_10m": windspeed10M,
        "winddirection_10m": winddirection10M,
        "uv_index": uvIndex,
        "is_day": isDay,
      };
}
