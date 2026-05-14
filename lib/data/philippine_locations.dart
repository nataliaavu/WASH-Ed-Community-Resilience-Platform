// municity → province lookup for flood-prone areas of the Philippines.
// Used by SetupLocationPage to populate the city/district dropdown and
// auto-derive the province when a location is selected.
const Map<String, String> philippineLocations = {
  // Metro Manila
  'Marikina City': 'Metro Manila',
  'Quezon City': 'Metro Manila',
  'Pasig City': 'Metro Manila',
  'Malabon': 'Metro Manila',
  'Navotas': 'Metro Manila',
  'Valenzuela City': 'Metro Manila',
  'Caloocan City': 'Metro Manila',
  'Manila': 'Metro Manila',
  'Parañaque City': 'Metro Manila',
  'Las Piñas City': 'Metro Manila',
  'Muntinlupa City': 'Metro Manila',
  'Taguig City': 'Metro Manila',
  'Mandaluyong City': 'Metro Manila',
  'San Juan City': 'Metro Manila',
  'Makati City': 'Metro Manila',
  'Pateros': 'Metro Manila',
  // Rizal
  'Cainta': 'Rizal',
  'Taytay': 'Rizal',
  'Antipolo City': 'Rizal',
  'San Mateo': 'Rizal',
  'Rodriguez (Montalban)': 'Rizal',
  // Pampanga
  'San Fernando City': 'Pampanga',
  'Angeles City': 'Pampanga',
  'Lubao': 'Pampanga',
  'Guagua': 'Pampanga',
  'Macabebe': 'Pampanga',
  'Minalin': 'Pampanga',
  'Candaba': 'Pampanga',
  'Arayat': 'Pampanga',
  // Bulacan
  'Malolos City': 'Bulacan',
  'Meycauayan City': 'Bulacan',
  'San Jose del Monte City': 'Bulacan',
  'Obando': 'Bulacan',
  'Paombong': 'Bulacan',
  'Calumpit': 'Bulacan',
  'Hagonoy': 'Bulacan',
  // Laguna
  'Santa Cruz': 'Laguna',
  'Calamba City': 'Laguna',
  'Los Baños': 'Laguna',
  'Bay': 'Laguna',
  'Calauan': 'Laguna',
  // Leyte
  'Tacloban City': 'Leyte',
  'Ormoc City': 'Leyte',
  'Palo': 'Leyte',
  'Tanauan': 'Leyte',
  'Dulag': 'Leyte',
  // Cagayan
  'Tuguegarao City': 'Cagayan',
  'Aparri': 'Cagayan',
  'Gonzaga': 'Cagayan',
  // Isabela
  'Ilagan City': 'Isabela',
  'Cauayan City': 'Isabela',
  'Santiago City': 'Isabela',
  // Iloilo
  'Iloilo City': 'Iloilo',
  'Pavia': 'Iloilo',
  // Cebu
  'Cebu City': 'Cebu',
  'Mandaue City': 'Cebu',
  'Lapu-Lapu City': 'Cebu',
  // Davao
  'Davao City': 'Davao del Sur',
  'Digos City': 'Davao del Sur',
  // Zamboanga
  'Zamboanga City': 'Zamboanga del Sur',
  // Cotabato
  'Kidapawan City': 'North Cotabato',
};
