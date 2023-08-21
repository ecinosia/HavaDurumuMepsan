class ApiConstants {
  static String baseUrl = 'https://api.open-meteo.com/';
  static String usersEndpoint =
      "/v1/forecast?latitude=37.8713&longitude=32.4846&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation_probability,rain,weathercode,surface_pressure,visibility,windspeed_10m,winddirection_10m,uv_index,is_day&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max,windspeed_10m_max,winddirection_10m_dominant&current_weather=true&timezone=auto&forecast_days=14";
}
//https://api.open-meteo.com/v1/forecast?latitude=37.8713&longitude=32.4846&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation_probability,rain,weathercode,visibility,windspeed_10m,winddirection_10m,uv_index,is_day&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max,windspeed_10m_max,winddirection_10m_dominant&current_weather=true&timezone=auto&forecast_days=14
//anladığım kadarıyla vermiş olduğun koordinatlara göre sana hava sıcaklığını veriyor. 
//evet koordinatların günün en yüksek sıcaklığını veriyor. anladığıum kadarıyla tek günün değil birden fazla günün ?Evet 1 hafta olması lazım
// tamam şimdi yaptığım sorguda bana geleni iyice anlayalım.
//sorgu verdiğim koordinatlara göre bana sadece o koordinatın verilerini veriyor. Yani elimde bir hava durumu listesi yok. Doğrumu
//Evet bu api için öyle detaylarla test aşamasında uğraşmamak amacıyla.
//tamam o zaman bu apiden alabileceğim şey bir koordinatın hjava durmu yani List değil. Doğru
//süper hemfikiriz.
