class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8000/api';
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const String tokenStorageKey = 'auth_token';
  static const String userStorageKey = 'auth_user';
  static const String appVersion = '1.0.0';

  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String phonePattern = r'^[+]?[0-9]{10,15}$';
  static const String postalCodePattern = r'^[a-zA-Z0-9\s\-]{1,20}$';
  static const String streetPattern = r'^[a-zA-Z0-9\s,.-]{3,255}$';

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int maxAddressesPerCustomer = 10;
  static const int minPasswordLength = 8;
}
