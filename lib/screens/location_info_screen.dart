// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:shelfless/dialogs/delete_dialog.dart';
// import 'package:shelfless/models/store_location.dart';
// import 'package:shelfless/providers/store_locations_provider.dart';
// import 'package:shelfless/screens/edit_location_screen.dart';
// import 'package:shelfless/utils/strings/strings.dart';

// class LocationInfoScreen extends StatelessWidget {
//   static const String routeName = "/location-info";

//   final StoreLocation location;

//   const LocationInfoScreen({
//     Key? key,
//     required this.location,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Fetch provider.
//     final StoreLocationsProvider locationsProvider = Provider.of(context, listen: true);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           strings.locationInfo,
//           style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Navigate to edit screen.
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => EditLocationScreen(location: location),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.edit_rounded),
//           ),
//           IconButton(
//             onPressed: () {
//               // Show dialog asking the user to confirm their choice.
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return DeleteDialog(
//                     title: Text("$location"),
//                     onConfirm: () => locationsProvider.deleteLocation(location),
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.delete_rounded),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Name.
//               Text(strings.locationInfoName),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(
//                   location.name,
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
