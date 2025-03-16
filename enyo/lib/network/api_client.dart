import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:enyo/schemas/serialization_classes.dart';
import 'package:http/http.dart' as http;

// TODO: networking code needs error handling
// TODO: parameterize models
class OllamaClient {
  OllamaClient._internal() {
    _instance = this;
  }
  factory OllamaClient() => _instance ?? OllamaClient._internal();

  static OllamaClient? _instance;
  static const url_root = "http://localhost:11434/api";
  static final http.Client _client = http.Client();
  final List<Message> model_ctx = [];

  // have a preprocessing model check the users query to determine if a tool call is needed
  Future<PythonCall> modelCheckForToolUsage(String query) async {
    final modelResponse = await queryModelCompletion(query);
    final json = jsonDecode(modelResponse.response);
    final callInfo = PythonCall.fromJson(json);
    return callInfo;
  }

  Future<ModelCompletionResponse> queryModelCompletion(String query) async {
    final body_obj = ModelCompletionQuery("llama3.2", query, false);
    final response = await _client.post(Uri.parse("$url_root/generate"),
        body: jsonEncode(body_obj));
    final json = jsonDecode(response.body);
    return ModelCompletionResponse.fromJson(json);
  }

  Future<http.StreamedResponse> queryModel(String query) async {
    model_ctx.add(Message("user", query));
    var body_obj = ModelQuery("llama2", model_ctx).toJson();

    var request = http.Request("POST", Uri.parse(("$url_root/chat")));
    request.body = jsonEncode(body_obj);

    return _client.send(request);
  }

  Future<RunningModels> fetch_running_models() async {
    final response = await _client.get(Uri.parse("$url_root/ps"));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to retrieve running models. Status: ${response.statusCode}");
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return RunningModels.fromJson(json);
  }

  Future<AvailableModels> fetch_available_models() async {
    final response = await _client.get(Uri.parse("$url_root/tags"));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to retrieve running models. Status: ${response.statusCode}");
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return AvailableModels.fromJson(json);
  }
}

class JSONRPCClient {
  JSONRPCClient._internal() {
    _instance = this;
  }
  factory JSONRPCClient() => _instance ?? JSONRPCClient._internal();

  static JSONRPCClient? _instance;
  final resultCtl = StreamController<PythonResults>();
  Socket? _sock;
  PythonResults? pyResultCache;
  SocketException? sockException;

  Future<void> _connect() async {
    _sock = await Socket.connect("127.0.0.1", 8181);
    _sock?.listen((data) {
      final response = String.fromCharCodes(data);
      print("Received over socket: $response");
      pyResultCache =
          PythonResults.fromJson(jsonDecode(response) as Map<String, dynamic>);
    }, onDone: () {
      print(
          "Tool server disconnected"); // TODO: should probably do something in this case too, but really the connection shouldnt be broken while the app is up
    }, onError: (e) {
      sockException = e;
    });
  }

  void disconnect() async {
    _sock ?? _sock?.close();
  }

  Future<PythonResults?> _waitForResults() async {
    for (int i = 0; pyResultCache != null; i++) {
      await Future.delayed(Duration(milliseconds: 25));
      if (i == 20) {
        // TODO: Do somehting about a potential timeout,
      }
    }
    return pyResultCache;
  }

  Future<PythonResults?> rpcCall(PythonCall callInfo) async {
    _sock ?? await _connect();
    // empty cache
    pyResultCache = null;
    print("Socket connected");
    final pycallJson = jsonEncode(callInfo);
    _sock?.write(pycallJson);
    print("Written data to socket");
    return await _waitForResults();
  }
}
