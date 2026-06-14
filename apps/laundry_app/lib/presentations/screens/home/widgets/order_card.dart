import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/icons/wash_order_icon.dart';
import 'package:shared_assets/models/order_model.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_details_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';

class OrderCard extends ConsumerWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String clientString = order.client != null ? "- ${order.client!.name}" : '';

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
              Expanded(
                child: Text(
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(65, 71, 80, 100)
                  ),
                  overflow: TextOverflow.ellipsis,
                  "#${order.orderNumber} $clientString",
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderDetailsTitle(title: "CAPI"),
                    Text("${order.orderItems.fold(0, (sum, i) => sum + (i.quantity ?? 0))} capi")
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
                    Text(order.deliveryDate != null
                        ? "${order.deliveryDate!.day.toString().padLeft(2, '0')}/${order.deliveryDate!.month.toString().padLeft(2, '0')}/${order.deliveryDate!.year}"
                        : "-")
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
