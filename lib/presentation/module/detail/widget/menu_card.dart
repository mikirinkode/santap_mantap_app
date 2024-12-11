import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/app_color.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/ui_utils.dart';

class MenuCard extends StatelessWidget {
  final String name;
  final bool isFood;

  const MenuCard({super.key, required this.name, required this.isFood});

  @override
  Widget build(BuildContext context) {
       return Padding(
      padding: UIUtils.paddingRight(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: UIUtils.paddingAll(16),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                (isFood) ? AppIcons.food : AppIcons.drink,
                width: 24,
                height: 24,
                color: AppColor.neutral400,
              ),
            ),
            UIUtils.heightSpace(8),
            SizedBox(
              width: 100,
              child: Text(
                name,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  
  }
}
