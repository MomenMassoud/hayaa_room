import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';
import '../../home/functions/get_user_profile.dart';
import '../../home/widgets/gradient_rounded_container.dart';
import '../../profile/views/visitor_.view.dart';
import '../functions/extract_owner_doc_id.dart';

class AgencyHostViewBody extends StatefulWidget {
  const AgencyHostViewBody({
    super.key,
  });
  _AgencyHostViewBody createState() => _AgencyHostViewBody();
}

class _AgencyHostViewBody extends State<AgencyHostViewBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String agncyOwnerDocId = '';
  String myagency = "";
  int myDaiomond = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(DateTime.now());
    getMyDaimond();
  }

  void getMyDaimond() async {
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      setState(() {
        myDaiomond = int.parse(snap.get('daimond'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    late DateTime joinDate;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Hayaa",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .where('doc', isEqualTo: _auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              myagency = massege.get('myagent');
              agncyOwnerDocId = extractOwnerId(
                myagency,
              );
              log(agncyOwnerDocId);
            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('agency')
                  .doc(myagency)
                  .collection('users')
                  .where('userid', isEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                String doc = "";
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  joinDate = DateTime.parse(massege.get('time'));
                  doc = massege.id;
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('agency')
                      .doc(myagency)
                      .collection('users')
                      .doc(doc)
                      .collection('income')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<DataRow> rows = [];
                    int total = 0;
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                    final masseges = snapshot.data?.docs;
                    for (var massege in masseges!.reversed) {
                      DateTime date = DateTime.parse(massege.get('date'));
                      total += int.parse(massege.get('count'));
                      DataRow row = DataRow(
                        cells: [
                          DataCell(Text("${date.day}/${date.month}")),
                          DataCell(Text(massege.get('hosttime'))),
                          DataCell(Text(massege.get('numberradio'))),
                          DataCell(Text(massege.get('count'))),
                        ],
                      );
                      rows.add(row);
                    }
                    return FutureBuilder(
                        future: getUserProfils(agncyOwnerDocId),
                        builder: (context, snapshot) {
                          UserModel userData = snapshot.data ??
                              UserModel("", "", '', '', '', '', '', '', '', '',
                                  '', '', '', '', '', '', '', '');
                          return ListView(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VistorView(userData.photo,
                                                        userData.docID)));
                                      },
                                      child: Text(
                                        "Agency Owner",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.04,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date Of Joining The Agency",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 18),
                                        Text(
                                          "${joinDate.day}/${joinDate.month}/${joinDate.year}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            GradientRoundedContainer(
                                                screenHeight:
                                                    screenHeight * 0.15,
                                                screenWidth: screenWidth * 0.4,
                                                colorOne: Colors.purpleAccent,
                                                colorTwo: Colors.purple),
                                            SizedBox(
                                              width: screenWidth * 0.2,
                                              child: const Opacity(
                                                opacity: 0.3,
                                                child: Image(
                                                    image: AssetImage(AppImages
                                                        .goldenDiamond)),
                                              ),
                                            ),
                                            Positioned(
                                                top: screenHeight * 0.02,
                                                left: screenWidth * 0.05,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Yellow Diamond \n       Balance",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              screenWidth *
                                                                  0.04),
                                                    ),
                                                    Text(
                                                      total <= myDaiomond
                                                          ? total.toString()
                                                          : myDaiomond
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              screenWidth *
                                                                  0.1),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Day Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: DataTable(
                                        columnSpacing: 5.0,
                                        horizontalMargin: 0,
                                        dividerThickness: 2.0,
                                        columns: [
                                          DataColumn(
                                              label: SizedBox(
                                            height: screenHeight * 0.08,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                child: Text('Date',
                                                    style: TextStyle(
                                                        fontSize: screenWidth *
                                                            0.035)),
                                              ),
                                            ),
                                          )),
                                          DataColumn(
                                              label: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            child: Text('Hostess\ntime',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.035)),
                                          )),
                                          DataColumn(
                                              label: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 9),
                                            child: Text('Number of radio\ndays',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.035)),
                                          )),
                                          DataColumn(
                                              label: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            child: Text(
                                                'Number of \ncurrencies',
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.035)),
                                          )),
                                        ],
                                        rows: rows,
                                        border: TableBorder.all(width: 0.4),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.8,
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              child: const Text(
                                                  "Withdrawal from the agency")),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  },
                );
              },
            );
          },
        ));
  }
}
