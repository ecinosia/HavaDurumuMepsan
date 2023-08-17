// To parse this JSON data, do
//
//     final weatherTest = weatherTestFromJson(jsonString);

import 'dart:convert';

WeatherTest weatherTestFromJson(String str) =>
    WeatherTest.fromJson(json.decode(str));

String weatherTestToJson(WeatherTest data) => json.encode(data.toJson());

class WeatherTest {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final int? elevation;
  final DailyUnits? dailyUnits;
  final Daily? daily;

  WeatherTest({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
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
        "daily_units": dailyUnits?.toJson(),
        "daily": daily?.toJson(),
      };
}

class Daily {
  final List<DateTime>? time;
  final List<double>? temperature2MMax;

  Daily({
    this.time,
    this.temperature2MMax,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        time: json["time"] == null
            ? []
            : List<DateTime>.from(json["time"]!.map((x) => DateTime.parse(x))),
        temperature2MMax: json["temperature_2m_max"] == null
            ? []
            : List<double>.from(
                json["temperature_2m_max"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null
            ? []
            : List<dynamic>.from(time!.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "temperature_2m_max": temperature2MMax == null
            ? []
            : List<dynamic>.from(temperature2MMax!.map((x) => x)),
      };
}

class DailyUnits {
  final String? time;
  final String? temperature2MMax;

  DailyUnits({
    this.time,
    this.temperature2MMax,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        time: json["time"],
        temperature2MMax: json["temperature_2m_max"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "temperature_2m_max": temperature2MMax,
      };
}
