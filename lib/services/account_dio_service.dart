import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dart_assincronismo/models/account.dart';
import 'package:dart_assincronismo/api_key.dart';

class AccountDioService {
  final Dio _dio = Dio();
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  String url = "https://api.github.com/gists/b52a4ebbde885199f357ba69855c82a9";

  // Os métodos virão aqui
}
