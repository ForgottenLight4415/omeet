import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/auth_cubit.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/check_connection.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/loading_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  AuthCubit? _authCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
  }

  @override
  void dispose() {
    _authCubit!.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedCrossFade(
          crossFadeState: _crossFadeState,
          duration: const Duration(milliseconds: 500),
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // LOGO
                          const AppLogo(),
                          // LOGIN Text
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sign in to continue",
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontFamily: AppStrings.secondaryFontFam,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextFormField(
                            textEditingController: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            label: "Email address",
                            hintText: "Enter registered email address",
                            validator: _isEmailValid,
                          ),
                          CustomTextFormField(
                              textEditingController: _passwordController,
                              textInputAction: TextInputAction.go,
                              label: "Password",
                              hintText: "Enter your password",
                              validator: _isPasswordValid,
                              obscureText: true,
                              onFieldSubmitted: (value) {
                                _signIn();
                              }),
                          const SizedBox(height: 18.0),
                          BlocProvider<AuthCubit>.value(
                            value: _authCubit!,
                            child: BlocListener<AuthCubit, AuthState>(
                              listener: _authListener,
                              child: ElevatedButton(
                                onPressed: _signIn,
                                child: const Text("SIGN IN"),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          secondChild: const LoadingWidget(
            label: AppStrings.signingIn,
          ),
          layoutBuilder:
              (topChild, topChildKey, bottomChild, bottomChildKey) {
            return Stack(
              clipBehavior: Clip.none,
              // Align the non-positioned child to center.
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  key: bottomChildKey,
                  top: 0,
                  bottom: 0,
                  child: bottomChild,
                ),
                Positioned(
                  key: topChildKey,
                  child: topChild,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (await checkConnection(context)) {
        _authCubit!.signIn(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        return;
      }
    }
  }

  String? _isEmailValid(String? email) {
    String _pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp _regex = RegExp(_pattern);
    if (_regex.hasMatch(email!)) {
      return null;
    }
    return "Invalid email address";
  }

  String? _isPasswordValid(String? password) {
    if (password!.isNotEmpty) {
      return null;
    }
    return "Password cannot be empty";
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: _emailController.text,
      );
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _crossFadeState = CrossFadeState.showFirst;
      });
    } else if (state is AuthFailed) {
      setState(() {
        _crossFadeState = CrossFadeState.showFirst;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign in failed. (${state.cause})"),
      ));
    } else {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    }
  }
}
