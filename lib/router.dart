import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/donation.dart';
import 'screens/about_screen.dart';
import 'screens/campaign_detail_screen.dart';
import 'screens/campaigns_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/donate_screen.dart';
import 'screens/donation_detail_screen.dart';
import 'screens/donations_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/shell_screen.dart';
import 'screens/volunteer_screen.dart';
import 'screens/zakat_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Every screen and demo state opens straight from a URL, for example
/// `/zakat?demo=1` or `/volunteer?demo=1&step=2`. Campaign and receipt
/// details sit above the tab bar on the root navigator.
GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ShellScreen(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'campaigns',
                    builder: (context, state) => const CampaignsScreen(),
                  ),
                  GoRoute(
                    path: 'campaign/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => CampaignDetailScreen(
                      campaignId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/donate',
                builder: (context, state) {
                  final query = state.uri.queryParameters;
                  return DonateScreen(
                    campaignId: query['campaign'],
                    cause: _causeFrom(query['cause']),
                    amount: int.tryParse(query['amount'] ?? ''),
                    demo: query['demo'] == '1',
                    showSuccess: query['success'] == '1',
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/zakat',
                builder: (context, state) {
                  final query = state.uri.queryParameters;
                  return ZakatScreen(
                    demo: query['demo'] == '1',
                    openRates: query['rates'] == '1',
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/volunteer',
                builder: (context, state) {
                  final query = state.uri.queryParameters;
                  return VolunteerScreen(
                    demo: query['demo'] == '1',
                    step: int.tryParse(query['step'] ?? ''),
                    showSuccess: query['success'] == '1',
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'donations',
                    builder: (context, state) => DonationsScreen(
                      filter: _statusFrom(state.uri.queryParameters['filter']),
                    ),
                    routes: [
                      GoRoute(
                        path: ':reference',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => DonationDetailScreen(
                          reference: state.pathParameters['reference']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutScreen(),
                  ),
                  GoRoute(
                    path: 'contact',
                    builder: (context, state) => ContactScreen(
                      sent: state.uri.queryParameters['sent'] == '1',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Cause? _causeFrom(String? name) {
  for (final cause in Cause.values) {
    if (cause.name == name) return cause;
  }
  return null;
}

DonationStatus? _statusFrom(String? name) {
  for (final status in DonationStatus.values) {
    if (status.name == name) return status;
  }
  return null;
}
