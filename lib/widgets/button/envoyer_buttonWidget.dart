// import 'package:flutter/material.dart';

// class EnvoyerButton extends StatelessWidget {
//   const EnvoyerButton({super.key, this.firstColour,this.secondColour, this.title, required this.onPressed});

//   final Color? firstColour;
//   final Color? secondColour;
//   final String? title;
//   final Function() onPressed;

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.sizeOf(context).width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 0.0),
//       child: SizedBox(
//         width: width,
//         child: TextButton(
//           style: TextButton.styleFrom(foregroundColor: Colors.transparent),
//           onPressed: onPressed,
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10), color: secondColour
//               /* gradient: LinearGradient(colors: [
//                   Color(0xFF01224b),
//                   Color(0xFF022e64),
//                   Color(0xFF023a7e),
//                 ])*/
//             ),
//             child: Center(
//               child: Text(
//                 title!,
//                 style: const TextStyle(
//                     fontSize: 20,
//                     letterSpacing: 1.5,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }