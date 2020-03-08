import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/blocs/item_feed/bloc.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';
import 'package:flutter_base_app/src/blocs/user_profile/user_profile_bloc.dart';
import 'package:flutter_base_app/src/repositories/items/item_repository.dart';
import 'package:flutter_base_app/src/repositories/auth/auth_repository.dart';
import 'package:flutter_base_app/src/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Combines application level bloc stores above the rest of the application
class AppBlocProviders extends StatelessWidget {
  AppBlocProviders({this.child});

  final AuthenticationBloc authBloc = AuthenticationBloc(AuthRepository());
  final Widget child;

  @override
  Widget build(BuildContext context) {
    authBloc.add(AppStarted());
    return BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => authBloc,
        child: Builder(builder: (BuildContext subAuthenticationContext) {
          return MultiBlocProvider(
              providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
                BlocProvider<LocalizationBloc>(
                  create: (_) => LocalizationBloc(),
                ),
                BlocProvider<ItemBloc>(
                  create: (_) => ItemBloc(itemRepository: ItemRepository()),
                ),
                BlocProvider<UserProfileBloc>(
                  create: (_) => UserProfileBloc(UserRepository()),
                )
              ],
              child: child);
        }));
  }
}
