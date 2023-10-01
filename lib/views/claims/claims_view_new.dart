import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/home_bloc/get_claims_cubit.dart';
import '../../recorder_initialization.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/claim_card.dart';

class ClaimsView extends StatefulWidget {
  final bool isCompleted;

  const ClaimsView({Key? key, this.isCompleted = false}) : super(key: key);

  @override
  State<ClaimsView> createState() => _ClaimsViewState();
}

class _ClaimsViewState extends State<ClaimsView> with AutomaticKeepAliveClientMixin {
  final GetClaimsCubit _claimsCubit = GetClaimsCubit();
  late TextEditingController _searchController;

  RecorderInitialization? _recorderInitialization;

  @override
  void initState() {
    super.initState();
    if (!widget.isCompleted) {
      initializeRecorders();
    }
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _claimsCubit.searchClaims(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _claimsCubit.close();
    super.dispose();
  }

  void initializeRecorders() async {
    _recorderInitialization = await RecorderInitialization.create();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: SearchField(
            textEditingController: _searchController,
            hintText: "Search",
          ),
        ),
        Expanded(
          child: BlocProvider<GetClaimsCubit>(
            create: (context) => _claimsCubit..getClaims(
              context,
              completed: widget.isCompleted,
            ),
            child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
              builder: (context, state) {
                if (state is GetClaimsSuccess) {
                  if (state.claims.isEmpty) {
                    return const InformationWidget(
                      svgImage: AppStrings.noDataImage,
                      label: AppStrings.noClaims,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<GetClaimsCubit>(context).getClaims(context);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 16.h,
                      ),
                      itemCount: state.claims.length,
                      itemBuilder: (context, index) => ClaimCard(
                        claim: state.claims[index],
                        isEditable: !widget.isCompleted,
                        screenRecorder: _recorderInitialization?.screenRecorder,
                        screenCapture: _recorderInitialization?.screenCapture,
                        videoRecorder: _recorderInitialization?.videoRecorder,
                      ),
                    ),
                  );
                } else if (state is GetClaimsFailed) {
                  return CustomErrorWidget(
                    errorText: state.cause + "\n(Error code: ${state.code})",
                    action: () {
                      BlocProvider.of<GetClaimsCubit>(context).getClaims(context);
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
