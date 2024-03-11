import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/screens/add_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.reference().child('Posts');
  TextEditingController searchController = TextEditingController();
  String search = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xfff9fafc),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('New Blog'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPostScreen()));
              },
              child: Icon(Icons.add),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                });
              },
              child: Icon(Icons.logout),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Search Blog',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef.child('Post List'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final post = snapshot.value as Map<dynamic, dynamic>;
                    String tempTitle = post['pTitle'];

                    if (searchController.text.isEmpty ||
                        tempTitle
                            .toLowerCase()
                            .contains(searchController.text.toString())) {
                      return buildPostContainer(post);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPostContainer(Map<dynamic, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.25,
                placeholder: 'images/logo.png',
                image: post['pImage'],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                post['pTitle'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                post['pDescription'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
