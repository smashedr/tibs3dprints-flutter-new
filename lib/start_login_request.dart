import 'package:json_annotation/json_annotation.dart';

part 'start_login_request.g.dart';

@JsonSerializable()
class StartLoginRequest {
  final String email;
  final String state;

  StartLoginRequest({required this.email, required this.state});

  factory StartLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$StartLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StartLoginRequestToJson(this);
}
