// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serialization_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunningModels _$RunningModelsFromJson(Map<String, dynamic> json) =>
    RunningModels(
      (json['models'] as List<dynamic>)
          .map((e) => ModelRunning.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RunningModelsToJson(RunningModels instance) =>
    <String, dynamic>{
      'models': instance.models,
    };

ModelRunning _$ModelRunningFromJson(Map<String, dynamic> json) => ModelRunning(
      json['name'] as String,
      json['model'] as String,
      json['size'] as num,
      json['digest'] as String,
      ModelDetails.fromJson(json['details'] as Map<String, dynamic>),
      json['expires_at'] as String,
      json['size_vram'] as num,
    );

Map<String, dynamic> _$ModelRunningToJson(ModelRunning instance) =>
    <String, dynamic>{
      'name': instance.name,
      'model': instance.model,
      'size': instance.size,
      'digest': instance.digest,
      'details': instance.details,
      'expires_at': instance.expires_at,
      'size_vram': instance.size_vram,
    };

ModelDetails _$ModelDetailsFromJson(Map<String, dynamic> json) => ModelDetails(
      json['parent_model'] as String,
      json['format'] as String,
      json['family'] as String,
      (json['families'] as List<dynamic>).map((e) => e as String).toList(),
      json['parameter_size'] as String,
      json['quantization_level'] as String,
    );

Map<String, dynamic> _$ModelDetailsToJson(ModelDetails instance) =>
    <String, dynamic>{
      'parent_model': instance.parent_model,
      'format': instance.format,
      'family': instance.family,
      'families': instance.families,
      'parameter_size': instance.parameter_size,
      'quantization_level': instance.quantization_level,
    };

ModelCompletionQuery _$ModelCompletionQueryFromJson(
        Map<String, dynamic> json) =>
    ModelCompletionQuery(
      model: json['model'] as String,
      prompt: json['prompt'] as String,
      stream: json['stream'] as bool,
      format: json['format'] == null
          ? null
          : ToolFormat.fromJson(json['format'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModelCompletionQueryToJson(
        ModelCompletionQuery instance) =>
    <String, dynamic>{
      'model': instance.model,
      'prompt': instance.prompt,
      'stream': instance.stream,
      'format': instance.format,
    };

ModelCompletionResponse _$ModelCompletionResponseFromJson(
        Map<String, dynamic> json) =>
    ModelCompletionResponse(
      json['model'] as String,
      json['created_at'] as String,
      json['response'] as String,
      json['done'] as bool,
      (json['context'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      json['total_duration'] as num,
      json['load_duration'] as num,
      json['prompt_eval_count'] as num,
      json['prompt_eval_duration'] as num,
      json['eval_count'] as num,
      json['eval_duration'] as num,
    );

Map<String, dynamic> _$ModelCompletionResponseToJson(
        ModelCompletionResponse instance) =>
    <String, dynamic>{
      'model': instance.model,
      'created_at': instance.created_at,
      'response': instance.response,
      'done': instance.done,
      'context': instance.context,
      'total_duration': instance.total_duration,
      'load_duration': instance.load_duration,
      'prompt_eval_count': instance.prompt_eval_count,
      'prompt_eval_duration': instance.prompt_eval_duration,
      'eval_count': instance.eval_count,
      'eval_duration': instance.eval_duration,
    };

ModelQuery _$ModelQueryFromJson(Map<String, dynamic> json) => ModelQuery(
      json['model'] as String,
      (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelQueryToJson(ModelQuery instance) =>
    <String, dynamic>{
      'model': instance.model,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

ModelResponseChunk _$ModelResponseChunkFromJson(Map<String, dynamic> json) =>
    ModelResponseChunk(
      json['model'] as String,
      json['created_at'] as String,
      Message.fromJson(json['message'] as Map<String, dynamic>),
      json['done'] as bool,
    );

Map<String, dynamic> _$ModelResponseChunkToJson(ModelResponseChunk instance) =>
    <String, dynamic>{
      'model': instance.model,
      'created_at': instance.created_at,
      'message': instance.message.toJson(),
      'done': instance.done,
    };

ModelResponseEndChunk _$ModelResponseEndChunkFromJson(
        Map<String, dynamic> json) =>
    ModelResponseEndChunk(
      json['model'] as String,
      json['created_at'] as String,
      json['done'] as bool,
      json['total_duration'] as num,
      json['load_duration'] as num,
      json['prompt_eval_count'] as num,
      json['prompt_eval_duration'] as num,
      json['eval_count'] as num,
      json['eval_duration'] as num,
    );

Map<String, dynamic> _$ModelResponseEndChunkToJson(
        ModelResponseEndChunk instance) =>
    <String, dynamic>{
      'model': instance.model,
      'created_at': instance.created_at,
      'done': instance.done,
      'total_duration': instance.total_duration,
      'load_duration': instance.load_duration,
      'prompt_eval_count': instance.prompt_eval_count,
      'prompt_eval_duration': instance.prompt_eval_duration,
      'eval_count': instance.eval_count,
      'eval_duration': instance.eval_duration,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['role'] as String,
      json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };

AvailableModels _$AvailableModelsFromJson(Map<String, dynamic> json) =>
    AvailableModels(
      (json['models'] as List<dynamic>)
          .map((e) => AvailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AvailableModelsToJson(AvailableModels instance) =>
    <String, dynamic>{
      'models': instance.models,
    };

AvailModel _$AvailModelFromJson(Map<String, dynamic> json) => AvailModel(
      name: json['name'] as String,
      modified_at: json['modified_at'] as String,
      size: (json['size'] as num).toInt(),
      digest: json['digest'] as String,
      details: ModelDetails.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvailModelToJson(AvailModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'modified_at': instance.modified_at,
      'size': instance.size,
      'digest': instance.digest,
      'details': instance.details,
    };

PythonResults _$PythonResultsFromJson(Map<String, dynamic> json) =>
    PythonResults(
      json['pyOutput'] as String,
      (json['exitCode'] as num).toInt(),
    );

Map<String, dynamic> _$PythonResultsToJson(PythonResults instance) =>
    <String, dynamic>{
      'pyOutput': instance.pyOutput,
      'exitCode': instance.exitCode,
    };

PythonCall _$PythonCallFromJson(Map<String, dynamic> json) => PythonCall(
      isNeeded: json['isNeeded'] as bool?,
      modName: json['modName'] as String,
      p0: json['p0'] as String,
      p1: json['p1'] as String,
      p2: json['p2'] as String,
      p3: json['p3'] as String,
      p4: json['p4'] as String,
    );

Map<String, dynamic> _$PythonCallToJson(PythonCall instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isNeeded', instance.isNeeded);
  val['modName'] = instance.modName;
  val['p0'] = instance.p0;
  val['p1'] = instance.p1;
  val['p2'] = instance.p2;
  val['p3'] = instance.p3;
  val['p4'] = instance.p4;
  return val;
}

ToolFormat _$ToolFormatFromJson(Map<String, dynamic> json) => ToolFormat(
      type: json['type'] as String? ?? "object",
      properties: json['properties'] == null
          ? const Properties(Property(), Property(), Property(), Property(),
              Property(), Property(), Property())
          : Properties.fromJson(json['properties'] as Map<String, dynamic>),
      required: (json['required'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ["modName", "p0", "p1", "p2", "p3", "p4"],
    );

Map<String, dynamic> _$ToolFormatToJson(ToolFormat instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'required': instance.required,
    };

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
      Property.fromJson(json['isNeeded'] as Map<String, dynamic>),
      Property.fromJson(json['modName'] as Map<String, dynamic>),
      Property.fromJson(json['p0'] as Map<String, dynamic>),
      Property.fromJson(json['p1'] as Map<String, dynamic>),
      Property.fromJson(json['p2'] as Map<String, dynamic>),
      Property.fromJson(json['p3'] as Map<String, dynamic>),
      Property.fromJson(json['p4'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{
      'isNeeded': instance.isNeeded,
      'modName': instance.modName,
      'p0': instance.p0,
      'p1': instance.p1,
      'p2': instance.p2,
      'p3': instance.p3,
      'p4': instance.p4,
    };

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      type: json['type'] as String? ?? "string",
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'type': instance.type,
    };
