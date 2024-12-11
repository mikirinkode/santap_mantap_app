import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:santap_mantap_app/domain/entities/customer_review_entity.dart';

import '../../../../theme/app_color.dart';
import '../../../../utils/ui_utils.dart';

class ReviewCard extends StatelessWidget {
  final CustomerReviewEntity review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIUtils.paddingBottom(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColor.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: UIUtils.paddingAll(8),
                child: const Icon(
                  CupertinoIcons.person_alt,
                  color: AppColor.neutral400,
                ),
              ),
              UIUtils.widthSpace(16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name ?? "",
                      style: const TextStyle(fontSize: 12),
                    ),
                    UIUtils.heightSpace(4),
                    Text(
                      review.review ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
          UIUtils.heightSpace(12),
          Container(
            width: double.infinity,
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
