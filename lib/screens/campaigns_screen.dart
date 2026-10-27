import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/sample_data.dart';
import '../state/app_scope.dart';
import '../widgets/campaign_card.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(title: Text(s.allCampaigns)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        itemCount: SampleData.campaigns.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(s.allCampaignsSubtitle, style: context.text.bodyMedium);
          }
          final campaign = SampleData.campaigns[index - 1];
          return CampaignCard(
            campaign: campaign,
            imageHeight: 176,
            onTap: () => context.go('/campaign/${campaign.id}'),
          );
        },
      ),
    );
  }
}
