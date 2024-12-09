import 'package:flutter_dotenv/flutter_dotenv.dart';

class Values {
  static String apiKey = dotenv.env['API_KEY'] ?? "";
  static String baseUrls =
      dotenv.env['BASE_URL'] != null ? '${dotenv.env['BASE_URL']}/Todo' : '';
}
