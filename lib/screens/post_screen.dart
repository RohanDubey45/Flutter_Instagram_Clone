import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/users.dart';
import 'package:instagram_flutter/providers/user_data_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();

  void postImage({
    required String uid,
    required String username,
    required String name,
    required String profImg,
    required String description,
    required Uint8List file,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    String res = await FirestoreMethods().uploadPost(
      uid: uid,
      name: name,
      username: username,
      profImg: profImg,
      description: description.trim(),
      file: file,
    );

    if (!mounted) return;

    Navigator.of(context).pop();

    if (res == "success") {
      res = "Post created successfully";
      showSnackBar(res, context);
      clearImageAndText();
    } else {
      showSnackBar(res, context);
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Create a post",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Take a photo", style: TextStyle(fontSize: 17)),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),

            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text(
                "Choose from gallery",
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),

            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Cancel", style: TextStyle(fontSize: 17)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImageAndText() {
    setState(() {
      _file = null;
      _descriptionController.text = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final User user = userData.getUser!;

    return _file == null
        ? GestureDetector(
          onTap: () => _selectImage(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Icon(Icons.upload, size: 40)),
              SizedBox(height: 0),
              Text("Create Post", style: TextStyle(fontSize: 18)),
            ],
          ),
        )
        : Scaffold(
          backgroundColor: mobileBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            elevation: 0, // 👈 Prevents elevation shading
            scrolledUnderElevation: 0, // 👈
            leading: IconButton(
              onPressed: () => clearImageAndText(),
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("New post"),
            centerTitle: false,
            actions: [
              TextButton(
                onPressed:
                    () => postImage(
                      uid: user.uid,
                      username: user.username,
                      profImg: user.photoUrl,
                      name: user.name,
                      description: _descriptionController.text,
                      file: _file!,
                    ),
                child: Text(
                  "Post",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    // fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                          radius: 30,
                        ),
                      ),
                    ),
                    Text("Post to...", style: TextStyle(fontSize: 17)),
                  ],
                ),

                // SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Container(
                    height: 300,
                    width: 500,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: "write a caption...",
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
