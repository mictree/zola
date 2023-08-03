import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Colos that use in our app
const kSecondaryColor = Color(0xFFFE6D8E);
const kTextColor = Color(0xFF12153D);
const kTextLightColor = Color(0xFF9A9BB2);
const kFillStarColor = Color(0xFFFCC419);

const kDefaultPadding = 20.0;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);

const api = apiHeroku;

const apiSocket =
    kIsWeb ? "http://localhost:5000" : "https://zola-api.herokuapp.com";

const apiLocal = "http://192.168.1.244:5000/api/v1";
const apiHeroku = "https://zola-api.herokuapp.com/api/v1";
const apiRender = "https://api-zola.onrender.com/api/v1";
// const api = "https://api-zola.onrender.com/api/v1";

const localSocket = "http://192.168.1.244:5000";
