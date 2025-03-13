import 'dart:convert';

import 'package:enyo/network/api_client.dart';
import 'package:enyo/schemas/serialization_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecordingState
{
  bool isRecording = false;
  int  pid = 0;
}

class EnyoState extends ChangeNotifier
{
  static const _platform = MethodChannel("enyo.flutter/stt");
  final RecordingState _recording_state = RecordingState();

  final ollama_client = OllamaClient();
  final bottom_text_field_ctrl = TextEditingController();
  String last_model_used = "";
  String lastMsg = "";
  bool nowStreaming = false;
  late List<Message> msgs;

  EnyoState () {
    msgs = ollama_client.model_ctx;
  }



  void record() {
    if (!_recording_state.isRecording) {
      _start_recording();
      return;
    }
    _stop_recording(_recording_state.pid);
  }

  Future<bool> _stop_recording(int pid) async {
    try {
      int? result = await _platform.invokeMethod<int>("stop_recording", <String, String>{
        "pid": pid.toString()
      });
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

  Future<bool> _start_recording() async {
    try {
      int? pid = await _platform.invokeMethod<int>("start_recording");
      _recording_state.isRecording = true;
      _recording_state.pid =  pid!;
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

  void chat(String query) async
  {
    
    final streamed_response = await ollama_client.query_model(query);
    msgs.add(Message("", "")); //  need to do this to keep indexing right for listview.builder
    nowStreaming = true;
    int chunkLen = 0;

    streamed_response.stream.toStringStream().listen((chunk) {
      var model_response_chunk = ModelResponseChunk.fromJson(jsonDecode(chunk));
      if (last_model_used.isEmpty || last_model_used != model_response_chunk.model)
      {
        last_model_used = model_response_chunk.model;
      }

      if (chunkLen < 4 && lastMsg.startsWith("echo")) {
        // TODO: make rpc call
      }

      
      lastMsg += model_response_chunk.message.content;
      notifyListeners();
    },
        onDone: ()
        {
          // swap the empty message with a message containing lastMsg
          msgs.removeLast();
          msgs.add(Message("assistant", lastMsg));
          lastMsg = "";
          nowStreaming = false;
          notifyListeners();
        },
        onError: (e) => () // TODO: handle this error
    );
  }

}