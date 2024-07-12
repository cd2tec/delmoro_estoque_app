import 'package:delmoro_estoque_app/widgets/stock/pulse_widget.dart';
import 'package:flutter/material.dart';

class PricesPromoItemInfoWidget extends StatelessWidget {
  final String description;
  final dynamic value;

  const PricesPromoItemInfoWidget(
      {Key? key, required this.description, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PulseAnimationWidget(
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: 400.0,
        height: 140.0,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
            )
          ],
          image: const DecorationImage(
            image: AssetImage('images/star.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              description,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
