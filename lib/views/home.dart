import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/home_bloc/get_claims_cubit.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../utilities/screen_capture.dart';
import '../utilities/screen_recorder.dart';
import '../utilities/video_record_config.dart';
import '../widgets/input_fields.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/claim_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetClaimsCubit _claimsCubit = GetClaimsCubit();
  TextEditingController? _searchController;
  String? _searchQuery;
  ScreenRecorder? _screenRecorder;
  ScreenCapture? _screenCapture;
  VideoRecorderConfig? _videoRecorderConfig;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController!.addListener(() {
      _searchQuery = _searchController!.text;
      _claimsCubit.searchClaims(_searchQuery);
    });
    _screenRecorder = ScreenRecorder();
    _screenCapture = ScreenCapture();
    _videoRecorderConfig = VideoRecorderConfig();
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
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/uploads');
                  },
                  icon: const Icon(Icons.upload),
                ),
                IconButton(
                  onPressed: () async {
                    await AuthRepository().signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
              title: Text(
                'Claims',
                style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: false,
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
                      screenRecorder: _screenRecorder!,
                      screenCapture: _screenCapture!,
                      videoRecorderConfig: _videoRecorderConfig!,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/new/claim');
        },
      ),
    );
  }
}
