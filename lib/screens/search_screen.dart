import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
              controller: searchController,
              decoration: InputDecoration(labelText: 'Search for a user'),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
              }),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: const CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: ((context) => ProfileScreen(
                                    uid: (snapshot.data! as dynamic).docs[index]
                                        ['uid'])))),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl']),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    }),
                  );
                },
              )
            : Text('Search for users')
        // : FutureBuilder(
        //     future: FirebaseFirestore.instance.collection('posts').get(),
        //     builder: (context, snapshot) {
        //       if (!snapshot.hasData) {
        //         return const Center(
        //           child: CircularProgressIndicator(
        //             color: Colors.black,
        //           ),
        //         );
        //       }
        //       return StaggeredGridView.count
        //     },
        //   ),
        );
  }
}
