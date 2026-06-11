import 'package:flutter/foundation.dart';

final ValueNotifier<int> profileRoleVersion = ValueNotifier(0);

// Incremented by PersonalDetailsPage after the name is saved.
// HomePage listens to this so the greeting updates without a restart.
final ValueNotifier<int> profileNameVersion = ValueNotifier(0);

// Incremented by ManageLocationsPage when the user sets a new home location.
// HomePage listens to this to reload weather/flood data for the new location.
final ValueNotifier<int> homeLocationVersion = ValueNotifier(0);

// Set to a tab index (0-4) to request AppMain to switch the bottom nav tab.
// Set to -1 as a no-op / reset state.
final ValueNotifier<int> tabSwitchRequest = ValueNotifier(-1);
