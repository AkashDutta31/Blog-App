import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:narrativeflow/models/blog.dart';
import 'package:narrativeflow/screens/home/widgets/item_blog.dart';

class MyBlogsScreen extends StatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  State<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends State<MyBlogsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blogs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('blogs')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!.docs;
            List<Blog> blogs = [];
            for (var element in data) {
              Blog blog = Blog.fromMap(element.data());
              blogs.add(blog);
            }
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [for (var blog in blogs) ItemBlog(blog: blog)],
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
