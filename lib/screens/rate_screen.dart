import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateScreen extends StatelessWidget {
  const RateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Container(
        child: Column(
          children: [
            Text('Restaurant rating'),
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
    );
  }
}
