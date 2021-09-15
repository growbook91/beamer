
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guard_riverpod/pages.dart';

BeamerDelegate createDelegate(Reader read) => BeamerDelegate(
  initialPath: '/$firstRoute',
  // If we wanted to, we could even pass the `Reader` to locations, if they
  // needed to.
  locationBuilder: BeamerLocationBuilder(beamLocations: [MyLocation()]),
  guards: [
    BeamGuard(
      pathPatterns: ['/$firstRoute/*'], 
      // Only allow to navigate past `firstRoute` if the `navigationProvider` is `true`.
      check: (_, __) => read(navigationProvider).state,
    ),
  ]
);

// Controls whether we will allow navigations to occur in our `BeamGuard`.
//
// Starts with `false`.
final navigationProvider = StateProvider<bool>((ref) => false);

const firstRoute = 'first';
const secondRoute = 'second';

class MyLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/$firstRoute', '/$firstRoute/$secondRoute'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(key: ValueKey(firstRoute), child: FirstPage()),
      if (state.uri.pathSegments.contains(secondRoute))
        BeamPage(key: ValueKey(secondRoute), fullScreenDialog: true, child: SecondPage()),
    ];
  }
}