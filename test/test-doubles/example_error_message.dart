import 'package:json_utils/json_utils.dart';
import 'package:abstractions/beliefs.dart';

/// Class for carrying basic error information for display to the user.
class ExampleErrorMessage implements CoreBeliefs {
  ExampleErrorMessage({required this.message, this.trace});

  final String message;

  final String? trace;

  @override
  ExampleErrorMessage copyWith({String? message, String? trace}) =>
      ExampleErrorMessage(
          message: message ?? this.message, trace: trace ?? this.trace);

  @override
  JsonMap toJson() => <String, dynamic>{'message': message, 'trace': trace};
}
