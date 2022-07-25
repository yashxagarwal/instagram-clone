import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/resources/firestore_methods.dart';
import 'package:instagramclone/screens/comments_screen.dart';
import 'widgets/comment_card.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();

    commentLen = snap.docs.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header post sec
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            FirestoreMethods().deletePost(
                                                widget.snap['postID']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(widget.snap['postId'],
                  widget.snap['uid'], widget.snap['likes']);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                widget.snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),

          //Like,comment,share
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(widget.snap['postId'],
                        widget.snap['uid'], widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(widget.snap['uid'])
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                                snap: widget.snap,
                              )),
                    );
                  },
                  icon: const Icon(
                    Icons.comment_outlined,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                  )),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border)),
                ),
              )
            ],
          ),
          // caption
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.snap['likes'].length} likes'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(text: ' '),
                        TextSpan(text: widget.snap['description'])
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all ${commentLen} comments',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 128, 128, 128)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
