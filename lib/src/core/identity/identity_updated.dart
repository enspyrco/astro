import 'package:abstractions/beliefs.dart';
import 'package:abstractions/identity.dart';

class IdentityUpdated<T extends CoreBeliefs> extends Conclusion<T> {
  const IdentityUpdated({String? newAppleCredential})
      : _newAppleCredential = newAppleCredential;

  final String? _newAppleCredential;

  @override
  T conclude(T beliefs) {
    final credentials = (beliefs as dynamic).identity.credentials
        as Map<IdentityProvider, String>;

    if (_newAppleCredential != null) {
      credentials[IdentityProvider.apple] = _newAppleCredential!;
    }

    return (beliefs as dynamic).copyWith(
        identity: (beliefs as dynamic)
            .identity
            .copyWith(credentials: credentials)) as T;
  }

  @override
  toJson() => {
        'name_': 'IdentityUpdated',
        'state_': {
          'newAppleCredential': _newAppleCredential,
        }
      };
}
