import 'package:cherifla/screens/evenement/evenement.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color/color.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final api = ApiServices();
  List evenement = [];
  var _showLoading = true;

  @override
  void initState() {
    super.initState();
    api.getEvenement().then(
      (value) {
        if (!mounted) return;
        if (value != null) {
          setState(() {
            evenement = value;
          });
          logger().d('length evenement ${evenement.length}');
        }
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Evénements'),
      body: Stack(
        children: [
          const Background(),
          getBody(),
        ],
      ),
    );
  }

  Widget getBody() {
    return ResponsiveScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showLoading)
            const SkeletonList(count: 4)
          else ...[
            Text(
              "${evenement.length} événement${evenement.length > 1 ? 's' : ''}",
              style: const TextStyle(color: mutedTextColor, fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],
          if (!_showLoading && evenement.isEmpty)
            const EmptyState(
                message: 'Aucun événement disponible',
                icon: Icons.event_busy_rounded),
          for (final item in evenement)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MenuTile(
                title: item['name'] ?? '',
                icon: Icons.event_rounded,
                onTap: () => Get.to(() => EvenementScreen(
                      id: item['id'].toString(),
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
