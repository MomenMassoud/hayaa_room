import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/widgets/show_snack_par.dart';
import '../../../home/views/home_view.dart';
import '../../../rooms/widget/create_alarm_error.dart';
import '../../sinup/widget/auth_service_google.dart';

class CompleteAndStorUserData extends StatefulWidget {
  const CompleteAndStorUserData({super.key, required this.userId});
  static const id = "CompleteAndStorUserData";
  final String userId;
  @override
  State<CompleteAndStorUserData> createState() =>
      _CompleteAndStorUserDataState();
}

class _CompleteAndStorUserDataState extends State<CompleteAndStorUserData> {
  late TextEditingController bioControler;
  String userCountry = "Egypt";
  String birthdate = "00-00-00";
  DateTime dateTime = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  var items = ["male", "female"];
  String? selectedGender = 'male';
  @override
  void initState() {
    bioControler = TextEditingController(text: 'Hello i use Hayya ');
    super.initState();
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final screenHight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "Complete Your Data to use app!",
          ),
        ),
        body: Container(
          height: screenHight,
          width: screenWidth,
          color: Colors.grey.withOpacity(0.2),
          child: ModalProgressHUD(
            inAsyncCall: isloading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          "gender",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            isExpanded: true,
                            iconSize: 36,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() {
                              selectedGender = value;
                              log(selectedGender ?? "");
                            }),
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
                                userCountry = country
                                    .toString()
                                    .split(" ")[3]
                                    .split(")")[0];
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
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
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
                      const Text(
                        "Birthdate",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => showSheet(context,
                            child: buildDatePicker(), onpress: () {
                          setState(() {
                            birthdate =
                                DateFormat('yyyy/MM/dd').format(dateTime);
                            print(birthdate);
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
                            birthdate,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                            BoxConstraints(minHeight: screenHight * 0.2),
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () async {
                                log(selectedGender ?? "");
                                if (birthdate != "00-00-00") {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    await storeUserData(
                                        auth,
                                        widget.userId,
                                        userCountry,
                                        selectedGender ?? "",
                                        birthdate,
                                        bioControler.text);
                                    Navigator.pushReplacementNamed(
                                        context, HomeView.id);
                                  } catch (e) {
                                    showSnackBar(
                                        "opps an error has happend ${e.toString()}",
                                        context);
                                  }
                                } else {
                                  allarmError(
                                      "please Enter Your BirthDate", context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: const Text(
                                "confirm",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                      ),
                      // const SizedBox(height: 24),
                    ]),
              ),
            ),
          ),
        ));
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      );
}
