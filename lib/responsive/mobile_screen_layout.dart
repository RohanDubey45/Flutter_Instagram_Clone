import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
// import 'package:instagram_flutter/models/users.dart';
// import 'package:instagram_flutter/providers/user_data_provider.dart';
// import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get _screens => homeScreen;

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: _screens[_page],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed, 
          currentIndex: _page,
          showSelectedLabels: false,
          showUnselectedLabels: false, 
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
                color: _page == 0 ? Colors.white : Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
                color: _page == 1 ? Colors.white : Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
                color: _page == 2 ? Colors.white : Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 30,
                color: _page == 3 ? Colors.white : Colors.grey,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
                color: _page == 4 ? Colors.white : Colors.grey,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
