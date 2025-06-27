import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'api_service.g.dart';

final _logger = Logger();

@JsonSerializable()
class StartLoginRequest {
  final String email;
  final String state;

  StartLoginRequest({required this.email, required this.state});

  factory StartLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$StartLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StartLoginRequestToJson(this);
}

@JsonSerializable()
class UserResponse {
  final String email;
  final String name;
  final bool verified;
  final String authorization;
  final int points;

  UserResponse({
    required this.email,
    required this.name,
    required this.verified,
    required this.authorization,
    required this.points,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

class ProcessLoginResult {
  final bool success;
  final UserResponse? user;
  final String? errorMessage;

  ProcessLoginResult({required this.success, this.user, this.errorMessage});
}

@JsonSerializable()
class ErrorResponse {
  final String message;

  ErrorResponse({required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

class StartLoginResult {
  final bool success;
  final String? errorMessage;

  StartLoginResult({required this.success, this.errorMessage});
}

class ApiService {
  ApiService._internal();

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  // Base URL constant inside the singleton
  static const String _baseUrl = 'https://app-dev.tibs3dprints.com/api';

  Future<StartLoginResult> startLogin({
    required String email,
    required String state,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/start/');
    final requestBody = StartLoginRequest(email: email, state: state);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        _logger.i('Login started successfully for email: $email');
        return StartLoginResult(success: true);
      } else {
        String errorMessage = 'Unknown error';

        try {
          final errorJson = jsonDecode(response.body);
          final errorResponse = ErrorResponse.fromJson(errorJson);
          errorMessage = errorResponse.message;
        } catch (e) {
          _logger.w('Failed to parse error message: $e');
        }

        _logger.w(
          'Login failed. Status: ${response.statusCode}, Message: $errorMessage',
        );

        return StartLoginResult(success: false, errorMessage: errorMessage);
      }
    } catch (e, stacktrace) {
      _logger.e('Exception during startLogin', e, stacktrace);
      return StartLoginResult(success: false, errorMessage: 'Network error');
    }
  }

  Future<ProcessLoginResult> processLogin({
    required String email,
    required String state,
    required String code,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/login/');
    final requestBody = ProcessLoginRequest(
      email: email,
      state: state,
      code: code,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final userResponse = UserResponse.fromJson(json);
        _logger.i('Login processed successfully for email: $email');
        return ProcessLoginResult(success: true, user: userResponse);
      } else {
        String errorMessage = 'Unknown error';

        try {
          final errorJson = jsonDecode(response.body);
          final errorResponse = ErrorResponse.fromJson(errorJson);
          errorMessage = errorResponse.message;
        } catch (e) {
          _logger.w('Failed to parse error message: $e');
        }

        _logger.w(
          'Process login failed. Status: ${response.statusCode}, Message: $errorMessage',
        );

        return ProcessLoginResult(success: false, errorMessage: errorMessage);
      }
    } catch (e, stacktrace) {
      _logger.e('Exception during processLogin', e, stacktrace);
      return ProcessLoginResult(success: false, errorMessage: 'Network error');
    }
  }
}

@JsonSerializable()
class ProcessLoginRequest {
  final String email;
  final String state;
  final String code;

  ProcessLoginRequest({
    required this.email,
    required this.state,
    required this.code,
  });

  factory ProcessLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$ProcessLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessLoginRequestToJson(this);
}
