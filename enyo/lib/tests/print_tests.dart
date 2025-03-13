import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import '../schemas/serialization_classes.dart';
import 'package:enyo/network/api_client.dart';

void main()
{
  test("Check to see if serialization works as expected", ()
  {
    final chat_endpoint_uri = Uri.parse("${OllamaClient.url_root}/chat");
    final initial_context = [Message("user", "Keep your responses to one to two sentences unless it's required")];

    var body_obj = ModelQuery("llama2", initial_context)
      .toJson();

    var request = http.Request("POST",  chat_endpoint_uri)
        .body = jsonEncode(body_obj);

    print(request);
  });

  test("ollama chat api", () async
  {

    final cli = OllamaClient();
    var out = "";
    final complete = Completer();
    final stream = await cli.query_model("why is eli so tall and white");
    stream.stream.toStringStream().listen((chunk)
        {
          print(chunk);
          var model_response_chunk = ModelResponseChunk.fromJson(jsonDecode(chunk));
          out += model_response_chunk.message.content;
          print(out);
        },
      onDone: () => {
          complete.complete()
      },
      onError: (e) => {
          complete.completeError(e)
      }
    );
    await complete.future;
  });

}