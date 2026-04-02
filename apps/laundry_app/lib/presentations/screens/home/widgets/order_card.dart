import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/wash_order_icon.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Card(
        color: Colors.white,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
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
                  Text(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    "Order title",
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
