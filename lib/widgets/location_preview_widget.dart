import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_location_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/element_action.dart';
import 'package:shelfless/utils/strings/strings.dart';

class LocationPreviewWidget extends StatelessWidget {
  final StoreLocation location;
  final void Function()? onTap;

  const LocationPreviewWidget({
    super.key,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ShelflessColors.mainContentInactive,
        elevation: Theme.of(context).cardTheme.elevation,
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    location.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ShelflessColors.onMainContentActive),
                  ),
                ],
              ),
              PopupMenuButton<ElementAction>(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: ElementAction.edit,
                      child: Row(
                        spacing: Themes.spacingSmall,
                        children: [
                          const Icon(Icons.edit_rounded),
                          Text(strings.bookEdit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: ElementAction.delete,
                      child: Row(
                        spacing: Themes.spacingSmall,
                        children: [
                          const Icon(Icons.delete_rounded),
                          Text(strings.bookDeleteAction),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (ElementAction value) async {
                  switch (value) {
                    case ElementAction.edit:
                      // Open EditLocationScreen.
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EditLocationScreen(
                          location: location,
                        ),
                      ));
                      break;
                    case ElementAction.delete:
                      final bool locationIsRogue = await LibraryContentProvider.instance.isLocationRogue(location);

                      if (context.mounted) {
                        if (!locationIsRogue) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(strings.genericCannotDelete),
                              content: Text(strings.cannotDeleteLocationContent),
                            ),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(strings.deleteLocationTitle),
                            content: Text(strings.deleteLocationContent),
                            actions: [
                              // Cancel button.
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  foregroundColor: ShelflessColors.onMainContentActive,
                                ),
                                child: Text(strings.cancel),
                              ),

                              // Confirm button.
                              ElevatedButton(
                                onPressed: () async {
                                  // Prefetch handlers before async gaps.
                                  final NavigatorState navigator = Navigator.of(context);
                                  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

                                  // Delete the location.
                                  await LibraryContentProvider.instance.deleteLocation(location);

                                  messenger.showSnackBar(
                                    SnackBar(
                                      // margin: const EdgeInsets.all(Themes.spacingMedium),
                                      duration: Themes.durationShort,
                                      behavior: SnackBarBehavior.floating,
                                      width: Themes.snackBarSizeSmall,
                                      content: Text(
                                        strings.locationDeleted,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );

                                  // Pop back.
                                  navigator.pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ShelflessColors.error,
                                  iconColor: ShelflessColors.onMainContentActive,
                                  foregroundColor: ShelflessColors.onMainContentActive,
                                ),
                                child: Text(strings.ok),
                              ),
                            ],
                          ),
                        );
                      }
                      break;
                    default:
                      break;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(Themes.spacingSmall),
                  child: Icon(
                    Icons.more_vert_rounded,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
