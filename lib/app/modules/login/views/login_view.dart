import 'package:flutter/material.dart';
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
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Login",
                                          style: textBlackSuperBig,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: TextFormField(
                                          controller:
                                              controller.emailController,
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText:
                                                    "Email tidak boleh kosong"),
                                            EmailValidator(
                                                errorText: "Email tidak valid"),
                                          ]),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            labelText: "Email",
                                            hintText: "Email",
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: TextFormField(
                                            controller:
                                                controller.passwordController,
                                            obscureText: controller
                                                .passwordVisible.value,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              labelText: "Password",
                                              hintText: "Password",
                                              suffixIcon: InkWell(
                                                child: Icon(controller
                                                        .passwordVisible.value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onTap: () {
                                                  controller.passwordVisible
                                                          .value =
                                                      !controller
                                                          .passwordVisible
                                                          .value;
                                                },
                                              ),
                                            ),
                                            validator: RequiredValidator(
                                                errorText:
                                                    "Password tidak boleh kosong"),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Center(
                                          child: ElevatedButton(
                                            clipBehavior: Clip.hardEdge,
                                            onPressed: () {
                                              if (_formkey.currentState!
                                                  .validate()) {
                                                controller.login();
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
                                                  "Login",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 60),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Doesn't have an account?",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Get.offNamed(Routes.REGISTER);
                                              },
                                              child: Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.red[900],
                                                    fontWeight:
                                                        FontWeight.bold),
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
}
