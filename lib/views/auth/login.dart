import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final bool development;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  AuthCubit? _authCubit;

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // TODO: DEVELOPMENT FLAG
    development = false;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
                          const SizedBox(height: 12.0),
                          CustomTextFormField(
                            textEditingController: _emailController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.next,
                            label: "Phone",
                            hintText: "e.g., 9876543210",
                            validator: _isPhoneValid,
                          ),
                          CustomTextFormField(
                              textEditingController: _passwordController,
                              textInputAction: TextInputAction.go,
                              label: "Password",
                              hintText: "Enter your password",
                              validator: _isPasswordValid,
                              obscureText: true,
                              onFieldSubmitted: (value) => _signIn()),
                          const SizedBox(height: 24.0),
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
          development,
        );
      } else {
        return;
      }
    }
  }

  String? _isPhoneValid(String? email) {
    String _patternPhone = r'^\d{10}$';
    RegExp _regexPhone = RegExp(_patternPhone);
    if (email != null && _regexPhone.hasMatch(email)) {
      return null;
    }
    return "Invalid phone";
  }

  String? _isPasswordValid(String? password) {
    if (password!.isNotEmpty) {
      return null;
    }
    return "Password cannot be empty";
  }

  void _authListener(BuildContext context, AuthState state) {
    List<String> args = [_emailController.text, _passwordController.text];
    if (state is AuthSuccess) {
      Navigator.pushNamed(context, '/otp', arguments: args);
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