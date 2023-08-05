import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';

import '../../blocs/home_bloc/get_claims_cubit.dart';
import '../../recorder_initialization.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/claim_card.dart';

class ClaimsViewNew extends StatefulWidget {
  final GetClaimsCubit cubit;
  final ClaimType claimType;

  const ClaimsViewNew({
    Key? key,
    required this.cubit,
    required this.claimType,
  }) : super(key: key);

  @override
  State<ClaimsViewNew> createState() => _ClaimsViewNewState();
}

class _ClaimsViewNewState extends State<ClaimsViewNew> with AutomaticKeepAliveClientMixin {

  RecorderInitialization? _recorderInitialization;

  @override
  void initState() {
    super.initState();
    if (widget.claimType == ClaimType.accepted) {
      initializeRecorders();
    }
  }

  void initializeRecorders() async {
    _recorderInitialization = await RecorderInitialization.create();
    log("Recorder Initialized");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: BlocProvider<GetClaimsCubit>.value(
            value: widget.cubit,
            child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
              builder: (context, state) {
                if (state is GetClaimsSuccess) {
                  if (state.claims.isEmpty) {
                    return const InformationWidget(
                      svgImage: AppStrings.noDataImage,
                      label: AppStrings.noClaims,
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                    ),
                    itemCount: state.claims.length,
                    itemBuilder: (context, index) => ClaimCard(
                      claim: state.claims[index],
                      cubit: widget.cubit,
                      claimType: widget.claimType,
                      screenRecorder: _recorderInitialization?.screenRecorder,
                      videoRecorder: _recorderInitialization?.videoRecorder,
                    ),
                  );
                } else if (state is GetClaimsFailed) {
                  return CustomErrorWidget(
                    errorText: state.cause + "\n(Error code: ${state.code})",
                    action: () {
                      BlocProvider.of<GetClaimsCubit>(context).getClaims(
                          context,
                          claimType: widget.claimType
                      );
                    },
                  );
                } else {
                  return const LoadingWidget(label: AppStrings.claimsLoading);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
