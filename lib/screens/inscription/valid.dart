import 'package:cherifla/screens/home/homeScreen.dart';
import 'package:cherifla/utils/color/color.dart';
import 'package:cherifla/utils/responsive/responsive.dart';
import 'package:cherifla/widgets/common/common_widgets.dart';
import 'package:cherifla/widgets/appbar/app_bar.dart';
import 'package:cherifla/widgets/background/background.dart';
import 'package:cherifla/widgets/button/buttonWidget.dart';
import 'package:cherifla/widgets/button/iconButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/dropdown_controller.dart';
import '../../services/api/api.services.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

final apiServices = ApiServices();
final dropdownController = Get.put(DropdownController());

class _ValidationScreenState extends State<ValidationScreen> {
  launchWhatsappWithMobileNumber() async {
    String message =
        "merci de recevoir votre code  adehenent ${apiServices.code.value} ";
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/${apiServices.phone.value}?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Inscription'),
      body: Stack(
        children: [const Background(), getBody()],
      ),
    );
  }

  Widget getBody() {
    return ResponsiveScrollView(
      maxWidth: ContentWidth.form,
      child: AppCard(
        padding: EdgeInsets.all(context.responsive(20, tablet: 32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionTitle('Inscription enregistrée', center: true),
            const SizedBox(height: 20),
            PhotoPreview(
              maxWidth: 220,
              child: apiServices.link.value.isNotEmpty
                  ? Image.network(
                      apiServices.link.value,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.person_outline_rounded,
                            size: 96, color: borderColor),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            const Text(
              "Numéro matricule",
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedTextColor, fontSize: 14),
            ),
            const SizedBox(height: 4),
            SelectableText(
              apiServices.code.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: loginColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1),
            ),
            const SizedBox(height: 28),
            IconButtonWidget(
              icon: 'images/whatsapp.svg',
              title: "Envoyer par WhatsApp",
              onPressed: () => launchWhatsappWithMobileNumber(),
            ),
            const SizedBox(height: 12),
            ButtonWidget(
              title: "Retour au menu principal",
              onPressed: () => Get.offAll(() => const HomeScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
