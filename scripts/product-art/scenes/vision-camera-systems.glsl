const vec3 BC = vec3(0.0, 800.0, -150.0);
const float BR = 1550.0;

const float PART = 50.0, RING = 51.0, TOTE = 52.0, CHUTE = 53.0, PADDLE = 54.0, LENSG = 55.0, REFLECT = 56.0, PLATE = 57.0, SCREEN = 60.0;

const vec3 CAB = vec3(-180.0, 0.0, -760.0);
const vec3 HMI = vec3(-260.0, 1270.0, -548.0);
const vec2 HMI_HS = vec2(150.0, 108.0);

float profile(vec3 q, vec3 hs) {
  float d = rbox(q, hs, 2.5);
  vec3 a = abs(q);
  float slots;
  if (hs.y > hs.x && hs.y > hs.z) slots = min(box(vec3(a.x - hs.x, q.y, q.z), vec3(3.5, hs.y + 1.0, 3.2)), box(vec3(q.x, q.y, a.z - hs.z), vec3(3.2, hs.y + 1.0, 3.5)));
  else slots = min(box(vec3(a.x - hs.x, q.y, q.z), vec3(3.5, 3.2, hs.z + 1.0)), box(vec3(q.x, a.y - hs.y, q.z), vec3(3.2, 3.5, hs.z + 1.0)));
  return max(d, -slots);
}

vec2 flangePart(vec3 q) {
  float d = cylY(q - vec3(0.0, 6.0, 0.0), 45.0, 6.0, 1.2);
  d = min(d, cylY(q - vec3(0.0, 24.0, 0.0), 25.0, 18.0, 1.5));
  d = max(d, -cylY(q - vec3(0.0, 24.0, 0.0), 12.0, 30.0, 0.0));
  float a = atan(q.z, q.x);
  float sa = rep(a + 0.785398, 1.570796);
  vec2 hp = length(q.xz) * vec2(cos(sa), sin(sa));
  d = max(d, -(length(hp - vec2(34.0, 0.0)) - 5.5));
  return vec2(d, PART);
}

vec2 camera(vec3 q) {
  float body = rbox(q - vec3(0.0, 180.0, 0.0), vec3(31.0, 46.0, 31.0), 3.0);
  body = max(body, -box(vec3(rep(q.x, 8.0), q.y - 196.0, abs(q.z) - 31.0), vec3(1.6, 26.0, 2.0)));
  vec2 r = vec2(body, DARK);
  r = U(r, vec2(rbox(q - vec3(0.0, 131.0, 0.0), vec3(28.0, 3.0, 28.0), 1.0), BLACK));
  float lens = cylY(q - vec3(0.0, 102.0, 0.0), 19.0, 26.0, 1.5);
  float rings = cylY(vec3(q.x, rep(q.y - 98.0, 14.0), q.z), 20.0, 3.2, 1.2) + 0.3 * step(0.0, sin(atan(q.z, q.x) * 40.0));
  rings = max(rings, abs(q.y - 104.0) - 20.0);
  r = U(r, vec2(lens, BLACK));
  r = U(r, vec2(rings, MGREY));
  r = U(r, vec2(cylY(q - vec3(0.0, 76.0, 0.0), 13.0, 0.8, 0.4), LENSG));
  r = U(r, vec2(cylY(q - vec3(0.0, 234.0, 0.0), 7.0, 8.0, 1.0), STEEL));
  float mount = rbox(q - vec3(0.0, 185.0, -42.0), vec3(40.0, 70.0, 6.0), 2.0);
  r = U(r, vec2(mount, ALU));
  float housing = cylY(q - vec3(0.0, -48.0, 0.0), 78.0, 11.0, 4.0);
  housing = max(housing, -cylY(q - vec3(0.0, -48.0, 0.0), 36.0, 20.0, 0.0));
  r = U(r, vec2(housing, BLACK));
  float glowRing = max(cylY(q - vec3(0.0, -60.0, 0.0), 79.0, 4.0, 1.0), -cylY(q - vec3(0.0, -60.0, 0.0), 32.0, 6.0, 0.0));
  glowRing = min(glowRing, max(cylY(q - vec3(0.0, -50.0, 0.0), 37.0, 9.0, 0.0), -cylY(q - vec3(0.0, -50.0, 0.0), 32.0, 12.0, 0.0)));
  r = U(r, vec2(glowRing, RING));
  float rods = cylY(vec3(abs(q.x) - 60.0, q.y - 60.0, q.z + 30.0), 4.0, 100.0, 1.0);
  r = U(r, vec2(rods, STEEL));
  r = U(r, vec2(rbox(q - vec3(0.0, 160.0, -30.0), vec3(70.0, 8.0, 10.0), 2.0), ALU));
  return r;
}

vec2 pusher(vec3 p) {
  vec3 c = vec3(520.0 - p.z, p.y - 845.0, p.x - 380.0);
  vec2 r = pneuCylinder(c, 50.0, 250.0, 206.0);
  r = U(r, vec2(rbox(vec3(p.x - 380.0, p.y - 846.0, p.z - 15.0), vec3(65.0, 24.0, 5.0), 2.0), PADDLE));
  float plate = box(vec3(p.x - 380.0, p.y - 807.0, p.z - 361.0), vec3(44.0, 4.0, 179.0));
  plate = min(plate, box(vec3(p.x - 380.0, p.y - 774.5, p.z - 186.0), vec3(44.0, 36.5, 5.0)));
  r = U(r, vec2(plate, ALU));
  r = U(r, vec2(cylY(vec3(abs(p.x - 380.0) - 32.0, p.y - 811.5, abs(p.z - 361.0) - 150.0), 5.0, 1.5, 0.8), STEEL));
  r = U(r, vec2(profile(vec3(p.x - 380.0, p.y - 401.5, p.z - 500.0), vec3(20.0, 401.5, 20.0)), ALU));
  r = U(r, vec2(cylY(vec3(p.x - 380.0, p.y - 6.0, p.z - 500.0), 28.0, 6.0, 2.0), BLACK));
  float hose = capsule(p, vec3(380.0, 893.0, 511.0), vec3(380.0, 915.0, 522.0), 4.0);
  hose = min(hose, capsule(p, vec3(380.0, 915.0, 522.0), vec3(406.0, 880.0, 525.0), 4.0));
  hose = min(hose, capsule(p, vec3(406.0, 880.0, 525.0), vec3(406.0, 30.0, 522.0), 4.0));
  hose = min(hose, capsule(p, vec3(406.0, 30.0, 522.0), vec3(410.0, 4.0, 600.0), 4.0));
  hose = min(hose, capsule(p, vec3(410.0, 4.0, 600.0), vec3(430.0, 4.0, 1100.0), 4.0));
  hose = min(hose, capsule(p, vec3(380.0, 893.0, 243.0), vec3(382.0, 918.0, 258.0), 4.0));
  hose = min(hose, capsule(p, vec3(382.0, 918.0, 258.0), vec3(398.0, 906.0, 470.0), 4.0));
  hose = min(hose, capsule(p, vec3(398.0, 906.0, 470.0), vec3(414.0, 870.0, 520.0), 4.0));
  hose = min(hose, capsule(p, vec3(414.0, 870.0, 520.0), vec3(414.0, 30.0, 520.0), 4.0));
  hose = min(hose, capsule(p, vec3(414.0, 30.0, 520.0), vec3(418.0, 4.0, 600.0), 4.0));
  hose = min(hose, capsule(p, vec3(418.0, 4.0, 600.0), vec3(440.0, 4.0, 1100.0), 4.0));
  r = U(r, vec2(hose, BLUEP));
  r = U(r, vec2(rbox(vec3(p.x - 410.0, repLim(p.y - 450.0, 300.0, -1.0, 1.0), p.z - 521.0), vec3(11.0, 2.0, 6.0), 1.4), BLACK));
  return r;
}

vec2 rejectSide(vec3 p) {
  vec3 t = p - vec3(380.0, 0.0, -470.0);
  float tote = rbox(t - vec3(0.0, 150.0, 0.0), vec3(200.0, 150.0, 150.0), 10.0);
  tote = max(tote, -rbox(t - vec3(0.0, 170.0, 0.0), vec3(188.0, 150.0, 138.0), 8.0));
  float rim = max(rbox(t - vec3(0.0, 292.0, 0.0), vec3(208.0, 8.0, 158.0), 4.0), -box(t - vec3(0.0, 292.0, 0.0), vec3(188.0, 20.0, 138.0)));
  vec2 r = vec2(min(tote, rim), TOTE);
  vec3 c = p - vec3(380.0, 0.0, 0.0);
  vec2 s = vec2(c.z + 185.0, c.y - 812.0);
  vec2 dir = normalize(vec2(-170.0, -330.0));
  float along = clamp(dot(s, dir), 0.0, 380.0);
  float sheet = length(s - dir * along) - 1.5;
  sheet = max(sheet, abs(c.x) - 85.0);
  vec2 off = s - dir * along;
  float walls = max(max(length(off) - 60.0, abs(abs(c.x) - 86.0) - 1.5), dot(off, vec2(-dir.y, dir.x)));
  r = U(r, vec2(min(sheet, walls), CHUTE));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 420.0, 0.0), vec3(910.0, 420.0, 200.0)) < r.x) r = U(r, beltConveyor(p, 1800.0, 300.0, 800.0, BELT));
  float cell = clamp(round((p.x + 250.0) / 350.0), -1.0, 1.0);
  vec3 pq = vec3(p.x + 250.0 - cell * 350.0, p.y - 800.0, p.z - cell * 14.0 - 6.0);
  pq.xz = rot(0.3 + cell * 0.7) * pq.xz;
  if (box(pq - vec3(0.0, 21.0, 0.0), vec3(47.0, 22.0, 47.0)) < r.x) r = U(r, flangePart(pq));
  vec3 rq = p - vec3(380.0, 800.0, -15.0);
  if (box(rq - vec3(0.0, 21.0, 0.0), vec3(47.0, 22.0, 47.0)) < r.x) r = U(r, flangePart(rq));
  vec3 g = p - vec3(-250.0, 0.0, 0.0);
  if (box(g - vec3(0.0, 1110.0, 0.0), vec3(60.0, 360.0, 240.0)) < r.x) {
    float up = profile(vec3(g.x, g.y - 1090.0, abs(g.z) - 202.0), vec3(20.0, 350.0, 20.0));
    float beam = profile(g - vec3(0.0, 1460.0, 0.0), vec3(20.0, 20.0, 222.0));
    float clamps = rbox(vec3(g.x, g.y - 780.0, abs(g.z) - 188.0), vec3(34.0, 40.0, 8.0), 2.0);
    r = U(r, vec2(min(min(up, beam), clamps), ALU));
    float slide = rbox(g - vec3(0.0, 1350.0, -44.0), vec3(40.0, 92.0, 4.0), 1.5);
    r = U(r, vec2(slide, DARK));
    vec3 cq = g - vec3(0.0, 1000.0, 0.0);
    if (box(cq - vec3(0.0, 120.0, 0.0), vec3(82.0, 140.0, 82.0)) < r.x) r = U(r, camera(cq));
    float lead = capsule(g, vec3(0.0, 1242.0, 0.0), vec3(0.0, 1300.0, 0.0), 3.5);
    lead = smin(lead, capsule(g, vec3(0.0, 1300.0, 0.0), vec3(0.0, 1330.0, -30.0), 3.5), 2.0);
    lead = smin(lead, capsule(g, vec3(0.0, 1330.0, -30.0), vec3(0.0, 1425.0, -30.0), 3.5), 2.0);
    lead = smin(lead, capsule(g, vec3(0.0, 1425.0, -30.0), vec3(-25.0, 1452.0, -48.0), 3.5), 2.0);
    lead = smin(lead, capsule(g, vec3(-25.0, 1452.0, -48.0), vec3(-25.0, 1452.0, -196.0), 3.5), 2.0);
    lead = smin(lead, capsule(g, vec3(-25.0, 1452.0, -196.0), vec3(-25.5, 1420.0, -205.0), 3.5), 2.0);
    lead = min(lead, capsule(g, vec3(-25.5, 1420.0, -205.0), vec3(-25.5, 760.0, -205.0), 3.5));
    r = U(r, vec2(lead, CABLE));
    float ties = rbox(vec3(g.x + 25.5, repLim(g.y - 1300.0, 120.0, -4.0, 1.0), g.z + 205.0), vec3(5.4, 2.0, 5.4), 1.4);
    ties = min(ties, rbox(vec3(g.x + 25.0, g.y - 1452.0, repLim(g.z + 120.0, 70.0, -1.0, 1.0)), vec3(5.4, 5.4, 2.0), 1.4));
    r = U(r, vec2(ties, BLACK));
    float screws = cylZ(vec3(abs(g.x) - 22.0, abs(g.y - 780.0) - 26.0, abs(g.z) - 196.8), 4.5, 1.4, 0.8);
    r = U(r, vec2(screws, STEEL));
  }
  float floorCable = capsule(p, vec3(-275.5, 760.0, -205.0), vec3(-275.5, 380.0, -260.0), 4.5);
  floorCable = min(floorCable, capsule(p, vec3(-275.5, 380.0, -260.0), vec3(-260.0, 4.5, -330.0), 4.5));
  floorCable = min(floorCable, capsule(p, vec3(-260.0, 4.5, -330.0), vec3(-215.0, 4.5, -540.0), 4.5));
  floorCable = min(floorCable, capsule(p, vec3(-215.0, 4.5, -540.0), vec3(-215.0, 60.0, -556.0), 4.5));
  r = U(r, vec2(floorCable, CABLE));
  r = U(r, vec2(rbox(p - vec3(560.0, 770.0, 180.7), vec3(40.0, 16.0, 0.6), 1.2), PLATE));
  vec3 sq = p - vec3(-460.0, 828.0, 196.0);
  if (box(sq, vec3(30.0, 40.0, 30.0)) < r.x) {
    float body = rbox(sq - vec3(0.0, 4.0, 0.0), vec3(10.0, 25.0, 16.0), 2.5);
    r = U(r, vec2(body, MGREY));
    r = U(r, vec2(rbox(sq - vec3(0.0, 8.0, -15.0), vec3(7.0, 13.0, 2.0), 1.5), LENSG));
    r = U(r, vec2(cylY(sq - vec3(-4.0, 29.4, 6.0), 1.8, 0.6, 0.4), LAMBER));
    r = U(r, vec2(box(sq - vec3(0.0, -28.0, -6.0), vec3(18.0, 2.0, 22.0)), ZINC));
  }
  r = U(r, vec2(cylZ(p - vec3(-460.0, 836.0, -184.0), 22.0, 3.0, 1.5), REFLECT));
  if (box(p - vec3(380.0, 470.0, 560.0), vec3(90.0, 470.0, 560.0)) < r.x) r = U(r, pusher(p));
  if (box(p - vec3(380.0, 450.0, -380.0), vec3(220.0, 420.0, 260.0)) < r.x) r = U(r, rejectSide(p));
  vec3 k = p - CAB;
  if (box(k - vec3(0.0, 1000.0, 0.0), vec3(320.0, 1010.0, 230.0)) < r.x) {
    r = U(r, cabinet(k, vec3(600.0, 1700.0, 400.0)));
    r = U(r, hmiPanel(p - HMI, HMI_HS, 40.0, 14.0, SCREEN));
    r = U(r, towerLight(k - vec3(200.0, 1700.0, 0.0), 0.0));
    vec3 ip = k - vec3(-150.0, 560.0, 200.6);
    r = U(r, vec2(rbox(ip, vec3(50.0, 30.0, 0.6), 1.5), PLATE));
    r = U(r, vec2(cylZ(vec3(abs(ip.x) - 45.0, abs(ip.y) - 25.0, ip.z - 0.7), 1.5, 0.6, 0.4), STEEL));
    vec3 w = k - vec3(-260.0, 1520.0, 200.6);
    float tri = max(max(-w.y - 20.0, dot(w.xy, vec2(0.866, 0.5)) - 20.0), dot(w.xy, vec2(-0.866, 0.5)) - 20.0);
    r = U(r, vec2(max(tri, abs(w.z) - 0.6), YELLOW));
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == SCREEN) {
    vec2 hs = HMI_HS - 14.0;
    vec2 uv = (p.xy - HMI.xy + hs) / (2.0 * hs);
    return screen(screenVision(uv, 4.0));
  }
  if (id == PART) return mat(vec3(0.82, 0.81, 0.78), 0.24 + 0.08 * vnoise(p * 0.4), 1.0);
  if (id == RING) return glow(vec3(0.9), 0.1, vec3(3.2, 3.25, 3.4));
  if (id == TOTE) return mat(vec3(0.45, 0.03, 0.02), 0.42, 0.0);
  if (id == CHUTE) return mat(vec3(0.8, 0.8, 0.79), 0.3, 1.0);
  if (id == PADDLE) return mat(vec3(0.78, 0.78, 0.76), 0.35, 0.0);
  if (id == LENSG) return mat(vec3(0.01, 0.012, 0.02), 0.04, 0.0);
  if (id == REFLECT) return mat(vec3(0.5, 0.02, 0.02), 0.2, 0.0);
  if (id == PLATE) return mat(vec3(0.78, 0.79, 0.8), 0.36 + 0.06 * vnoise(p * vec3(0.4, 0.02, 0.02)), 1.0);
  return libMat(id, p, n);
}
