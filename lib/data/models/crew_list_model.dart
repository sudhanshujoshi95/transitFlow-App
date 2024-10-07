class CrewMember {
  final String crewId;
  final String name;
  final String role;
  final String status;

  CrewMember({
    required this.crewId,
    required this.name,
    required this.role,
    required this.status,
  });

  factory CrewMember.fromMap(Map<String, dynamic> data) {
    return CrewMember(
      crewId: data['crewId'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'crewId': crewId,
      'name': name,
      'role': role,
      'status': status,
    };
  }
}
