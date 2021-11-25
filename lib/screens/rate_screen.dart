import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/firestore.dart' as firestore;

class RateScreen extends StatelessWidget {
  const RateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // FutureBuilder(
        //   future: firestore.getResRating(FirebaseAuth.instance.currentUser!.uid),
        StreamBuilder(
      stream:
          firestore.getResRatingSync(FirebaseAuth.instance.currentUser!.uid),
      builder: (ctx, data) {
        if (data.connectionState == ConnectionState.active) {
          final doc = data.data as DocumentSnapshot;
          final dataMap = doc.data() as Map<String, dynamic>;
          final rating = dataMap['rating'];

          return LayoutBuilder(
            builder: (ctx, constraints) => Container(
              child: Center(
                child: Column(
                  children: [
                    Spacer(),
                    // if (data.connectionState == ConnectionState.waiting)
                    //   CircularProgressIndicator(),
                    // if (data.connectionState == ConnectionState.done)
                    ...[
                      Text(
                        'Restaurant rating',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: constraints.maxWidth * 0.1,
                        ),
                      ),
                      SizedBox(height: 10),
                      RatingBarIndicator(
                        direction: Axis.horizontal,
                        rating: double.parse(rating as String),
                        itemCount: 5,
                        itemSize: constraints.maxHeight * 0.1,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                    Spacer(),
                    // RatingBar.builder(
                    //   initialRating: double.parse(data['rating']!),
                    //   minRating: 1,
                    //   direction: Axis.horizontal,
                    //   allowHalfRating: false,
                    //   itemCount: 5,
                    //   itemSize: constraints.maxWidth * 0.055,
                    //   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    //   itemBuilder: (context, _) => Icon(
                    //     Icons.star,
                    //     color: Colors.pink.shade200,
                    //   ),
                    //   onRatingUpdate: (rating) {
                    //     var preRating = double.parse(data['rating']!);
                    //     var newRating = (preRating + rating) / 2;
                    //     data['rating'] = newRating.toString();
                    //     print(data['rating']);
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          );
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
}
