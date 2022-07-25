import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:instagramclone/models/user.dart' as model;

class tonav extends StatefulWidget {
  const tonav({Key? key}) : super(key: key);

  @override
  State<tonav> createState() => _tonavState();
}

class _tonavState extends State<tonav> {
  String username = '';

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    print(snap.data());
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      body: Center(
        child: Text(user.username),
      ),
    );
  }
}
