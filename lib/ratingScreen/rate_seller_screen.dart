import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/helper/sizebox_helper.dart';

class RateSellerScreen extends StatefulWidget {
  String? sellerId;

  RateSellerScreen({super.key, this.sellerId});

  @override
  State<RateSellerScreen> createState() => _RateSellerScreenState();
}

class _RateSellerScreenState extends State<RateSellerScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBoxHelper.sizeBox20,
              const Text(
                "Rate this Seller",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 22),
              ),
              SizedBoxHelper.sizeBox20,
              const Divider(
                height: 4,
                thickness: 4,
              ),
              SizedBoxHelper.sizeBox20,
              //we already have smooth start dependency
              SmoothStarRating(
                rating: countStarsRating,
                allowHalfRating: true,
                starCount: 5,
                color: Colors.purpleAccent,
                borderColor: Colors.purpleAccent,
                size: 46,
                onRatingChanged: (valueOfStarChosen) {
                  countStarsRating = valueOfStarChosen;
                  if (countStarsRating == 1) {
                    setState(() {
                      titleStarsRating = "Very Bad";
                    });
                  }
                  if (countStarsRating == 2) {
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }
                  if (countStarsRating == 3) {
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }
                  if (countStarsRating == 4) {
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }
                  if (countStarsRating == 5) {
                    setState(() {
                      titleStarsRating = "Excellent";
                    });
                  }
                },
              ),
              SizedBoxHelper.sizeBox20,

              Text(
                titleStarsRating,
                style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent),
              ),
              SizedBoxHelper.sizeBox20,
              ElevatedButton(
                onPressed: () {
                  firebaseFirestore.collection("sellers")
                      .doc(widget.sellerId)
                      .get().then((snap) {
                    if (snap.data()!["ratings"] ==
                        null) { //seller has no ratings
                      firebaseFirestore.collection("sellers")
                          .doc(widget.sellerId)
                          .update({
                        "ratings": countStarsRating.toString(),
                      });
                    } else {
                      double originalRating = (countStarsRating + double.parse(
                          snap.data()!["ratings"])) / 2;
                      firebaseFirestore.collection("sellers")
                          .doc(widget.sellerId)
                          .update({
                        "ratings": originalRating.toString(),
                      });
                    }
                    Fluttertoast.showToast(msg: "Rated Successfully");
                    //make sure to re initialize it
                    countStarsRating = 0.0;
                    titleStarsRating = "";
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 74)),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBoxHelper.sizeBox12,
            ],
          ),
        ),
      ),
    );
  }
}
