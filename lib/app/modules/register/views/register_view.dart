// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';

import '../../../themes/theme_app.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
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
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            child: Center(
                              child: Obx(
                                () => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: (!controller.openOtp.value)
                                        ? buildRegisterForm(context)
                                        : buildKodeVerifikasiForm(context),
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

  List<Widget> buildRegisterForm(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 15),
        child: Text("Register", style: textBlackSuperBig),
      ),
      buildTextFormField(
        label: "Email",
        textController: controller.emailRegisterController,
        validator: MultiValidator(
          [
            RequiredValidator(errorText: "Email tidak boleh kosong"),
            EmailValidator(errorText: "Email tidak valid"),
          ],
        ),
        context: context,
      ),
      buildTextFormField(
        label: "Nama",
        textController: controller.namaRegisterController,
        validator: RequiredValidator(errorText: "Nama tidak boleh kosong"),
        context: context,
      ),
      buildTextFormFieldPassword(
        label: "Password",
        textController: controller.passwordRegisterController,
        validator: RequiredValidator(errorText: "Password tidak boleh kosong"),
        isObsecure: controller.passwordVisible,
        context: context,
      ),
      buildTextFormFieldPassword(
        label: "Confirm Password",
        textController: controller.confirmPasswordRegisterController,
        validator:
            RequiredValidator(errorText: "Confirm password tidak boleh kosong"),
        isObsecure: controller.confirmPasswordVisible,
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
                controller.openOtp.value = !controller.openOtp.value;
                controller.startTimer();
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
                  "Register",
                  style: textWhiteSmallNormal,
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: textBlackSmallBalasan,
            ),
            TextButton(
              onPressed: () {
                Get.offNamed(Routes.LOGIN);
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

  List<Widget> buildKodeVerifikasiForm(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 15),
        child: Text(
          "Verification code",
          style: textBlackSuperBig,
        ),
      ),
      Text(
        "We have sent the code verification to:",
        style: textBlackSmallBalasan,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Text(
          controller.emailRegisterController.text,
          style: textBlackSmallNormal,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextFormFieldOtp(
            textController: controller.otpControllerOne,
            context: context,
          ),
          buildTextFormFieldOtp(
            textController: controller.otpControllerTwo,
            context: context,
          ),
          buildTextFormFieldOtp(
            textController: controller.otpControllerThree,
            context: context,
          ),
          buildTextFormFieldOtp(
            textController: controller.otpControllerFour,
            context: context,
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
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
      const SizedBox(height: 100),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: FlatButton(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: primaryColor),
                  ),
                  onPressed: () {
                    if (controller.startTime.value <= 0) {
                      controller.timer.cancel();
                      controller.startTimer();
                    }
                  },
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child: Text(
                        "Resend",
                        style: textRedSmallNormal,
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
                      controller.openOtp.value = !controller.openOtp.value;
                    }
                  },
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: textWhiteSmallNormal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
    ];
  }

  Widget buildTextFormFieldPassword({
    required String label,
    required TextEditingController textController,
    required String? Function(String?)? validator,
    required RxBool isObsecure,
    required BuildContext context,
  }) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: TextFormField(
          controller: textController,
          obscureText: isObsecure.value,
          validator: validator,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: label,
            suffixIcon: InkWell(
              child: Icon(
                  isObsecure.value ? Icons.visibility : Icons.visibility_off),
              onTap: () {
                isObsecure.value = !isObsecure.value;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String label,
    required TextEditingController textController,
    required String? Function(String?)? validator,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        controller: textController,
        validator: validator,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: label,
        ),
      ),
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
