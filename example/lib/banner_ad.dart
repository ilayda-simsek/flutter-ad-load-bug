import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pausable_timer/pausable_timer.dart';
import 'package:rxdart/subjects.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RefreshableBannerAd extends StatefulWidget {
  final AdSize size;
  const RefreshableBannerAd({Key? key, required this.size}) : super(key: key);

  @override
  _RefreshableBannerAdState createState() => _RefreshableBannerAdState();
}

class _RefreshableBannerAdState extends State<RefreshableBannerAd> {
  final BehaviorSubject<AdManagerBannerAd> bannerStream =
      BehaviorSubject<AdManagerBannerAd>();
  AdManagerBannerAd? _adManagerBannerAd;

  int refreshSeconds = 20;
  Timer? _refreshTimer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bannerStream,
      builder:
          (BuildContext context, AsyncSnapshot<AdManagerBannerAd> snapshot) {
        if (snapshot.hasData) {
          return Container(
              width: widget.size.width.toDouble(),
              height: widget.size.height.toDouble(),
              child: AdWidget(ad: _adManagerBannerAd!));
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerWithRefresh();
  }

  void _loadBannerWithRefresh() async {
    if (_refreshTimer != null) return;

    _refreshTimer =
        Timer.periodic(Duration(seconds: refreshSeconds), (Timer t) async {
      _unloadBanner();
      _loadBanner();
    });

    _loadBanner();
  }

  void _loadBanner() {
    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: '/6499/example/banner',
      request: AdManagerAdRequest(),
      sizes: <AdSize>[widget.size],
      listener: AdManagerBannerAdListener(
          onAdLoaded: (Ad ad) => bannerStream.add(ad as AdManagerBannerAd),
          onAdFailedToLoad: (Ad ad, _) => ad.dispose()),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _unloadBanner();
    _disposeTimer();
    bannerStream.close();
  }

  void _disposeTimer() {
    if (_refreshTimer != null && _refreshTimer!.isActive) {
      _refreshTimer!.cancel();
      _refreshTimer = null;
    }
  }

  void _unloadBanner() {
    _adManagerBannerAd?.dispose();
    _adManagerBannerAd = null;
    bannerStream.addError(Exception("Banner disposed"));
  }
}

class BannerAdWidget extends StatefulWidget {
  final AdSize size;
  const BannerAdWidget({Key? key, required this.size}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with AutomaticKeepAliveClientMixin<BannerAdWidget> {
  AdManagerBannerAd? _adManagerBannerAd;
  bool _adLoaded = false;

  Widget _bannerPlaceholder() {
    return Container(
      width: widget.size.width.toDouble(),
      height: widget.size.height.toDouble(),
    );
  }

  Widget _bannerAd() {
    return Container(
        width: widget.size.width.toDouble(),
        height: widget.size.height.toDouble(),
        child: AdWidget(ad: _adManagerBannerAd!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _adLoaded ? _bannerAd() : _bannerPlaceholder();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBanner();
  }

  void _loadBanner() {
    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: '/6499/example/banner',
      request: AdManagerAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[widget.size],
      listener: AdManagerBannerAdListener(
          onAdLoaded: (_) => setState(() => _adLoaded = true),
          onAdFailedToLoad: (Ad ad, _) => ad.dispose()),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _adManagerBannerAd?.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
