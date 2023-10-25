import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkGallery extends StatefulWidget {
  final String docId;
  const WorkGallery({Key? key, required this.docId}) : super(key: key);

  @override
  State<WorkGallery> createState() => _WorkGalleryState();
}

class _WorkGalleryState extends State<WorkGallery> {

  TextEditingController _commentController = TextEditingController();


  Future<void> addComment(String id) async {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.docId).collection('comments').doc(id).update({
        'comments': FieldValue.arrayUnion([commentText]),
      });

      _commentController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
     body:
   Column(
     children: [
       Expanded(
         child:
         StreamBuilder<QuerySnapshot>(
           stream: FirebaseFirestore.instance
               .collection('workers')
               .doc(widget.docId)
               .collection('comments')
               .snapshots(),
           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
             if (snapshot.hasError) {
               return Text('Error: ${snapshot.error}');
             }

             if (snapshot.connectionState == ConnectionState.waiting) {
               return CircularProgressIndicator();
             }

             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
               return const Text('No comments found');
             }

             return ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context, index) {
                 var commentDoc = snapshot.data!.docs[index];
                 var commentData = commentDoc.data() as Map<String, dynamic>;

                 var imageUrl = commentData['image'] as String?;
                 var comments = commentData['comments'] as List<dynamic>?;

                 return Column(
                   children: [
                     if (imageUrl != null)
                       Image.network(
                         imageUrl,
                         width: 200,
                         height: 200,
                         fit: BoxFit.cover,
                       ),
                     SizedBox(height: 10),
                     if (comments != null)
                       ListView.builder(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemCount: comments.length,
                         itemBuilder: (context, index) {
                           var comment = comments[index] as String?;
                           return comment != null ? Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Expanded(child: Text(comment)),
                               IconButton(onPressed: (){}, icon: Icon(Icons.delete))
                             ],
                           ) : SizedBox();
                         },
                       ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                         children: [
                           Expanded(
                             child: TextField(
                               controller: _commentController,
                               decoration: const InputDecoration(
                                 hintText: 'Enter your comment',
                               ),
                             ),
                           ),
                           const SizedBox(width: 8.0),
                           ElevatedButton(
                             onPressed: (){
                               addComment(commentDoc.id);
                             },
                             child: const Text('Submit'),
                           ),
                         ],
                       ),
                     ),
                     Divider(),
                   ],
                 );
               },
             );
           },
         ),
       ),

     ],
   ),
    );
  }
}
