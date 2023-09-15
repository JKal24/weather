import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: Column (children: [
        Container(
          height: 150,
          color: Colors.green,
          margin: const EdgeInsets.only(top: 15),
          // child: ListView.builder(
            // itemBuilder: (context, index) {
            //   return Container();
            // }
          // ),
        )
      ],
      )
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: const Text(
      "Weather",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: true,
    leading: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F8),
        borderRadius: BorderRadius.circular(10)
      ),
      child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg'),
    ),
    actions: [
      GestureDetector(
        onTap: () {  },
        child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        width: 40,
        decoration: BoxDecoration(
          color: const Color(0xffF7F8F8),
          borderRadius: BorderRadius.circular(10)
        ),
        child: SvgPicture.asset('assets/icons/dots.svg'),
        )
      )
    ],
  );
}

Container _searchBar() {
  return Container(
    margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: const Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0
        )
      ]
    ),
    child: TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        hintText: 'Search...',
        hintStyle: const TextStyle(
          color: Color(0xffDDDADA),
          fontSize: 14
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset('assets/icons/Search.svg')
        ),
        suffixIcon: Container(
          width: 100,
          child: IntrinsicHeight(child: 
            Row (
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const VerticalDivider(
                  color: Colors.black,
                  indent: 10,
                  endIndent: 10,
                  thickness: 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Filter.svg')
                )
              ]
            )
          )
        ) ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none
        )
      ),
    )
  );
}

Container _title() {
  return Container(
    margin: const EdgeInsets.only(top: 40),
    child: const Column (
      children: [
        Text(
          'Weather',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600
          )
        )
      ]
    )
  );
}