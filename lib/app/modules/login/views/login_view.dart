import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Image.asset(
                "assets/images/bg_login.jpeg",
                fit: BoxFit.cover,
                height: double.infinity,
                alignment: Alignment.center,
              ),
              SafeArea(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/logo_telkom.png",
                        ),
                      ),
                      SingleChildScrollView(
                        child: Form(
                          key: _formkey,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25))),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Center(
                                  child: Obx(
                                    () => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (!controller
                                              .isForgotPassword.value)
                                          ? buildLoginScreen(context)
                                          : buildForgotPasswordScreen(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildLoginScreen(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          "Login",
          style: textBlackSuperBig,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: buildTextFormField(
          context: context,
          controller: controller.emailLoginController,
          label: "Email",
          validator: MultiValidator(
            [
              RequiredValidator(errorText: "Email tidak boleh kosong"),
              EmailValidator(errorText: "Email tidak valid"),
            ],
          ),
        ),
      ),
      Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 15),
          child: buildTextFormFieldPassword(
            context: context,
            controller: controller.passwordLoginController,
            isObscure: controller.passwordVisible,
            label: "Password",
            validator:
                RequiredValidator(errorText: "Password tidak boleh kosong"),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: ElevatedButton(
            clipBehavior: Clip.hardEdge,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                controller.login();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text("Login", style: textWhiteSmallNormal),
              ),
            ),
          ),
        ),
      ),
      TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent)),
        onPressed: () {
          controller.isForgotPassword.value =
              !controller.isForgotPassword.value;
        },
        child: Text("Forgot Password?", style: textBlackSmall),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Doesn't have an account?",
              style: textBlackSmallBalasan,
            ),
            TextButton(
              onPressed: () {
                Get.offNamed(Routes.REGISTER, arguments: [
                  controller.emailLoginController.text,
                  controller.passwordLoginController.text
                ]);
              },
              child: Text(
                "Sign Up",
                style: textRedMini,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> buildForgotPasswordScreen(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          (controller.isOtpSend.value &&
                  controller.isAccessResetPasswordConfirmed.value)
              ? "Change your password"
              : "Forgot your Password?",
          style: textBlackSuperBig,
        ),
      ),
      if (controller.isOtpSend.value &&
          controller.isAccessResetPasswordConfirmed.value) ...[
        const SizedBox(height: 30),
        buildTextFormField(
          label: "Email",
          controller: controller.emailLoginController,
          context: context,
          readOnly: true,
        ),
        const SizedBox(height: 15),
        buildTextFormFieldPassword(
          label: "Password",
          controller: controller.passwordLoginController,
          validator:
              RequiredValidator(errorText: "Password tidak boleh kosong"),
          isObscure: controller.passwordVisible,
          context: context,
        ),
        const SizedBox(height: 15),
        buildTextFormFieldPassword(
          label: "Confirm Password",
          controller: controller.confirmPasswordLoginController,
          validator: RequiredValidator(
              errorText: "Confirm password tidak boleh kosong"),
          isObscure: controller.confirmPasswordVisible,
          context: context,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: ElevatedButton(
              clipBehavior: Clip.hardEdge,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  controller.resetPassword();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Reset password",
                    style: textWhiteSmallNormal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ] else if (controller.isOtpSend.value &&
          !controller.isAccessResetPasswordConfirmed.value) ...[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "We have sent the code verification to:",
            style: textBlackSmallBalasan,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              FittedBox(
                child: Text(
                  controller.emailLoginController.text,
                  style: textBlackSmall,
                ),
              ),
              FittedBox(
                child: TextButton(
                  onPressed: () {
                    controller.isOtpSend.value = false;
                    controller.timer.cancel();
                    controller.otpControllerOne.text = "";
                    controller.otpControllerTwo.text = "";
                    controller.otpControllerThree.text = "";
                    controller.otpControllerFour.text = "";
                  },
                  child: Text(
                    "Bukan email saya?",
                    style: textLinkSmallNormal,
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextFormFieldOtp(
              textController: controller.otpControllerOne,
              context: context,
            ),
            const SizedBox(width: 10),
            buildTextFormFieldOtp(
              textController: controller.otpControllerTwo,
              context: context,
            ),
            const SizedBox(width: 10),
            buildTextFormFieldOtp(
              textController: controller.otpControllerThree,
              context: context,
            ),
            const SizedBox(width: 10),
            buildTextFormFieldOtp(
              textController: controller.otpControllerFour,
              context: context,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Resend code after ",
                    style: textBlackSmallBalasan,
                  ),
                  TextSpan(
                    text: controller.startTime.value.toString(),
                    style: textRedMini,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: FlatButton(
                    splashColor:
                        (controller.startTime.value <= 0) ? null : whiteColor,
                    highlightColor:
                        (controller.startTime.value <= 0) ? null : whiteColor,
                    color: (controller.startTime.value <= 0)
                        ? primaryColor
                        : Colors.transparent,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: primaryColor),
                    ),
                    onPressed: () {
                      if (controller.startTime.value <= 0) {
                        controller.sentOtpResetPassword();
                      }
                    },
                    child: SizedBox(
                      height: 45,
                      child: Center(
                        child: Text(
                          "Resend",
                          style: (controller.startTime.value <= 0)
                              ? textWhiteSmallNormal
                              : textRedSmallNormal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        controller.confirmOtpResetPassword();
                      }
                    },
                    child: SizedBox(
                      height: 45,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            "Confirm",
                            style: textWhiteSmallNormal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ] else ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Please enter your email address.",
            style: textBlackSmallNormal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: buildTextFormField(
            context: context,
            controller: controller.emailLoginController,
            validator: MultiValidator([
              RequiredValidator(errorText: "Email tidak boleh kosong"),
              EmailValidator(errorText: "Email tidak valid"),
            ]),
            label: "Email",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: ElevatedButton(
              clipBehavior: Clip.hardEdge,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  controller.isOtpSend.value = true;
                  controller.sentOtpResetPassword();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text("Reset Password", style: textWhiteSmallNormal),
                ),
              ),
            ),
          ),
        ),
      ],
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remember your password?",
              style: textBlackSmallBalasan,
            ),
            TextButton(
              onPressed: () {
                controller.isForgotPassword.value = false;
                controller.isOtpSend.value = false;
                controller.isAccessResetPasswordConfirmed.value = false;
                controller.otpControllerOne.text = "";
                controller.otpControllerTwo.text = "";
                controller.otpControllerThree.text = "";
                controller.otpControllerFour.text = "";
                controller.timer.cancel();
              },
              child: Text(
                "Sign In",
                style: textRedMini,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  TextFormField buildTextFormFieldPassword({
    required String label,
    required BuildContext context,
    required TextEditingController controller,
    required RxBool isObscure,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: controller,
      obscureText: isObscure.value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: label,
        hintText: label,
        suffixIcon: InkWell(
          child:
              Icon(isObscure.value ? Icons.visibility : Icons.visibility_off),
          onTap: () {
            isObscure.value = !isObscure.value;
          },
        ),
      ),
      validator: validator,
    );
  }

  TextFormField buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool? readOnly,
  }) {
    return TextFormField(
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: label,
        hintText: label,
      ),
      readOnly: (readOnly) ?? false,
    );
  }

  Widget buildTextFormFieldOtp({
    required TextEditingController textController,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 64,
      height: 68,
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: textRedSuperBig,
        onChanged: (value) {
          FocusScope.of(context).nextFocus();
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        controller: textController,
        decoration: InputDecoration(
          hintText: "0",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
