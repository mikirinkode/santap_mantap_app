import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:santap_mantap_app/theme/app_button_style.dart';
import 'package:santap_mantap_app/theme/app_color.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';

class EmptyStateView extends StatelessWidget {
  final String message;

  const EmptyStateView({
    this.message = "Saat ini tidak ada data Restoran.",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIUtils.paddingAll(24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fastfood_rounded,
              color: AppColor.neutral400,
              size: 100,
            ),
            UIUtils.heightSpace(24),
            const Text(
              "Tidak Ada Data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            UIUtils.heightSpace(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColor.neutral400,
              ),
            ),
            UIUtils.heightSpace(16),
          ],
        ),
      ),
    );
  }
}
