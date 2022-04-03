import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const DOMAIN_URL = "http://10.0.2.2:8000";
const HOST_URL = "http://10.0.2.2:8000";
const BASE_URL = "$HOST_URL/api";
const UNAUTHENTICATED_USER = 'unauthenticated_user';

const ADD = 'ADD';
const REMOVE = 'REMOVE';
const SUCCESS = 'SUCCESS';
const FAILED = 'FAILED';

const PAGE_LIMIT = 8;

const EMAIL_REGEX = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

//THEME COLOR

const Map<int, Color> color = {
  50: Color.fromRGBO(28, 122, 219, .1),
  100: Color.fromRGBO(28, 122, 219, .2),
  200: Color.fromRGBO(28, 122, 219, .3),
  300: Color.fromRGBO(28, 122, 219, .4),
  400: Color.fromRGBO(28, 122, 219, .5),
  500: Color.fromRGBO(28, 122, 219, .6),
  600: Color.fromRGBO(28, 122, 219, .7),
  700: Color.fromRGBO(28, 122, 219, .8),
  800: Color.fromRGBO(28, 122, 219, .9),
  900: Color.fromRGBO(28, 122, 219, 1),
};

const PRIMARY_SWATCH = MaterialColor(0xff1C7ADB, color);
const SECONDARY_HEADER_COLOR = PRIMARY_SWATCH;

const INPUT_BORDER_COLOR = Color(0xffD9D9D9);

final OutlineInputBorder ENABLED_BORDER = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: INPUT_BORDER_COLOR));

final OutlineInputBorder FOCUSED_BORDER = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: PRIMARY_SWATCH, width: 2));

final OutlineInputBorder ERROR_BORDER = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.red, width: 2));
