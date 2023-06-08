import 'package:flutter/material.dart';
import 'package:omeet_motor/data/models/claim.dart';

import '../utilities/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_detail_text.dart';

class ClaimDetails extends StatelessWidget {
  final Claim claim;

  const ClaimDetails({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _allDetails(context),
        ),
      ),
    );
  }

  List<Widget> _detailsWidget(String key) {
    Map<String, Map<String, dynamic>> _mainMap = claim.toMap();
    List<Widget> detailsWidget = _mainMap[key]!
        .entries
        .map(
          (entry) => CardDetailText(
        title: entry.key,
        content: entry.value != AppStrings.blank
            ? entry.value
            : AppStrings.unavailable,
      ),
    )
        .toList();
    return detailsWidget;
  }

  List<Widget> _allDetails(BuildContext context) {
    Map<String, dynamic> _mainMap = claim.toMap();
    return _mainMap.entries
        .map(
          (entry) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                    entry.key,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium
                ),
              ),
              SizedBox(height: 10.h),
            ] +
                _detailsWidget(entry.key),
          ),
        ),
      ),
    ).toList();
  }
}
