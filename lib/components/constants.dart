class ApiConstants {
  static String baseUrl = 'https://api.open-meteo.com/';
  static String usersEndpoint =
      '/v1/forecast?latitude=37.8713&longitude=32.4846&daily=temperature_2m_max&timezone=auto';
}

//anladığım kadarıyla vermiş olduğun koordinatlara göre sana hava sıcaklığını veriyor. 
//evet koordinatların günün en yüksek sıcaklığını veriyor. anladığıum kadarıyla tek günün değil birden fazla günün ?Evet 1 hafta olması lazım
// tamam şimdi yaptığım sorguda bana geleni iyice anlayalım.
//sorgu verdiğim koordinatlara göre bana sadece o koordinatın verilerini veriyor. Yani elimde bir hava durumu listesi yok. Doğrumu
//Evet bu api için öyle detaylarla test aşamasında uğraşmamak amacıyla.
//tamam o zaman bu apiden alabileceğim şey bir koordinatın hjava durmu yani List değil. Doğru
//süper hemfikiriz.
