class AppConfig {
  /// Google API key dùng cho:
  /// - Google Maps SDK Android
  /// - Google Places REST (autocomplete + details)
  static const String googleApiKey = "AIzaSyCnHE799pwV8PlnvpvLmEh2pxfGsBcEyQE";
  static const googleMapsApiKey = googleApiKey;     // Dùng cho Google Map Android
  static const googlePlacesApiKey = googleApiKey;   // Dùng cho Autocomplete

  /// HERE Routing REST API key (không phải SDK)
  /// Khi chưa có key, app sẽ dùng routing mock.
  static const String hereApiKey = "uq-ayBEP9T-wD0lKdPq43A";


  /// Bật Routing thật
  ///static const useHereRouting = true;
// ========== FUEL CONFIG ==========
  // Mức tiêu hao nhiên liệu mặc định (L/100km)
  // Xe tải lớn: 12–20 L/100km
  // Xe con: 6–8 L/100km
  // Xe máy: 1.8–2.2 L/100km
   /// Giá xăng mặc định
  static const double fuelConsumption = 8.0;

  // Giá nhiên liệu mặc định (VND / Lit)
  static const double fuelPrice = 23000;

  // Default location nếu không lấy được GPS
  static const double defaultFuelPrice = 23000; // VNĐ/lít
  static const double defaultFuelConsumption = 8.0; // L/100km
}
