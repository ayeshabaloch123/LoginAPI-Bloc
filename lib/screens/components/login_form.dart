import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/bloc/login_event.dart';
import 'package:login_bloc/bloc/login_state.dart';

import '../../../constants.dart';

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginForm({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _usernameField(),
              const SizedBox(height: defaultPadding),
              _passwordField(),
              const SizedBox(height: defaultPadding),
              _loginButton(),
              const SizedBox(height: defaultPadding),
              if (state.loginStatus == LoginStatus.loading)
                const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (current, previous) => current.email != previous.email,
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            hintText: "email",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'email is required';
            }
            return null;
          },
          onChanged: (value) => context.read<LoginBloc>().add(
            EmailChanged(email: value),
          ),

        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (current, previous) => current.password != previous.password,
      builder: (context, state) {
        return TextFormField(
          textInputAction: TextInputAction.done,
          obscureText: true,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            hintText: "password",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.lock),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
          onChanged: (value) => context.read<LoginBloc>().add(
            PasswordChanged(password: value),
              ),
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.loginStatus != current.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text(state.message.toString())));
        } else if (state.loginStatus == LoginStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Login successful')));
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.loginStatus == LoginStatus.loading
              ? null
              : () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginApi());
            }
          },
          child: Text(
            state.loginStatus == LoginStatus.loading
                ? "Submitting..."
                : "Login".toUpperCase(),
          ),
        );
      },
    );
  }
}











