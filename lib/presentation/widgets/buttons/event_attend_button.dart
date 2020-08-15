import 'package:flutter/material.dart';

FadeTransition EventAttendButton({
  BuildContext context,
  AnimationController animationController,
  bool isAttending,
  Function onPressed
}) {
  return FadeTransition(
    opacity: animationController,
    child: ScaleTransition(
      scale: animationController,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          gradient: isAttending
              ? LinearGradient(colors: [
                Color(0xFF27ba4e),
                Color(0xFF2ed159),
              ])
              : LinearGradient(
              colors: [
                Color(0xffde2a6c), 
                Color(0xffeb3477)
              ])
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        child: RawMaterialButton(
          shape: CircleBorder(),
          elevation: 3,
          child: Text(
            isAttending ? "Attending" : "Attend",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,
        ),
      )
    ),
  );
}