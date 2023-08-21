import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/withdrawal.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/card_detail_text.dart';

class ClaimDetails extends StatefulWidget {
  final Withdrawal claim;

  const ClaimDetails({Key? key, required this.claim}) : super(key: key);

  @override
  State<ClaimDetails> createState() => _ClaimDetailsState();
}

class _ClaimDetailsState extends State<ClaimDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.claim.claimId,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ] +
              _allDetails(),
        ),
      ),
    );
  }

  List<Widget> _detailsWidget(String key) {
    Map<String, Map<String, dynamic>> _mainMap = widget.claim.toMap();
    return _mainMap[key]!
        .entries
        .map((entry) => CardDetailText(
        title: entry.key,
        content: entry.value != AppStrings.blank
            ? entry.value
            : AppStrings.unavailable,
      ),
    )
        .toList();
  }

  List<Widget> _allDetails() {
    Map<String, Map<String, dynamic>> _mainMap = widget.claim.toMap();
    return _mainMap.entries
        .map(
          (entry) => Column(
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
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
    )
        .toList();
  }
}
