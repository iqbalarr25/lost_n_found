import 'package:flutter/material.dart';
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
              Image.network(
                "https://firebasestorage.googleapis.com/v0/b/telu-lost-and-found.appspot.com/o/app%2Fbg_login.jpeg?alt=media&token=36e2ecdc-6079-469b-812b-0ae597da4fdf",
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
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/telu-lost-and-found.appspot.com/o/app%2FLogoTelkom.png?alt=media&token=db9cde83-69fe-42ec-bc0c-12b9fbb28b6c",
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
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 25, bottom: 15),
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    buildTextFormField(
                                      label: "Email",
                                      textController:
                                          controller.emailController,
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                              errorText:
                                                  "Email tidak boleh kosong"),
                                          EmailValidator(
                                              errorText: "Email tidak valid"),
                                        ],
                                      ),
                                    ),
                                    buildTextFormField(
                                      label: "Nama",
                                      textController: controller.namaController,
                                      validator: RequiredValidator(
                                          errorText: "Nama tidak boleh kosong"),
                                    ),
                                    buildTextFormFieldPassword(
                                      label: "Password",
                                      textController:
                                          controller.passwordController,
                                      validator: RequiredValidator(
                                          errorText:
                                              "Password tidak boleh kosong"),
                                      isObsecure: controller.passwordVisible,
                                    ),
                                    buildTextFormFieldPassword(
                                      label: "Confirm Password",
                                      textController:
                                          controller.confirmPasswordController,
                                      validator: RequiredValidator(
                                          errorText:
                                              "Confirm password tidak boleh kosong"),
                                      isObsecure:
                                          controller.confirmPasswordVisible,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Center(
                                        child: ElevatedButton(
                                          clipBehavior: Clip.hardEdge,
                                          onPressed: () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              controller.register();
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Sign up",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Doesn't have an account?",
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.offNamed(Routes.LOGIN);
                                            },
                                            child: const Text(
                                              "Sign In",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Obx buildTextFormFieldPassword({
    required String label,
    required TextEditingController textController,
    required String? Function(String?)? validator,
    required RxBool isObsecure,
  }) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: TextFormField(
          controller: textController,
          obscureText: isObsecure.value,
          validator: validator,
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

  Padding buildTextFormField({
    required String label,
    required TextEditingController textController,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: textController,
        validator: validator,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: label),
      ),
    );
  }
}
