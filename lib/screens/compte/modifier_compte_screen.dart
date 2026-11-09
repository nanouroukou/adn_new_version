import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';

import '../../widgets/background/background.dart';

class ModifierCompteScreen extends StatefulWidget {
  const ModifierCompteScreen({super.key});

  @override
  State<ModifierCompteScreen> createState() => _ModifierCompteScreenState();
}

class _ModifierCompteScreenState extends State<ModifierCompteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Modification du profil'),
      body: const Stack(
        children: [
          Background(),
          ResponsiveScrollView(
            maxWidth: ContentWidth.form,
            child: SectionTitle('Modification du profil', center: true),
          ),
        ],
      ),
    );
  }
}
