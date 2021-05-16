import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isRight;
  final VoidCallback onPressed;
  final double radius;
  final Color onPrimary;
  final Color primary;
  const CustomElevatedButton({Key key,Color primary,Color onPrimary,this.radius=22,this.icon,this.isRight=false,this.label,this.onPressed}) 
  :  this.primary=primary ?? Colors.white,
     this.onPrimary=onPrimary ?? Colors.red,super(key:key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        clipBehavior: Clip.hardEdge,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
            onPrimary:onPrimary,
            primary:primary),
        child: Container(
          width: 90,
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}
