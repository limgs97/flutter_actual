import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
        'http://$ip/restaurant',
        options: Options(
            headers: {
              'authorization': 'Bearer $accessToken',
            }
        )
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List>(
                future: paginateRestaurant(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      final pItem = RestaurantModel.fromJson(json: item);
                      //parsed
                      // final pItem = RestaurantModel(
                      //   id: item['id'],
                      //   name: item['name'],
                      //   thumbUrl: 'http://${ip}${item['thumbUrl']}',
                      //   tags: List.from(item['tags']),
                      //   priceRange: RestaurantPriceRange.values.firstWhere(
                      //     (e) => e.name == item['priceRange'],
                      //   ),
                      //   ratings: item['ratings'],
                      //   ratingsCount: item['ratingsCount'],
                      //   deliveryTime: item['deliveryTime'],
                      //   deliveryFee: item['deliveryFee']
                      // );

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => RestaurantDetailScreen()),
                          );
                        },
                        child: RestaurantCard.fromModel(
                          model: pItem
                        )
                      );
                      // return RestaurantCard(
                      //   image: Image.network(
                      //     // 'http://${ip}${item['thumbUrl']}',
                      //     pItem.thumbUrl,
                      //     fit: BoxFit.cover,
                      //   ),
                      //   name: pItem.name,
                      //   tags: pItem.tags,
                      //   ratingsCount: pItem.ratingsCount,
                      //   deliveryTime: pItem.deliveryTime,
                      //   deliveryFee: pItem.deliveryFee,
                      //   ratings: pItem.ratings,
                      // );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16.0,);
                    },
                  );
                },

              )
          )
      ),
    );
  }
}
