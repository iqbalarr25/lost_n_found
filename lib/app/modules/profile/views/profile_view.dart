import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/data/models/user_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';

import '../../../themes/theme_app.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            icon: const Icon(Icons.history, size: 28),
            onPressed: () {
              Get.toNamed(Routes.HISTORY);
            },
          ),
          centerTitle: true,
          title: Text(
            "My Profile",
            style: textAppBar,
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (controller.dataUser.value.email != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: buildEditProfile(controller.dataUser, context),
                    ),
                  );
                }
              },
            ),
            IconButton(
              onPressed: () {
                controller.box.erase();
                Get.reloadAll();
                Get.offAllNamed(Routes.LOGIN);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: (!controller.isLoading.value)
            ? FutureBuilder(
                future: controller.tampilDataUserFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    controller.namaController.text =
                        controller.dataUser.value.name!;
                    controller.nimController.text =
                        (controller.dataUser.value.nim != null)
                            ? controller.dataUser.value.nim
                            : "";
                    controller.nomorController.text =
                        (controller.dataUser.value.phone != null)
                            ? controller.dataUser.value.phone
                            : "";
                    return Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          color: primaryColor,
                        ),
                        Center(
                          child: SingleChildScrollView(
                            child: Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 90,
                                          backgroundImage: const NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/telu-lost-and-found.appspot.com/o/app%2Favatar.jpg?alt=media&token=c01c3914-2907-43ed-b81f-c00d11294b15"),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                            controller.dataUser.value.name!
                                                .capitalizeFirst!,
                                            style: textBlackSuperBig),
                                        const SizedBox(height: 10),
                                        Text(
                                          "2 post created",
                                          style: textBlackSmall,
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 250,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 20),
                                            child: Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: [
                                                buildBiodata(
                                                  icon: Icons.assignment_ind,
                                                  judul: "Role",
                                                  isi: controller
                                                      .dataUser.value.role,
                                                ),
                                                buildBiodata(
                                                  icon: Icons.assignment,
                                                  judul: "NIM",
                                                  isi: controller
                                                      .dataUser.value.nim,
                                                ),
                                                buildBiodata(
                                                  icon: Icons.phone,
                                                  judul: "Phone",
                                                  isi: controller
                                                      .dataUser.value.phone,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/telu-lost-and-found.appspot.com/o/app%2FLogoTelkom.png?alt=media&token=db9cde83-69fe-42ec-bc0c-12b9fbb28b6c",
                                              width: 70,
                                              height: 70,
                                              color: Colors.red[900],
                                            ),
                                            Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/telu-lost-and-found.appspot.com/o/app%2Fmytelu.png?alt=media&token=47cccf7b-ec63-4247-a1fe-691b2bd09af5",
                                              width: 70,
                                              height: 70,
                                            ),
                                            const SizedBox(height: 85)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget buildBiodata(
      {required IconData icon, required String judul, required dynamic isi}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: textBlackSmall,
            ),
            if (isi == null)
              Text(
                "Belum memiliki $judul",
                style: textRedMini,
              )
            else
              Text(
                isi,
                style: textGreyDetailLaporan,
              )
          ],
        )
      ],
    );
  }

  Widget buildEditProfile(Rx<User> dataUser, BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Edit Profile",
                      style: textBlackSuperBig,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: controller.namaController,
                      validator: RequiredValidator(
                          errorText: "Nama tidak boleh kosong"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Nama",
                        hintStyle: textGreyMediumNormal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      controller: controller.nimController,
                      validator: RequiredValidator(
                          errorText: "NIM tidak boleh kosong"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "NIM",
                        hintStyle: textGreyMediumNormal,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      controller: controller.nomorController,
                      validator: RequiredValidator(
                          errorText: "Nomor tidak boleh kosong"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Nomor",
                        hintStyle: textGreyMediumNormal,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: ElevatedButton(
                        clipBehavior: Clip.hardEdge,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.editProfil();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
