import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/agency_model.dart';
import '../models/agency_model.dart';
import '../views/agency_creation_view.dart';
import 'agencies_list_item.dart';

class AgencyJoiningViewBody extends StatefulWidget {
  const AgencyJoiningViewBody({
    super.key,
  });

  @override
  State<AgencyJoiningViewBody> createState() => _AgencyJoiningViewBodyState();
}

class _AgencyJoiningViewBodyState extends State<AgencyJoiningViewBody> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  List<AgencyModel> agencies = [];
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Choose Agency",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('agency').snapshots(),
        builder: (context,snapshot){
          List<AgencyModelS> agency=[];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            agency.add(
              AgencyModelS(massege.id, massege.get('name'), massege.get('photo'), massege.get('bio'))
            );
          }
          return agency.length>0?ListView.builder(
            itemCount: agency.length,
            itemBuilder: (context,index){
              if(index==0){
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AgencyCreationView.id);
                        },
                        child: const Text("Create Agency",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AgenciesListItem(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            agencyModel: agency[index])
                    )
                  ],
                );
              }
              else{
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AgenciesListItem(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        agencyModel: agency[index])
                );
              }
            },
          ): Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screenWidth * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AgencyCreationView.id);
                  },
                  child: const Text("Create Agency",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("لا توجد اي وكالات",
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ],
          );
        },
      )
    );
  }
}
