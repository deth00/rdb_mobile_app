class ApiConstants {
  // Base URLs
  static const String baseUrlV1 =
      'https://fund.nbb.com.la/api/'; // Using existing DioClient base URL

  // API Endpoints
  static const String getAccountLinkage = '/act/get_linkage';
  static const String updatePrimaryAccount = '/act/update_primary_account';

  // Query Parameters
  static const String linkTypeDPT = 'DPT';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorizationBearer = 'Bearer';
}
