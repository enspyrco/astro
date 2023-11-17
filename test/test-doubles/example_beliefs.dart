import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:abstractions/beliefs.dart';
import 'package:abstractions/error_correction.dart';

class ExampleBeliefs implements CoreBeliefs, ErrorCorrectionConcept {
  ExampleBeliefs({required this.error});

  static ExampleBeliefs get initial =>
      ExampleBeliefs(error: DefaultErrorCorrectionBeliefs.initial);

  @override
  final DefaultErrorCorrectionBeliefs error;

  @override
  ExampleBeliefs copyWith({DefaultErrorCorrectionBeliefs? error}) {
    return ExampleBeliefs(error: error ?? this.error);
  }

  @override
  toJson() => {'error': error.toJson()};

  @override
  bool operator ==(Object other) =>
      other is ExampleBeliefs && other.error == error;

  @override
  int get hashCode => error.hashCode;
}
