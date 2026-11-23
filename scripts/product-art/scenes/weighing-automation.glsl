const vec3 BC = vec3(-150.0, 800.0, 550.0);
const float BR = 2600.0;

const float STAIN = 50.0, LCD = 51.0, DRUM = 52.0, CHECKER = 53.0, BINRED = 54.0, KEYPAD = 55.0;
const vec3 DISP_A = vec3(-40.0, 1545.0, -254.0);
const vec3 DISP_B = vec3(-1990.0, 1275.0, 946.0);
const vec2 DISP_HS = vec2(150.0, 48.0);

vec2 conveyors(vec3 p) {
  vec2 r = beltConveyor(p - vec3(-1150.0, 0.0, 0.0), 1500.0, 420.0, 850.0, BELT);
  r = U(r, beltConveyor(p - vec3(1150.0, 0.0, 0.0), 1500.0, 420.0, 850.0, BELT));
  return r;
}

vec2 checkweigher(vec3 p) {
  vec2 r = beltConveyor(p, 620.0, 420.0, 860.0, BELT);
  r = U(r, vec2(rbox(p - vec3(0.0, 375.0, 0.0), vec3(380.0, 375.0, 300.0), 6.0), STAIN));
  r = U(r, vec2(box(vec3(abs(p.x) - 190.0, p.y - 420.0, p.z - 300.0), vec3(1.5, 300.0, 3.0)), DARK));
  r = U(r, vec2(rbox(vec3(abs(p.x) - 185.0, p.y - 470.0, p.z - 304.0), vec3(6.0, 40.0, 5.0), 3.0), BLACK));
  r = U(r, vec2(rbox(p - vec3(0.0, 768.0, 0.0), vec3(330.0, 10.0, 250.0), 3.0), STAIN));
  r = U(r, vec2(cylY(p - vec3(0.0, 1150.0, -330.0), 22.0, 380.0, 3.0), STAIN));
  r = U(r, vec2(rbox(p - vec3(0.0, 1530.0, -300.0), vec3(240.0, 140.0, 45.0), 10.0), STAIN));
  r = U(r, vec2(box(p - DISP_A, vec3(DISP_HS, 0.6)), LCD));
  vec3 k = vec3(rep(p.x + 70.0, 46.0), p.y - 1440.0, p.z + 254.5);
  r = U(r, vec2(max(rbox(k, vec3(17.0, 14.0, 1.5), 3.0), abs(p.x + 25.0) - 160.0), KEYPAD));
  r = U(r, pilotLight(vec3(p.x - 185.0, p.y - 1575.0, p.z + 255.0), LGREEN));
  r = U(r, pilotLight(vec3(p.x - 185.0, p.y - 1510.0, p.z + 255.0), RED_OFF));
  vec3 s = vec3(p.x + 330.0, p.y, abs(p.z) - 275.0);
  r = U(r, vec2(cylY(s - vec3(0.0, 470.0, 0.0), 14.0, 470.0, 2.0), STEEL));
  r = U(r, vec2(rbox(s - vec3(0.0, 945.0, 0.0), vec3(22.0, 32.0, 20.0), 4.0), DARK));
  r = U(r, vec2(cylZ(vec3(s.x, s.y - 945.0, s.z + 20.0), 7.0, 3.0, 1.0), LRED));
  return r;
}

vec2 reject(vec3 p) {
  vec3 q = p - vec3(1250.0, 0.0, 0.0);
  vec2 r = pneuCylinder(vec3(q.z + 560.0, q.y - 930.0, -q.x), 50.0, 120.0, 70.0);
  r = U(r, vec2(rbox(q - vec3(0.0, 930.0, -322.0), vec3(95.0, 45.0, 8.0), 3.0), BLUEP));
  r = U(r, vec2(rbox(q - vec3(0.0, 870.0, -500.0), vec3(60.0, 20.0, 70.0), 3.0), MGREY));
  r = U(r, vec2(rbox(q - vec3(0.0, 430.0, -540.0), vec3(25.0, 430.0, 25.0), 3.0), MGREY));
  r = U(r, vec2(cylY(q - vec3(0.0, 6.0, -540.0), 45.0, 6.0, 2.0), BLACK));
  vec3 c = q - vec3(0.0, 720.0, 330.0);
  c.yz = rot(-0.6) * c.yz;
  r = U(r, vec2(rbox(c, vec3(170.0, 4.0, 130.0), 2.0), STAIN));
  r = U(r, vec2(rbox(vec3(abs(c.x) - 170.0, c.y - 40.0, c.z), vec3(4.0, 40.0, 130.0), 2.0), STAIN));
  vec3 b = q - vec3(0.0, 0.0, 600.0);
  float outer = rbox(b - vec3(0.0, 230.0, 0.0), vec3(260.0, 230.0, 200.0), 10.0);
  float inner = rbox(b - vec3(0.0, 250.0, 0.0), vec3(245.0, 230.0, 185.0), 8.0);
  r = U(r, vec2(max(outer, -inner), BINRED));
  vec3 t = b - vec3(-40.0, 30.0, 10.0);
  t.xz = rot(0.5) * t.xz;
  t.xy = rot(0.25) * t.xy;
  r = U(r, carton(t, vec3(130.0, 90.0, 110.0)));
  return r;
}

vec2 cartons(vec3 p) {
  vec3 hs = vec3(130.0, 90.0, 110.0);
  vec2 r = carton(p - vec3(-1650.0, 850.0, 10.0), hs);
  r = U(r, carton(p - vec3(-1000.0, 850.0, -15.0), hs));
  r = U(r, carton(p - vec3(10.0, 860.0, 0.0), hs));
  r = U(r, carton(p - vec3(720.0, 850.0, 20.0), hs));
  r = U(r, carton(p - vec3(1620.0, 850.0, -10.0), hs));
  return r;
}

vec2 platformScale(vec3 p) {
  vec3 q = p - vec3(-1500.0, 0.0, 1300.0);
  vec2 r = vec2(rbox(q - vec3(0.0, 48.0, 0.0), vec3(460.0, 42.0, 460.0), 5.0), CHECKER);
  r = U(r, vec2(box(q - vec3(0.0, 4.0, 0.0), vec3(440.0, 4.0, 440.0)), DARK));
  vec3 d = q - vec3(-15.0, 90.0, -10.0);
  float drum = cylY(d - vec3(0.0, 440.0, 0.0), 290.0, 440.0, 8.0);
  drum = min(drum, torusY(vec3(d.x, abs(d.y - 440.0) - 145.0, d.z), 291.0, 9.0));
  drum = min(drum, torusY(vec3(d.x, abs(d.y - 440.0) - 430.0, d.z), 291.0, 8.0));
  r = U(r, vec2(drum, DRUM));
  r = U(r, vec2(cylY(d - vec3(110.0, 886.0, 60.0), 32.0, 8.0, 3.0), DARK));
  r = U(r, vec2(rbox(q - vec3(-490.0, 650.0, -400.0), vec3(25.0, 650.0, 25.0), 3.0), MGREY));
  r = U(r, vec2(cylY(q - vec3(-490.0, 6.0, -400.0), 70.0, 6.0, 2.0), DARK));
  r = U(r, vec2(rbox(p - vec3(-1990.0, 1265.0, 905.0), vec3(220.0, 125.0, 40.0), 10.0), STAIN));
  r = U(r, vec2(box(p - DISP_B, vec3(DISP_HS, 0.6)), LCD));
  r = U(r, pilotLight(vec3(p.x + 1815.0, p.y - 1300.0, p.z - 945.0), LGREEN));
  float cord = cable(p, vec3(-1990.0, 1140.0, 905.0), vec3(-1970.0, 300.0, 960.0), vec3(-1880.0, 50.0, 1050.0), 6.0);
  r = U(r, vec2(cord, CABLE));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 450.0, 0.0), vec3(1950.0, 460.0, 260.0)) < r.x) r = U(r, conveyors(p));
  if (box(p - vec3(0.0, 830.0, -40.0), vec3(400.0, 870.0, 340.0)) < r.x) r = U(r, checkweigher(p));
  if (box(p - vec3(0.0, 950.0, 0.0), vec3(1800.0, 110.0, 130.0)) < r.x) r = U(r, cartons(p));
  if (box(p - vec3(1250.0, 500.0, 50.0), vec3(280.0, 520.0, 780.0)) < r.x) r = U(r, reject(p));
  if (box(p - vec3(-1650.0, 700.0, 1150.0), vec3(600.0, 700.0, 620.0)) < r.x) r = U(r, platformScale(p));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == STAIN) return mat(vec3(0.68, 0.69, 0.7) * (0.93 + 0.1 * fbm(vec3(p.x * 0.004, p.y * 0.4, p.z * 0.004))), 0.3, 1.0);
  if (id == DRUM) return mat(vec3(0.03, 0.15, 0.42) * (0.9 + 0.15 * fbm(p * 0.02)), 0.38, 0.0);
  if (id == BINRED) return mat(vec3(0.45, 0.03, 0.02), 0.45, 0.0);
  if (id == KEYPAD) return mat(vec3(0.05, 0.06, 0.08), 0.5, 0.0);
  if (id == CHECKER) {
    vec2 g = rot(0.785) * p.xz * 0.06;
    float bump = step(0.62, abs(fract(g.x) - 0.5) * 2.0) * step(abs(fract(g.y * 3.0) - 0.5), 0.18);
    return mat(vec3(0.5, 0.51, 0.52) * (0.85 + 0.25 * bump), 0.35, 1.0);
  }
  if (id == LCD) {
    vec3 c = p.x < -1000.0 ? DISP_B : DISP_A;
    vec2 uv = (p.xy - c.xy + DISP_HS) / (2.0 * DISP_HS);
    vec3 col = vec3(0.03, 0.05, 0.04);
    float cell = floor(uv.x * 6.0);
    vec2 g = vec2(fract(uv.x * 6.0), uv.y);
    float seg = max(step(abs(g.y - 0.5), 0.05), max(step(abs(g.y - 0.85), 0.05), step(abs(g.y - 0.15), 0.05))) * step(abs(g.x - 0.5), 0.3);
    seg = max(seg, step(abs(g.x - 0.2), 0.05) * step(abs(g.y - 0.5), 0.35) * step(0.4, h22(vec2(cell, c.x)).x));
    seg = max(seg, step(abs(g.x - 0.8), 0.05) * step(abs(g.y - 0.5), 0.35));
    seg *= step(0.12, uv.y) * step(uv.y, 0.88) * step(0.5, uv.x * 6.0) * step(uv.x * 6.0, 5.5);
    float dot2 = step(length((uv - vec2(0.5, 0.17)) * vec2(6.0, 1.0)), 0.06);
    col = mix(col, vec3(0.3, 1.25, 0.5), max(seg, dot2));
    return glow(vec3(0.01), 0.08, col);
  }
  return libMat(id, p, n);
}
