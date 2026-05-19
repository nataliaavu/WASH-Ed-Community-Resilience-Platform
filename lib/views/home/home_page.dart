    import 'package:flutter/material.dart';

    class HomePage extends StatefulWidget {
      final Function(int) onTabSelected;

      const HomePage({
        super.key,
        required this.onTabSelected,
      });

      State<HomePage> createState() => _HomePageState();
    }

    class _HomePageState extends State<HomePage> {
      String riskLevel = "low";

      String selectedCity = "Bulacan";

      final List<String> cities = [
        "Bulacan",
        "Quezon City",
        "Davao City", 
        "Manila",
        "Caloocan City", 
        "Taguig City",
      ];

      @override
      Widget build(BuildContext context) {
        final screen = MediaQuery.of(context).size;
        final screenWidth = screen.width;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Hello Miguel!',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    'assets/wash-ed/WASHEd_logo_2022_og_no-shadow.png',
                    height: screen.height * 0.06,
                    fit: BoxFit.contain,
                  )
                )
              ]
            ),
            bottom: PreferredSize( //Thin yellow line below the AppBar
              preferredSize: const Size.fromHeight(2),
              child: Container(
                color: Colors.yellow,
                height: 3,
              ),
            ),
          ),

          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(137, 234, 216, 255), 
                  Color.fromARGB(170, 245, 247, 191),
                ],
              ),
            ),

            child : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.yellow, width: 2),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

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
                                    ),

                                    Expanded(
                                      child:DropdownButton<String>(
                                        value: selectedCity,
                                        isDense: true,
                                        underline: SizedBox(),
                                        icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),

                                        items: cities.map((city) {
                                          return DropdownMenuItem(
                                            value: city,
                                            child: Text(city),
                                          );
                                        }).toList(),

                                        onChanged: (value) {
                                          setState(() {
                                            selectedCity = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ], 
                            ),
                            
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                                  size: 30,
                                ),
                                const SizedBox(width: 10), 
                                Text(
                                  "30°",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.bold
                                  ), 
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),

                  
                    const SizedBox(height: 20),
                    kikoBox(riskLevel),
                    const SizedBox(height: 20),
                    weatherBox('Weather by Hour', screenWidth, null),
                    const SizedBox(height: 20),
                    riskBox('Flood Risk', screenWidth, null),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              widget.onTabSelected(2);
                            },
                            child: buttonBox('Learning Module', screenWidth * 0.27, 100, Icons.cast_for_education),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: InkWell(
                            onTap: () {
                              widget.onTabSelected(3);
                            },
                            child: buttonBox('Flood Prep', screenWidth * 0.27, 100, Icons.checklist_sharp),
                          ),
                        ),

                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              //TODO: Replace with games page
                            },
                            child: buttonBox('Play Games', screenWidth * 0.27, 100, Icons.gamepad_outlined),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Center(child: Text("Our Sponsors")),
                    
                  ],
                ),
              ),
            ),
          ),
        );
      }

      Widget kikoBox(String riskLevel) {
        Color boxColor;
        String statusText;
        String messageText; 
        String kikoMessage;
        AssetImage image;

        if (riskLevel == "low") { 
          boxColor = Color.fromARGB(255, 195, 235, 154);
          statusText = "All Clear";
          messageText = "Everything is lookin safe right now!";
          kikoMessage = "Kiko checked and water levels are just right. Time to learn and play";
          image = AssetImage('assets/kiko/WashEd_kiko_sprite_thumbs-up.png');
        }
        else if (riskLevel == "medium") { 
          boxColor = Color.fromARGB(255, 249, 201, 110);
          statusText = "Be Alert";
          messageText = "Water levels are rising sligtly";
          kikoMessage = "Kiko noticed rising water levels. Stay cautious!";
          image = AssetImage('assets/kiko/WashEd_kiko_sprite_sad.png');
        }
        else { 
          boxColor = Color.fromARGB(255, 250, 119, 110);
          statusText = "Warning!";
          messageText = "Flood risk is high. Stay safe and follow instructions!";
          kikoMessage = "Kiko says to stay safe and follow instructions.";
          image = AssetImage('assets/kiko/WashEd_kiko_sprite_stress.png');
        }
        
        return Container(
          padding: const EdgeInsets.all(12),
          decoration : BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: boxColor,
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
                flex: 1,
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18, 
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          statusText,
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),

                    Text(
                      messageText,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 12),
                    Text(
                      kikoMessage,
                      style : Theme.of(context).textTheme.bodySmall
                    ),
                  ]
                ),
              ),
              
              Flexible(
                child: Image(image: image, fit: BoxFit.contain), 
              ),
            ], 
          ),
        );
      }

      Widget weatherBox(String text, double width, double? height){
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12), 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), 
            color: Colors.white,
            border: Border.all(color: Colors.yellow, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Weather by Hour",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                )
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var temp in ["30°", "29°", "29°", "25°", "30°"])
                    Expanded(child: bubble(temp)),
                ],
              ),
            ],
          ),
        );
      }

      Widget bubble(String temp){
        return AspectRatio(
          aspectRatio: 0.7,
          child:Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: Text(temp, style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      }

      Widget riskBox(String text, double width, double? height){
        
        return LayoutBuilder(
          builder: (context, constraints) {
            double barWidth = riskLevel == "low"
              ? constraints.maxWidth * 0.3
              : riskLevel == "medium"
                ? constraints.maxWidth * 0.6
                :constraints.maxWidth * 0.9;
            Color barColor = riskLevel == "low"
              ? Colors.green
              : riskLevel == "medium"
                ? Colors.orange
                : Colors.red;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
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
                      Text(
                        "Risk",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )
                      ), 
                      Text(
                        riskLevel.toUpperCase(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: riskLevel == "low"
                            ? Colors.green
                            : riskLevel == "medium"
                              ?Colors.orange
                              :Colors.red,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Stack(
                    children: [
                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 239, 239),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),

                      Positioned(
                        left: 0,
                        child: Container(
                          width: barWidth, 
                          height: 28, 
                          decoration: BoxDecoration(
                            color: barColor, 
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
          },
        );
      }
      
      Widget buttonBox(String text, double? width, double? height, IconData icon) {
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