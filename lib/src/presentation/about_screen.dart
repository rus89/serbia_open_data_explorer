// ABOUTME: "O Aplikaciji" screen with app name, description, audience, and link to data.gov.rs.
// ABOUTME: Shown when user taps bottom nav "O Aplikaciji". All text in Serbian.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _portalUrl = 'https://data.gov.rs';

/// About screen: app description, who it's for, and link to the open data portal.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openPortal(BuildContext context) async {
    final uri = Uri.parse(_portalUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (context.mounted && !launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nije moguće otvoriti portal.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Otvoreni podaci Srbije',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aplikacija za pregled kataloga otvorenih podataka Republike Srbije.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'O aplikaciji',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Možete pretraživati skupove podataka po naslovu ili opisu, sužavati rezultate filterima (organizacija, licenca, učestalost, format) i otvarati bilo koji skup da vidite opis, izdavača, učestalost ažuriranja i linkove za preuzimanje (CSV, JSON, XLS i dr.).',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Namena',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aplikacija je namenjena novinarima, studentima, programerima i nevladinim organizacijama koji rade sa otvorenim podacima u Srbiji.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Portal otvorenih podataka',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Svi podaci dolaze sa zvaničnog portala otvorenih podataka.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _openPortal(context),
            icon: const Icon(Icons.open_in_new, size: 20),
            label: const Text('Otvori data.gov.rs'),
          ),
          const SizedBox(height: 24),
          Text(
            'O projektu',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ova aplikacija nije povezana ni u kakvom odnosu sa vladom ili zvaničnim portalom data.gov.rs. Radi se o ličnom projektu sa ciljem da korisnicima olakša pristup otvorenim podacima, da doprinese zajednici i da kroz razvoj pomogne u učenju agentnog AI razvoja i Flutter okvira.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Verzija 1.0.0',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
