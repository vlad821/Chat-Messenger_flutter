
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/chat_page.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class Homme extends StatefulWidget {
  const Homme({super.key});

  @override
  State<Homme> createState() => _HommeState();
}

class _HommeState extends State<Homme> {
  //sign user out
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signOut() {
    //get authservice
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), actions: [
        IconButton(
          onPressed: signOut,
          icon: const Icon(Icons.logout),
        )
      ]),
      body: _buildUserList(),
    );
  }


Widget _buildUserList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('error');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('loading...');
      }
      return ListView(
        children: snapshot.data!.docs
            .map<Widget>((doc) => _buildUserListItem(doc))
            .toList(),
      );
    },
  );
}

Widget _buildUserListItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  //display users

  if (_auth.currentUser!.email != data['email']) {
    return ListTile(
      title: Text(data['email']),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      receiverUserEmail: data['email'],
                      receiverID: data['uid'],
                    )
                    ));
      },
    );
  } else {
    return Container();
  }
}
}