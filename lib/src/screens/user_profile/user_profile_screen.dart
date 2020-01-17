import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/blocs/user_profile/bloc.dart';
import 'package:flutter_base_app/src/widgets/user_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  build(context) {
    final theme = Theme.of(context);
    final _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        bloc: _userProfileBloc,
        builder: (context, userProfileState) {
          if (userProfileState is InitialUserProfileState) {
            BlocProvider.of<AuthenticationBloc>(context)
                .getCurrentUserId()
                .then((userId) {
              _userProfileBloc.add(FetchUserProfile(userId));
            });
          }
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, isScrolled) {
                return [SliverAppBar()];
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(children: [
                  if (userProfileState is UserProfileFetched)
                    UserAvatar(userProfileState.user)
                  else
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      (userProfileState as UserProfileFetched)
                              ?.user
                              ?.fullName ??
                          '',
                      style: theme.primaryTextTheme.headline
                          .copyWith(color: Colors.black)),
                  Text(
                      (userProfileState as UserProfileFetched)?.user?.email ??
                          '',
                      style: theme.primaryTextTheme.headline
                          .copyWith(color: Colors.black))
                ]),
              ),
            ),
          );
        });
  }
}
