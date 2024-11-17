//  // Contribution Cards
//                 _contributionCard(context),
//                 SizedBox(height: height * 0.02),
//                 _contributionCard(context),


//   Widget _contributionCard(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.purple[50],
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 8,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.grey[300],
//                 child: Icon(Icons.person, size: 30),
//               ),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Name",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   // Text(
//                   //   "Designation",
//                   //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   // ),
//                 ],
//               ),
//               Spacer(),
//               Text(
//                 "Contributed a month ago",
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(
//             '"The Power of Fate in Silapathikaram: Kannagi’s Transformative Journey"',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Icon(Icons.favorite, color: Colors.red),
//               SizedBox(width: 5),
//               Text("200"),
//               SizedBox(width: 10),
//               Icon(Icons.verified, color: Colors.green),
//               SizedBox(width: 5),
//               Text("Verified by"),
//               SizedBox(width: 5),
//               CircleAvatar(radius: 10, backgroundColor: Colors.blue),
//               CircleAvatar(radius: 10, backgroundColor: Colors.green),
//               CircleAvatar(radius: 10, backgroundColor: Colors.orange),
//               CircleAvatar(radius: 10, backgroundColor: Colors.pink),
//               Spacer(),
//               ElevatedButton(
//                 onPressed: () {
//                   print("Read More");
//                 },
//                 child: Text("Read More"),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.purple,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }