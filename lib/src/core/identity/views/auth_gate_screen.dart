import 'package:flutter/material.dart';
import 'package:types_for_auth/types_for_auth.dart';
import 'package:abstractions/beliefs.dart';

import '../../../widgets/stream_of_consciousness.dart';
import '../../../widgets/utils/progress_indicator_with_message.dart';

class AuthGateScreen<S extends CoreBeliefs> extends StatelessWidget {
  const AuthGateScreen({
    required this.signInScreen,
    required this.homeScreen,
    super.key,
  });

  final Widget signInScreen;
  final Widget homeScreen;

  @override
  Widget build(BuildContext context) {
    return StreamOfConsciousness<S, SignedInState>(
      infer: (state) =>
          (state as dynamic).identity.userAuthState.signedIn as SignedInState,
      builder: ((context, signedInState) {
        switch (signedInState) {
          case SignedInState.checking:
            return const ProgressIndicatorWithMessage('Checking...');
          case SignedInState.notSignedIn:
            return signInScreen;
          case SignedInState.signedIn:
            return homeScreen;
          default:
            return const CircularProgressIndicator();
        }
      }),
    );
  }
}
