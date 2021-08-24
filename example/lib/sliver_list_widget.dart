// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: public_member_api_docs


import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads_example/banner_ad.dart';
import 'constants.dart';
/// This example demonstrates inline ads in a list view, where the ad objects
/// live for the lifetime of this widget.
class SliverListWidget extends StatefulWidget {
  @override
  _SliverListWidgetState createState() => _SliverListWidgetState();
}

class _SliverListWidgetState extends State<SliverListWidget> {
  // A SliverList inside a CustomScrollView
  // Refreshable banner ad is pinned to the top
  // Every even indexed widget is a banner ad
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(80.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black,
                        child:
                            Center(child: RefreshableBannerAd(size: AdSize.banner)),
                      ),
                    ),
                  )),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (c, i) {
                    if (i.isEven) {
                      return BannerAdWidget(size: AdSize.mediumRectangle);
                    }

                    return Text(
                      Constants.placeholderText,
                      style: TextStyle(fontSize: 24),
                    );
                  },
                  childCount: 30,
                  addAutomaticKeepAlives: true,
                ),
              )
            ],
          ),
        ),
      );
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
