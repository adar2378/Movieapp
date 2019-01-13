import 'package:flutter/material.dart';

class UserSelctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ClipPath(
        clipper: MyClipper(),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.25,
          width: MediaQuery.of(context).size.width,
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(45),
                elevation: 5,
                color: Colors.purple,
                child: InkWell(
                  onTap: () {},
                  highlightColor: Colors.pink.withOpacity(.5),
                  borderRadius: BorderRadius.circular(45),
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                  radius: 55,
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(45),
                elevation: 5,
                color: Colors.indigo,
                child: InkWell(
                  onTap: () {},
                  highlightColor: Colors.pink.withOpacity(.5),
                  borderRadius: BorderRadius.circular(45),
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                  radius: 55,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}
