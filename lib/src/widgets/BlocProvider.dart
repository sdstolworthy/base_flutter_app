import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';
import 'package:flutter_base_app/src/repositories/user/userRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Combines application level bloc stores above the rest of the application
class AppBlocProviders extends StatelessWidget {
  final Widget child;
  AppBlocProviders({this.child});
  Widget build(BuildContext _) {
    return BlocProvider(
        builder: (context) => AuthenticationBloc(new UserRepository()),
        child: Builder(builder: (subAuthenticationContext) {
          final authBloc =
              BlocProvider.of<AuthenticationBloc>(subAuthenticationContext);
          return MultiBlocProvider(providers: [
            BlocProvider<LocalizationBloc>(
                builder: (context) => LocalizationBloc()),
          ], child: child);
        }));
  }
}
