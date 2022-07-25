import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/resources/auth_methods.dart';
import 'package:instagramclone/resources/firestore_methods.dart';
import 'package:instagramclone/screens/login_screen.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    // post length
    var postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    postLen = postSnap.docs.length;
    userData = userSnap.data()!;
    followers = userSnap.data()!['followers'].length;
    following = userSnap.data()!['following'].length;
    isFollowing = userSnap
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            userData['username'],
          ),
          centerTitle: false,
        ),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userData['photoUrl'],
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "posts"),
                              buildStatColumn(followers, "followers"),
                              buildStatColumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? FollowButton(
                                      backgroundColor: Colors.blue,
                                      borderColor: Colors.grey,
                                      text: 'Sign Out',
                                      textColor: Colors.black,
                                      function: () async {
                                        await Authmethods().signOut();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                      },
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          backgroundColor: Colors.blue,
                                          borderColor: Colors.grey,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid']);
                                            setState(() {
                                              isFollowing = false;
                                              followers--;
                                            });
                                          },
                                          text: 'Unfollow',
                                          textColor: Colors.white)
                                      : FollowButton(
                                          backgroundColor: Colors.blue,
                                          borderColor: Colors.grey,
                                          text: 'Follow',
                                          textColor: Colors.black,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid']);
                                            setState(() {
                                              isFollowing = true;
                                              followers++;
                                            });
                                          },
                                        )
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              userData['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 1,
                            ),
                            child: Text(
                              userData['bio'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.amber,
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ]))
        ]));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
