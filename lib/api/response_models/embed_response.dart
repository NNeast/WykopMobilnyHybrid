import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'embed_response.g.dart';

abstract class EmbedResponse
    implements Built<EmbedResponse, EmbedResponseBuilder> {
  factory EmbedResponse([updates(EmbedResponseBuilder b)]) = _$EmbedResponse;
  String get url;
  String get preview;

  EmbedResponse._();
  static Serializer<EmbedResponse> get serializer => _$embedResponseSerializer;
}
