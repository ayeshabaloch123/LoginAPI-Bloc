import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/auth/auth_repository.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/responsive.dart';
import 'package:login_bloc/screens/components/background.dart';
import 'package:login_bloc/screens/components/login_form.dart';
import 'package:login_bloc/screens/components/login_screen_image.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: BlocProvider(
            create: (context) => LoginBloc(
              authRepo: context.read<AuthRepository>(),
            ),
            child: const MobileLoginScreen(),
          ),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenImage(),
              ),
              BlocProvider(
                create: (context) => LoginBloc(
                  authRepo: context.read<AuthRepository>(),
                ),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: LoginForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginScreenImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
