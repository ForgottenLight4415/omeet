import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/blocs/home_bloc/get_claims_cubit.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';
import 'package:omeet_motor/widgets/app_logo.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../data/models/claim.dart';
import '../utilities/bridge_call.dart';
import '../views/claims/claims_view_new.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../widgets/case_header.dart';
import '../widgets/input_fields.dart';
import '../widgets/list_filter.dart';
import '../widgets/omeet_drawer_header.dart';
import '../widgets/snack_bar.dart';

class LandingNewB extends StatefulWidget {
  final String email;
  final String phone;

  const LandingNewB({Key? key, required this.email, required this.phone})
      : super(key: key);

  @override
  State<LandingNewB> createState() => _LandingNewBState();
}

class _LandingNewBState extends State<LandingNewB>
    with SingleTickerProviderStateMixin {
  late final GetClaimsCubit _allClaims;
  late final GetClaimsCubit _overallClaims;
  late final GetClaimsCubit _acceptedClaims;
  late final GetClaimsCubit _rejectedClaims;
  late final GetClaimsCubit _concludedClaims;
  late final TextEditingController _searchController;

  late final List<GetClaimsCubit> _cubitList;

  int _noAllClaims = 0;
  int _noOverallClaims = 0;
  int _noAcceptedClaims = 0;
  int _noRejectedClaims = 0;
  int _noConcludedClaims = 0;

  String _stateFilter = "ALL";
  String _districtFilter = "ALL";
  String _policeStationFilter = "ALL";

  List<String> _stateOptions = ['ALL'];
  List<DistrictFilter> _districtOptions = [ const DistrictFilter("ALL", "ALL") ];
  List<PoliceStationFilter> _policeStationOptions = [ const PoliceStationFilter("ALL", "ALL", "ALL") ];

  ClaimType _currentClaimType = ClaimType.overall;

  late final TabController _controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _allClaims = GetClaimsCubit(claimType: ClaimType.allocated);
    _overallClaims = GetClaimsCubit(claimType: ClaimType.overall);
    _acceptedClaims = GetClaimsCubit(claimType: ClaimType.accepted);
    _rejectedClaims = GetClaimsCubit(claimType: ClaimType.rejected);
    _concludedClaims = GetClaimsCubit(claimType: ClaimType.concluded);
    _cubitList = [
      _overallClaims,
      _allClaims,
      _acceptedClaims,
      _rejectedClaims,
      _concludedClaims,
    ];

    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
      switch (_controller.index) {
        case 0:
          _currentClaimType = ClaimType.overall;
          break;
        case 1:
          _currentClaimType = ClaimType.allocated;
          break;
        case 2:
          _currentClaimType = ClaimType.accepted;
          break;
        case 3:
          _currentClaimType = ClaimType.rejected;
          break;
        case 4:
          _currentClaimType = ClaimType.concluded;
          break;
      }
      setState(() {});
    });

    _searchController = TextEditingController();
    _searchController.addListener(() {
      for (var cubit in _cubitList) {
        cubit.searchClaims(_searchController.text);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    for (var cubit in _cubitList) {
      cubit.close();
    }
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withAlpha(0),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocProvider<GetClaimsCubit>.value(
            value: _overallClaims,
            child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
              builder: (context, state) {
                List<String> _tempList = [];
                if (state is GetClaimsSuccess) {
                  if (_stateOptions.length == 1) {
                    _stateOptions = ["ALL"];
                    for (Claim claim in state.claims) {
                      String state = claim.state;
                      if (!_tempList.contains(state)) {
                        _tempList.add(claim.state);
                      }
                    }
                    _tempList.sort();
                    _stateOptions.addAll(_tempList);
                  }

                  List<DistrictFilter> _tempDFilter = [];
                  if (_districtOptions.length == 1) {
                    _districtOptions = [];
                    for (Claim claim in state.claims) {
                      DistrictFilter district = DistrictFilter(claim.state, claim.district);
                      if (!_tempDFilter.contains(district)) {
                        _tempDFilter.add(district);
                      }
                    }
                    _tempDFilter.sort((a, b) => a.districtName.compareTo(b.districtName));
                    _districtOptions.addAll(_tempDFilter);
                  }

                  List<PoliceStationFilter> _tempPFilter = [];
                  if (_policeStationOptions.length == 1) {
                    _policeStationOptions = [];
                    for (Claim claim in state.claims) {
                      PoliceStationFilter policeStation = PoliceStationFilter(claim.state, claim.district, claim.policeStation);
                      if (!_tempPFilter.contains(policeStation)) {
                        _tempPFilter.add(policeStation);
                      }
                    }
                    _tempPFilter.sort((a, b) => a.psName.compareTo(b.psName));
                    _policeStationOptions.addAll(_tempPFilter);
                  }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListFilterElement(
                        buttonLabel: "STATE: $_stateFilter",
                        options: _stateOptions,
                        onChanged: (value) {
                          _stateFilter = value;
                          _districtFilter = "ALL";
                          _policeStationFilter = "ALL";
                          for (var cubit in _cubitList) {
                            cubit.setStateName(_stateFilter);
                            cubit.setDistrictName(_districtFilter);
                            cubit.setPoliceStationName(_policeStationFilter);
                          }
                          for (var cubit in _cubitList) {
                            cubit.getClaims(context);
                          }
                        }),
                    ListFilterElement(
                        buttonLabel: "DISTRICT: $_districtFilter",
                        options: getDistrictOptions(),
                        onChanged: (value) {
                          _districtFilter = value;
                          _policeStationFilter = "ALL";
                          for (var cubit in _cubitList) {
                            cubit.setDistrictName(_districtFilter);
                            cubit.setPoliceStationName(_policeStationFilter);
                          }
                          for (var cubit in _cubitList) {
                            cubit.getClaims(context);
                          }
                        }),
                    ListFilterElement(
                        buttonLabel: "PS: $_policeStationFilter",
                        options: getPoliceStationOptions(),
                        onChanged: (value) {
                          _policeStationFilter = value;
                          for (var cubit in _cubitList) {
                            cubit.setPoliceStationName(_policeStationFilter);
                          }
                          for (var cubit in _cubitList) {
                            cubit.getClaims(context);
                          }
                        }),
                  ],
                );
              },
            ),
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const AppLogo(size: 40.0),
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OMeetUserDrawerHeader(email: widget.email, phone: widget.phone),
            BlocProvider<CallCubit>(
              create: (context) => CallCubit(),
              child: BlocConsumer<CallCubit, CallState>(
                listener: _callListener,
                builder: (context, state) => ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    AppStrings.customCall,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    _scaffoldKey.currentState?.closeDrawer();
                    await customCallSetup(context);
                  },
                ),
              ),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.arrowUp,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                AppStrings.uploads,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, '/uploads');
              },
            ),
            Expanded(child: Container()),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                AppStrings.signOut,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await AuthRepository().signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.appVersion,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black45),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SearchField(
              textEditingController: _searchController,
              hintText: "Search",
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _overallClaims
                    ..getClaims(context),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noOverallClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _noOverallClaims.toString(),
                        label: "Overall",
                        isActive: _currentClaimType == ClaimType.overall,
                        onPressed: () => _controller.animateTo(0),
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _allClaims
                    ..getClaims(context),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noAllClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _noAllClaims.toString(),
                        label: "Allocated",
                        isActive: _currentClaimType == ClaimType.allocated,
                        onPressed: () => _controller.animateTo(1),
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _acceptedClaims
                    ..getClaims(context),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noAcceptedClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _noAcceptedClaims.toString(),
                        label: "Accepted",
                        isActive: _currentClaimType == ClaimType.accepted,
                        onPressed: () => _controller.animateTo(2),
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _rejectedClaims
                    ..getClaims(context),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noRejectedClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _noRejectedClaims.toString(),
                        label: "Rejected",
                        isActive: _currentClaimType == ClaimType.rejected,
                        onPressed: () => _controller.animateTo(3),
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _concludedClaims
                    ..getClaims(context),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noConcludedClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _noConcludedClaims.toString(),
                        label: "Concluded",
                        isActive: _currentClaimType == ClaimType.concluded,
                        onPressed: () => _controller.animateTo(4),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    _overallClaims.getClaims(context);
                  },
                  child: ClaimsViewNew(
                    cubit: _overallClaims,
                    claimType: ClaimType.overall,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    _allClaims.getClaims(context);
                  },
                  child: ClaimsViewNew(
                    cubit: _allClaims,
                    claimType: ClaimType.allocated,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    _acceptedClaims.getClaims(context);
                  },
                  child: ClaimsViewNew(
                    cubit: _acceptedClaims,
                    claimType: ClaimType.accepted,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    _rejectedClaims.getClaims(context);
                  },
                  child: ClaimsViewNew(
                    cubit: _rejectedClaims,
                    claimType: ClaimType.rejected,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    _concludedClaims.getClaims(context);
                  },
                  child: ClaimsViewNew(
                    cubit: _concludedClaims,
                    claimType: ClaimType.concluded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> getDistrictOptions() {
    List<String> results = ["ALL"];
    for (DistrictFilter filter in _districtOptions) {
      if (_stateFilter == "ALL" || _stateFilter == filter.filterState) {
        String dName = filter.districtName;
        if (!results.contains(dName)) {
          results.add(dName);
        }
      }
    }
    return results;
  }

  List<String> getPoliceStationOptions() {
    List<String> results = ["ALL"];
    for (PoliceStationFilter filter in _policeStationOptions) {
      if ((_stateFilter == "ALL" || _stateFilter == filter.filterState)
          || (_districtFilter == "ALL" || _districtFilter == filter.filterDistrict)) {
        String psName = filter.psName;
        if (!results.contains(psName)) {
          results.add(psName);
        }
      }
    }
    return results;
  }

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall, type: SnackBarType.success);
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, type: SnackBarType.error);
    }
  }
}

class DistrictFilter {
  final String filterState;
  final String districtName;

  const DistrictFilter(this.filterState, this.districtName);
}

class PoliceStationFilter {
  final String filterState;
  final String filterDistrict;
  final String psName;

  const PoliceStationFilter(this.filterState, this.filterDistrict, this.psName);
}