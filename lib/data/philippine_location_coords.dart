// Approximate lat/lng for every city in philippineLocations.
// Used to pass user-specific coordinates to the flood API so that
// a Davao user sees Davao flood data, not Metro Manila data.
const Map<String, (double, double)> philippineLocationCoords = {
  // Metro Manila
  'Marikina City':      (14.6507, 121.1029),
  'Quezon City':        (14.6760, 121.0437),
  'Pasig City':         (14.5764, 121.0851),
  'Malabon':            (14.6629, 120.9578),
  'Navotas':            (14.6597, 120.9422),
  'Valenzuela City':    (14.7011, 120.9831),
  'Caloocan City':      (14.6493, 120.9733),
  'Manila':             (14.5995, 120.9842),
  'Parañaque City':     (14.4793, 121.0198),
  'Las Piñas City':     (14.4491, 121.0007),
  'Muntinlupa City':    (14.4081, 121.0434),
  'Taguig City':        (14.5243, 121.0792),
  'Mandaluyong City':   (14.5794, 121.0359),
  'San Juan City':      (14.6008, 121.0371),
  'Makati City':        (14.5547, 121.0244),
  'Pateros':            (14.5511, 121.0732),
  // Rizal
  'Cainta':                   (14.5786, 121.1197),
  'Taytay':                   (14.5555, 121.1326),
  'Antipolo City':            (14.6260, 121.1763),
  'San Mateo':                (14.6990, 121.1230),
  'Rodriguez (Montalban)':    (14.7426, 121.1333),
  // Pampanga
  'San Fernando City':  (15.0289, 120.6899),
  'Angeles City':       (15.1450, 120.5887),
  'Lubao':              (14.9295, 120.6021),
  'Guagua':             (14.9683, 120.6278),
  'Macabebe':           (14.9053, 120.7046),
  'Minalin':            (15.0007, 120.7191),
  'Candaba':            (15.0931, 120.8227),
  'Arayat':             (15.1550, 120.7700),
  // Bulacan
  'Malolos City':             (14.8527, 120.8107),
  'Meycauayan City':          (14.7348, 120.9572),
  'San Jose del Monte City':  (14.8141, 121.0454),
  'Obando':                   (14.7071, 120.9246),
  'Paombong':                 (14.8295, 120.7896),
  'Calumpit':                 (14.9168, 120.7577),
  'Hagonoy':                  (14.8384, 120.7367),
  // Laguna
  'Santa Cruz':   (14.2793, 121.4181),
  'Calamba City': (14.2116, 121.1650),
  'Los Baños':    (14.1678, 121.2395),
  'Bay':          (14.1839, 121.2768),
  'Calauan':      (14.1562, 121.3250),
  // Leyte
  'Tacloban City': (11.2439, 124.9987),
  'Ormoc City':    (11.0067, 124.6076),
  'Palo':          (11.1475, 124.9856),
  'Tanauan':       (11.1126, 125.0173),
  'Dulag':         (10.9552, 125.0324),
  // Cagayan
  'Tuguegarao City': (17.6131, 121.7269),
  'Aparri':          (18.3554, 121.6392),
  'Gonzaga':         (18.2698, 121.9862),
  // Isabela
  'Ilagan City':   (17.1478, 121.8897),
  'Cauayan City':  (16.9289, 121.7724),
  'Santiago City': (16.6889, 121.5512),
  // Iloilo
  'Iloilo City': (10.6969, 122.5644),
  'Pavia':       (10.7891, 122.5573),
  // Cebu
  'Cebu City':       (10.3157, 123.8854),
  'Mandaue City':    (10.3394, 123.9078),
  'Lapu-Lapu City':  (10.3103, 123.9494),
  // Davao
  'Davao City':  (7.0731, 125.6128),
  'Digos City':  (6.7496, 125.3572),
  // Zamboanga
  'Zamboanga City': (6.9214, 122.0790),
  // Cotabato
  'Kidapawan City': (7.0083, 125.0893),
};
