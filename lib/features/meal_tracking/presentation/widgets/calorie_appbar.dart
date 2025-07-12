// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../shared/widgets/glassmorphic_container.dart';

// class CalorieAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CalorieAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       title: GlassmorphicContainer(
//         color: const Color(0xFF26A69A),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         child: DropdownButton<String>(
//           value: "Today",
//           dropdownColor: const Color(0xFF26A69A).withOpacity(0.5),
//           underline: const SizedBox(),
//           icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           items: const [
//             DropdownMenuItem(
//               value: "Today",
//               child: Text("Today", style: TextStyle(color: Colors.white)),
//             ),
//             DropdownMenuItem(
//               value: "Yesterday",
//               child: Text("Yesterday", style: TextStyle(color: Colors.white)),
//             ),
//             DropdownMenuItem(
//               value: "Pick Date",
//               child: Text("Pick Date", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//           onChanged: (value) {},
//         ),
//       ),
//     );
//   }
// }