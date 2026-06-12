import 'package:flutter/material.dart';

/// Sticky banner slot. Replace with a BannerAd widget once
/// google_mobile_ads is wired up.
class AdBannerPlaceholder extends StatelessWidget {
  const AdBannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      width: double.infinity,
      height: 50,
      child: const Center(
        child: Text('AdMob Banner Placeholder',
            style: TextStyle(color: Colors.white38)),
      ),
    );
  }
}
