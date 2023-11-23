import 'package:abstractions/beliefs.dart';
import 'package:abstractions/identity.dart';

class CredentialAdded<T extends CoreBeliefs> extends Conclusion<T> {
  const CredentialAdded({
    required this.newAppleCredential,
  });

  final String? newAppleCredential;

  @override
  T conclude(T beliefs) {
    final credentials = (beliefs as dynamic).identity.credentials
        as Map<IdentityProvider, String>;

    if (newAppleCredential != null) {
      credentials[IdentityProvider.apple] = newAppleCredential!;
    }

    return (beliefs as dynamic).copyWith(
        identity: (beliefs as dynamic)
            .identity
            .copyWith(credentials: credentials)) as T;
  }

  @override
  toJson() => {
        'name_': 'CredentialAdded',
        'state_': (newAppleCredential != null)
            ? {
                'newAppleCredential': newAppleCredential,
              }
            : {},
      };
}
