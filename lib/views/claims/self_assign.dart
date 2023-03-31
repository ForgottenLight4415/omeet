import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/widgets/buttons.dart';

import '../../blocs/home_bloc/get_claims_cubit.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/claim_card.dart';

class SelfAssignClaimsPage extends StatefulWidget {
  const SelfAssignClaimsPage({Key? key}) : super(key: key);

  @override
  State<SelfAssignClaimsPage> createState() => _SelfAssignClaimsPageState();
}

class _SelfAssignClaimsPageState extends State<SelfAssignClaimsPage> {
  final GetClaimsCubit _claimsCubit = GetClaimsCubit();
  TextEditingController? _searchController;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
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
                'Assign claim',
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
                      hintText: "Search claims",
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: BlocProvider<GetClaimsCubit>(
          create: (context) => _claimsCubit
            ..getClaims(
              context,
              department: true,
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
                    padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 8.w),
                    itemCount: state.claims.length,
                    itemBuilder: (context, index) => ClaimCard(
                      claim: state.claims[index],
                      isEditable: false,
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
