import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocProviders extends StatelessWidget {
  final Widget child;
  AppBlocProviders({this.child});
  Widget build(BuildContext _) {
    return BlocProvider(
        builder: (context) => AuthenticationBloc(),
        child: Builder(builder: (subAuthenticationContext) {
          final authBloc =
              BlocProvider.of<AuthenticationBloc>(subAuthenticationContext);
          return MultiBlocProvider(providers: [], child: child);
        }));
  }
}
