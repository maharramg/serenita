import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenita/foundation/helpers/classes/sized_boxes.dart';
import 'package:serenita/foundation/helpers/classes/validations.dart';
import 'package:serenita/foundation/helpers/functions/locator.dart';
import 'package:serenita/foundation/services/notification_service.dart';
import 'package:serenita/foundation/state-logic/sign-up/sign_up_cubit.dart';
import 'package:serenita/presentation/screens/home_screen.dart';
import 'package:serenita/presentation/screens/sign_in_screen.dart';
import 'package:serenita/presentation/widgets/common/app_bar_custom.dart';
import 'package:serenita/presentation/widgets/common/button_custom.dart';
import 'package:serenita/presentation/widgets/common/text_field_custom.dart';
import 'package:serenita/supplies/constants/theme_globals.dart';
import 'package:serenita/supplies/extensions/build_context_ext.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpCubit = SignUpCubit();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: context.tr('sign_up'),
      ),
      body: BlocProvider(
        create: (context) => _signUpCubit,
        child: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.pushAndRemoveUntil(const HomeScreen());
            }

            if (state is SignUpFailure) {
              getIt<NotificationService>().notify(context.tr(state.message));
            }
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Container(
          padding: spacing16,
          child: Column(
            children: [
              TextFieldCustom(
                key: const Key('signup_first_name_input'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                validator: (value) => Validations(context: context).validateInputText(value!),
                onChanged: (value) {
                  _signUpCubit.setFirstNameValue(value);
                },
                labelText: context.tr('first_name'),
                showInputTitle: true,
              ),
              const SizedBox12(),
              TextFieldCustom(
                key: const Key('signup_last_name_input'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                onChanged: (value) {
                  _signUpCubit.setLastNameValue(value);
                },
                labelText: '${context.tr('last_name')} (${context.tr('optional')})',
                placeholder: context.tr('last_name'),
                showInputTitle: true,
              ),
              const SizedBox12(),
              TextFieldCustom(
                key: const Key('signup_email_input'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                validator: (value) => Validations(context: context).validateEmail(value!),
                onChanged: (value) {
                  _signUpCubit.setEmailValue(value);
                },
                labelText: context.tr('email'),
                showInputTitle: true,
              ),
              const SizedBox12(),
              TextFieldCustom(
                key: const Key('login_password_input'),
                obscureText: true,
                labelText: context.tr('password'),
                showInputTitle: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                textInputAction: TextInputAction.send,
                validator: (value) => Validations(context: context).validatePassword(value!, strict: true),
                onChanged: (value) {
                  _signUpCubit.setPasswordValue(value);
                },
              ),
              const SizedBox12(),
              TextFieldCustom(
                key: const Key('login_repeat_password_input'),
                obscureText: true,
                labelText: context.tr('repeat_password'),
                showInputTitle: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                textInputAction: TextInputAction.send,
                validator: (value) => Validations(context: context).validateConfirmPassword(value: value, password: _signUpCubit.passwordFieldValue),
                onChanged: (value) {
                  _signUpCubit.setConfirmPasswordValue(value);
                },
                onFieldSubmitted: (val) {
                  _signUpCubit.signUp();
                },
              ),
              const SizedBox16(),
              ButtonCustom(
                title: context.tr('sign_up').toUpperCase(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signUpCubit.signUp();
                  }
                },
              ),
              const SizedBox24(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: grey400Color.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AutoSizeText(
                    context.tr('or'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: grey400Color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: grey400Color.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox24(),
              // Row(
              //   children: [
              //     Expanded(
              //       child: BlocBuilder<RegistrationCubit, RegistrationState>(
              //         builder: (context, state) {
              //           return ButtonSocial(
              //             onPressed: () async => await _registrationCubit.signUpWithGoogle(),
              //             icon: FontAwesomeIcons.google,
              //             iconColor: whiteColor,
              //             bgColor: whiteColor,
              //             textColor: primaryColor,
              //             status: state is RegistrationGoogleBusy,
              //             imageIcon: Image.asset(
              //               AssetImages.googleIcon,
              //               height: 28.0,
              //             ),
              //             outline: true,
              //           );
              //         },
              //       ),
              //     ),
              //     if (Platform.isIOS) ...[
              //       const SizedBox(width: 12.0),
              //       Expanded(
              //         child: ButtonSocial(
              //           onPressed: () async => await _registrationCubit.signUpWithApple(),
              //           icon: FontAwesomeIcons.apple,
              //           iconColor: whiteColor,
              //           bgColor: appleColor,
              //           textColor: whiteColor,
              //         ),
              //       ),
              //     ],
              //   ],
              // ),
              // const SizedBox24(),
              RichText(
                text: TextSpan(
                  style: size13weight400.copyWith(color: grey800Color),
                  children: [
                    TextSpan(text: '${context.tr('already_have_an_account')} '),
                    TextSpan(
                      text: context.tr('sign_in'),
                      style: size13weight600.copyWith(color: primaryColor),
                      recognizer: TapGestureRecognizer()..onTap = () => context.pushReplacement(const SignInScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
