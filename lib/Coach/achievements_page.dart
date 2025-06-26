import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class AchievementsPage extends StatefulWidget {
  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Workout Warrior',
      'description': 'You have successfully completed 10 workouts this month.',
      'image': 'assets/images/workout.png',
      'progress': 1.0,
      'level': 'Silver',
      'unlocked': true,
      'points': 150,
      'category': 'Fitness',
      'color': Color(0xFFFF6B35),
    },
    {
      'title': 'Weight Loss Champion',
      'description': 'Congratulations on your weight loss journey!',
      'image': 'assets/images/weight_loss.png',
      'progress': 1.0,
      'level': 'Gold',
      'unlocked': true,
      'points': 300,
      'category': 'Health',
      'color': Color(0xFFFFD700),
    },
    {
      'title': 'Challenge Accepted',
      'description': 'You have joined the 30-day fitness challenge.',
      'image': 'assets/images/challenge.png',
      'progress': 0.8,
      'level': 'Bronze',
      'unlocked': true,
      'points': 100,
      'category': 'Challenge',
      'color': Color(0xFF4ECDC4),
    },
    {
      'title': 'Personal Best',
      'description': 'You set a new personal best in your last workout.',
      'image': 'assets/images/personal_best.png',
      'progress': 0.4,
      'level': 'Silver',
      'unlocked': false,
      'points': 200,
      'category': 'Performance',
      'color': Color(0xFF96CEB4),
    },
    {
      'title': 'Consistency King',
      'description': 'You attended for 4 consecutive weeks.',
      'image': 'assets/images/attendance.png',
      'progress': 0.6,
      'level': 'Bronze',
      'unlocked': false,
      'points': 120,
      'category': 'Consistency',
      'color': Color(0xFF45B7D1),
    },
    {
      'title': 'Strength Master',
      'description': 'Achieved maximum strength in all major lifts.',
      'image': 'assets/images/strength.png',
      'progress': 0.3,
      'level': 'Gold',
      'unlocked': false,
      'points': 500,
      'category': 'Strength',
      'color': Color(0xFFE74C3C),
    },
  ];

  final List<String> _filters = ['All', 'Unlocked', 'Locked', 'Gold', 'Silver', 'Bronze'];

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAchievements {
    if (_selectedFilter == 'Unlocked') {
      return _achievements.where((a) => a['unlocked']).toList();
    } else if (_selectedFilter == 'Locked') {
      return _achievements.where((a) => !a['unlocked']).toList();
    } else if (_selectedFilter == 'Gold' || _selectedFilter == 'Silver' || _selectedFilter == 'Bronze') {
      return _achievements.where((a) => a['level'] == _selectedFilter).toList();
    }
    return _achievements;
  }

  int get _totalPoints {
    return _achievements
        .where((a) => a['unlocked'])
        .fold(0, (sum, a) => sum + (a['points'] as int));
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    if (achievement['unlocked']) {
      _confettiController.play();
    }
    
    showDialog(
      context: context,
      builder: (_) => Stack(
        alignment: Alignment.center,
        children: [
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          achievement['color'].withOpacity(0.8),
                          achievement['color'].withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      achievement['unlocked'] ? Icons.emoji_events : Icons.lock,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    achievement['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: achievement['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${achievement['level']} • ${achievement['points']} pts',
                      style: GoogleFonts.poppins(
                        color: achievement['color'],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    achievement['description'],
                    style: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!achievement['unlocked']) ...[
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            'Progress',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: achievement['progress'],
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(achievement['color']),
                            minHeight: 6,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(achievement['progress'] * 100).toInt()}% Complete',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: achievement['color'],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (achievement['unlocked'])
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [achievement['color'], Colors.white, Colors.amber],
              numberOfParticles: 30,
              emissionFrequency: 0.05,
              gravity: 0.1,
              blastDirection: -pi / 2,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        title: Text(
          'Achievements',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF0F0F0F),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header with stats
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B35).withOpacity(0.8), Color(0xFFFF8E53).withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Achievements',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$_totalPoints total points earned',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${_achievements.where((a) => a['unlocked']).length}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Unlocked',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Filter chips
              Container(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return Container(
                      margin: EdgeInsets.only(right: 12),
                      child: FilterChip(
                        label: Text(
                          filter,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.grey[400],
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: Color(0xFFFF6B35).withOpacity(0.2),
                        backgroundColor: Color(0xFF1A1A1A),
                        side: BorderSide(
                          color: isSelected ? Color(0xFFFF6B35) : Colors.transparent,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Achievements grid
              Expanded(
                child: GridView.builder(
                  itemCount: _filteredAchievements.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final achievement = _filteredAchievements[index];
                    return GestureDetector(
                      onTap: () => _showAchievementDetails(achievement),
                      child: Hero(
                        tag: achievement['title'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(20),
                            border: achievement['unlocked']
                                ? Border.all(color: achievement['color'], width: 1)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with icon and level
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: achievement['unlocked']
                                        ? [
                                            achievement['color'].withOpacity(0.8),
                                            achievement['color'].withOpacity(0.6),
                                          ]
                                        : [
                                            Colors.grey[800]!,
                                            Colors.grey[900]!,
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        achievement['unlocked'] ? Icons.emoji_events : Icons.lock,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          achievement['level'],
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        achievement['title'],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        achievement['category'],
                                        style: GoogleFonts.poppins(
                                          color: achievement['color'],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      if (!achievement['unlocked']) ...[
                                        LinearProgressIndicator(
                                          value: achievement['progress'],
                                          backgroundColor: Colors.grey[800],
                                          valueColor: AlwaysStoppedAnimation<Color>(achievement['color']),
                                          minHeight: 4,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${(achievement['progress'] * 100).toInt()}%',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ] else ...[
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: achievement['color'],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${achievement['points']} pts',
                                              style: GoogleFonts.poppins(
                                                color: achievement['color'],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}