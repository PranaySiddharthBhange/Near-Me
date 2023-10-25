
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String title;
  final String imagePath;
  Category({required this.title, required this.imagePath});
}

class BloodCategories extends StatefulWidget {
  const BloodCategories({Key? key}) : super(key: key);

  @override
  State<BloodCategories> createState() => _BloodCategoriesState();
}

class _BloodCategoriesState extends State<BloodCategories> {
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
      await FirebaseFirestore.instance.collection('bloodCategories').get();
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

  }


  FocusNode _searchFocusNode = FocusNode();

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
              Icons.water_drop_outlined,
              size: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Blood',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          isTextFieldVisible?SizedBox():IconButton(onPressed: (){
            toggleTextFieldVisibility();
          }, icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: const Icon(Icons.search,color: Colors.black,size: 25,),
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
                          offset: const Offset(0, 3), // changes position of shadow
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
                        Text(category.title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
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

