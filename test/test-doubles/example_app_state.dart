import 'package:error_handling_for_perception/error_handling_for_perception.dart';
import 'package:types_for_perception/error_handling_types.dart';
import 'package:types_for_perception/state_types.dart';

class ExampleAppState implements AstroState, AppStateErrorHandling {
  ExampleAppState({required this.error});

  static ExampleAppState get initial =>
      ExampleAppState(error: DefaultErrorHandlingState.initial);

  @override
  final DefaultErrorHandlingState error;

  @override
  ExampleAppState copyWith({DefaultErrorHandlingState? error}) {
    return ExampleAppState(error: error ?? this.error);
  }

  @override
  toJson() => {'error': error.toJson()};

  @override
  bool operator ==(Object other) =>
      other is ExampleAppState && other.error == error;

  @override
  int get hashCode => error.hashCode;
}
