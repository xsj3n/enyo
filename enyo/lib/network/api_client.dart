import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:enyo/schemas/serialization_classes.dart';
import 'package:http/http.dart' as http;




class OllamaClient
{
  static OllamaClient? _instance;
  OllamaClient._internal() {
    _instance = this;
  }
  factory OllamaClient() => _instance ?? OllamaClient._internal();
  static const url_root = "http://localhost:11434/api";
  //static const _init_msg = "Keep your responses to one to two sentences unless it's required. Right after this message, respond with a quick greeting.";
  static final http.Client _client = http.Client();
  // the ctx is just the chat history + other directives we need to bake in
  final List<Message> model_ctx = [];

  Future<http.StreamedResponse> query_model(String query) async {
    model_ctx.add(Message("user", query));
    var body_obj = ModelQuery("llama3.2", model_ctx)
      .toJson();

    var request = http.Request("POST",  Uri.parse(("$url_root/chat")));
    request.body = jsonEncode(body_obj);

    return _client.send(request);
  }


  Future<RunningModels> fetch_running_models() async {
    final response = await _client.get(Uri.parse("$url_root/ps"));
    if (response.statusCode != 200) {
      throw Exception("Failed to retrieve running models. Status: ${response.statusCode}");
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return RunningModels.fromJson(json);
  }

  Future<AvailableModels> fetch_available_models() async {
    final response = await _client.get(Uri.parse("$url_root/tags"));
    if (response.statusCode != 200) {
      throw Exception("Failed to retrieve running models. Status: ${response.statusCode}");
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return AvailableModels.fromJson(json);
  }


}

class JSONRPCClient
{
  JSONRPCClient._internal() {
    _instance = this;
  }
  factory JSONRPCClient() => _instance ?? JSONRPCClient._internal();

  static JSONRPCClient? _instance;
  final _resultCtl = StreamController<PythonResults>();
  Socket? _sock;

  void connect() async {
    _sock = await Socket.connect("127.0.0.1", 8181);
    _sock?.listen(_handleRPCOutStream,
      onDone: () {
        // TODO: should probably do something in this case too
      },
      onError: (e) {
        // TODO: add client side error handling
      }
    );
  }

  void _handleRPCOutStream(Uint8List data) async {
    final response = String.fromCharCodes(data);
    /*
    TODO: decide how to handle the out stream of rpc events
    */
  }

  void disconnect() async {
    _sock?.close();
  }

  void pythonRPC() async {

  }



}