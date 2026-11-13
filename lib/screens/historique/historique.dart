import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/screens/adherent/adherent_detail_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/loading/loading_utils.dart';
import 'package:cherifla/utils/log/logger.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/color/color.dart';

/// Une inscription, préparée pour l'affichage.
class _Entry {
  _Entry({
    required this.name,
    required this.code,
    required this.place,
    required this.date,
    required this.raw,
  });

  final String name;
  final String code;
  final String place;
  final DateTime? date;

  /// Données brutes de l'adhérent renvoyées par l'API.
  final Map<String, dynamic> raw;

  String get initials {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  bool matches(String q) {
    final query = q.toLowerCase();
    return name.toLowerCase().contains(query) ||
        code.toLowerCase().contains(query) ||
        place.toLowerCase().contains(query);
  }
}

String _titleCase(String value) => value
    .trim()
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  final api = ApiServices();
  final _searchController = TextEditingController();
  List<_Entry> _entries = [];
  String _query = '';
  var _showLoading = true;

  @override
  void initState() {
    super.initState();
    api.getHistorique().then(
      (value) {
        if (!mounted) return;
        if (value != null) {
          setState(() {
            _entries = value.map(_toEntry).toList()
              ..sort((a, b) =>
                  (b.date ?? DateTime(0)).compareTo(a.date ?? DateTime(0)));
          });
          logger().d('length historique ${_entries.length}');
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _Entry _toEntry(dynamic item) {
    final raw = item['adhesionDate'];
    return _Entry(
      name: _titleCase("${item['nom'] ?? ''} ${item['prenom'] ?? ''}"),
      code: (item['codeAdherent'] ?? '-').toString(),
      place: _titleCase((item['level6']?['name'] ?? '').toString()),
      date: raw == null ? null : DateTime.tryParse(raw.toString()),
      raw: Map<String, dynamic>.from(item as Map),
    );
  }

  void _openDetail(_Entry entry) {
    Adherent adherent;
    try {
      adherent = Adherent.fromJson(entry.raw);
    } catch (e) {
      logger().e('Lecture adhérent historique impossible : $e');
      adherent = Adherent(
        nom: entry.raw['nom']?.toString(),
        prenom: entry.raw['prenom']?.toString(),
        codeAdherent: entry.code,
        identityType: null,
        sexe: null,
      );
    }
    Get.to(() => AdherentDetailScreen(adherent: adherent));
  }

  /// Regroupe les inscriptions par mois (« Janvier 2026 »).
  Map<String, List<_Entry>> _groupByMonth(List<_Entry> entries) {
    final groups = <String, List<_Entry>>{};
    for (final e in entries) {
      final key = e.date == null
          ? 'Date inconnue'
          : toBeginningOfSentenceCase(
              DateFormat('MMMM yyyy', 'fr').format(e.date!));
      groups.putIfAbsent(key, () => []).add(e);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _entries
        : _entries.where((e) => e.matches(_query)).toList();
    final groups = _groupByMonth(filtered);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: buildAppBar(title: 'Historique'),
      body: Stack(
        children: [
          ResponsiveCenter(
            maxWidth: ContentWidth.content,
            padding: EdgeInsets.zero,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      context.pagePadding, 20, context.pagePadding, 0),
                  sliver: SliverToBoxAdapter(child: _buildSummary()),
                ),
                if (_showLoading)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                        context.pagePadding, 24, context.pagePadding, 0),
                    sliver: const SliverToBoxAdapter(child: SkeletonList()),
                  ),
                if (!_showLoading && filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyState(
                      message: _query.isEmpty
                          ? 'Aucune inscription pour le moment'
                          : 'Aucun résultat pour « $_query »',
                      icon: _query.isEmpty
                          ? Icons.history_rounded
                          : Icons.search_off_rounded,
                    ),
                  ),
                for (final group in groups.entries)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                        context.pagePadding, 24, context.pagePadding, 0),
                    sliver: SliverToBoxAdapter(
                      child: _buildGroup(group.key, group.value),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SkeletonBox(width: 160, height: 20),
          )
        else
          Text(
            '${_entries.length} inscription${_entries.length > 1 ? 's' : ''}',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: titleTextColor),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v.trim()),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Rechercher un nom, un code…',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Effacer',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGroup(String title, List<_Entry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: mutedTextColor,
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                _EntryRow(
                  entry: entries[i],
                  onTap: () => _openDetail(entries[i]),
                ),
                if (i < entries.length - 1)
                  const Divider(height: 1, indent: 16, color: borderColor),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, this.onTap});
  final _Entry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date = entry.date == null
        ? ''
        : DateFormat('d MMM yyyy', 'fr').format(entry.date!);

    const muted = TextStyle(fontSize: 13, color: mutedTextColor);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name.isEmpty ? 'Sans nom' : entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleTextColor),
                  ),
                  const SizedBox(height: 3),
                  Text(entry.code, style: muted),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date, style: muted),
                const SizedBox(height: 3),
                Text(entry.place, style: muted),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: mutedTextColor),
          ],
        ),
      ),
    );
  }
}
