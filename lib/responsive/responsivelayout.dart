// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:instagramclone/providers/user_provider.dart';
// import 'package:instagramclone/utils/utils.dart';
// import 'package:provider/provider.dart';
// import '../providers/user_provider.dart';

// class responsivelayout extends StatefulWidget {
//   const responsivelayout({Key? key}) : super(key: key);

//   @override
//   State<responsivelayout> createState() => _responsivelayoutState();
// }

// class _responsivelayoutState extends State<responsivelayout> {
//   @override
//   void initState() {
//     super.initState();
//     addData();
//   }

//   addData() async {
//     UserProvider _userProvider =
//         Provider.of<UserProvider>(context, listen: false);
//     await _userProvider.refreshUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           height: 200,
//           width: 100,
//           color: Colors.yellow,
//         ),
//       ),
//     );
//   }
// }
