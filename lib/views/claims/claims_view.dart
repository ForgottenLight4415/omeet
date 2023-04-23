import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/buttons.dart';
import '../../widgets/claim_card.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/loading_widget.dart';
import '../../recorder_initialization.dart';
import '../../utilities/app_constants.dart';
import '../../blocs/home_bloc/get_claims_cubit.dart';

class ClaimsView extends StatefulWidget {
  const ClaimsView({Key? key}) : super(key: key);

  @override
  State<ClaimsView> createState() => _ClaimsViewState();
}

class _ClaimsViewState extends State<ClaimsView> {
  final GetClaimsCubit _claimsCubit = GetClaimsCubit();
  TextEditingController? _searchController;
  String? _searchQuery;

  late final RecorderInitialization _recorderInitialization;

  @override
  void initState() {
    super.initState();
    initializeRecorders();
    _searchController = TextEditingController();
    _searchController!.addListener(() {
      _searchQuery = _searchController!.text;
      _claimsCubit.searchClaims(_searchQuery);
    });
  }

  @override
  void dispose() {
    _searchController!.dispose();
    _claimsCubit.close();
    super.dispose();
  }

  void initializeRecorders() async {
    _recorderInitialization = await RecorderInitialization.create();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              stretch: true,
              floating: true,
              pinned: true,
              snap: true,
              expandedHeight: 145.h,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              leading: const AppBackButton(),
              title: Text(
                'Hospitals',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: SearchField(
                      textEditingController: _searchController,
                      hintText: "Search hospitals",
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: BlocProvider<GetClaimsCubit>(
          create: (context) => _claimsCubit..getClaims(context),
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
                    padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 8.w),
                    itemCount: state.claims.length,
                    itemBuilder: (context, index) => ClaimCard(
                      claim: state.claims[index],
                      screenRecorder: _recorderInitialization.screenRecorder,
                      screenCapture: _recorderInitialization.screenCapture,
                      videoRecorder: _recorderInitialization.videoRecorder,
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
    );
  }
}
