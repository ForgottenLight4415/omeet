import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/data/models/claim.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';
import 'package:omeet_motor/widgets/list_filter.dart';

import '../../blocs/home_bloc/get_claims_cubit.dart';
import '../../recorder_initialization.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/claim_card.dart';

class ClaimsView extends StatefulWidget {
  final GetClaimsCubit cubit;
  final ClaimType claimType;

  const ClaimsView({
    Key? key,
    required this.cubit,
    required this.claimType,
  }) : super(key: key);

  @override
  State<ClaimsView> createState() => _ClaimsViewState();
}

class _ClaimsViewState extends State<ClaimsView>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _searchController;

  RecorderInitialization? _recorderInitialization;

  String _stateFilter = "ALL";
  String _districtFilter = "ALL";
  String _policeStationFilter = "ALL";

  @override
  void initState() {
    super.initState();
    if (widget.claimType == ClaimType.accepted) {
      initializeRecorders();
    }
    _searchController = TextEditingController();
    _searchController.addListener(() {
      widget.cubit.searchClaims(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget.cubit.close();
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocProvider<GetClaimsCubit>.value(
                  value: widget.cubit,
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      final List<String> options = ["ALL"];
                      if (state is GetClaimsSuccess) {
                        for (Claim claim in state.claims) {
                          String state = claim.state;
                          if (!options.contains(state)) {
                            options.add(claim.state);
                          }
                        }
                      }
                      return ListFilterElement(
                          buttonLabel: "STATE",
                          options: options,
                          onChanged: (value) {
                            _stateFilter = value;
                            widget.cubit.getClaims(
                              context,
                              claimType: widget.claimType,
                              state: _stateFilter,
                              district: _districtFilter,
                              policeStation: _policeStationFilter,
                            );
                          });
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>.value(
                  value: widget.cubit,
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      final List<String> options = ["ALL"];
                      if (state is GetClaimsSuccess) {
                        for (Claim claim in state.claims) {
                          String district = claim.district;
                          if (!options.contains(district)) {
                            options.add(claim.district);
                          }
                        }
                      }
                      return ListFilterElement(
                          buttonLabel: "DISTRICT",
                          options: options,
                          onChanged: (value) {
                            _districtFilter = value;
                            widget.cubit.getClaims(
                              context,
                              state: _stateFilter,
                              district: _districtFilter,
                              policeStation: _policeStationFilter,
                            );
                          });
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>.value(
                  value: widget.cubit,
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      final List<String> options = ["ALL"];
                      if (state is GetClaimsSuccess) {
                        for (Claim claim in state.claims) {
                          String policeStation = claim.policeStation;
                          if (!options.contains(policeStation)) {
                            options.add(claim.policeStation);
                          }
                        }
                      }
                      return ListFilterElement(
                          buttonLabel: "PS",
                          options: options,
                          onChanged: (value) {
                            _policeStationFilter = value;
                            widget.cubit.getClaims(
                              context,
                              claimType: widget.claimType,
                              state: _stateFilter,
                              district: _districtFilter,
                              policeStation: _policeStationFilter,
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: SearchField(
            textEditingController: _searchController,
            hintText: "Search",
          ),
        ),
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<GetClaimsCubit>(context).getClaims(
                        context,
                        claimType: widget.claimType
                      );
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
                        cubit: widget.cubit,
                        claimType: widget.claimType,
                        screenRecorder: _recorderInitialization?.screenRecorder,
                        videoRecorder: _recorderInitialization?.videoRecorder,
                      ),
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
