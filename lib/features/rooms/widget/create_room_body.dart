import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../core/Utils/app_images.dart';
import '../../../core/widgets/show_snack_par.dart';
import '../../agencies/widgets/custom_image_picker.dart';
import '../../agencies/widgets/seperated_text.dart';
import '../../auth/choice between registration and login/widgets/gradiant_button.dart';
import '../states_manager/room_creation/room_creation_cubit.dart';
import 'create_alarm_error.dart';

class CreateRoomBody extends StatefulWidget {
  const CreateRoomBody({super.key});

  @override
  _CreateRoomBody createState() => _CreateRoomBody();
}

class _CreateRoomBody extends State<CreateRoomBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? imageFile;
  bool showPickedFile = false;
  Random random = new Random();
  bool _showspinner = false;
  TextEditingController namefield = TextEditingController();
  String mycountry = "";
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Hayaa Room",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<RoomCreationCubit, RoomCreationState>(
        listener: (context, state) {
          if (state is RoomCreationFailure) {
            allarmError(state.errorMessage, context);
          } else if (state is RoomCreationSuccess) {
            // allarmError("your room is created successfully", context);
            showSnackBar("your room is created successfully", context);
            Navigator.pop(context, true);
            //create snack par
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is RoomCreationLoading ? true : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showPickedFile == false
                        ? CustomImagePicker(
                            screenWidth: screenWidth,
                            onTap: () {
                              _pickImage();
                            },
                          )
                        : InkWell(
                            onTap: () {
                              _pickImage();
                            },
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage: showPickedFile
                                  ? FileImage(imageFile!)
                                  : const AssetImage(AppImages.UserImage)
                                      as ImageProvider,
                            ),
                          ),
                    const SeperatedText(
                      tOne: "Room Name ",
                      tTwo: "*",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: namefield,
                      decoration: InputDecoration(
                          hintText: "Please Enter Name",
                          hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
                    ),
                    const SeperatedText(
                      tOne: "Country",
                      tTwo: "*",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          exclude: <String>['KN', 'MF'],
                          favorite: <String>['SE'],
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            mycountry =
                                country.toString().split(" ")[3].split(")")[0];
                            print('Select country: ${mycountry}');
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
                                  color:
                                      const Color(0xFF8C98A8).withOpacity(0.2),
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
                      child:
                          const Text('اختار دولتك').tr(args: ['اختار دولتك']),
                    ),
                    const SizedBox(height: 30),
                    GradiantButton(
                        screenWidth: screenWidth,
                        buttonLabel: "Create Room",
                        onPressed: () async {
                          if (imageFile == null) {
                            allarmError("برجاء اختيار صورة للغرفة", context);
                          } else if (namefield.text == "") {
                            allarmError("برجاء ادخال اسم الغرفة", context);
                          } else if (mycountry == "") {
                            allarmError("برجاء ادخال الدولة", context);
                          } else {
                            Allarm();
                          }
                          //Navigator.pushNamed(context, AgencyAgentView.id);
                        },
                        buttonRatio: 0.8),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void Allarm() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("هل انت متاكد من انشاء الغرفة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        BlocProvider.of<RoomCreationCubit>(context).createRoom(
                          imageFile: imageFile!,
                          namefield: namefield,
                          mycountry: mycountry,
                        );
                        // Navigator.pop(context);
                        // setState(() {
                        //   _showspinner = true;
                        // });
                        // img.Image image =
                        //     img.decodeImage(imageFile!.readAsBytesSync())!;
                        // img.Image compressedImage =
                        //     img.copyResize(image, width: 800);
                        // File compressedFile = File(
                        //     '${imageFile!.path}_compressed.jpg')
                        //   ..writeAsBytesSync(img.encodeJpg(compressedImage));
                        // final path =
                        //     "room/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
                        // final ref = FirebaseStorage.instance.ref().child(path);
                        // final uploadTask = ref.putFile(compressedFile);
                        // final snapshot = await uploadTask.whenComplete(() {});
                        // final urlDownload = await snapshot.ref.getDownloadURL();
                        // print("Download Link : $urlDownload");
                        // String docRoom =
                        //     "${DateTime.now().toString()} - ${_auth.currentUser!.uid}";
                        // String myID = "";
                        // await _firestore
                        //     .collection('user')
                        //     .doc(_auth.currentUser!.uid)
                        //     .get()
                        //     .then((value) {
                        //   myID = value.get('id');
                        // }).then((value) {
                        //   _firestore.collection('room').doc(docRoom).set({
                        //     'bio': _namefield.text,
                        //     'car': '',
                        //     'cartype': '',
                        //     'doc': docRoom,
                        //     'gift': '',
                        //     'gifttype': '',
                        //     'owner': _auth.currentUser!.uid,
                        //     'password': '',
                        //     'seat': '9',
                        //     'wallpaper': '',
                        //     'id': myID,
                        //     'country': mycountry,
                        //     'block': 'false',
                        //     'photo': urlDownload
                        //   }).then((value) {
                        //     _firestore
                        //         .collection('user')
                        //         .doc(_auth.currentUser!.uid)
                        //         .update({
                        //       'room': docRoom,
                        //     }).then((value) {
                        //       setState(() {
                        //         _showspinner = false;

                        //       });
                        //     });
                        //   });
                        // });
                      },
                      child: Text("نعم")),
                  const SizedBox(
                    height: 70,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("الغاء")),
                ],
              ));
        });
  }

  // for picking image file
  _pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile = tempImage;
      showPickedFile = true;
    });
  }
}
