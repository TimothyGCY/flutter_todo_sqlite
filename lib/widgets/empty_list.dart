import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Image(
            image: AssetImage(
              'assets/images/flame-2.png',
            ),
            height: 300,
            width: 300,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
            height: 24,
          ),
          Text('You have nothing to do'),
        ],
      ),
    );
  }
}
