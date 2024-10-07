import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/bloc/form_submission_status.dart';
import 'package:login_bloc/bloc/login_bloc.dart';
import 'package:login_bloc/bloc/login_event.dart';
import 'package:login_bloc/bloc/login_state.dart';

import '../../../constants.dart';

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(
              context, 'Login failed: ${formStatus.exception.toString()}');
        }
        if (formStatus is SubmissionSuccess) {
          _showSnackBar(context, 'Login Successful!');
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _usernameField(),
            const SizedBox(height: defaultPadding),
            _passwordField(),
            const SizedBox(height: defaultPadding),
            _loginButton(),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            hintText: "username",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Username is required';
            }
            if (value.length <= 3) {
              return 'Username is too short';
            }
            return null;
          },
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginUsernameChanged(username: value),
              ),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
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
            if (value.length <= 6) {
              return 'Password is too short';
            }
            return null;
          },
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginPasswordChanged(password: value),
              ),
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                },
                child: Text(
                  "Login".toUpperCase(),
                ),
              );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
