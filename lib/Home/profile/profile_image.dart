import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  String? image;
  ProfileImage({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blueGrey.shade100,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(shape: 
                          BoxShape.circle),
                          child: Image.network(image ?? '')
                        ),
                      );
  }
}