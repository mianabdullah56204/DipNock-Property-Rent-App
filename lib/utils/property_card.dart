import 'package:flutter/material.dart';

class PropertyAdCard extends StatelessWidget {
  const PropertyAdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;

        Widget textAndButton = Column(
          crossAxisAlignment:
              isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              "Looking for Tenants / Buyers?",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SourceSans3'),
              textAlign: isNarrow ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.electric_bolt, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  "Faster & Verified Tenants/Buyers",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'SourceSans3'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.exposure_zero, color: Colors.white, size: 20),
                Text(
                  "Pay ZERO brokerage",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'SourceSans3'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: isNarrow ? 0.8 : 0.8,
              child: ElevatedButton(
                onPressed: () {
                  "Post FREE property Ad button tapped";
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "Post FREE property Ad",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'SourceSans3'),
                  ),
                ),
              ),
            ),
          ],
        );

        Widget image = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/find_home.png',
            height: isNarrow ? 135 : 135,
            width: isNarrow ? double.infinity : 100,
            fit: BoxFit.contain,
          ),
        );

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.brown[500],
            borderRadius: BorderRadius.circular(12),
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textAndButton,
                    const SizedBox(height: 16),
                    image,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: textAndButton),
                    const SizedBox(width: 16),
                    Expanded(flex: 4, child: image),
                  ],
                ),
        );
      },
    );
  }
}
