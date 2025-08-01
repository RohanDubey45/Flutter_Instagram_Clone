import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'dart:async';

import 'package:instagram_flutter/widgets/view_post.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  Timer? _debounce;

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search for user',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();

            _debounce = Timer(const Duration(seconds: 1), () {
              setState(() {
                isSearch = value.isNotEmpty;
              });
            });
          },
        ),
      ),

      body:
          isSearch
              ? FutureBuilder(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'username',
                          isGreaterThanOrEqualTo: searchController.text,
                        )
                        .where(
                          'username',
                          // ignore: prefer_interpolation_to_compose_strings
                          isLessThan: searchController.text + 'z',
                        )
                        .get(),
                builder: (
                  context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProfileScreen(
                                  uid: snapshot.data!.docs[index]['uid'],
                                );
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[index].data().containsKey(
                                    'photoUrl',
                                  )
                                  ? snapshot.data!.docs[index]['photoUrl']
                                  : 'https://imgs.search.brave.com/3j37xYQB8s1tDecnoGsMHgzKdc5hY2h1b9kBTPJ2TWk/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pbWdz/LnNlYXJjaC5icmF2/ZS5jb20vQ3RfUnkw/V0tkUjNLV0dJbjVJ/YmQ1em5CUXBmVmFD/TlkybVBsMm4yV2xo/RS9yczpmaXQ6NTAw/OjA6MDowL2c6Y2Uv/YUhSMGNITTZMeTkw/TkM1bS9kR05rYmk1/dVpYUXZhbkJuL0x6/QXdMelkwTHpZM0x6/WXovTHpNMk1GOUdY/elkwTmpjMi9Nemd6/WDB4a1ltMW9hVTVO/L05sbHdlbUl6Umsw/MFVGQjEvUmxBNWNr/aGxOM0pwT0VwMS9M/bXB3Wnc.jpeg', // use a default/fallback image URL
                            ),
                            radius: 24,
                          ),
                          title: Text(
                            snapshot.data!.docs[index]['username'],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
              : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (
                  context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return MasonryGridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> ViewPost(snap: snap))
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            snap['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

    );
  }
}
