import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:not_gatew/authenticate/authentication.dart';
import 'package:not_gatew/notice_card/post.dart';
import 'package:not_gatew/screens/upload.dart';

import '../colours.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget cardUI(Post post) {
    return Card(
      margin: EdgeInsets.only(top: 20.0),
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.date,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  post.time,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: post.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              post.notice,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              post.message,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.black_s1,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Upload()));
            },
          ),
          title: Center(child: Text('not_gate')),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                AuthService().signOut();
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('not_gate')
                  .orderBy('index', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No Post Yet'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> postMap =
                          snapshot.data.docs[index].data();
                      Post post = Post(
                        postMap['imageUrl'],
                        postMap['message'],
                        postMap['notice'],
                        postMap['date'],
                        postMap['time'],
                      );
                      return cardUI(post);
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
