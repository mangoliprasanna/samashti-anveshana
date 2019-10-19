import 'package:flutter/material.dart';

class AnveshanaIntro extends StatelessWidget {
  const AnveshanaIntro({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(219, 219, 219, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                    child: Center(
                  child: Image.asset(
                    "assets/anv_logo.png",
                    height: 150.0,
                  ),
                )),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Anveshana is an exclusive freshers fest which adds special charm amongst the first years by virtue of it being a novel experience for them. It gives them the special platform to exhibit their talent and get along with the college. Anveshana meaning discovery is a perfect platform for all the new faces to discover their hidden talents and perform like never before.",
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}