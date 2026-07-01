import 'package:flutter/material.dart';

class BusinessInfoPage extends StatefulWidget {
  const BusinessInfoPage({super.key});

  @override
  State<BusinessInfoPage> createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  final TextEditingController businessController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  int selectedDisplay = 0;

  final Color gold = const Color(0xffF6C443);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Title
              const Text(
                "Business Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Help customers identify your business.",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              /// Progress
              Row(
                children: List.generate(
                  5,
                      (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      height: 5,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? gold
                            : Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Step 1 of 5",
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 35),

              /// Logo
              Center(
                child: Column(
                  children: [

                    Stack(
                      children: [

                        Container(
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(
                            color: const Color(0xff181818),
                            border: Border.all(
                              color: gold,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 42,
                            color: gold,
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: gold,
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Upload Business Logo",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "PNG • JPG • SVG",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// Business Name
              const Text(
                "Business Name *",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: businessController,
                style: const TextStyle(color: Colors.white),
                decoration: inputDecoration(
                  "Mokawil Construction",
                  Icons.business,
                ),
              ),

              const SizedBox(height: 28),

              /// Branch
              const Text(
                "Branch (Optional)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: branchController,
                style: const TextStyle(color: Colors.white),
                decoration: inputDecoration(
                  "Riyadh Branch",
                  Icons.location_on_outlined,
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "Display Name",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff181818),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [

                    Expanded(
                      child: buildSegment(
                        "Business Name",
                        0,
                      ),
                    ),

                    Expanded(
                      child: buildSegment(
                        "Branch Name",
                        1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              /// Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff181818),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 30,
                      backgroundColor: gold,
                      child: const Icon(
                        Icons.store,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      selectedDisplay == 0
                          ? (businessController.text.isEmpty
                          ? "Business Name"
                          : businessController.text)
                          : (branchController.text.isEmpty
                          ? "Branch Name"
                          : branchController.text),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: gold.withOpacity(.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Verified Business",
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade700),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSegment(String text, int index) {
    bool selected = selectedDisplay == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDisplay = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? gold : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xff181818),
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade600,
      ),
      prefixIcon: Icon(
        icon,
        color: gold,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: gold,
          width: 2,
        ),
      ),
    );
  }
}