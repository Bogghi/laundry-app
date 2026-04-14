import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/wash_order_icon.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_details_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LaundryCard(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(215, 227, 248, 100),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WashOrderIcon(),
                  )
              ),
              Column(
                children: [
                  Text(
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(65, 71, 80, 100)
                    ),
                    "Order title",
                  ),
                  Text(
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(65, 71, 80, 100)
                      ),
                      "Order #1234"
                  )
                ],
              )
            ],
          ),
          Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(215, 227, 248, 100),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Text(
                  style: TextStyle(
                    color: Color.fromRGBO(89, 101, 118, 100),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  'STATUS',
                ),
              )
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderDetailsTitle(title: "ITEMS"),
                    Text("12 camice")
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderDetailsTitle(title: "EXPECTED"),
                    Text("15/04/2026")
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
