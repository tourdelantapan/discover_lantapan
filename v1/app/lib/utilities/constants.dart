// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool IS_PODUCTION = false;

String BASE_URL = IS_PODUCTION ? "WALA_PA" : dotenv.env['BASE_URL_LOCAL'] ?? "";

const double HORIZONTAL_PADDING = 15.0;
const String placeholderImage =
    "https://i0.wp.com/joansfootprints.com/wp-content/uploads/2022/01/IMG_20200229_064250-2.jpg?resize=1000%2C750&ssl=1";

double mapZoom = 15;
