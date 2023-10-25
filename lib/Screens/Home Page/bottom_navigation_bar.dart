import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Rent%20Services/rent_categories.dart';
import 'package:geofire/Screens/Shops%20Services/shop_categories.dart';
import 'package:geofire/Screens/Home%20Page/home_screen.dart';
import '../Group Services/group_screen.dart';
import '../Resell Services/resell_categories.dart';
import '../Working Services/working_categories.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>  with SingleTickerProviderStateMixin  {

  int currentIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    ServiceSection(),
    ResellCategories(),
    LeaseCategories(),
    WorkingCategories(),

  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
        bottomNavigationBar:
        Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child:
          BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            }, items:  const [
            BottomNavigationBarItem(
              icon:Icon(Icons.home_rounded),

              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shops',
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.sell),
              label: 'Resell',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_rounded),
              label: 'Rent',
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.work_rounded),
              label: 'Services',
            ),

          ],
          ),

        )

    );
  }
}
