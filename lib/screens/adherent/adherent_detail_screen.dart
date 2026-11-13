import 'package:cherifla/models/adherent_model.dart';
import 'package:cherifla/screens/changeComite/change_comite_form_screen.dart';
import 'package:cherifla/services/api/api.services.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/format/phone_format.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';

/// Fiche détaillée d'un adhérent (ouverte depuis l'historique).
///
/// S'affiche tout de suite avec les données disponibles, puis se complète
/// avec la fiche à jour récupérée par le code d'adhérent.
class AdherentDetailScreen extends StatefulWidget {
  const AdherentDetailScreen({super.key, required this.adherent});
  final Adherent adherent;

  @override
  State<AdherentDetailScreen> createState() => _AdherentDetailScreenState();
}

class _AdherentDetailScreenState extends State<AdherentDetailScreen> {
  final api = ApiServices();
  late Adherent _adherent = widget.adherent;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final code = widget.adherent.codeAdherent;
    if (code == null || code.isEmpty) return;
    setState(() => _refreshing = true);
    try {
      final fresh = await api.getAdherentByCode(code, showAlert: false);
      if (mounted && fresh != null) setState(() => _adherent = fresh);
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  bool get _deactivated => _adherent.deactivate == true;
  bool get _suspended => _adherent.suspend == true;
  bool get _active => !_deactivated && !_suspended;

  String get _statusLabel => _deactivated
      ? 'Désactivé'
      : _suspended
          ? 'Suspendu'
          : 'Actif';

  String _v(String? value) =>
      (value == null || value.trim().isEmpty || value == 'null') ? '-' : value;

  String get _phone => _adherent.phone == null || _adherent.phone!.isEmpty
      ? '-'
      : PhoneFormat.international(_adherent.phone, _adherent.indicePays);

  String get _contact {
    final raw = _adherent.personToContact;
    if (raw == null || raw.trim().isEmpty) return '-';
    final parts = PhoneFormat.split(raw, countries.map((c) => c.dialCode));
    return PhoneFormat.international(parts.number, parts.dialCode);
  }

  @override
  Widget build(BuildContext context) {
    final a = _adherent;
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: buildAppBar(title: "Détail de l'adhérent"),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ResponsiveScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_refreshing) const LinearProgressIndicator(minHeight: 2),
              _buildHeader(a),
              const SizedBox(height: 20),
              _section('Identité', [
                InfoRow(label: 'Nom', value: _v(a.nom)),
                InfoRow(label: 'Prénom(s)', value: _v(a.prenom)),
                InfoRow(label: 'Sexe', value: _v(a.sexe)),
                InfoRow(label: 'Date de naissance', value: _v(a.dateNaissance)),
                InfoRow(
                    label: 'Lieu de naissance', value: _v(a.placeOfBirthday)),
                InfoRow(
                    label: 'Nationalité',
                    value: _v(a.nationality),
                    showDivider: false),
              ]),
              _section('Filiation', [
                InfoRow(label: 'Prénom(s) du père', value: _v(a.prenomPere)),
                InfoRow(label: 'Nom du père', value: _v(a.nomPere)),
                InfoRow(label: 'Prénom(s) de la mère', value: _v(a.prenomMere)),
                InfoRow(
                    label: 'Nom de la mère',
                    value: _v(a.nomMere),
                    showDivider: false),
              ]),
              _section('Coordonnées', [
                InfoRow(label: 'Téléphone', value: _phone),
                InfoRow(
                    label: 'Personne à contacter',
                    value: _contact,
                    showDivider: false),
              ]),
              _section('Profession et adhésion', [
                InfoRow(label: 'Profession', value: _v(a.profession)),
                InfoRow(label: 'Poste occupé', value: _v(a.position)),
                InfoRow(label: 'Diplôme', value: _v(a.degree?.degreeTitle)),
                InfoRow(label: 'Comité', value: _v(a.level?.name)),
                InfoRow(
                    label: "Date d'adhésion",
                    value: _v(a.adhesionDate),
                    showDivider: false),
              ]),
              _section("Pièce d'identité", [
                InfoRow(label: 'Type', value: _v(a.identityType?.name)),
                InfoRow(label: 'Numéro', value: _v(a.identityCardNumber)),
                const SizedBox(height: 12),
                PhotoPreview(
                  child: _image(a.identityDocImage == null
                      ? null
                      : '${ApiServices.BASE_URL}/api/adherent/doc-image/${a.identityDocImage}'),
                ),
                const SizedBox(height: 8),
              ]),
              if (!_active)
                _section('Statut', [
                  InfoRow(
                      label: 'Raison',
                      value: _v(
                          _deactivated ? a.deactivateReason : a.suspendReason),
                      valueColor: redColor,
                      showDivider: false),
                ]),
              if (_active) ...[
                const SizedBox(height: 8),
                ResponsiveCenter(
                  maxWidth: ContentWidth.form,
                  padding: EdgeInsets.zero,
                  child: ButtonWidget(
                    title: 'Modifier',
                    icon: Icons.edit_outlined,
                    onPressed: () =>
                        Get.to(() => ChangeComiteFormScreen(adherent: a)),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Adherent a) {
    final name = '${a.prenom ?? ''} ${a.nom ?? ''}'.trim();
    final statusColor = _active ? primaryColor : redColor;
    return AppCard(
      child: Column(
        children: [
          PhotoPreview(
            maxWidth: 160,
            child: _image(a.picture == null
                ? null
                : '${ApiServices.BASE_URL}/api/adherent/photo/${a.picture}'),
          ),
          const SizedBox(height: 16),
          Text(
            name.isEmpty ? 'Sans nom' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: titleTextColor),
          ),
          const SizedBox(height: 4),
          Text(_v(a.codeAdherent),
              style: const TextStyle(fontSize: 14, color: mutedTextColor)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_statusLabel,
                style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleTextColor)),
            const SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget? _image(String? url) {
    if (url == null || url.endsWith('/null')) return null;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child:
            Icon(Icons.broken_image_outlined, size: 48, color: mutedTextColor),
      ),
    );
  }
}
