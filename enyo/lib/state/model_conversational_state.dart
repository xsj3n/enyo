import 'dart:convert';
import 'package:enyo/network/api_client.dart';
import 'package:enyo/schemas/serialization_classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecordingState {
  bool isRecording = false;
  int pid = 0;
}

class EnyoState extends ChangeNotifier {
  static const _platform = MethodChannel("enyo.flutter/stt");
  final RecordingState _recording_state = RecordingState();

  final ollama_client = OllamaClient();
  final _rpcClient = JSONRPCClient();
  final bottom_text_field_ctrl = TextEditingController();
  String last_model_used = "";
  String lastMsg = ""; // trigger var
  bool nowStreaming = false;
  bool isLoading = false;
  late List<Message> msgs;

  EnyoState() {
    msgs = ollama_client.model_ctx;
  }

  void record() {
    if (!_recording_state.isRecording) {
      _start_recording();
      return;
    }
    _stop_recording(_recording_state.pid);
  }

  // TODO: update to recording via python
  Future<bool> _stop_recording(int pid) async {
    try {
      int? result = await _platform.invokeMethod<int>(
          "stop_recording", <String, String>{"pid": pid.toString()});
      if (result == 1) {
        print("_stop_recording: ${result!}");
        _recording_state.isRecording = false;
        _recording_state.pid = 0;
        return true;
      }
      //_recording_state.pid = 0;
      return false;
    } on PlatformException catch (e) {
      return false;
    }
  }

  // TODO: update to recording via python
  Future<bool> _start_recording() async {
    try {
      int? pid = await _platform.invokeMethod<int>("start_recording");
      _recording_state.isRecording = true;
      _recording_state.pid = pid!;
      print("arecord pid: ${_recording_state.pid}");
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }

  // TODO: make a button for this
  void clearMsgs() {
    msgs.clear();
    notifyListeners();
  }

  void _finalizeMsg() {
    // swap the empty message with a message containing lastMsg
    msgs.removeLast();
    msgs.add(Message("assistant", lastMsg));
    lastMsg = "";
    nowStreaming = false;
    notifyListeners();
  }

  // Take in /generate completions and then act as if we are streaming them
  // Only consumed in the chat() function of this class
  Future<void> _displayDataAsStream(String completionData) async {
    lastMsg = "";
    isLoading = false;
    nowStreaming = true;

    for (int i = 0; i < completionData.length; i++) {
      lastMsg += completionData[i];
      notifyListeners();
      await Future.delayed(
          Duration(milliseconds: 25)); // simulate streamed response
    }
    _finalizeMsg();
  }

  void chat(String query) async {
    // phase 1 preprocessor
    isLoading = true;
    msgs.add(Message("",
        "")); // load in an empty message so listview.builder has the correct item count while we build the next item
    final callInfo = await ollama_client.modelCheckForToolUsage(query);

    // phase 2 final output
    // is the call is needed, have model interpret the output data,
    // otherwise, stream the response of the primary model
    // TODO: decide if data interpretation will fall on the preproc or primary model
    if (callInfo.isNeeded != null && callInfo.isNeeded == true) {
      final PythonResults? res = await _rpcClient.rpcCall(callInfo);

      if (res == null || _rpcClient.sockException != null) {
        final modelResponse = await ollama_client.queryModelCompletion(
            "Inform the user the of socket error that occured when communicating with the tool server:\n${_rpcClient.sockException?.message}",
            false);
        _displayDataAsStream(modelResponse.response);
        return;
      }

      final modelResponse = await ollama_client.queryModelCompletion(
          "Summarize the following information for the user:\n${res?.pyOutput}",
          false);
      _displayDataAsStream(modelResponse.response);
      return;
    }

    isLoading = false;
    nowStreaming = true;
    final streamed_response = await ollama_client.queryModel(query);
    streamed_response.stream.toStringStream().listen(
        (chunk) {
          print("chunk:\n$chunk");
          final model_response_chunk =
              ModelResponseChunk.fromJson(jsonDecode(chunk));
          if (last_model_used.isEmpty ||
              last_model_used != model_response_chunk.model) {
            last_model_used = model_response_chunk.model;
          }

          lastMsg += model_response_chunk.message.content;
          notifyListeners();
        },
        onDone: () => _finalizeMsg(),
        onError: (e) {
          msgs.add(Message("assistant",
              "An error has occured while attempting to communicate with the Ollama server:\n${e.message}"));
          notifyListeners();
        });
  }
}
