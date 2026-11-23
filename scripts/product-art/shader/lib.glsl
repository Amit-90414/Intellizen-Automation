const float ALU = 1.0, STEEL = 2.0, GREY = 3.0, DARK = 4.0, BLACK = 5.0, RUBBER = 6.0, YELLOW = 7.0, RED = 8.0;
const float CARD = 9.0, TAPE = 10.0, PAPER = 11.0, GLASS = 12.0, LGREEN = 13.0, LAMBER = 14.0, LRED = 15.0, LWHITE = 16.0;
const float ROBOT = 17.0, WOOD = 18.0, BLUE = 19.0, COPPER = 20.0, WHITE = 21.0, MESH = 22.0, CABLE = 23.0, ORANGE = 24.0;
const float LBLUE = 25.0, CHROME = 26.0, GREEN = 27.0, BLUEP = 28.0, LGREY = 29.0, RED_OFF = 30.0, AMBER_OFF = 31.0, GREEN_OFF = 32.0;
const float ZINC = 33.0, BRASS = 34.0, CAST = 35.0, NAVY = 36.0, MGREY = 37.0, BELT = 38.0, POLY = 39.0, MESHP = 40.0, CLEAR = 41.0, BENCHTOP = 42.0, PEGBOARD = 43.0;

Mat libMat(float id, vec3 p, vec3 n) {
  float g = vnoise(p * 0.08);
  if (id < 1.5) return mat(vec3(0.8, 0.81, 0.83), 0.34 + 0.08 * g, 1.0);
  if (id < 2.5) return mat(vec3(0.84, 0.83, 0.8), 0.2 + 0.06 * g, 1.0);
  if (id < 3.5) return mat(vec3(0.55, 0.56, 0.54), 0.4 + 0.06 * g, 0.0);
  if (id < 4.5) return mat(vec3(0.04, 0.045, 0.05), 0.42, 0.0);
  if (id < 5.5) return mat(vec3(0.018), 0.38 + 0.1 * g, 0.0);
  if (id < 6.5) return mat(vec3(0.028), 0.6, 0.0);
  if (id < 7.5) return mat(vec3(0.86, 0.52, 0.012), 0.36, 0.0);
  if (id < 8.5) return mat(vec3(0.52, 0.014, 0.012), 0.28, 0.0);
  if (id < 9.5) return mat(vec3(0.47, 0.3, 0.15) * (0.93 + 0.1 * fbm(p * 0.02) + 0.04 * vnoise(p * 0.9)), 0.78, 0.0);
  if (id < 10.5) return mat(vec3(0.42, 0.3, 0.16), 0.28, 0.0);
  if (id < 11.5) return mat(vec3(0.8, 0.8, 0.78), 0.5, 0.0);
  if (id < 12.5) return mat(vec3(0.008), 0.05, 0.0);
  if (id < 13.5) return glow(vec3(0.1, 0.5, 0.12), 0.12, vec3(0.25, 2.4, 0.4));
  if (id < 14.5) return glow(vec3(0.6, 0.3, 0.02), 0.12, vec3(2.6, 1.1, 0.05));
  if (id < 15.5) return glow(vec3(0.5, 0.02, 0.02), 0.12, vec3(2.8, 0.14, 0.08));
  if (id < 16.5) return glow(vec3(0.8), 0.12, vec3(2.6, 2.65, 2.7));
  if (id < 17.5) return mat(vec3(0.82, 0.44, 0.02), 0.3 + 0.05 * g, 0.0);
  if (id < 18.5) return mat(vec3(0.5, 0.36, 0.2) * (0.8 + 0.35 * fbm(p * vec3(0.02, 0.6, 0.6))), 0.75, 0.0);
  if (id < 19.5) return mat(vec3(0.025, 0.07, 0.19), 0.36, 0.0);
  if (id < 20.5) return mat(vec3(0.95, 0.62, 0.48), 0.28 + 0.1 * g, 1.0);
  if (id < 21.5) return mat(vec3(0.76, 0.77, 0.76), 0.34, 0.0);
  if (id < 22.5) return mat(vec3(0.03, 0.032, 0.035), 0.5, 0.0);
  if (id < 23.5) return mat(vec3(0.02), 0.48, 0.0);
  if (id < 24.5) return mat(vec3(0.8, 0.2, 0.012), 0.36, 0.0);
  if (id < 25.5) return glow(vec3(0.05, 0.2, 0.6), 0.12, vec3(0.2, 0.9, 2.8));
  if (id < 26.5) return mat(vec3(0.95, 0.95, 0.96), 0.08, 1.0);
  if (id < 27.5) return mat(vec3(0.015, 0.22, 0.05), 0.28, 0.0);
  if (id < 28.5) return mat(vec3(0.02, 0.07, 0.32), 0.3, 0.0);
  if (id < 29.5) return mat(vec3(0.6, 0.61, 0.6), 0.42, 0.0);
  if (id < 30.5) return mat(vec3(0.3, 0.012, 0.01), 0.1, 0.0);
  if (id < 31.5) return mat(vec3(0.45, 0.2, 0.012), 0.1, 0.0);
  if (id < 32.5) return mat(vec3(0.015, 0.2, 0.04), 0.1, 0.0);
  if (id < 33.5) return mat(vec3(0.72, 0.74, 0.76) * (0.9 + 0.15 * fbm(p * 0.03)), 0.42, 1.0);
  if (id < 34.5) return mat(vec3(0.9, 0.7, 0.36), 0.25, 1.0);
  if (id < 35.5) return mat(vec3(0.07, 0.12, 0.1) * (0.85 + 0.3 * fbm(p * 0.02)), 0.55, 0.0);
  if (id < 36.5) return mat(vec3(0.012, 0.03, 0.09), 0.38, 0.0);
  if (id < 37.5) return mat(vec3(0.2, 0.21, 0.22), 0.42, 0.0);
  if (id < 38.5) return mat(vec3(0.05, 0.055, 0.06), 0.55, 0.0);
  if (id < 39.5) return mat(vec3(0.75, 0.76, 0.74), 0.3, 0.0);
  if (id < 40.5) {
    vec2 uv = abs(n.z) > abs(n.x) ? p.xy : p.zy;
    vec2 g = abs(vec2(rep(uv.x, 50.0), rep(uv.y, 50.0)));
    if (min(g.x, g.y) < 1.9) return mat(vec3(0.03, 0.032, 0.035), 0.45, 0.0);
    return clearMat(vec3(1.0), 0.5, 1.0);
  }
  if (id < 41.5) return clearMat(vec3(0.9, 0.93, 0.95), 0.04, 0.86);
  if (id < 42.5) return mat(vec3(0.56, 0.4, 0.24) * (0.85 + 0.2 * fbm(p * vec3(0.004, 0.08, 0.08)) + 0.06 * vnoise(p * vec3(0.01, 0.6, 0.6))), 0.42, 0.0);
  if (id < 43.5) {
    vec2 uv = abs(n.z) > abs(n.x) ? p.xy : p.zy;
    float hole = length(vec2(rep(uv.x, 25.0), rep(uv.y, 25.0))) - 3.2;
    return mat(mix(vec3(0.015), vec3(0.42, 0.44, 0.45), smoothstep(-0.4, 0.4, hole)), 0.5, 0.0);
  }
  return mat(vec3(0.5), 0.5, 0.0);
}

float cover(float d) { return smoothstep(0.0015, -0.0015, d); }
float rect(vec2 uv, vec2 c, vec2 h) { return cover(box2(uv - c, h)); }
float rrect(vec2 uv, vec2 c, vec2 h, float r) { return cover(box2(uv - c, h - r) - r); }
float disc(vec2 uv, vec2 c, float r) { return cover(length(uv - c) - r); }
float ring(vec2 uv, vec2 c, float r, float w) { return cover(abs(length(uv - c) - r) - w); }

float textLines(vec2 uv, vec2 c, vec2 h, float rows, float seed) {
  vec2 q = (uv - c + h) / (2.0 * h);
  if (q.x < 0.0 || q.x > 1.0 || q.y < 0.0 || q.y > 1.0) return 0.0;
  float row = floor(q.y * rows);
  float fy = fract(q.y * rows);
  float len = 0.45 + 0.5 * h22(vec2(row, seed)).x;
  float word = step(0.18, fract(q.x * (4.0 + 3.0 * h22(vec2(seed, row)).y)));
  return step(0.3, fy) * step(fy, 0.7) * step(q.x, len) * mix(1.0, word, 0.6);
}

vec3 screenHmi(vec2 uv, float seed) {
  vec3 c = vec3(0.075, 0.09, 0.12);
  c = mix(c, vec3(0.04, 0.2, 0.42), rect(uv, vec2(0.5, 0.955), vec2(0.5, 0.045)));
  c = mix(c, vec3(0.85), textLines(uv, vec2(0.2, 0.955), vec2(0.15, 0.02), 1.0, seed));
  c = mix(c, vec3(0.2, 0.75, 0.3), disc(uv, vec2(0.95, 0.955), 0.016));
  for (int i = 0; i < 5; i++) {
    float y = 0.8 - float(i) * 0.15;
    vec3 b = i == 0 ? vec3(0.12, 0.42, 0.8) : vec3(0.14, 0.17, 0.22);
    c = mix(c, b, rrect(uv, vec2(0.1, y), vec2(0.075, 0.055), 0.01));
    c = mix(c, vec3(0.8), 0.8 * textLines(uv, vec2(0.1, y), vec2(0.05, 0.012), 1.0, seed + float(i)));
  }
  c = mix(c, vec3(0.11, 0.13, 0.17), rrect(uv, vec2(0.59, 0.5), vec2(0.385, 0.4), 0.012));
  c = mix(c, vec3(0.35, 0.37, 0.4), rect(uv, vec2(0.52, 0.42), vec2(0.27, 0.018)));
  for (int i = 0; i < 4; i++) c = mix(c, vec3(0.7, 0.5, 0.25), rect(uv, vec2(0.33 + float(i) * 0.12, 0.465), vec2(0.03, 0.026)));
  c = mix(c, vec3(0.3, 0.32, 0.36), rect(uv, vec2(0.3, 0.6), vec2(0.008, 0.16)));
  c = mix(c, vec3(0.3, 0.32, 0.36), rect(uv, vec2(0.45, 0.75), vec2(0.15, 0.008)));
  c = mix(c, vec3(0.9, 0.6, 0.1), rect(uv, vec2(0.6, 0.71), vec2(0.03, 0.04)));
  for (int i = 0; i < 3; i++) {
    vec2 tc = vec2(0.86, 0.75 - float(i) * 0.12);
    c = mix(c, vec3(0.15, 0.18, 0.23), rrect(uv, tc, vec2(0.075, 0.05), 0.008));
    c = mix(c, i == 2 ? vec3(0.95, 0.65, 0.1) : vec3(0.2, 0.78, 0.35), disc(uv, tc - vec2(0.045, 0.0), 0.014));
    c = mix(c, vec3(0.8), textLines(uv, tc + vec2(0.015, 0.0), vec2(0.04, 0.02), 2.0, seed + 9.0 + float(i)));
  }
  c = mix(c, vec3(0.16, 0.19, 0.24), rect(uv, vec2(0.59, 0.2), vec2(0.36, 0.012)));
  c = mix(c, vec3(0.2, 0.75, 0.32), rect(uv, vec2(0.23 + 0.25, 0.2), vec2(0.25, 0.012)));
  for (int i = 0; i < 4; i++) {
    c = mix(c, i == 0 ? vec3(0.15, 0.6, 0.28) : (i == 3 ? vec3(0.7, 0.12, 0.1) : vec3(0.18, 0.22, 0.28)), rrect(uv, vec2(0.32 + float(i) * 0.18, 0.07), vec2(0.075, 0.04), 0.01));
  }
  return c;
}

vec3 screenScada(vec2 uv, float seed) {
  vec3 c = vec3(0.13, 0.14, 0.16);
  c = mix(c, vec3(0.06, 0.07, 0.09), rect(uv, vec2(0.5, 0.965), vec2(0.5, 0.035)));
  c = mix(c, vec3(0.8), textLines(uv, vec2(0.18, 0.965), vec2(0.14, 0.018), 1.0, seed));
  c = mix(c, vec3(0.8, 0.55, 0.1), rect(uv, vec2(0.8, 0.965), vec2(0.13, 0.02)));
  for (int i = 0; i < 3; i++) {
    vec2 tc = vec2(0.14 + float(i) * 0.17, 0.62);
    float lvl = 0.35 + 0.45 * h22(vec2(seed, float(i))).x;
    c = mix(c, vec3(0.5, 0.52, 0.55), rrect(uv, tc, vec2(0.055, 0.17), 0.02));
    c = mix(c, vec3(0.2, 0.22, 0.25), rrect(uv, tc, vec2(0.05, 0.165), 0.018));
    c = mix(c, vec3(0.12, 0.45, 0.85), rect(uv, tc - vec2(0.0, 0.165 - lvl * 0.165), vec2(0.048, lvl * 0.165)));
    c = mix(c, vec3(0.85), textLines(uv, tc + vec2(0.0, 0.2), vec2(0.04, 0.012), 1.0, seed + float(i)));
  }
  c = mix(c, vec3(0.55, 0.58, 0.6), rect(uv, vec2(0.4, 0.43), vec2(0.3, 0.006)));
  for (int i = 0; i < 3; i++) c = mix(c, vec3(0.55, 0.58, 0.6), rect(uv, vec2(0.14 + float(i) * 0.17, 0.44), vec2(0.006, 0.02)));
  c = mix(c, vec3(0.2, 0.75, 0.32), disc(uv, vec2(0.7, 0.43), 0.03));
  c = mix(c, vec3(0.5, 0.52, 0.55), rect(uv, vec2(0.85, 0.43), vec2(0.12, 0.05)));
  for (int i = 0; i < 4; i++) c = mix(c, vec3(0.75, 0.55, 0.3), rect(uv, vec2(0.77 + float(i) * 0.055, 0.49), vec2(0.018, 0.018)));
  c = mix(c, vec3(0.1, 0.11, 0.13), rect(uv, vec2(0.5, 0.17), vec2(0.47, 0.14)));
  vec2 g = fract(vec2((uv.x - 0.03) * 20.0, (uv.y - 0.03) * 14.0));
  float inside = rect(uv, vec2(0.5, 0.17), vec2(0.47, 0.14));
  c = mix(c, vec3(0.2, 0.22, 0.25), max(step(g.x, 0.04), step(g.y, 0.06)) * inside);
  float x = (uv.x - 0.03) / 0.94;
  float l1 = 0.17 + 0.07 * sin(x * 13.0 + seed) + 0.03 * sin(x * 37.0);
  float l2 = 0.13 + 0.05 * sin(x * 7.0 + 2.0 + seed);
  c = mix(c, vec3(0.25, 0.8, 0.4), inside * cover(abs(uv.y - l1) - 0.003));
  c = mix(c, vec3(0.95, 0.65, 0.15), inside * cover(abs(uv.y - l2) - 0.003));
  return c;
}

vec3 screenVision(vec2 uv, float seed) {
  vec3 c = vec3(0.06, 0.065, 0.075);
  vec2 iv = (uv - vec2(0.36, 0.48)) / vec2(0.33, 0.42);
  float img = rect(uv, vec2(0.36, 0.48), vec2(0.33, 0.42));
  vec3 photo = vec3(0.2, 0.21, 0.22) + 0.08 * iv.y;
  float part = cover(length(iv * vec2(1.0, 0.75)) - 0.55);
  photo = mix(photo, vec3(0.62, 0.63, 0.64) - 0.2 * length(iv), part);
  photo = mix(photo, vec3(0.1), disc(iv * vec2(1.0, 0.75), vec2(0.0), 0.2));
  for (int i = 0; i < 4; i++) {
    float a = float(i) * 1.5708 + 0.785;
    photo = mix(photo, vec3(0.12), disc(iv * vec2(1.0, 0.75), vec2(cos(a), sin(a)) * 0.38, 0.05));
  }
  c = mix(c, photo, img);
  c = mix(c, vec3(0.2, 0.9, 0.35), cover(abs(box2(iv * vec2(1.0, 0.75), vec2(0.6)) ) - 0.008) * img);
  c = mix(c, vec3(0.2, 0.9, 0.35), ring(iv * vec2(1.0, 0.75), vec2(0.0), 0.2, 0.006) * img);
  c = mix(c, vec3(0.12, 0.62, 0.3), rrect(uv, vec2(0.85, 0.82), vec2(0.12, 0.08), 0.01));
  c = mix(c, vec3(0.95), textLines(uv, vec2(0.85, 0.82), vec2(0.05, 0.03), 1.0, seed));
  for (int i = 0; i < 5; i++) {
    float y = 0.62 - float(i) * 0.08;
    c = mix(c, vec3(0.7), 0.7 * textLines(uv, vec2(0.82, y), vec2(0.1, 0.018), 1.0, seed + float(i)));
    c = mix(c, vec3(0.25, 0.85, 0.4), disc(uv, vec2(0.95, y), 0.012));
  }
  for (int i = 0; i < 10; i++) {
    float hgt = 0.02 + 0.1 * h22(vec2(float(i), seed)).x;
    c = mix(c, vec3(0.3, 0.55, 0.9), rect(uv, vec2(0.74 + float(i) * 0.024, 0.12 + hgt), vec2(0.008, hgt)));
  }
  return c;
}

vec3 screenTrend(vec2 uv, float seed) {
  vec3 c = vec3(0.08, 0.09, 0.11);
  c = mix(c, vec3(0.05, 0.2, 0.4), rect(uv, vec2(0.5, 0.95), vec2(0.5, 0.05)));
  for (int i = 0; i < 4; i++) {
    vec2 tc = vec2(0.13 + float(i) * 0.25, 0.76);
    c = mix(c, vec3(0.13, 0.15, 0.19), rrect(uv, tc, vec2(0.1, 0.1), 0.01));
    c = mix(c, vec3(0.85), textLines(uv, tc + vec2(0.0, 0.03), vec2(0.07, 0.025), 1.0, seed + float(i)));
    float pct = 0.3 + 0.6 * h22(vec2(float(i), seed)).y;
    c = mix(c, vec3(0.25, 0.25, 0.3), rect(uv, tc - vec2(0.0, 0.05), vec2(0.07, 0.008)));
    c = mix(c, i == 2 ? vec3(0.95, 0.65, 0.12) : vec3(0.25, 0.8, 0.4), rect(uv, tc - vec2(0.07 - 0.07 * pct, 0.05), vec2(0.07 * pct, 0.008)));
  }
  float inside = rect(uv, vec2(0.5, 0.32), vec2(0.46, 0.25));
  c = mix(c, vec3(0.11, 0.12, 0.15), inside);
  float x = uv.x * 9.0 + seed;
  float l1 = 0.32 + 0.1 * sin(x) + 0.04 * sin(x * 3.7);
  float l2 = 0.25 + 0.06 * sin(x * 0.7 + 1.0);
  c = mix(c, vec3(0.3, 0.6, 1.0), inside * cover(abs(uv.y - l1) - 0.004));
  c = mix(c, vec3(0.25, 0.85, 0.45), inside * cover(abs(uv.y - l2) - 0.004));
  return c;
}

Mat screen(vec3 c) { return glow(vec3(0.004), 0.05, c * 1.5); }

vec2 cabinet(vec3 p, vec3 s) {
  vec3 q = p - vec3(0.0, (s.y + 100.0) * 0.5, 0.0);
  vec3 hs = vec3(s.x * 0.5, (s.y - 100.0) * 0.5, s.z * 0.5);
  float body = rbox(q, hs, 6.0);
  vec2 dh = hs.xy - 22.0;
  float slot = max(abs(box2(q.xy, dh)) - 1.4, abs(q.z - hs.z) - 3.0);
  body = max(body, -slot);
  vec2 r = vec2(body, GREY);
  float plinth = box(p - vec3(0.0, 50.0, 0.0), vec3(hs.x - 4.0, 50.0, hs.z - 4.0));
  r = U(r, vec2(plinth, DARK));
  vec3 hq = q - vec3(dh.x - 45.0, 40.0, hs.z + 9.0);
  float handle = rbox(hq, vec3(14.0, 70.0, 9.0), 6.0);
  handle = min(handle, rbox(hq - vec3(0.0, 0.0, -6.0), vec3(20.0, 92.0, 4.0), 3.0));
  r = U(r, vec2(handle, BLACK));
  vec3 hg = vec3(q.x + dh.x + 2.0, abs(q.y) - dh.y * 0.72, q.z - hs.z - 3.0);
  r = U(r, vec2(cylY(hg, 7.0, 40.0, 2.0), DARK));
  return r;
}

vec2 hmiPanel(vec3 p, vec2 hs, float d, float border, float sid) {
  float bez = rbox(p + vec3(0.0, 0.0, d * 0.5), vec3(hs, d * 0.5), 4.0);
  float pocket = box(p - vec3(0.0, 0.0, 1.0), vec3(hs - border, 2.2));
  bez = max(bez, -pocket);
  float glass = box(p + vec3(0.0, 0.0, 0.9), vec3(hs - border, 0.4));
  return U(vec2(bez, BLACK), vec2(glass, sid));
}

vec2 towerLight(vec3 p, float lit) {
  vec2 r = vec2(cylY(p - vec3(0.0, 14.0, 0.0), 30.0, 14.0, 3.0), DARK);
  r = U(r, vec2(cylY(p - vec3(0.0, 60.0, 0.0), 11.0, 34.0, 1.0), ALU));
  float y = p.y - 94.0;
  float idx = clamp(floor(y / 62.0), 0.0, 2.0);
  vec3 m = vec3(p.x, y - idx * 62.0 - 31.0, p.z);
  float lens = cylY(m, 32.0, 27.0, 4.0);
  float lensId = idx < 0.5 ? (lit == 0.0 ? LGREEN : GREEN_OFF) : (idx < 1.5 ? (lit == 1.0 ? LAMBER : AMBER_OFF) : (lit == 2.0 ? LRED : RED_OFF));
  r = U(r, vec2(lens, lensId));
  float rings = cylY(vec3(p.x, rep(y, 62.0), p.z), 33.0, 3.5, 1.5);
  rings = max(rings, max(-y - 4.0, y - 190.0));
  r = U(r, vec2(rings, DARK));
  r = U(r, vec2(cylY(p - vec3(0.0, 290.0, 0.0), 32.0, 10.0, 8.0), DARK));
  return r;
}

vec2 pushButton(vec3 p, float cap) {
  float bezel = cylZ(p - vec3(0.0, 0.0, 3.5), 14.5, 3.5, 1.4);
  bezel = max(bezel, -cylZ(p - vec3(0.0, 0.0, 7.0), 11.6, 3.0, 0.0));
  float button = cylZ(p - vec3(0.0, 0.0, 5.5), 11.0, 3.0, 1.6);
  button = max(button, -max(length(p - vec3(0.0, 0.0, 40.0)) - 32.0, -1.0));
  return U(vec2(bezel, CHROME), vec2(button, cap));
}

vec2 pilotLight(vec3 p, float lens) {
  float bezel = cylZ(p - vec3(0.0, 0.0, 3.5), 14.5, 3.5, 1.4);
  float dome = max(length(p - vec3(0.0, 0.0, 1.0)) - 12.0, 5.0 - p.z);
  dome = min(dome, cylZ(p - vec3(0.0, 0.0, 5.0), 11.0, 3.0, 0.5));
  return U(vec2(bezel, CHROME), vec2(dome, lens));
}

vec2 selectorSwitch(vec3 p, float a) {
  float bezel = cylZ(p - vec3(0.0, 0.0, 3.5), 14.5, 3.5, 1.4);
  vec2 r = vec2(bezel, CHROME);
  float knob = cylZ(p - vec3(0.0, 0.0, 9.0), 11.5, 4.0, 1.5);
  vec3 q = p - vec3(0.0, 0.0, 16.0);
  q.xy = rot(a) * q.xy;
  knob = smin(knob, rbox(q, vec3(4.0, 13.0, 6.0), 2.5), 1.5);
  return U(r, vec2(knob, BLACK));
}

vec2 estop(vec3 p) {
  float plate = cylZ(p - vec3(0.0, 0.0, 1.0), 31.0, 1.0, 0.5);
  vec2 r = vec2(plate, YELLOW);
  float collar = cylZ(p - vec3(0.0, 0.0, 6.0), 16.0, 4.5, 1.5);
  r = U(r, vec2(collar, BLACK));
  float stem = cylZ(p - vec3(0.0, 0.0, 13.0), 11.0, 4.0, 0.0);
  float head = cylZ(p - vec3(0.0, 0.0, 21.0), 20.0, 5.5, 5.0);
  head = smin(head, max(length(p - vec3(0.0, 0.0, 4.0)) - 25.0, 18.0 - p.z), 3.0);
  r = U(r, vec2(min(stem, head), RED));
  return r;
}

vec2 lightCurtain(vec3 p, float h) {
  vec3 q = p - vec3(0.0, h * 0.5, 0.0);
  float body = rbox(q, vec3(14.0, h * 0.5, 16.0), 3.0);
  vec2 r = vec2(body, YELLOW);
  float win = rbox(q - vec3(0.0, 0.0, 15.2), vec3(9.5, h * 0.5 - 34.0, 1.6), 1.0);
  r = U(r, vec2(win, GLASS));
  float caps = rbox(vec3(q.x, abs(q.y) - h * 0.5 + 12.0, q.z), vec3(15.0, 12.0, 17.0), 3.0);
  r = U(r, vec2(caps, BLACK));
  float led = cylZ(vec3(q.x - 4.0, q.y - h * 0.5 + 20.0, q.z - 17.0), 2.6, 1.2, 0.5);
  r = U(r, vec2(led, LGREEN));
  return r;
}

vec2 beltConveyor(vec3 p, float L, float W, float H, float beltId) {
  vec3 q = p - vec3(0.0, H, 0.0);
  float side = rbox(vec3(q.x, q.y + 28.0, abs(q.z) - W * 0.5 - 16.0), vec3(L * 0.5, 44.0, 14.0), 2.0);
  float groove = box(vec3(q.x, abs(q.y + 28.0) - 20.0, abs(q.z) - W * 0.5 - 30.0), vec3(L * 0.5 + 1.0, 3.0, 4.0));
  side = max(side, -groove);
  vec2 r = vec2(side, ALU);
  float st = box2(vec2(q.x, q.y + 32.0), vec2(L * 0.5 - 38.0, 0.0)) - 32.0;
  float belt = max(abs(st + 3.0) - 3.0, abs(q.z) - W * 0.5 + 2.0);
  r = U(r, vec2(belt, beltId));
  float drum = cylZ(vec3(abs(q.x) - L * 0.5 + 38.0, q.y + 32.0, q.z), 26.0, W * 0.5 + 2.0, 2.0);
  r = U(r, vec2(drum, STEEL));
  float lx = abs(q.x) - L * 0.5 + 110.0;
  float legs = rbox(vec3(lx, p.y - (H - 72.0) * 0.5, abs(q.z) - W * 0.5 - 16.0), vec3(20.0, (H - 72.0) * 0.5, 20.0), 2.0);
  float bar = rbox(vec3(lx, p.y - 170.0, q.z), vec3(20.0, 20.0, W * 0.5 + 10.0), 2.0);
  r = U(r, vec2(min(legs, bar), ALU));
  float foot = cylY(vec3(lx, p.y - 6.0, abs(q.z) - W * 0.5 - 16.0), 26.0, 6.0, 2.0);
  r = U(r, vec2(foot, BLACK));
  return r;
}

vec2 rollerConveyor(vec3 p, float L, float W, float H, float pitch) {
  vec3 q = p - vec3(0.0, H, 0.0);
  vec3 sq = vec3(q.x, q.y + 20.0, abs(q.z) - W * 0.5 - 8.0);
  float side = max(box(sq, vec3(L * 0.5, 45.0, 4.0)), -box(sq - vec3(0.0, 0.0, -10.0), vec3(L * 0.5 + 1.0, 39.0, 8.0)));
  side = min(side, box(vec3(sq.x, abs(sq.y) - 42.0, sq.z + 12.0), vec3(L * 0.5, 3.0, 16.0)));
  vec2 r = vec2(side, GREY);
  float n = floor(L * 0.5 / pitch) - 1.0;
  float rx = repLim(q.x, pitch, -n, n);
  float roller = cylZ(vec3(rx, q.y + 25.0, q.z), 25.0, W * 0.5, 2.0);
  r = U(r, vec2(roller, ZINC));
  float axle = cylZ(vec3(rx, q.y + 25.0, q.z), 6.0, W * 0.5 + 10.0, 0.0);
  r = U(r, vec2(axle, STEEL));
  float lx = abs(q.x) - L * 0.5 + 110.0;
  float legs = rbox(vec3(lx, p.y - (H - 66.0) * 0.5, abs(q.z) - W * 0.5 - 14.0), vec3(20.0, (H - 66.0) * 0.5, 20.0), 2.0);
  float bar = rbox(vec3(lx, p.y - 170.0, q.z), vec3(20.0, 20.0, W * 0.5 + 10.0), 2.0);
  r = U(r, vec2(min(legs, bar), GREY));
  float foot = cylY(vec3(lx, p.y - 6.0, abs(q.z) - W * 0.5 - 14.0), 26.0, 6.0, 2.0);
  r = U(r, vec2(foot, BLACK));
  return r;
}

vec2 carton(vec3 p, vec3 hs) {
  vec3 q = p - vec3(0.0, hs.y, 0.0);
  float b = rbox(q, hs, 2.5);
  float seam = max(abs(q.z) - 0.7, hs.y - 1.5 - q.y);
  b = max(b, -seam);
  vec2 r = vec2(b, CARD);
  float shell = max(box(q, vec3(hs.x + 0.4, hs.y + 0.4, 24.0)), -box(q, vec3(hs.x - 0.4, hs.y - 0.4, 30.0)));
  float tape = max(shell, hs.y - 70.0 - q.y);
  r = U(r, vec2(tape, TAPE));
  return r;
}

vec2 pallet(vec3 p) {
  float top = box(vec3(p.x, p.y - 133.0, repLim(p.z, 172.0, -2.0, 2.0)), vec3(600.0, 11.0, 58.0));
  float str = box(vec3(repLim(p.x, 528.0, -1.0, 1.0), p.y - 100.0, p.z), vec3(70.0, 11.0, 400.0));
  float blk = box(vec3(repLim(p.x, 528.0, -1.0, 1.0), p.y - 50.0, repLim(p.z, 335.0, -1.0, 1.0)), vec3(70.0, 39.0, 64.0));
  float bot = box(vec3(p.x, p.y - 11.0, repLim(p.z, 335.0, -1.0, 1.0)), vec3(600.0, 11.0, 64.0));
  return vec2(min(min(top, str), min(blk, bot)) - 0.8, WOOD);
}

vec2 fencePanel(vec3 p, float w, float h) {
  float post = rbox(vec3(abs(p.x) - w * 0.5, p.y - h * 0.5, p.z), vec3(25.0, h * 0.5, 25.0), 3.0);
  float plate = rbox(vec3(abs(p.x) - w * 0.5, p.y - 4.0, p.z), vec3(55.0, 4.0, 55.0), 2.0);
  vec2 r = vec2(min(post, plate), YELLOW);
  vec3 f = p - vec3(0.0, (h + 160.0) * 0.5, 0.0);
  vec2 fh = vec2(w * 0.5 - 30.0, (h - 160.0) * 0.5 - 15.0);
  float frame = max(abs(box2(f.xy, fh)) - 10.0, abs(f.z) - 10.0);
  r = U(r, vec2(frame, MESH));
  if (gClear > 0.5) r = U(r, vec2(box(f, vec3(fh, 1.5)), MESHP));
  return r;
}

vec2 pneuCylinder(vec3 p, float bore, float L, float ext) {
  float s = bore * 0.62;
  vec3 b = p - vec3(L * 0.5 + 18.0, 0.0, 0.0);
  float barrel = rbox(b, vec3(L * 0.5, s, s), bore * 0.2);
  float slot = box(vec3(b.x, abs(b.y) - s, abs(b.z) - s * 0.45), vec3(L * 0.5 + 1.0, 2.0, 2.2));
  barrel = max(barrel, -slot);
  vec2 r = vec2(barrel, ALU);
  float caps = rbox(vec3(abs(p.x - L * 0.5 - 18.0) - L * 0.5 - 9.0, p.y, p.z), vec3(9.0, s + 3.0, s + 3.0), 3.0);
  r = U(r, vec2(caps, MGREY));
  float screws = cylX(vec3(abs(p.x - L * 0.5 - 18.0) - L * 0.5 - 18.0, abs(p.y) - s + 4.0, abs(p.z) - s + 4.0), 3.2, 1.2, 0.5);
  r = U(r, vec2(screws, STEEL));
  float rod = cylX(p - vec3(L + 36.0 + ext * 0.5, 0.0, 0.0), bore * 0.3, ext * 0.5 + 1.0, 0.8);
  r = U(r, vec2(rod, CHROME));
  float nut = hexZ(vec3(p.y, p.z, p.x - L - 40.0 - ext), bore * 0.38, 4.0, 1.05);
  r = U(r, vec2(nut, STEEL));
  vec3 fq = vec3(abs(p.x - L * 0.5 - 18.0) - L * 0.5 - 9.0, p.y - s - 3.0, p.z);
  float fit = cylY(fq - vec3(0.0, 6.0, 0.0), 5.5, 6.0, 1.0);
  r = U(r, vec2(fit, BLACK));
  float collar = cylY(fq - vec3(0.0, 13.0, 0.0), 5.0, 1.6, 0.6);
  r = U(r, vec2(collar, BLUEP));
  return r;
}

vec2 motor(vec3 p, float R, float L, float paint) {
  float body = cylX(p, R, L * 0.5, 8.0);
  float a = atan(p.z, p.y);
  float rr = length(p.yz);
  float fin = max(max(rr - R - 13.0, abs(rep(a, 6.2831853 / 32.0)) * rr - 2.4), abs(p.x) - L * 0.5 + 18.0);
  fin = max(fin, -p.y - R * 0.55);
  body = min(body, fin);
  float shield = cylX(vec3(abs(p.x) - L * 0.5, p.yz), R + 4.0, 14.0, 5.0);
  body = min(body, shield);
  vec2 r = vec2(body, paint);
  float fan = cylX(p + vec3(L * 0.5 + 60.0, 0.0, 0.0), R + 3.0, 48.0, 14.0);
  float grill = max(max(abs(rep(p.y, 9.0)) - 2.2, -p.x - L * 0.5 - 104.0), rr - R * 0.75);
  fan = max(fan, -grill);
  r = U(r, vec2(fan, paint));
  float shaft = cylX(p - vec3(L * 0.5 + 50.0, 0.0, 0.0), R * 0.2, 40.0, 1.5);
  r = U(r, vec2(shaft, STEEL));
  vec3 tb = p - vec3(L * 0.08, R + 38.0, 0.0);
  float box1 = rbox(tb, vec3(R * 0.55, 34.0, R * 0.55), 8.0);
  r = U(r, vec2(box1, paint));
  float gland = cylZ(tb - vec3(0.0, -6.0, R * 0.55 + 10.0), 11.0, 10.0, 2.0);
  r = U(r, vec2(gland, BLACK));
  float feet = rbox(vec3(abs(p.x) - L * 0.3, p.y + R + 20.0, p.z), vec3(32.0, 20.0, R * 0.95), 4.0);
  feet = smin(feet, rbox(vec3(abs(p.x) - L * 0.3, p.y + R * 0.6, p.z), vec3(26.0, R * 0.5, R * 0.6), 6.0), 8.0);
  r = U(r, vec2(feet, paint));
  float eye = torusX(p - vec3(0.0, R + 22.0, 0.0), 14.0, 4.5);
  r = U(r, vec2(eye, STEEL));
  return r;
}

vec2 dinRail(vec3 p, float L) {
  float top = box(p - vec3(0.0, 0.0, 7.0), vec3(L * 0.5, 13.5, 0.6));
  float web = box(vec3(p.x, abs(p.y) - 13.5, p.z - 3.5), vec3(L * 0.5, 0.6, 4.0));
  float lip = box(vec3(p.x, abs(p.y) - 16.5, p.z), vec3(L * 0.5, 3.6, 0.6));
  float d = min(top, min(web, lip));
  d = max(d, -box(vec3(rep(p.x, 25.0), p.y, p.z), vec3(7.5, 2.6, 10.0)));
  return vec2(d, ZINC);
}

vec2 mcb(vec3 p, float poles, float lever) {
  float w = 9.0 * poles - 0.5;
  float base = rbox(p - vec3(0.0, 0.0, 30.0), vec3(w, 45.0, 30.0), 1.5);
  float front = rbox(p - vec3(0.0, 0.0, 62.0), vec3(w, 22.5, 6.0), 1.5);
  float body = min(base, front);
  float pockets = box(vec3(rep(p.x, 18.0), abs(p.y) - 34.0, p.z - 60.0), vec3(4.5, 5.0, 4.0));
  body = max(body, -pockets);
  vec2 r = vec2(body, WHITE);
  float screw = cylZ(vec3(rep(p.x, 18.0), abs(p.y) - 34.0, p.z - 56.0), 2.6, 1.0, 0.4);
  r = U(r, vec2(max(screw, abs(p.x) - w), STEEL));
  vec3 lq = p - vec3(0.0, lever * 6.0, 70.0);
  float lev = rbox(lq, vec3(w - 2.0, 5.5, 5.0), 2.0);
  r = U(r, vec2(lev, BLACK));
  float label = box(p - vec3(0.0, -14.0, 68.2), vec3(w - 3.0, 4.0, 0.2));
  r = U(r, vec2(label, GREY));
  return r;
}

vec2 contactor(vec3 p) {
  float body = rbox(p - vec3(0.0, 0.0, 38.0), vec3(22.5, 43.0, 38.0), 2.0);
  float front = rbox(p - vec3(0.0, 0.0, 80.0), vec3(18.0, 24.0, 6.0), 2.0);
  vec2 r = vec2(min(body, front), LGREY);
  float term = rbox(vec3(p.x, abs(p.y) - 37.0, p.z - 50.0), vec3(22.0, 8.0, 26.0), 1.5);
  term = max(term, -box(vec3(rep(p.x, 14.0), abs(p.y) - 40.0, p.z - 70.0), vec3(4.0, 5.0, 8.0)));
  r = U(r, vec2(term, MGREY));
  float window = box(p - vec3(0.0, 4.0, 86.0), vec3(9.0, 6.0, 0.6));
  r = U(r, vec2(window, BLACK));
  return r;
}

vec2 terminalBlocks(vec3 p, float n, float bridgeId) {
  float cell = clamp(round(p.x / 6.2), -n, n);
  vec3 q = vec3(p.x - cell * 6.2, p.y, p.z);
  float blk = rbox(q - vec3(0.0, 0.0, 22.0), vec3(2.8, 30.0, 22.0), 1.0);
  blk = smin(blk, rbox(q - vec3(0.0, 0.0, 38.0), vec3(2.8, 14.0, 10.0), 1.0), 3.0);
  blk = max(blk, -box(vec3(q.x, abs(q.y) - 22.0, q.z - 44.0), vec3(3.5, 4.0, 4.0)));
  float id = mod(cell, 6.0) == 5.0 ? bridgeId : GREY;
  return vec2(blk, id);
}

vec2 sensorM18(vec3 p, float faceId) {
  vec2 r;
  float a = atan(p.z, p.y) / (2.0 * PI);
  float t = abs(fract(p.x + a) - 0.5) * 2.0;
  float rr = 8.5 + 0.5 * smoothstep(0.15, 0.85, t);
  float th = max((length(p.yz) - rr) * 0.7, max(-26.0 - p.x, p.x - 27.8));
  r = vec2(th, STEEL);
  r = U(r, vec2(cylX(p + vec3(29.9, 0.0, 0.0), 8.6, 4.1, 0.5), STEEL));
  float nut1 = hexZ(vec3(p.z, p.y, p.x - 10.0), 11.9, 2.1, 1.06);
  float nut2 = hexZ(vec3(p.z, p.y, p.x + 17.0), 11.9, 2.1, 1.06);
  r = U(r, vec2(min(nut1, nut2) - 0.08, ZINC));
  r = U(r, vec2(cylX(p - vec3(30.2, 0.0, 0.0), 8.45, 2.8, 1.6), faceId));
  r = U(r, vec2(cylX(p + vec3(38.8, 0.0, 0.0), 7.2, 5.2, 0.9), BLACK));
  r = U(r, vec2(cylX(p + vec3(37.5, 0.0, 0.0), 7.45, 0.9, 0.3), LAMBER));
  float rel = max((length(p.yz) - mix(4.7, 3.1, clamp((-44.0 - p.x) / 9.0, 0.0, 1.0))) * 0.9, max(p.x + 43.5, -53.5 - p.x));
  r = U(r, vec2(rel, BLACK));
  return r;
}

float cable(vec3 p, vec3 a, vec3 b, vec3 c, float r) {
  float best = 1e9;
  vec3 prev = a;
  for (int i = 1; i <= 8; i++) {
    float t = float(i) / 8.0;
    vec3 q = mix(mix(a, b, t), mix(b, c, t), t);
    best = min(best, capsule(p, prev, q, r));
    prev = q;
  }
  return best;
}

vec2 robotArm(vec3 p, float a1, float a2, float a3, float a5, float tool) {
  vec2 r = vec2(rbox(p - vec3(0.0, 15.0, 0.0), vec3(230.0, 15.0, 230.0), 6.0), DARK);
  float bolts = cylY(vec3(abs(p.x) - 195.0, p.y - 32.0, abs(p.z) - 195.0), 12.0, 4.0, 2.0);
  r = U(r, vec2(bolts, STEEL));
  float base = cylY(p - vec3(0.0, 120.0, 0.0), 175.0, 90.0, 18.0);
  base = smin(base, cylY(p - vec3(0.0, 215.0, 0.0), 150.0, 12.0, 4.0), 20.0);
  r = U(r, vec2(base, ROBOT));
  vec3 q = p;
  q.xz = rot(a1) * q.xz;
  float turret = rbox(q - vec3(40.0, 330.0, 0.0), vec3(150.0, 100.0, 140.0), 60.0);
  turret = smin(turret, cylY(q - vec3(0.0, 250.0, 0.0), 160.0, 22.0, 10.0), 30.0);
  r = U(r, vec2(turret, ROBOT));
  float m1 = cylX(q - vec3(-150.0, 330.0, 0.0), 70.0, 50.0, 12.0);
  r = U(r, vec2(m1, DARK));
  vec3 s = q - vec3(130.0, 470.0, 0.0);
  s.xy = rot(a2) * s.xy;
  float shoulder = cylZ(s, 140.0, 150.0, 30.0);
  float cap = cylZ(s - vec3(0.0, 0.0, -165.0), 95.0, 28.0, 12.0);
  r = U(r, vec2(shoulder, ROBOT));
  r = U(r, vec2(cap, DARK));
  vec3 la = s - vec3(0.0, 330.0, 25.0);
  float w = mix(105.0, 80.0, clamp((la.y + 330.0) / 660.0, 0.0, 1.0));
  float lower = rbox(la, vec3(w, 330.0, 92.0), 55.0);
  r = U(r, vec2(lower, ROBOT));
  vec3 e = s - vec3(0.0, 660.0, 0.0);
  e.xy = rot(a3) * e.xy;
  float elbow = cylZ(e, 115.0, 118.0, 26.0);
  r = U(r, vec2(elbow, ROBOT));
  float cap2 = cylZ(e - vec3(0.0, 0.0, 130.0), 78.0, 20.0, 10.0);
  r = U(r, vec2(cap2, DARK));
  float m3 = cylX(e + vec3(170.0, -40.0, 0.0), 72.0, 70.0, 14.0);
  r = U(r, vec2(m3, DARK));
  float housing = rbox(e - vec3(-60.0, 40.0, 0.0), vec3(150.0, 95.0, 95.0), 55.0);
  r = U(r, vec2(housing, ROBOT));
  vec3 u = e - vec3(0.0, 40.0, 0.0);
  float ux = clamp(u.x / 620.0, 0.0, 1.0);
  float upper = max(length(u.yz) - mix(78.0, 58.0, ux), max(-u.x, u.x - 620.0));
  upper = smin(upper, housing, 30.0);
  r = U(r, vec2(upper, ROBOT));
  float ring = cylX(u - vec3(380.0, 0.0, 0.0), 66.0, 6.0, 2.0);
  r = U(r, vec2(ring, DARK));
  vec3 wq = u - vec3(640.0, 0.0, 0.0);
  float yoke = rbox(vec3(wq.x - 10.0, wq.y, abs(wq.z) - 44.0), vec3(55.0, 55.0, 14.0), 14.0);
  r = U(r, vec2(yoke, ROBOT));
  wq.xy = rot(a5) * wq.xy;
  float wrist = cylZ(wq - vec3(30.0, 0.0, 0.0), 48.0, 32.0, 8.0);
  r = U(r, vec2(wrist, DARK));
  vec3 fq = wq - vec3(30.0, -70.0, 0.0);
  float flange = cylY(fq, 40.0, 22.0, 4.0);
  r = U(r, vec2(flange, ROBOT));
  float plate = cylY(fq + vec3(0.0, 28.0, 0.0), 45.0, 6.0, 1.5);
  r = U(r, vec2(plate, STEEL));
  vec3 g = fq + vec3(0.0, 34.0, 0.0);
  if (tool < 0.5) {
    float frame = rbox(g + vec3(0.0, 18.0, 0.0), vec3(150.0, 12.0, 110.0), 4.0);
    frame = min(frame, rbox(g + vec3(0.0, 6.0, 0.0), vec3(40.0, 8.0, 40.0), 3.0));
    r = U(r, vec2(frame, ALU));
    vec3 cq = vec3(abs(g.x) - 100.0, g.y + 30.0, abs(g.z) - 65.0);
    float stem = cylY(cq + vec3(0.0, 12.0, 0.0), 7.0, 14.0, 1.0);
    r = U(r, vec2(stem, STEEL));
    float cup = cylY(cq + vec3(0.0, 34.0, 0.0), 22.0, 8.0, 4.0);
    cup = smin(cup, cylY(cq + vec3(0.0, 24.0, 0.0), 12.0, 6.0, 2.0), 6.0);
    r = U(r, vec2(cup, BLACK));
  } else {
    float body = rbox(g + vec3(0.0, 30.0, 0.0), vec3(55.0, 30.0, 38.0), 6.0);
    r = U(r, vec2(body, ALU));
    float jaws = rbox(vec3(abs(g.x) - 30.0, g.y + 95.0, g.z), vec3(10.0, 38.0, 22.0), 3.0);
    r = U(r, vec2(jaws, MGREY));
  }
  return r;
}

vec2 workbench(vec3 p, vec3 s) {
  vec3 q = p - vec3(0.0, s.y - 20.0, 0.0);
  vec2 r = vec2(rbox(q, vec3(s.x * 0.5, 20.0, s.z * 0.5), 3.0), BENCHTOP);
  float legs = rbox(vec3(abs(p.x) - s.x * 0.5 + 60.0, p.y - (s.y - 40.0) * 0.5, abs(p.z) - s.z * 0.5 + 60.0), vec3(25.0, (s.y - 40.0) * 0.5, 25.0), 2.0);
  float rail = rbox(vec3(p.x, p.y - s.y + 80.0, abs(p.z) - s.z * 0.5 + 60.0), vec3(s.x * 0.5 - 60.0, 25.0, 15.0), 2.0);
  float shelf = rbox(p - vec3(0.0, 230.0, 0.0), vec3(s.x * 0.5 - 40.0, 10.0, s.z * 0.5 - 40.0), 3.0);
  float feet = cylY(vec3(abs(p.x) - s.x * 0.5 + 60.0, p.y - 5.0, abs(p.z) - s.z * 0.5 + 60.0), 30.0, 5.0, 2.0);
  r = U(r, vec2(min(min(legs, rail), shelf), GREY));
  r = U(r, vec2(feet, BLACK));
  vec3 b = p - vec3(0.0, s.y + 360.0, -s.z * 0.5 + 20.0);
  float uprights = rbox(vec3(abs(b.x) - s.x * 0.5 + 30.0, b.y, b.z), vec3(20.0, 360.0, 20.0), 2.0);
  r = U(r, vec2(uprights, GREY));
  r = U(r, vec2(box(b - vec3(0.0, 0.0, 6.0), vec3(s.x * 0.5 - 50.0, 330.0, 3.0)), PEGBOARD));
  vec3 dq = p - vec3(s.x * 0.5 - 300.0, s.y - 260.0, 0.0);
  float drawers = rbox(dq, vec3(230.0, 210.0, s.z * 0.5 - 20.0), 3.0);
  drawers = max(drawers, -box(vec3(dq.x, rep(dq.y + 35.0, 140.0), dq.z - s.z * 0.5 + 20.0), vec3(240.0, 2.0, 3.0)));
  r = U(r, vec2(drawers, GREY));
  float handles = rbox(vec3(dq.x, rep(dq.y + 35.0 - 70.0, 140.0), dq.z - s.z * 0.5 + 12.0), vec3(70.0, 6.0, 8.0), 3.0);
  handles = max(handles, abs(dq.y) - 200.0);
  r = U(r, vec2(handles, DARK));
  return r;
}
