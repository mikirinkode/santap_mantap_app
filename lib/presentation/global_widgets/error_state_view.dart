import 'package:flutter/material.dart';
import 'package:santap_mantap_app/theme/app_button_style.dart';
import 'package:santap_mantap_app/theme/app_color.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';

class ErrorStateView extends StatelessWidget {
  final String message;
  final Function() onRetry;

  const ErrorStateView({
    super.key,
    required this.message,
    required this.onRetry,
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: UIUtils.paddingAll(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 100,
                  ),
                  UIUtils.heightSpace(24),
                  const Text(
                    "Terjadi Kesalahan",
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
                  FilledButton(
                    onPressed: onRetry,
                    style: AppButtonStyle.filledPrimary,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
