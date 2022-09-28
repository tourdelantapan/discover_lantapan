// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool IS_PODUCTION = false;

String BASE_URL = IS_PODUCTION
    ? dotenv.env['BASE_URL_PRODUCTION'] ?? ""
    : dotenv.env['BASE_URL_LOCAL'] ?? "";

const double HORIZONTAL_PADDING = 15.0;
const String placeholderImage =
    "https://dpointernational.com/wp-content/uploads/2015/12/placeholder-image.jpg";

double mapZoom = 15;
