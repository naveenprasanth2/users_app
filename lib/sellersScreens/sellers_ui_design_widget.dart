import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../models/sellers.dart';

class SellersUiDesignWidget extends StatefulWidget {
  Sellers? model;

  SellersUiDesignWidget({super.key, this.model});

  @override
  State<SellersUiDesignWidget> createState() => _SellersUiDesignWidgetState();
}

class _SellersUiDesignWidgetState extends State<SellersUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Colors.black54,
        elevation: 20,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.model!.photoUrl!,
                    fit: BoxFit.fill,
                    height: 220,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.name!,
                  style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SmoothStarRating(
                  rating: widget.model!.ratings == null
                      ? 0.0
                      : double.parse(widget.model!.ratings!),
                  allowHalfRating: true,
                  starCount: 5,
                  color: Colors.pinkAccent,
                  borderColor: Colors.pinkAccent,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
