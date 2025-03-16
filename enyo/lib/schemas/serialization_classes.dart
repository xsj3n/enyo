import 'package:json_annotation/json_annotation.dart';

part 'serialization_classes.g.dart';

// Commands to gen bindings===
// dart run build_runner build --delete-conflicting-outputs
// dart run build_runner watch --delete-conflicting-outputs

// LIST RUNNING MODELS API DATA MODEL===
@JsonSerializable()
class RunningModels {
  RunningModels(this.models);
  factory RunningModels.fromJson(Map<String, dynamic> json) =>
      _$RunningModelsFromJson(json);
  Map<String, dynamic> toJson() => _$RunningModelsToJson(this);

  final List<ModelRunning> models;
}

@JsonSerializable()
class ModelRunning {
  ModelRunning(this.name, this.model, this.size, this.digest, this.details,
      this.expires_at, this.size_vram);
  factory ModelRunning.fromJson(Map<String, dynamic> json) =>
      _$ModelRunningFromJson(json);
  Map<String, dynamic> toJson() => _$ModelRunningToJson(this);

  final String name;
  final String model;
  final num size;
  final String digest;
  final ModelDetails details;
  final String expires_at;
  final num size_vram;
}

@JsonSerializable()
class ModelDetails {
  ModelDetails(this.parent_model, this.format, this.family, this.families,
      this.parameter_size, this.quantization_level);
  factory ModelDetails.fromJson(Map<String, dynamic> json) =>
      _$ModelDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ModelDetailsToJson(this);

  final String parent_model;
  final String format;
  final String family;
  final List<String> families;
  final String parameter_size;
  final String quantization_level;
}

// COMPLETION API DATA MODEL===
@JsonSerializable()
class ModelCompletionQuery {
  ModelCompletionQuery(this.model, this.prompt, this.stream);
  factory ModelCompletionQuery.fromJson(Map<String, dynamic> json) =>
      _$ModelCompletionQueryFromJson(json);
  Map<String, dynamic> toJson() => _$ModelCompletionQueryToJson(this);

  final String model;
  final String prompt;
  final bool stream;
}

@JsonSerializable()
class ModelCompletionResponse {
  ModelCompletionResponse(
      this.model,
      this.created_at,
      this.response,
      this.done,
      this.context,
      this.total_duration,
      this.load_duration,
      this.prompt_eval_count,
      this.prompt_eval_duration,
      this.eval_count,
      this.eval_duration);
  factory ModelCompletionResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelCompletionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ModelCompletionResponseToJson(this);

  final String model;
  final String created_at;
  final String response;
  final bool done;
  final List<int> context;
  final num total_duration;
  final num load_duration;
  final num prompt_eval_count;
  final num prompt_eval_duration;
  final num eval_count;
  final num eval_duration;
}

// CHAT API DATA MODEL===
@JsonSerializable(explicitToJson: true)
class ModelQuery {
  ModelQuery(this.model, this.messages);
  factory ModelQuery.fromJson(Map<String, dynamic> json) =>
      _$ModelQueryFromJson(json);
  Map<String, dynamic> toJson() => _$ModelQueryToJson(this);

  final String model;
  final List<Message> messages;
}

@JsonSerializable(explicitToJson: true)
class ModelResponseChunk {
  ModelResponseChunk(this.model, this.created_at, this.message, this.done);
  factory ModelResponseChunk.fromJson(Map<String, dynamic> json) =>
      _$ModelResponseChunkFromJson(json);
  Map<String, dynamic> toJson() => _$ModelResponseChunkToJson(this);

  final String model;
  final String created_at;
  final Message message;
  final bool done;
}

@JsonSerializable()
class ModelResponseEndChunk {
  ModelResponseEndChunk(
      this.model,
      this.created_at,
      this.done,
      this.total_duration,
      this.load_duration,
      this.prompt_eval_count,
      this.prompt_eval_duration,
      this.eval_count,
      this.eval_duration);
  factory ModelResponseEndChunk.fromJson(Map<String, dynamic> json) =>
      _$ModelResponseEndChunkFromJson(json);
  Map<String, dynamic> toJson() => _$ModelResponseEndChunkToJson(this);

  final String model;
  final String created_at;
  final bool done;
  final num total_duration;
  final num load_duration;
  final num prompt_eval_count;
  final num prompt_eval_duration;
  final num eval_count;
  final num eval_duration;
}

@JsonSerializable()
class Message {
  Message(this.role, this.content);
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  final String role;
  final String content;
  final String? images = null;
}

// LIST MODEL LIBRARY API DATA MODEL

@JsonSerializable()
class AvailableModels {
  AvailableModels(this.models);
  factory AvailableModels.fromJson(Map<String, dynamic> json) =>
      _$AvailableModelsFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableModelsToJson(this);

  final List<AvailModel> models;
}

@JsonSerializable()
class AvailModel {
  AvailModel({
    required this.name,
    required this.modified_at,
    required this.size,
    required this.digest,
    required this.details,
  });

  factory AvailModel.fromJson(Map<String, dynamic> json) =>
      _$AvailModelFromJson(json);
  Map<String, dynamic> toJson() => _$AvailModelToJson(this);

  final String name;
  final String modified_at;
  final int size;
  final String digest;
  final ModelDetails details;
}

@JsonSerializable()
class PythonResults {
  PythonResults(this.pyOutput, this.exitCode);
  factory PythonResults.fromJson(Map<String, dynamic> json) =>
      _$PythonResultsFromJson(json);
  Map<String, dynamic> toJson() => _$PythonResultsToJson(this);

  final String pyOutput;
  final int exitCode;
}

@JsonSerializable(includeIfNull: false)
class PythonCall {
  PythonCall(
      {required this.isNeeded,
      required this.modName,
      required this.p0,
      required this.p1,
      required this.p2,
      required this.p3,
      required this.p4});

  factory PythonCall.fromJson(Map<String, dynamic> json) =>
      _$PythonCallFromJson(json);
  Map<String, dynamic> toJson() => _$PythonCallToJson(this);

  final bool? isNeeded;
  final String modName;
  final String p0;
  final String p1;
  final String p2;
  final String p3;
  final String p4;
}

// OLLAMA STRUCTURED OUTPUTS===
// Note: Feeding a model this format will make it generate PythonCall JSON objects
@JsonSerializable()
class ToolFormat {
  ToolFormat(this.type, this.properties, this.required);

  factory ToolFormat.fromJson(Map<String, dynamic> json) =>
      _$ToolFormatFromJson(json);
  Map<String, dynamic> toJson() => _$ToolFormatToJson(this);

  final String type;
  final Properties properties;
  final List<String> required;
}

@JsonSerializable()
class Properties {
  Properties(
      this.isNeeded, this.modName, this.p0, this.p1, this.p2, this.p3, this.p4);

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$PropertiesToJson(this);

  final Property isNeeded;
  final Property modName;
  final Property p0;
  final Property p1;
  final Property p2;
  final Property p3;
  final Property p4;
}

@JsonSerializable()
class Property {
  Property(this.type);

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  final String type;
}
