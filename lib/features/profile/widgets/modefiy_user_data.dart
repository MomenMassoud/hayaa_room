import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/widgets/show_snack_par.dart';
import '../../../models/user_model.dart';
import '../functions/update_user_data.dart';
import '../functions/upload_user_profile_photo.dart';

class ModefiyUserData extends StatefulWidget {
  const ModefiyUserData({super.key, required this.userData});
  final UserModel userData;
  @override
  State<ModefiyUserData> createState() => _ModefiyUserDataState();
}

class _ModefiyUserDataState extends State<ModefiyUserData> {
  late TextEditingController nameControler;
  late TextEditingController bioControler;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool showPickedFile = false;
  File? imageFile;
  bool _showspinner = false;
  String userCountry = "";
  String userImage = "";
  DateTime dateTime = DateTime.now();
  String birthDate = "";
  bool isloading = false;
  @override
  void initState() {
    userCountry = widget.userData.acualCountry;
    birthDate = widget.userData.birthdate;
    userImage = widget.userData.photo;
    // TODO: implement initState
    nameControler = TextEditingController(text: widget.userData.name);
    bioControler = TextEditingController(text: widget.userData.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHieght = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Edit profile",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isloading = true;
                });
                try {
                  if (imageFile != null) {
                    userImage = await uploadUserProfilePhoto(imageFile);
                  }
                  await updateUserProfileData({
                    'photo': userImage,
                    "name": nameControler.text,
                    "birthdate": birthDate,
                    "acualCountry": userCountry,
                    "bio": bioControler.text
                  });
                  Navigator.pop(context, true);
                  showSnackBar("your data updated successfully", context);
                } catch (e) {
                  setState(() {
                    isloading = false;
                  });
                  showSnackBar(
                      "Opps an Error has happend ${e.toString()}", context);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: (widget.userData.name == nameControler.text &&
                            widget.userData.birthdate == birthDate &&
                            widget.userData.country == userCountry &&
                            widget.userData.bio == bioControler.text &&
                            imageFile == null)
                        ? Colors.grey
                        : Colors.green),
              ),
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        child: Container(
          height: screenHieght,
          width: screenWidth,
          color: Colors.grey.withOpacity(0.15),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  const Text(
                    "Avatar",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      await _pickImage();
                    },
                    child: showPickedFile
                        ? Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(imageFile!))),
                          )
                        : Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        widget.userData.photo),
                                    fit: BoxFit.fill)),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        "Nickname",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "${widget.userData.name.length}/30",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      controller: nameControler,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Birthdate",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => showSheet(context, child: buildDatePicker(),
                        onpress: () {
                      setState(() {
                        birthDate = DateFormat('yyyy/MM/dd').format(dateTime);
                        log(birthDate);
                      });
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 54,
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        // "2002-08-27",
                        birthDate,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Country/Region",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        exclude: <String>['KN', 'MF'],
                        favorite: <String>['SE'],
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            userCountry =
                                country.toString().split(" ")[3].split(")")[0];
                          });
                          print('Select country: ${userCountry}');
                        },
                        countryListTheme: CountryListThemeData(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                          // Optional. Styles the search field.
                          inputDecoration: InputDecoration(
                            labelText: 'Search',
                            hintText: 'Start typing to search',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
                              ),
                            ),
                          ),
                          searchTextStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                    child: Container(
                        height: 54,
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          userCountry,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        "bio",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "${bioControler.text.length}/400",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                      constraints:
                          BoxConstraints(minHeight: screenHieght * 0.2),
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        maxLines: 5,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        controller: bioControler,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile = tempImage;
      showPickedFile = true;
    });
  }

  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          initialDateTime: dateTime,
          maximumYear: DateTime.now().year,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (value) => setState(
            () => dateTime = value,
          ),
        ),
      );
  static void showSheet(BuildContext context,
          {required Widget child, required VoidCallback onpress}) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [child],
            cancelButton: CupertinoActionSheetAction(
                onPressed: onpress,
                child: const Text(
                  "confirm",
                  style: TextStyle(color: Colors.green),
                )),
          );
        },
      );
}
