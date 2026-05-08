  import 'package:flutter/material.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    int selectedIndex = 0;
    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hello Miguel!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)), // Spacing between text and logo
              Image(image: AssetImage('assets/wash-ed/WASHEd_logo_2022_og_no-shadow.png'), height: 50),
            ]
          ),
          bottom: PreferredSize( //Thin yellow line below the AppBar
            preferredSize: const Size.fromHeight(2),
            child: Container(
              color: Colors.yellow,
              height: 2,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth * 0.4, 
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.yellow, width: 2),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        
                        children: [
                          
                          const Text(
                            "Location", 
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.blue,
                                size: 30,
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Bulacan", 
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ], 
                      ),
                      
                    ),

                    Container(
                      width: screenWidth * 0.35, 
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.yellow, width: 2),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sunny,
                            color: Colors.orange,
                            size: 40,
                          ),
                          SizedBox(width: 15), 
                          const Text(
                            "30°",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ),

              
                const SizedBox(height: 20),
                kikoBox('Flood Warning', screenWidth * 1, 190, AssetImage('assets/kiko/WashEd_kiko_sprite_thumbs-up.png')),
                const SizedBox(height: 20),
                weatherBox('Weather by Hour', screenWidth * 1, 180),
                const SizedBox(height: 20),
                riskBox('Flood Risk', screenWidth * 1, 140),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buttonBox('Learning Module', screenWidth * 0.27, 100, Icons.cast_for_education),
                    const SizedBox(width: 10),
                    buttonBox('Flood Prep', screenWidth * 0.27, 100, Icons.checklist_sharp),
                    const SizedBox(width: 10),
                    buttonBox('Play Games', screenWidth * 0.27, 100, Icons.gamepad_outlined),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Our Sponsors"
                  ),
                ),
                
              ],
            ),
          ),
        )
      );
    }

    Widget kikoBox(String text, double screenWidth, double height, AssetImage? imageAsset) {
      return Container(
        width: screenWidth,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration : BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 195, 235, 154), 
          border: Border.all(color: Colors.grey, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6, 
              offset: Offset(0,3), 
            )
          ],
        ),
        
        child : Row(
          children: [
            Expanded( 
              flex: 3,
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20, 
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "All Clear",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  Text(
                    "Everything is looking safe right now!",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight : FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "Kiko checked and water levels are just right. Time to learn and play!",
                    style : TextStyle(fontSize: 12),
                  ),
                ]
              ),
            ),
            
            Align(
            alignment: Alignment.centerRight,
              child: SizedBox(
                child: Image(
                  image: imageAsset!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ], 
        ),
      );
    }

    Widget weatherBox(String text, double width, double height){
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(10), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          color: Colors.white,
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weather by Hour",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bubble("30°"),
                bubble("29°"),
                bubble("29°"), 
                bubble("25°"), 
                bubble("30°"),
              ],
            ),
          ],
        ),
      );
    }

    Widget bubble(String temp){
      return Container(
        width: 50,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: Text(
          temp,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    Widget riskBox(String text, double width, double height){
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          color: Colors.white,
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Risk",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ), 
                const Text(
                  "Low",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Stack(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 239, 239),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey),
                  ),
                ),

                Positioned(
                  left: 0,
                  child: Container(
                    width: 70, 
                    height: 30, 
                    decoration: BoxDecoration(
                      color: Colors.lightGreen, 
                      borderRadius: BorderRadius.circular(40),
                    ),
                  )
                ),
              ],
            ),
            const SizedBox(height: 10), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Safe",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ), 
                const Text(
                  "Warning",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    
    Widget buttonBox(String text, double width, double height, IconData icon) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          color: Colors.white,
          border: Border.all(color: Colors.yellow, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.7), 
              blurRadius: 6,
              offset: Offset(-1, 3),
            )
          ]
        ),
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 5),
            Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        )
      );
    }
  }