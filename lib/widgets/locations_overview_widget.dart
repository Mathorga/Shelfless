// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:shelfless/models/book.dart';
// import 'package:shelfless/models/store_location.dart';
// import 'package:shelfless/providers/libraries_provider.dart';
// import 'package:shelfless/providers/store_locations_provider.dart';
// import 'package:shelfless/screens/books_screen.dart';
// import 'package:shelfless/screens/edit_location_screen.dart';
// import 'package:shelfless/screens/location_info_screen.dart';
// import 'package:shelfless/utils/strings/strings.dart';
// import 'package:shelfless/widgets/location_preview_widget.dart';

// class LocationsOverviewWidget extends StatelessWidget {
//   final String searchValue;

//   const LocationsOverviewWidget({
//     Key? key,
//     this.searchValue = "",
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final StoreLocationsProvider locationsProvider = Provider.of(context, listen: true);
//     final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

//     // Fetch all relevant authors based on the currently viewed library. All if no specific library is selected.
//     final List<StoreLocation> unfilteredLocations = librariesProvider.currentLibrary != null
//         ? librariesProvider.currentLibrary!.books
//             .where((Book book) => book.publisher != null)
//             .map<StoreLocation>((Book book) => book.location!)
//             .fold(<StoreLocation>[], (List<StoreLocation> result, StoreLocation element) => result..add(element))
//             .toSet()
//             .toList()
//         : locationsProvider.locations;

//     final List<StoreLocation> locations = unfilteredLocations.where((StoreLocation publisher) => publisher.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

//     return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: locations.isEmpty
//             ? Center(
//                 child: Text(strings.noLocationsFound),
//               )
//             : GridView.count(
//                 crossAxisCount: 2,
//                 childAspectRatio: 12 / 9,
//                 padding: const EdgeInsets.all(12.0),
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   ...List.generate(
//                     locations.length,
//                     (index) => GestureDetector(
//                       onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (BuildContext context) => BooksScreen(location: locations[index]),
//                         ),
//                       ),
//                       child: Stack(
//                         children: [
//                           SizedBox(
//                             height: double.infinity,
//                             child: LocationPreviewWidget(
//                               location: locations[index],
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: IconButton(
//                               onPressed: () {
//                                 // Edit the selected author.
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (BuildContext context) => LocationInfoScreen(location: locations[index]),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(Icons.settings_rounded),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => const EditLocationScreen(),
//               ),
//             );
//           },
//           child: const Icon(Icons.add_rounded),
//         ));
//   }
// }
