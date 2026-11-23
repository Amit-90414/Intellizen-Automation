const vec3 BC = vec3(0.0, 1300.0, 400.0);
const float BR = 3300.0;

const float HAZARD = 50.0, PAINT = 51.0, BRONZE = 52.0;

float triangle2(vec2 p, float r) {
  const float k = 1.7320508;
  p.x = abs(p.x) - r;
  p.y = p.y + r / k;
  if (p.x + k * p.y > 0.0) p = vec2(p.x - k * p.y, -k * p.x - p.y) / 2.0;
  p.x -= clamp(p.x, -2.0 * r, 0.0);
  return -length(p) * sign(p.y);
}

vec2 warning(vec3 q, float r) {
  vec2 res = vec2(max(triangle2(q.xy, r) - 3.0, abs(q.z - 0.3) - 0.3), BLACK);
  res = U(res, vec2(max(triangle2(q.xy, r * 0.78) - 2.0, abs(q.z - 0.5) - 0.5), YELLOW));
  float bar = rbox(vec3(q.x, q.y + r * 0.02, q.z - 0.6), vec3(r * 0.06, r * 0.22, 0.6), r * 0.05);
  float dot2 = max(length(q.xy + vec2(0.0, r * 0.36)) - r * 0.07, abs(q.z - 0.6) - 0.6);
  return U(res, vec2(min(bar, dot2), BLACK));
}

vec2 idPlate(vec3 q, vec2 hs) {
  vec2 r = vec2(rbox(q, vec3(hs, 0.8), 0.6), ZINC);
  return U(r, vec2(cylZ(vec3(abs(q.x) - hs.x + 7.0, abs(q.y) - hs.y + 7.0, q.z - 0.8), 2.4, 0.8, 0.6), STEEL));
}

float ties(vec3 p, vec3 a, float y0, float y1) {
  return max(torusY(vec3(p.x - a.x, rep(p.y - y0, 160.0), p.z - a.z), 5.0, 1.5), max(y0 - 5.0 - p.y, p.y - y1 - 5.0));
}

vec2 press(vec3 p) {
  vec3 q = p - vec3(300.0, 0.0, -50.0);
  vec2 r = vec2(rbox(q - vec3(0.0, 380.0, 0.0), vec3(650.0, 380.0, 380.0), 14.0), PAINT);
  float bolster = rbox(q - vec3(0.0, 778.0, 0.0), vec3(560.0, 18.0, 330.0), 3.0);
  bolster = max(bolster, -box(vec3(q.x, q.y - 796.0, rep(q.z, 110.0)), vec3(570.0, 8.0, 9.0)));
  r = U(r, vec2(bolster, STEEL));
  vec3 cq = vec3(abs(q.x) - 480.0, q.y, abs(q.z) - 240.0);
  r = U(r, vec2(cylY(cq - vec3(0.0, 1720.0, 0.0), 62.0, 940.0, 4.0), CHROME));
  r = U(r, vec2(cylY(cq - vec3(0.0, 2660.0, 0.0), 82.0, 22.0, 6.0), DARK));
  r = U(r, vec2(rbox(q - vec3(0.0, 2470.0, 0.0), vec3(650.0, 170.0, 380.0), 14.0), PAINT));
  float slide = rbox(q - vec3(0.0, 1520.0, 0.0), vec3(600.0, 105.0, 335.0), 10.0);
  r = U(r, vec2(slide, PAINT));
  r = U(r, vec2(cylY(cq - vec3(0.0, 1520.0, 0.0), 92.0, 118.0, 6.0), BRONZE));
  r = U(r, vec2(box(q - vec3(0.0, 1520.0, 337.0), vec3(560.0, 70.0, 2.0)), HAZARD));
  r = U(r, vec2(rbox(q - vec3(0.0, 1370.0, 0.0), vec3(380.0, 45.0, 250.0), 4.0), MGREY));
  r = U(r, vec2(rbox(q - vec3(0.0, 840.0, 0.0), vec3(380.0, 45.0, 250.0), 4.0), MGREY));
  r = U(r, vec2(cylY(q - vec3(0.0, 2800.0, 0.0), 175.0, 160.0, 12.0), DARK));
  r = U(r, vec2(cylY(q - vec3(0.0, 2972.0, 0.0), 150.0, 14.0, 6.0), MGREY));
  vec3 t = q - vec3(-420.0, 2800.0, -120.0);
  r = U(r, vec2(rbox(t, vec3(170.0, 160.0, 210.0), 10.0), PAINT));
  r = U(r, motor(vec3(t.x, t.y - 285.0, t.z), 85.0, 230.0, PAINT));
  float hose = capsule(q, vec3(-260.0, 2900.0, -60.0), vec3(-150.0, 2900.0, 60.0), 14.0);
  hose = min(hose, capsule(q, vec3(-260.0, 2860.0, -180.0), vec3(-140.0, 2700.0, -150.0), 14.0));
  r = U(r, vec2(hose, CABLE));
  vec3 eb = q - vec3(-660.0, 430.0, 120.0);
  r = U(r, vec2(rbox(eb + vec3(100.0, 0.0, 0.0), vec3(110.0, 200.0, 160.0), 6.0), GREY));
  r = U(r, idPlate(vec3(q.x - 420.0, q.y - 560.0, q.z - 380.0), vec2(70.0, 45.0)));
  r = U(r, warning(vec3(q.x + 420.0, q.y - 2470.0, q.z - 380.0), 70.0));
  return r;
}

vec3 toSign(vec3 p) { return p - vec3(-750.0, 1450.0, 905.0); }

vec2 sign2(vec3 q) {
  vec2 r = vec2(rbox(q, vec3(150.0, 105.0, 1.2), 4.0), PAPER);
  r = U(r, warning(vec3(q.x, q.y + 6.0, q.z - 1.2), 62.0));
  r = U(r, vec2(cylZ(vec3(abs(q.x) - 135.0, abs(q.y) - 90.0, q.z - 1.2), 3.0, 1.0, 0.5), STEEL));
  return r;
}

vec2 fences(vec3 p) {
  vec2 r = fencePanel(p - vec3(-750.0, 0.0, 900.0), 1100.0, 2000.0);
  r = U(r, fencePanel(p - vec3(1050.0, 0.0, 900.0), 500.0, 2000.0));
  r = U(r, fencePanel(vec3(p.x - 650.0 * sign(p.x), p.y, p.z + 900.0), 1300.0, 2000.0));
  r = U(r, fencePanel(vec3(p.z - 450.0 * sign(p.z), p.y, p.x + 1300.0), 900.0, 2000.0));
  r = U(r, fencePanel(vec3(p.z + 450.0, p.y, p.x - 1300.0), 900.0, 2000.0));
  r = U(r, vec2(rbox(vec3(p.x - 1300.0, p.y - 1000.0, abs(p.z - 450.0) - 450.0), vec3(25.0, 1000.0, 25.0), 3.0), YELLOW));
  r = U(r, sign2(toSign(p)));
  r = U(r, sign2(vec3(-(p.z - 450.0), p.y - 1500.0, p.x - 1318.0)));
  return r;
}

vec2 gate(vec3 p) {
  vec3 f = vec3(p.z - 450.0, p.y - 1075.0, p.x - 1300.0);
  vec2 fh = vec2(405.0, 900.0);
  vec2 r = vec2(max(abs(box2(f.xy, fh)) - 14.0, abs(f.z) - 14.0), MESH);
  if (gClear > 0.5) r = U(r, vec2(box(f, vec3(fh, 1.5)), MESHP));
  vec3 h = vec3(f.x + 405.0, abs(f.y) - 650.0, f.z);
  r = U(r, vec2(cylY(h - vec3(-22.0, 0.0, 0.0), 12.0, 45.0, 2.0), DARK));
  vec3 hd = vec3(f.x - 350.0, f.y - 30.0, f.z - 14.0);
  float handle = rbox(hd - vec3(0.0, 0.0, 45.0), vec3(12.0, 110.0, 12.0), 6.0);
  handle = min(handle, rbox(vec3(hd.x, abs(hd.y) - 95.0, hd.z - 24.0), vec3(10.0, 10.0, 24.0), 5.0));
  r = U(r, vec2(handle, DARK));
  return r;
}

vec2 interlock(vec3 p) {
  vec3 s = p - vec3(1356.0, 1100.0, 912.0);
  vec2 r = vec2(rbox(s, vec3(20.0, 62.0, 16.0), 4.0), YELLOW);
  float head = rbox(s - vec3(0.0, -76.0, 0.0), vec3(20.0, 16.0, 16.0), 3.0);
  head = max(head, -box(s - vec3(0.0, -76.0, -14.0), vec3(3.5, 9.0, 8.0)));
  r = U(r, vec2(head, BLACK));
  r = U(r, vec2(box(s - vec3(20.4, 18.0, 0.0), vec3(0.4, 22.0, 11.0)), PAPER));
  float screws = cylX(vec3(s.x - 20.0, abs(s.y) - 50.0, s.z), 3.0, 1.2, 0.6);
  r = U(r, vec2(screws, STEEL));
  r = U(r, vec2(cylX(s - vec3(20.0, -40.0, 8.0), 2.2, 1.0, 0.4), LGREEN));
  r = U(r, vec2(cylY(s - vec3(0.0, 72.0, 0.0), 8.0, 10.0, 2.0), BLACK));
  r = U(r, vec2(capsule(p, vec3(1356.0, 1185.0, 912.0), vec3(1356.0, 1240.0, 935.0), 4.0), CABLE));
  r = U(r, vec2(capsule(p, vec3(1356.0, 1240.0, 935.0), vec3(1340.0, 1980.0, 935.0), 4.0), CABLE));
  r = U(r, vec2(max(torusY(vec3(p.x - 1348.0, rep(p.y - 1300.0, 200.0), p.z - 935.0), 4.5, 1.4), abs(p.y - 1600.0) - 320.0), BLACK));
  vec3 a = p - vec3(1336.0, 1024.0, 860.0);
  float arm = rbox(a, vec3(22.0, 10.0, 3.0), 1.0);
  arm = min(arm, rbox(a - vec3(20.0, 0.0, 22.0), vec3(3.0, 7.0, 24.0), 1.5));
  r = U(r, vec2(arm, STEEL));
  r = U(r, vec2(rbox(p - vec3(1320.0, 1024.0, 860.0), vec3(6.0, 22.0, 18.0), 2.0), DARK));
  r = U(r, vec2(rbox(s + vec3(25.5, 0.0, 0.0), vec3(5.5, 72.0, 20.0), 1.5), DARK));
  return r;
}

vec2 curtainColumn(vec3 p, float side) {
  vec2 r = vec2(rbox(p - vec3(0.0, 6.0, 0.0), vec3(150.0, 6.0, 150.0), 3.0), DARK);
  r = U(r, vec2(rbox(p - vec3(0.0, 1000.0, 0.0), vec3(40.0, 990.0, 40.0), 4.0), MGREY));
  r = U(r, vec2(cylY(vec3(abs(p.x) - 110.0, p.y - 13.0, abs(p.z) - 110.0), 9.0, 2.0, 1.0), STEEL));
  vec3 c = vec3(-p.z * side, p.y - 380.0, (p.x - 55.0 * side) * side);
  r = U(r, lightCurtain(c, 1500.0));
  r = U(r, vec2(rbox(vec3(p.x - 44.0 * side, abs(p.y - 1130.0) - 640.0, p.z), vec3(6.0, 14.0, 24.0), 2.0), DARK));
  r = U(r, vec2(capsule(p, vec3(55.0 * side, 370.0, 0.0), vec3(45.0 * side, 3.5, -70.0), 3.5), CABLE));
  return r;
}

vec2 scanner(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(0.0, 78.0, 0.0), vec3(68.0, 72.0, 66.0), 10.0), YELLOW);
  float win = cylY(p - vec3(0.0, 186.0, 6.0), 52.0, 36.0, 6.0);
  r = U(r, vec2(win, GLASS));
  r = U(r, vec2(cylY(p - vec3(0.0, 230.0, 6.0), 56.0, 8.0, 5.0), DARK));
  r = U(r, vec2(box(p - vec3(0.0, 100.0, 66.5), vec3(42.0, 22.0, 0.6)), BLACK));
  r = U(r, vec2(cylZ(vec3(abs(p.x - 0.0) - 26.0, p.y - 40.0, p.z - 66.0), 2.4, 1.0, 0.5), LGREEN));
  r = U(r, vec2(rbox(p - vec3(0.0, 3.0, 0.0), vec3(100.0, 3.0, 95.0), 2.0), DARK));
  r = U(r, vec2(capsule(p, vec3(0.0, 40.0, -66.0), vec3(0.0, 4.0, -150.0), 4.0), CABLE));
  return r;
}

vec2 estopPost(vec3 p) {
  vec2 r = vec2(cylY(p - vec3(0.0, 8.0, 0.0), 170.0, 8.0, 3.0), DARK);
  r = U(r, vec2(rbox(p - vec3(0.0, 520.0, 0.0), vec3(32.0, 510.0, 32.0), 4.0), GREY));
  vec3 b = p - vec3(0.0, 1080.0, 0.0);
  r = U(r, vec2(rbox(b, vec3(75.0, 85.0, 60.0), 8.0), YELLOW));
  vec3 f = b - vec3(0.0, 0.0, 60.0);
  r = U(r, estop(f - vec3(0.0, 22.0, 0.0)));
  r = U(r, pushButton(f + vec3(0.0, 50.0, 0.0), BLUEP));
  r = U(r, vec2(cylY(b - vec3(0.0, -95.0, 0.0), 10.0, 12.0, 2.0), BLACK));
  return r;
}

float tape(vec3 p) {
  vec2 q = vec2(p.x - 300.0, p.z - 1450.0);
  float ring = abs(box2(q, vec2(560.0, 470.0))) - 25.0;
  return max(ring, abs(p.y - 0.6) - 0.6);
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(300.0, 1550.0, -50.0), vec3(680.0, 1500.0, 420.0)) < r.x) r = U(r, press(p));
  if (box(p - vec3(0.0, 1000.0, 0.0), vec3(1360.0, 1010.0, 960.0)) < r.x) r = U(r, fences(p));
  if (box(p - vec3(1300.0, 1075.0, 450.0), vec3(80.0, 930.0, 450.0)) < r.x) r = U(r, gate(p));
  if (box(p - vec3(1345.0, 1300.0, 900.0), vec3(50.0, 700.0, 70.0)) < r.x) r = U(r, interlock(p));
  if (box(p - vec3(-150.0, 1000.0, 950.0), vec3(160.0, 1000.0, 160.0)) < r.x) r = U(r, curtainColumn(p - vec3(-140.0, 0.0, 950.0), 1.0));
  if (box(p - vec3(740.0, 1000.0, 950.0), vec3(160.0, 1000.0, 160.0)) < r.x) r = U(r, curtainColumn(p - vec3(740.0, 0.0, 950.0), -1.0));
  if (box(p - vec3(-430.0, 130.0, 1080.0), vec3(110.0, 130.0, 160.0)) < r.x) r = U(r, scanner(p - vec3(-430.0, 0.0, 1080.0)));
  if (box(p - vec3(-820.0, 600.0, 1500.0), vec3(180.0, 600.0, 180.0)) < r.x) r = U(r, estopPost(p - vec3(-820.0, 0.0, 1500.0)));
  if (abs(p.y) < r.x) r = U(r, vec2(tape(p), HAZARD));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == HAZARD) {
    float s = step(0.5, fract((p.x + p.z + p.y) / 100.0));
    return mat(mix(vec3(0.82, 0.5, 0.01), vec3(0.02), s), 0.45, 0.0);
  }
  if (id == PAINT) return mat(vec3(0.045, 0.08, 0.12), 0.36, 0.0);
  if (id == BRONZE) return mat(vec3(0.75, 0.55, 0.3), 0.35, 1.0);
  if (id == ALU) return mat(vec3(0.8, 0.81, 0.83), 0.6, 1.0);
  return libMat(id, p, n);
}
