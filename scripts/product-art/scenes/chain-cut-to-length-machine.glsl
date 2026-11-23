const vec3 BC = vec3(150.0, 900.0, 0.0);
const float BR = 2300.0;

const float CHAINC = 50.0, MACHINE = 51.0, SCREEN = 52.0, GUARD = 53.0, COIL = 54.0, TRAYST = 55.0;
const float CHAIN_Y = 935.0;
const vec2 HMI_C = vec2(1650.0, 1330.0);
const vec2 HMI_HS = vec2(165.0, 120.0);

float link(vec3 q) {
  vec3 a = vec3(max(abs(q.x) - 13.0, 0.0), q.y, q.z);
  return length(vec2(length(a.xy) - 11.0, a.z)) - 4.5;
}

float chainRun(vec3 q, float n) {
  float pitch = 36.0;
  float d = link(vec3(repLim(q.x, 2.0 * pitch, -n, n), q.y, q.z));
  return min(d, link(vec3(repLim(q.x - pitch, 2.0 * pitch, -n, n - 1.0), q.z, q.y)));
}

float chainSpan(vec3 p, vec3 a, vec3 b) {
  vec2 d = normalize(b.xy - a.xy);
  vec3 q = p - (a + b) * 0.5;
  float len = length(b.xy - a.xy);
  vec3 l = vec3(dot(q.xy, d), dot(q.xy, vec2(-d.y, d.x)), q.z);
  return max(chainRun(l, floor(len / 144.0)), abs(l.x) - len * 0.5);
}

vec2 reel(vec3 p) {
  vec3 q = p - vec3(-1450.0, 0.0, 0.0);
  vec2 r = vec2(rbox(q - vec3(0.0, 30.0, 0.0), vec3(320.0, 30.0, 260.0), 4.0), MACHINE);
  vec3 u = vec3(q.x, q.y - 380.0, abs(q.z) - 210.0);
  r = U(r, vec2(rbox(u, vec3(35.0, 350.0, 22.0), 3.0), MACHINE));
  r = U(r, vec2(cylZ(q - vec3(0.0, 720.0, 0.0), 28.0, 240.0, 2.0), STEEL));
  vec3 f = vec3(q.x, q.y - 720.0, abs(q.z) - 140.0);
  float flange = max(cylZ(f, 390.0, 7.0, 2.0), -cylZ(f, 60.0, 9.0, 0.0));
  r = U(r, vec2(flange, DARK));
  r = U(r, vec2(cylZ(q - vec3(0.0, 720.0, 0.0), 330.0, 132.0, 6.0), COIL));
  return r;
}

vec2 table(vec3 p) {
  vec3 q = p - vec3(50.0, 440.0, 0.0);
  float body = rbox(q, vec3(1050.0, 440.0, 360.0), 6.0);
  float seams = box(vec3(abs(q.x) - 350.0, q.y + 30.0, q.z - 360.0), vec3(1.5, 360.0, 4.0));
  seams = min(seams, box(vec3(abs(q.x) - 1000.0, q.y + 30.0, q.z - 360.0), vec3(1.5, 360.0, 4.0)));
  body = max(body, -seams);
  vec2 r = vec2(body, MACHINE);
  vec3 h = vec3(abs(abs(q.x) - 675.0) - 140.0, q.y - 230.0, q.z - 366.0);
  r = U(r, vec2(rbox(h, vec3(8.0, 30.0, 6.0), 3.0), BLACK));
  r = U(r, vec2(box(p - vec3(50.0, 40.0, 0.0), vec3(1030.0, 40.0, 340.0)), DARK));
  r = U(r, vec2(rbox(p - vec3(50.0, 890.0, 0.0), vec3(1070.0, 10.0, 380.0), 3.0), STEEL));
  r = U(r, vec2(box(p - vec3(-160.0, 903.0, 0.0), vec3(820.0, 3.0, 46.0)), STEEL));
  r = U(r, vec2(rbox(vec3(p.x + 160.0, p.y - 925.0, abs(p.z) - 43.0), vec3(820.0, 22.0, 3.0), 1.0), STEEL));
  return r;
}

vec2 feed(vec3 p) {
  vec3 q = p - vec3(-560.0, 0.0, 0.0);
  vec2 r = vec2(rbox(q - vec3(0.0, 1065.0, -10.0), vec3(130.0, 85.0, 120.0), 8.0), MACHINE);
  r = U(r, vec2(rbox(q - vec3(-60.0, 1095.0, 111.0), vec3(32.0, 22.0, 1.5), 2.0), YELLOW));
  r = U(r, vec2(rbox(vec3(abs(q.x) - 95.0, abs(q.y - 1065.0) - 55.0, q.z - 111.0), vec3(5.0, 5.0, 3.0), 2.0), STEEL));
  r = U(r, vec2(cylZ(q - vec3(-70.0, 982.0, 0.0), 32.0, 60.0, 3.0), RUBBER));
  r = U(r, vec2(cylZ(q - vec3(70.0, 982.0, 0.0), 32.0, 60.0, 3.0), RUBBER));
  r = U(r, vec2(cylZ(q - vec3(0.0, 1065.0, -200.0), 72.0, 75.0, 6.0), BLUE));
  r = U(r, vec2(max(cylZ(vec3(q.x, q.y - 1065.0, rep(q.z + 200.0, 16.0)), 77.0, 2.5, 1.0), abs(q.z + 200.0) - 60.0), BLUE));
  r = U(r, vec2(rbox(q - vec3(0.0, 1150.0, -200.0), vec3(40.0, 18.0, 45.0), 3.0), BLUE));
  r = U(r, vec2(cylZ(q - vec3(0.0, 1065.0, -285.0), 50.0, 12.0, 6.0), DARK));
  return r;
}

vec2 encoder(vec3 p) {
  vec3 q = p - vec3(-170.0, 0.0, 0.0);
  float wy = CHAIN_Y + 15.5 + 34.0;
  vec2 r = vec2(cylZ(q - vec3(0.0, wy, 0.0), 34.0, 9.0, 2.0), CHROME);
  r = U(r, vec2(cylZ(q - vec3(0.0, wy, 0.0), 10.0, 40.0, 1.0), STEEL));
  r = U(r, vec2(rbox(q - vec3(0.0, wy, -65.0), vec3(14.0, 14.0, 30.0), 3.0), MACHINE));
  r = U(r, vec2(rbox(q - vec3(-60.0, wy + 30.0, -95.0), vec3(80.0, 10.0, 10.0), 3.0), MACHINE));
  r = U(r, vec2(rbox(q - vec3(-130.0, 960.0, -95.0), vec3(12.0, 70.0, 12.0), 3.0), MACHINE));
  r = U(r, vec2(cylZ(q - vec3(0.0, wy, 46.0), 24.0, 16.0, 3.0), BLACK));
  r = U(r, vec2(cylZ(q - vec3(0.0, wy, 64.0), 6.0, 4.0, 1.0), DARK));
  return r;
}

vec2 cutter(vec3 p) {
  vec3 q = p - vec3(720.0, 0.0, 0.0);
  vec2 r = vec2(rbox(vec3(q.x, q.y - 1050.0, abs(q.z) - 80.0), vec3(60.0, 150.0, 10.0), 3.0), MACHINE);
  r = U(r, vec2(rbox(q - vec3(0.0, 1214.0, 0.0), vec3(70.0, 14.0, 95.0), 3.0), MACHINE));
  r = U(r, vec2(rbox(q - vec3(0.0, 1005.0, 0.0), vec3(4.0, 42.0, 60.0), 1.0), CHROME));
  r = U(r, vec2(rbox(q - vec3(0.0, 1075.0, 0.0), vec3(32.0, 26.0, 62.0), 3.0), DARK));
  r = U(r, pneuCylinder(vec3(1470.0 - q.y, q.x, q.z), 80.0, 160.0, 190.0));
  vec3 b = vec3(abs(q.x) - 200.0, q.y - 1100.0, abs(q.z) - 170.0);
  float post = rbox(b, vec3(12.0, 200.0, 12.0), 2.0);
  post = min(post, rbox(vec3(q.x, q.y - 1300.0, abs(q.z) - 170.0), vec3(212.0, 12.0, 12.0), 2.0));
  post = min(post, rbox(vec3(abs(q.x) - 200.0, q.y - 1300.0, q.z), vec3(12.0, 12.0, 182.0), 2.0));
  r = U(r, vec2(post, YELLOW));
  if (gClear > 0.5) {
    float sides = box(vec3(q.x, q.y - 1100.0, abs(q.z) - 170.0), vec3(188.0, 188.0, 2.0));
    float top = box(vec3(q.x, q.y - 1300.0, q.z), vec3(188.0, 2.0, 158.0));
    r = U(r, vec2(min(sides, top), GUARD));
  }
  return r;
}

vec2 tray(vec3 p) {
  vec3 q = p - vec3(985.0, 900.0, 0.0);
  float outer = rbox(q - vec3(0.0, 28.0, 0.0), vec3(125.0, 28.0, 200.0), 3.0);
  float inner = box(q - vec3(0.0, 34.0, 0.0), vec3(120.0, 30.0, 195.0));
  vec2 r = vec2(max(outer, -inner), TRAYST);
  for (int i = 0; i < 3; i++) {
    float fi = float(i);
    vec3 c = q - vec3(-5.0 + 8.0 * sin(fi * 2.1), 25.0 + 9.0 * fi, -110.0 + 105.0 * fi);
    c.xz = rot(0.12 * (fi - 1.0) + 0.05) * c.xz;
    r = U(r, vec2(max(chainRun(c, 1.0), abs(c.x) - 110.0), CHAINC));
  }
  return r;
}

vec2 cabinetUnit(vec3 p) {
  vec3 q = p - vec3(1650.0, 0.0, -150.0);
  vec2 r = cabinet(q, vec3(600.0, 1800.0, 400.0));
  float front = 200.0;
  r = U(r, hmiPanel(vec3(p.xy - HMI_C, q.z - front - 9.0), HMI_HS, 6.0, 16.0, SCREEN));
  vec3 f = vec3(q.x, q.y, q.z - front);
  r = U(r, pushButton(f - vec3(-110.0, 1100.0, 0.0), GREEN));
  r = U(r, pushButton(f - vec3(-40.0, 1100.0, 0.0), RED));
  r = U(r, pilotLight(f - vec3(30.0, 1100.0, 0.0), LGREEN));
  r = U(r, selectorSwitch(f - vec3(100.0, 1100.0, 0.0), 0.6));
  r = U(r, estop(f - vec3(0.0, 990.0, 0.0)));
  r = U(r, vec2(rbox(f - vec3(0.0, 1500.0, 1.0), vec3(90.0, 18.0, 1.0), 0.6), PAPER));
  r = U(r, towerLight(q - vec3(220.0, 1800.0, -120.0), 0.0));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(-1450.0, 560.0, 0.0), vec3(400.0, 560.0, 270.0)) < r.x) r = U(r, reel(p));
  if (box(p - vec3(50.0, 470.0, 0.0), vec3(1080.0, 470.0, 390.0)) < r.x) r = U(r, table(p));
  if (box(p - vec3(-560.0, 1060.0, -110.0), vec3(140.0, 100.0, 200.0)) < r.x) r = U(r, feed(p));
  if (box(p - vec3(-240.0, 1000.0, -30.0), vec3(110.0, 80.0, 110.0)) < r.x) r = U(r, encoder(p));
  if (box(p - vec3(720.0, 1240.0, 0.0), vec3(220.0, 340.0, 190.0)) < r.x) r = U(r, cutter(p));
  if (box(p - vec3(985.0, 950.0, 0.0), vec3(135.0, 60.0, 210.0)) < r.x) r = U(r, tray(p));
  if (box(p - vec3(-1150.0, 980.0, 0.0), vec3(260.0, 90.0, 40.0)) < r.x) r = U(r, vec2(chainSpan(p, vec3(-1450.0, 1050.0, 0.0), vec3(-960.0, CHAIN_Y, 0.0)), CHAINC));
  if (box(p - vec3(-160.0, CHAIN_Y, 0.0), vec3(830.0, 20.0, 20.0)) < r.x) r = U(r, vec2(max(chainRun(p - vec3(-160.0, CHAIN_Y, 0.0), 11.0), abs(p.x + 160.0) - 815.0), CHAINC));
  if (box(p - vec3(1650.0, 1000.0, -100.0), vec3(320.0, 1100.0, 290.0)) < r.x) r = U(r, cabinetUnit(p));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == CHAINC) return mat(vec3(0.42, 0.43, 0.45) * (0.75 + 0.35 * fbm(p * 0.3)), 0.32, 1.0);
  if (id == COIL) {
    float links = 0.5 + 0.5 * sin(atan(p.y - 720.0, p.x + 1450.0) * 60.0) * sin(p.z * 0.2);
    return mat(vec3(0.3, 0.31, 0.33) * (0.55 + 0.45 * links) * (0.85 + 0.3 * fbm(p * 0.05)), 0.42, 1.0);
  }
  if (id == MACHINE) return mat(vec3(0.6, 0.62, 0.6) * (0.96 + 0.08 * fbm(p * 0.01)), 0.45, 0.0);
  if (id == TRAYST) return mat(vec3(0.66, 0.67, 0.68), 0.38, 1.0);
  if (id == GUARD) return clearMat(vec3(0.97, 0.98, 0.99), 0.03, 0.95);
  if (id == SCREEN) {
    vec2 uv = (p.xy - (HMI_C - HMI_HS + 16.0)) / (2.0 * (HMI_HS - 16.0));
    return screen(screenHmi(uv, 3.0));
  }
  return libMat(id, p, n);
}
