// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:geofire/Screens/creat_shop.dart';
// //
// // import '../nearbyDocs.dart';
// //
// // class ServiceSection extends StatefulWidget {
// //   const ServiceSection({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ServiceSection> createState() => _ServiceSectionState();
// // }
// //
// // class _ServiceSectionState extends State<ServiceSection> {
// //
// //
// //   List<String> categories = [
// //     'Electronics',
// //     'Clothing',
// //     'Books',
// //     'Home & Kitchen',
// //     'Sports',
// //     'Labours'
// //   ];
// //
// //   List<String> filteredCategories = [];
// //
// //   final TextEditingController _searchController = TextEditingController();
// //
// //   void filterCategories(String query) {
// //     if (query.isNotEmpty) {
// //       List<String> tempList = [];
// //       categories.forEach((category) {
// //         if (category.toLowerCase().contains(query.toLowerCase())) {
// //           tempList.add(category);
// //         }
// //       });
// //       setState(() {
// //         filteredCategories = tempList;
// //       });
// //     } else {
// //       setState(() {
// //         filteredCategories = [];
// //       });
// //     }
// //   }
// //   void showToast(String message) {
// //     Fluttertoast.showToast(
// //       msg: message,
// //       toastLength: Toast.LENGTH_SHORT,
// //       gravity: ToastGravity.BOTTOM,
// //       timeInSecForIosWeb: 1,
// //       backgroundColor: Colors.red,
// //       textColor: Colors.white,
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return Scaffold(
// //       appBar:
// //       AppBar(
// //         actions: [
// //           IconButton(onPressed: (){
// //             Navigator.push(context, MaterialPageRoute(builder: (context) => CreatShop(),));
// //
// //           }, icon: const Icon(Icons.add,size: 30,)),
// //           IconButton(onPressed: (){
// //             Navigator.push(context, MaterialPageRoute(builder: (context) => MapSample(),));
// //           }, icon: const Icon(Icons.location_searching,fill: 0.0,)),
// //         ],
// //         automaticallyImplyLeading: false,
// //         title:  Row(
// //           children: [
// //             IconButton(onPressed: (){},
// //                 icon: const Icon(Icons.near_me_outlined,size: 25,)),
// //             const Text('Services',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
// //
// //           ],
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: _searchController,
// //               onChanged: (value) {
// //                 filterCategories(value);
// //               },
// //               decoration: const InputDecoration(
// //                 hintText: 'Search for a category',
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: filteredCategories.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(filteredCategories[index]),
// //                   onTap: () {
// //                     showToast('Category: ${filteredCategories[index]}');
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // import 'package:flutter/material.dart';
// //
// // class Category {
// //   final String title;
// //   final String imagePath;
// //
// //   Category({required this.title, required this.imagePath});
// // }
// //
// // class CategoryScreen extends StatefulWidget {
// //   @override
// //   _CategoryScreenState createState() => _CategoryScreenState();
// // }
// //
// // class _CategoryScreenState extends State<CategoryScreen> {
// //   List<Category> categories = [
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //     Category(title: 'Category 1', imagePath: 'assets/img.png'),
// //
// //
// //     // Add more categories as needed
// //   ];
// //
// //   List<Category> filteredCategories = [];
// //
// //
// //   void searchCategories(String query) {
// //     setState(() {
// //       if (query.isEmpty) {
// //         filteredCategories = [];
// //       } else {
// //         filteredCategories = categories.where((category) {
// //           return category.title.toLowerCase().contains(query.toLowerCase());
// //         }).toList();
// //       }
// //     });
// //   }
// //
// //   void navigateToCategoryDetails(Category category) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => CategoryDetailsScreen(category: category),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Services'),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               onChanged: searchCategories,
// //               decoration: const InputDecoration(
// //                 labelText: 'Search',
// //                 prefixIcon: Icon(Icons.search),
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: (filteredCategories.isNotEmpty) ? filteredCategories.length : (categories.length / 2).ceil(),
// //               itemBuilder: (context, index) {
// //                 if (filteredCategories.isNotEmpty) {
// //                   Category category = filteredCategories[index];
// //                   return GestureDetector(
// //                     onTap: () => navigateToCategoryDetails(category),
// //                     child: Container(
// //                       margin: const EdgeInsets.all(8.0),
// //                       child: Column(
// //                         children: [
// //                           Image.asset(
// //                             category.imagePath,
// //                             width: 100,
// //                             height: 100,
// //                             fit: BoxFit.cover,
// //                           ),
// //                           const SizedBox(height: 8.0),
// //                           Text(category.title),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 } else {
// //                   int startIndex = index * 2;
// //                   int endIndex = startIndex + 2;
// //
// //                   // Ensure endIndex does not exceed the length of the list
// //                   if (endIndex > categories.length) endIndex = categories.length;
// //
// //                   // Create a sublist of categories for this row
// //                   List<Category> rowCategories = categories.sublist(startIndex, endIndex);
// //
// //                   return Row(
// //                     children: rowCategories.map((category) {
// //                       return Expanded(
// //                         child: GestureDetector(
// //                           onTap: () => navigateToCategoryDetails(category),
// //                           child: Container(
// //                             margin: EdgeInsets.all(8.0),
// //                             child: Column(
// //                               children: [
// //                                 Image.asset(
// //                                   category.imagePath,
// //                                   width: 100,
// //                                   height: 100,
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                                 SizedBox(height: 8.0),
// //                                 Text(category.title),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   );
// //                 }
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class CategoryDetailsScreen extends StatelessWidget {
// //   final Category category;
// //
// //   CategoryDetailsScreen({required this.category});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(category.title),
// //       ),
// //       body: Center(
// //         child: Text('Category Details: ${category.title}'),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geofire/Screens/Working%20Services/working_categories.dart';
// import 'package:geofire/Screens/Shops%20Services/shop_services.dart';
//
// class Category {
//   final String title;
//   final String imagePath;
//
//   Category({required this.title, required this.imagePath});
// }
//
// class ResellCategories extends StatefulWidget {
//   const ResellCategories({Key? key}) : super(key: key);
//
//   @override
//   State<ResellCategories> createState() => _ResellCategoriesState();
// }
//
// class _ResellCategoriesState extends State<ResellCategories> {
//   List<Category> categories = [];
//   List<Category> filteredCategories = [];
//
//   final TextEditingController _searchController = TextEditingController();
//
//
//   String searchQuery = '';
//   void setSearchQuery(String query) {
//     setState(() {
//       searchQuery = query;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   void fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance.collection('resellCategories').get();
//
//       setState(() {
//         categories = snapshot.docs.map((doc) => Category(
//           title: doc['title'],
//           imagePath: doc['imagePath'],
//         )).toList();
//       });
//     } catch (e) {
//       // Handle error
//       print('Error fetching categories: $e');
//     }
//   }
//
//   void filterCategories(String query) {
//     if (query.isNotEmpty) {
//       List<Category> tempList = [];
//       categories.forEach((category) {
//         if (category.title.toLowerCase().contains(query.toLowerCase())) {
//           tempList.add(category);
//         }
//       });
//       setState(() {
//         filteredCategories = tempList;
//       });
//     } else {
//       setState(() {
//         filteredCategories = [];
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void navigateToCategoryDetails(Category category) {
//
//
//   }
//
//   void handleSearch() {
//     Category matchedCategory = categories.firstWhere(
//           (category) => category.title.toLowerCase() == searchQuery.toLowerCase(),
//       orElse: () => Category(title: 'No Category Found', imagePath: ''),
//     );
//     if (matchedCategory.title != 'No Category Found') {
//       navigateToCategoryDetails(matchedCategory);
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('No Category Found'),
//           content: Text('The entered category was not found.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Services'),
//         actions: [
//           IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context) => WorkingCategories(),));
//           }, icon: Icon(Icons.sensor_occupied_rounded))
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 filterCategories(value);
//               },
//               decoration: const InputDecoration(
//                 hintText: 'Search for a category',
//               ),
//             ),
//           ),
//           Expanded(
//             child:
//             ListView.builder(
//
//
//               itemCount: (filteredCategories.isNotEmpty) ? filteredCategories.length : (categories.length / 2).ceil(),
//               itemBuilder: (context, index) {
//
//                 List<Category> sortedCategories = categories.toList(); // Create a copy of the categories list
//                 sortedCategories.sort((a, b) => a.title.compareTo(b.title)); // Sort the list based on the title field
//
//                 if (filteredCategories.isNotEmpty) {
//                   Category category = sortedCategories[index];
//                   return GestureDetector(
//                     onTap: () => navigateToCategoryDetails(category),
//                     child: Container(
//                       margin: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Image.network(
//                             category.imagePath,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                           const SizedBox(height: 8.0),
//                           Text(category.title),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   int startIndex = index * 2;
//                   int endIndex = startIndex + 2;
//
//                   // Ensure endIndex does not exceed the length of the list
//                   if (endIndex > categories.length) endIndex = categories.length;
//
//                   // Create a sublist of categories for this row
//                   List<Category> rowCategories = sortedCategories.sublist(startIndex, endIndex);
//
//                   return Row(
//                     children: rowCategories.map((category) {
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () => navigateToCategoryDetails(category),
//                           child: Container(
//                             margin: EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Image.network(
//                                   category.imagePath,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(category.title),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geofire/Screens/Working%20Services/working_categories.dart';
// import 'package:geofire/Screens/Shops%20Services/shop_services.dart';
//
// class Category {
//   final String title;
//   final String imagePath;
//
//   Category({required this.title, required this.imagePath});
// }
//
// class ServiceSection extends StatefulWidget {
//   const ServiceSection({Key? key}) : super(key: key);
//
//   @override
//   State<ServiceSection> createState() => _ServiceSectionState();
// }
//
// class _ServiceSectionState extends State<ServiceSection> {
//   List<Category> categories = [];
//   List<Category> filteredCategories = [];
//
//   final TextEditingController _searchController = TextEditingController();
//
//
//   String searchQuery = '';
//   void setSearchQuery(String query) {
//     setState(() {
//       searchQuery = query;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   void fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance.collection('categories').get();
//
//       setState(() {
//         categories = snapshot.docs.map((doc) => Category(
//           title: doc['title'],
//           imagePath: doc['imagePath'],
//         )).toList();
//       });
//     } catch (e) {
//       // Handle error
//       print('Error fetching categories: $e');
//     }
//   }
//
//   // void filterCategories(String query) {
//   //   if (query.isNotEmpty) {
//   //     List<Category> tempList = [];
//   //     categories.forEach((category) {
//   //       if (category.title.toLowerCase().contains(query.toLowerCase())) {
//   //         tempList.add(category);
//   //       }
//   //     });
//   //     setState(() {
//   //       filteredCategories = tempList;
//   //     });
//   //   } else {
//   //     setState(() {
//   //       filteredCategories = [];
//   //     });
//   //   }
//   // }
//   void filterCategories(String query) {
//     if (query.isNotEmpty) {
//       List<Category> tempList = [];
//       for (var category in categories) {
//         if (category.title.toLowerCase().contains(query.toLowerCase())) {
//           tempList.add(category);
//         }
//       }
//       setState(() {
//         filteredCategories = tempList;
//       });
//     } else {
//       setState(() {
//         filteredCategories = categories.toList();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void navigateToCategoryDetails(Category category) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ServiceScreen(category: category),
//       ),
//     );
//   }
//
//   void handleSearch() {
//     Category matchedCategory = categories.firstWhere(
//           (category) => category.title.toLowerCase() == searchQuery.toLowerCase(),
//       orElse: () => Category(title: 'No Category Found', imagePath: ''),
//     );
//     if (matchedCategory.title != 'No Category Found') {
//       navigateToCategoryDetails(matchedCategory);
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('No Category Found'),
//           content: Text('The entered category was not found.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Services'),
//         actions: [
//           IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context) => WorkingCategories(),));
//           }, icon: Icon(Icons.sensor_occupied_rounded))
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 filterCategories(value);
//               },
//               decoration: const InputDecoration(
//                 hintText: 'Search for a category',
//               ),
//             ),
//           ),
//           Expanded(
//             child:
//             ListView.builder(
//
//
//               itemCount: (filteredCategories.isNotEmpty) ? filteredCategories.length : (categories.length / 2).ceil(),
//               itemBuilder: (context, index) {
//
//                 List<Category> sortedCategories = categories.toList(); // Create a copy of the categories list
//                 sortedCategories.sort((a, b) => a.title.compareTo(b.title)); // Sort the list based on the title field
//
//                 if (filteredCategories.isNotEmpty) {
//                   Category category = sortedCategories[index];
//                   return GestureDetector(
//                     onTap: () => navigateToCategoryDetails(category),
//                     child: Container(
//                       margin: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Image.network(
//                             category.imagePath,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                           const SizedBox(height: 8.0),
//                           Text(category.title),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   int startIndex = index * 2;
//                   int endIndex = startIndex + 2;
//
//                   // Ensure endIndex does not exceed the length of the list
//                   if (endIndex > categories.length) endIndex = categories.length;
//
//                   // Create a sublist of categories for this row
//                   List<Category> rowCategories = sortedCategories.sublist(startIndex, endIndex);
//
//                   return Row(
//                     children: rowCategories.map((category) {
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () => navigateToCategoryDetails(category),
//                           child: Container(
//                             margin: EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Image.network(
//                                   category.imagePath,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(category.title),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 }
//               },
//             ),
//
//
//
//
//           ),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String title;
  final String imagePath;
  Category({required this.title, required this.imagePath});
}

class ResellCategories extends StatefulWidget {
  const ResellCategories({Key? key}) : super(key: key);

  @override
  State<ResellCategories> createState() => _ResellCategoriesState();
}

class _ResellCategoriesState extends State<ResellCategories> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];

  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';

  void setSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('resellCategories').get();

      List<Category> fetchedCategories = snapshot.docs
          .map((doc) => Category(
        title: doc['title'],
        imagePath: doc['imagePath'],
      ))
          .toList();

      fetchedCategories.sort((a, b) =>
          a.title.compareTo(b.title)); // Sort categories alphabetically

      setState(() {
        categories = fetchedCategories;
        filteredCategories = fetchedCategories.toList();
      });
    } catch (e) {
      // Handle error
      print('Error fetching categories: $e');
    }
  }

  void filterCategories(String query) {
    if (query.isNotEmpty) {
      List<Category> tempList = categories.where((category) {
        return category.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        filteredCategories = tempList;
      });
    } else {
      setState(() {
        filteredCategories = categories.toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  void navigateToCategoryDetails(Category category) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ServiceScreen(category: category),
    //   ),
    // );
  }


  final FocusNode _searchFocusNode = FocusNode();

  bool isTextFieldVisible = false;
  void toggleTextFieldVisibility() {
    setState(() {
      isTextFieldVisible = !isTextFieldVisible;
      if (isTextFieldVisible) {
        _searchFocusNode.requestFocus(); // Request focus on the text field
      } else {
        _searchFocusNode.unfocus(); // Remove focus from the text field
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
      AppBar(

        automaticallyImplyLeading: false,
        title: isTextFieldVisible? Padding(
          padding: const EdgeInsets.only(top:12,bottom: 8),
          child: TextField(
            focusNode: _searchFocusNode,
            controller: _searchController,
            onChanged: (value) {
              filterCategories(value);
            },
            decoration:  InputDecoration(
              suffix:IconButton(onPressed: (){
                setState(() {
                  _searchController.clear();
                  filterCategories(''); // Clear the search query
                });
                toggleTextFieldVisibility();
              }, icon: const Icon(Icons.clear,color: Colors.black,size: 25,)),
              hintText: 'Search Shops Near You',
            ),
          ),
        ): const Row(
          children: [
            Icon(
              // Icons.shopping_cart_outlined,
              Icons.sell_outlined,
              size: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
                'Resell',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          isTextFieldVisible?const SizedBox():IconButton(onPressed: (){
            toggleTextFieldVisibility();
          }, icon: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.search,color: Colors.black,size: 25,),
          ))
        ],

      ),
      body:
      Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                Category category = filteredCategories[index];
                return GestureDetector(
                  onTap: () => navigateToCategoryDetails(category),
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 9,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              category.imagePath,
                              width: 150,
                              height: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(category.title,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

