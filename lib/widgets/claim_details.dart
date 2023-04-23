import 'package:flutter/material.dart';

import '../data/models/audit.dart';
import '../utilities/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_detail_text.dart';

class ClaimDetails extends StatefulWidget {
  final Audit claim;

  const ClaimDetails({Key? key, required this.claim}) : super(key: key);

  @override
  State<ClaimDetails> createState() => _ClaimDetailsState();
}

class _ClaimDetailsState extends State<ClaimDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 10.0, right: 4.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _allDetails(),
        ),
      ),
    );
  }

  List<Widget> _detailsWidget(String key) {
    Map<String, Map<String, dynamic>> _mainMap = widget.claim.toMap();
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

  List<Widget> _allDetails() {
    Map<String, dynamic> _mainMap = widget.claim.toMap();
    return _mainMap.entries
        .map(
          (entry) => Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                                overflow: TextOverflow.fade,
                              ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ] +
                    _detailsWidget(entry.key),
              ),
            ),
          ),
        )
        .toList();
  }
}
