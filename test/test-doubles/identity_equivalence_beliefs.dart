import 'package:error_correction_in_perception/error_correction_in_perception.dart';
import 'package:abstractions/beliefs.dart';
import 'package:abstractions/error_correction.dart';

class IdentityEquivalenceBeliefs
    implements CoreBeliefs, ErrorCorrectionConcept {
  IdentityEquivalenceBeliefs({required this.error});

  static IdentityEquivalenceBeliefs get initial =>
      IdentityEquivalenceBeliefs(error: DefaultErrorCorrectionBeliefs.initial);

  @override
  final DefaultErrorCorrectionBeliefs error;

  @override
  IdentityEquivalenceBeliefs copyWith({DefaultErrorCorrectionBeliefs? error}) {
    return IdentityEquivalenceBeliefs(error: error ?? this.error);
  }

  @override
  toJson() => {'error': error.toJson()};
}
