import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/blocs/home_bloc/get_claims_cubit.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';
import 'package:omeet_motor/widgets/app_logo.dart';
import 'package:omeet_motor/widgets/loading_widget.dart';

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

class _LandingNewBState extends State<LandingNewB> {
  late final GetClaimsCubit _allClaims;
  late final GetClaimsCubit _overallClaims;
  late final GetClaimsCubit _acceptedClaims;
  late final GetClaimsCubit _rejectedClaims;
  late final GetClaimsCubit _concludedClaims;
  late final TextEditingController _searchController;

  int _noAllClaims = 0;
  int _noOverallClaims = 0;
  int _noAcceptedClaims = 0;
  int _noRejectedClaims = 0;
  int _noConcludedClaims = 0;

  String _stateFilter = "ALL";
  String _districtFilter = "ALL";
  String _policeStationFilter = "ALL";

  List<String> _stateOptions = ['ALL'];
  List<String> _districtOptions = ['ALL'];
  List<String> _policeStationOptions = ['ALL'];

  GetClaimsCubit? _currentCubit;
  ClaimType _currentClaimType = ClaimType.overall;

  Widget view = const LoadingWidget();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _allClaims = GetClaimsCubit();
    _overallClaims = GetClaimsCubit();
    _acceptedClaims = GetClaimsCubit();
    _rejectedClaims = GetClaimsCubit();
    _concludedClaims = GetClaimsCubit();
    _currentCubit = _overallClaims;
    view = ClaimsViewNew(cubit: _overallClaims, claimType: ClaimType.overall);

    _searchController = TextEditingController();
    _searchController.addListener(() {
      _currentCubit!.searchClaims(_searchController.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _allClaims.close();
    _overallClaims.close();
    _acceptedClaims.close();
    _rejectedClaims.close();
    _concludedClaims.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocProvider<GetClaimsCubit>.value(
                value: _currentCubit!,
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      if (_stateFilter == "ALL") {
                        _stateOptions = ["ALL"];
                        for (Claim claim in state.claims) {
                          String state = claim.state;
                          if (!_stateOptions.contains(state)) {
                            _stateOptions.add(claim.state);
                          }
                        }
                      }
                    }
                    return ListFilterElement(
                        buttonLabel: "STATE",
                        options: _stateOptions,
                        onChanged: (value) {
                          _stateFilter = value;
                          _currentCubit?.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        });
                  },
                ),
              ),
              BlocProvider<GetClaimsCubit>.value(
                value: _currentCubit!,
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      if (_districtFilter == "ALL") {
                        _districtOptions = ["ALL"];
                        for (Claim claim in state.claims) {
                          String district = claim.district;
                          if (!_districtOptions.contains(district)) {
                            _districtOptions.add(claim.district);
                          }
                        }
                      }
                    }
                    return ListFilterElement(
                        buttonLabel: "DISTRICT",
                        options: _districtOptions,
                        onChanged: (value) {
                          _districtFilter = value;
                          _currentCubit?.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        });
                  },
                ),
              ),
              BlocProvider<GetClaimsCubit>.value(
                value: _currentCubit!,
                child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                  builder: (context, state) {
                    if (state is GetClaimsSuccess) {
                      if (_policeStationFilter == "ALL") {
                        _policeStationOptions = ["ALL"];
                        for (Claim claim in state.claims) {
                          String policeStation = claim.policeStation;
                          if (!_policeStationOptions.contains(policeStation)) {
                            _policeStationOptions.add(claim.policeStation);
                          }
                        }
                      }
                    }
                    return ListFilterElement(
                        buttonLabel: "PS",
                        options: _policeStationOptions,
                        onChanged: (value) {
                          _policeStationFilter = value;
                          _currentCubit?.getClaims(
                            context,
                            claimType: _currentClaimType,
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
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.wandSparkles,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "IL-IBNR 1.3",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, '/new_landing_b',
                    arguments: [widget.email, widget.phone]);
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
                "VERSION 1.4 EARLY ACCESS",
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
                    ..getClaims(context, claimType: ClaimType.overall),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noOverallClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _currentClaimType != ClaimType.overall && _searchController.text.isNotEmpty
                            ? "-"
                            : _noOverallClaims.toString(),
                        label: "Overall",
                        isActive: _currentClaimType == ClaimType.overall,
                        onPressed: () {
                          _searchController.clear();
                          _currentCubit = _overallClaims;
                          _currentClaimType = ClaimType.overall;
                          setState(() {
                            view = ClaimsViewNew(
                              cubit: _overallClaims,
                              claimType: _currentClaimType,
                            );
                          });
                          _currentCubit!.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        },
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _allClaims
                    ..getClaims(context, claimType: ClaimType.allocated),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noAllClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _currentClaimType != ClaimType.allocated && _searchController.text.isNotEmpty
                            ? "-"
                            : _noAllClaims.toString(),
                        label: "Allocated",
                        isActive: _currentClaimType == ClaimType.allocated,
                        onPressed: () {
                          _searchController.clear();
                          _currentCubit = _allClaims;
                          _currentClaimType = ClaimType.allocated;
                          setState(() {
                            view = ClaimsViewNew(
                              cubit: _allClaims,
                              claimType: _currentClaimType,
                            );
                          });
                          _currentCubit!.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        },
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _acceptedClaims
                    ..getClaims(context, claimType: ClaimType.accepted),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noAcceptedClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _currentClaimType != ClaimType.accepted && _searchController.text.isNotEmpty
                            ? "-"
                            : _noAcceptedClaims.toString(),
                        label: "Accepted",
                        isActive: _currentClaimType == ClaimType.accepted,
                        onPressed: () {
                          _searchController.clear();
                          _currentCubit = _acceptedClaims;
                          _currentClaimType = ClaimType.accepted;
                          setState(() {
                            view = ClaimsViewNew(
                              cubit: _acceptedClaims,
                              claimType: _currentClaimType,
                            );
                          });
                          _currentCubit!.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        },
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _rejectedClaims
                    ..getClaims(context, claimType: ClaimType.rejected),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noRejectedClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _currentClaimType != ClaimType.rejected && _searchController.text.isNotEmpty
                            ? "-"
                            : _noRejectedClaims.toString(),
                        label: "Rejected",
                        isActive: _currentClaimType == ClaimType.rejected,
                        onPressed: () {
                          _searchController.clear();
                          _currentCubit = _rejectedClaims;
                          _currentClaimType = ClaimType.rejected;
                          setState(() {
                            view = ClaimsViewNew(
                              cubit: _rejectedClaims,
                              claimType: _currentClaimType,
                            );
                          });
                          _currentCubit!.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        },
                      );
                    },
                  ),
                ),
                BlocProvider<GetClaimsCubit>(
                  create: (context) => _concludedClaims
                    ..getClaims(context, claimType: ClaimType.concluded),
                  child: BlocBuilder<GetClaimsCubit, GetClaimsState>(
                    builder: (context, state) {
                      if (state is GetClaimsSuccess) {
                        _noConcludedClaims = state.claims.length;
                      }
                      return CaseHeader(
                        noCases: _currentClaimType != ClaimType.concluded && _searchController.text.isNotEmpty
                            ? "-"
                            : _noConcludedClaims.toString(),
                        label: "Concluded",
                        isActive: _currentClaimType == ClaimType.concluded,
                        onPressed: () {
                          _searchController.clear();
                          _currentCubit = _concludedClaims;
                          _currentClaimType = ClaimType.concluded;
                          setState(() {
                            view = ClaimsViewNew(
                              cubit: _concludedClaims,
                              claimType: _currentClaimType,
                            );
                          });
                          _currentCubit!.getClaims(
                            context,
                            claimType: _currentClaimType,
                            state: _stateFilter,
                            district: _districtFilter,
                            policeStation: _policeStationFilter,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: view),
        ],
      ),
    );
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
