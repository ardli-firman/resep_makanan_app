import 'package:flutter/material.dart';

class ItemResepWidget extends StatefulWidget {
  const ItemResepWidget({super.key, required this.onTap});

  final Function() onTap;

  @override
  State<ItemResepWidget> createState() => ItemResepWidgetState();
}

class ItemResepWidgetState extends State<ItemResepWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/resep.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Title",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                      ),
                      Text("100",
                          style: Theme.of(context).textTheme.labelSmall),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.comment),
                      ),
                      Text("100",
                          style: Theme.of(context).textTheme.labelSmall),
                    ])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
