const vec3 BC = vec3(150.0, 1150.0, 200.0);
const float BR = 1950.0;

const float PLATE = 50.0, SCREEN = 51.0, PART = 52.0, ANODIZED = 53.0, GUARD = 54.0, HMI_ANGLE = -0.41;
const vec3 HMI_AT = vec3(800.0, 1430.0, 520.0);

float extr(vec3 q, float h, float w) {
  float d = rbox(q, vec3(w, h, w), 2.5);
  vec3 a = abs(q);
  float g = min(box(vec3(a.x - w, q.y, q.z), vec3(3.5, h + 1.0, 4.0)), box(vec3(q.x, q.y, a.z - w), vec3(4.0, h + 1.0, 3.5)));
  return max(d, -g);
}

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

vec2 baseCabinet(vec3 p) {
  vec3 q = p - vec3(0.0, 490.0, 0.0);
  vec3 hs = vec3(600.0, 390.0, 400.0);
  float body = rbox(q, hs, 6.0);
  float seam = max(abs(box2(vec2(abs(q.x) - 300.0, q.y), vec2(278.0, 360.0))) - 1.4, abs(q.z - hs.z) - 3.0);
  body = max(body, -seam);
  vec2 r = vec2(body, GREY);
  vec3 hq = vec3(abs(q.x) - 62.0, q.y - 120.0, q.z - hs.z - 9.0);
  float handle = rbox(hq, vec3(9.0, 62.0, 7.0), 4.0);
  handle = min(handle, rbox(hq + vec3(0.0, 0.0, 6.0), vec3(14.0, 80.0, 3.0), 2.0));
  r = U(r, vec2(handle, BLACK));
  vec3 fq = vec3(abs(p.x) - 540.0, p.y, abs(p.z) - 340.0);
  r = U(r, vec2(cylY(fq - vec3(0.0, 60.0, 0.0), 11.0, 42.0, 1.0), STEEL));
  r = U(r, vec2(cylY(fq - vec3(0.0, 12.0, 0.0), 40.0, 12.0, 4.0), BLACK));
  vec3 sq = vec3(q.x - hs.x, q.y - 180.0, q.z - 180.0);
  r = U(r, vec2(rbox(sq - vec3(1.5, 0.0, 0.0), vec3(1.5, 52.0, 52.0), 3.0), YELLOW));
  float hub = cylX(sq - vec3(12.0, 0.0, 0.0), 22.0, 9.0, 4.0);
  hub = smin(hub, rbox(sq - vec3(20.0, 22.0, 0.0), vec3(8.0, 42.0, 11.0), 5.0), 6.0);
  r = U(r, vec2(hub, RED));
  r = U(r, warning(vec3(abs(q.x) - 300.0, q.y - 250.0, q.z - hs.z), 45.0));
  r = U(r, idPlate(vec3(-(q.z - 150.0), q.y + 200.0, q.x - hs.x), vec2(60.0, 38.0)));
  return r;
}

vec2 frame(vec3 p) {
  vec2 r = vec2(extr(vec3(abs(p.x) - 577.5, p.y - 1460.0, abs(p.z) - 377.5), 540.0, 22.5), ALU);
  r = U(r, vec2(extr(vec3(p.y - 1977.5, p.x, abs(p.z) - 377.5), 555.0, 22.5), ALU));
  r = U(r, vec2(extr(vec3(abs(p.x) - 577.5, p.z, p.y - 1977.5), 355.0, 22.5), ALU));
  r = U(r, vec2(extr(vec3(abs(p.x) - 577.5, p.z, p.y - 942.5), 355.0, 22.5), ALU));
  r = U(r, vec2(extr(vec3(p.y - 942.5, p.x, p.z + 377.5), 555.0, 22.5), ALU));
  if (gClear > 0.5) {
    float side = box(vec3(abs(p.x) - 577.5, p.y - 1460.0, p.z), vec3(2.0, 495.0, 355.0));
    float back = box(vec3(p.x, p.y - 1460.0, p.z + 377.5), vec3(555.0, 495.0, 2.0));
    r = U(r, vec2(min(side, back), GUARD));
  }
  return r;
}

vec2 press(vec3 p) {
  vec2 r = vec2(box(p - vec3(0.0, 2010.0, 40.0), vec3(600.0, 10.0, 150.0)), ANODIZED);
  float bolts = cylY(vec3(abs(p.x) - 577.5, p.y - 2022.0, abs(p.z - 40.0) - 110.0), 7.5, 3.0, 1.5);
  r = U(r, vec2(bolts, STEEL));
  vec3 c = vec3(2296.0 - p.y, p.x, p.z - 40.0);
  r = U(r, pneuCylinder(c, 100.0, 240.0, 728.0));
  vec3 g = vec3(abs(p.x) - 120.0, p.y, p.z - 40.0);
  r = U(r, vec2(cylY(g - vec3(0.0, 1670.0, 0.0), 16.0, 400.0, 1.0), CHROME));
  r = U(r, vec2(cylY(g - vec3(0.0, 1975.0, 0.0), 30.0, 25.0, 3.0), STEEL));
  r = U(r, vec2(cylY(g - vec3(0.0, 2062.0, 0.0), 24.0, 8.0, 2.0), DARK));
  r = U(r, vec2(rbox(p - vec3(0.0, 1270.0, 40.0), vec3(165.0, 18.0, 70.0), 3.0), PLATE));
  r = U(r, vec2(cylY(g - vec3(0.0, 1270.0, 0.0), 30.0, 22.0, 2.0), STEEL));
  r = U(r, vec2(rbox(p - vec3(0.0, 1232.0, 40.0), vec3(45.0, 20.0, 45.0), 2.0), DARK));
  r = U(r, vec2(cylY(p - vec3(0.0, 1175.0, 40.0), 24.0, 38.0, 3.0), CHROME));
  return r;
}

vec2 fixture(vec3 p) {
  vec3 f = p - vec3(0.0, 920.0, 40.0);
  vec2 r = vec2(rbox(f - vec3(0.0, 22.0, 0.0), vec3(175.0, 22.0, 135.0), 3.0), ANODIZED);
  float nest = cylY(f - vec3(0.0, 62.0, 0.0), 72.0, 18.0, 2.0);
  nest = max(nest, -cylY(f - vec3(0.0, 80.0, 0.0), 51.0, 6.0, 0.0));
  r = U(r, vec2(nest, ALU));
  float part = cylY(f - vec3(0.0, 96.0, 0.0), 50.0, 22.0, 2.5);
  part = smin(part, cylY(f - vec3(0.0, 124.0, 0.0), 30.0, 10.0, 2.0), 3.0);
  part = max(part, -cylY(f - vec3(0.0, 120.0, 0.0), 13.0, 30.0, 0.0));
  r = U(r, vec2(part, PART));
  float pins = cylY(vec3(abs(f.x) - 130.0, f.y - 52.0, abs(f.z) - 95.0), 7.0, 8.0, 2.0);
  r = U(r, vec2(pins, CHROME));
  float screws = cylY(vec3(abs(f.x) - 150.0, f.y - 45.0, abs(f.z) - 30.0), 6.0, 1.5, 0.6);
  r = U(r, vec2(screws, STEEL));
  vec3 s = vec3(f.x + 150.0, f.y - 80.0, f.z - 100.0);
  r = U(r, vec2(rbox(s, vec3(18.0, 35.0, 14.0), 3.0), ALU));
  r = U(r, sensorM18(vec3(s.x - 30.0, s.y - 15.0, s.z), BLUEP));
  return r;
}

vec2 curtains(vec3 p) {
  vec2 r = lightCurtain(vec3(-(p.z - 377.5), p.y - 950.0, p.x + 535.0), 860.0);
  r = U(r, lightCurtain(vec3(p.z - 377.5, p.y - 950.0, -(p.x - 535.0)), 860.0));
  float brk = rbox(vec3(abs(p.x) - 545.0, abs(p.y - 1380.0) - 380.0, p.z - 377.5), vec3(14.0, 10.0, 24.0), 2.0);
  r = U(r, vec2(brk, DARK));
  return r;
}

vec3 toHmi(vec3 p) {
  vec3 q = p - HMI_AT;
  q.xz = rot(HMI_ANGLE) * q.xz;
  return q;
}

vec2 hmiArm(vec3 p) {
  vec2 r = vec2(capsule(p, vec3(605.0, 1690.0, 377.5), vec3(824.0, 1690.0, 465.0), 24.0), GREY);
  r = U(r, vec2(cylY(p - vec3(824.0, 1690.0, 465.0), 34.0, 30.0, 6.0), GREY));
  r = U(r, vec2(capsule(p, vec3(824.0, 1690.0, 465.0), vec3(824.0, 1610.0, 465.0), 24.0), GREY));
  r = U(r, vec2(rbox(p - vec3(605.0, 1690.0, 377.5), vec3(8.0, 45.0, 45.0), 3.0), DARK));
  vec3 q = toHmi(p);
  r = U(r, vec2(rbox(q - vec3(0.0, 150.0, -60.0), vec3(44.0, 25.0, 40.0), 6.0), GREY));
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, -88.0), vec3(170.0, 125.0, 25.0), 8.0), GREY));
  r = U(r, hmiPanel(q, vec2(200.0, 150.0), 64.0, 20.0, SCREEN));
  float cab = capsule(p, vec3(608.0, 1650.0, 395.0), vec3(608.0, 935.0, 395.0), 4.5);
  cab = min(cab, capsule(p, vec3(608.0, 935.0, 395.0), vec3(606.0, 905.0, 380.0), 4.5));
  r = U(r, vec2(cab, CABLE));
  r = U(r, vec2(ties(p, vec3(608.0, 0.0, 395.0), 980.0, 1600.0), BLACK));
  return r;
}

vec2 palmButton(vec3 q) {
  float collar = cylZ(q - vec3(0.0, 0.0, 10.0), 46.0, 10.0, 3.0);
  collar = max(collar, -cylZ(q - vec3(0.0, 0.0, 14.0), 38.0, 10.0, 2.0));
  vec2 r = vec2(collar, BLACK);
  float cap = cylZ(q - vec3(0.0, 0.0, 12.0), 32.0, 6.0, 5.5);
  cap = smin(cap, max(length(q - vec3(0.0, 0.0, -12.0)) - 34.0, 12.0 - q.z), 3.0);
  r = U(r, vec2(cap, GREEN));
  return r;
}

vec2 twoHand(vec3 p) {
  vec3 q = p - vec3(0.0, 840.0, 480.0);
  q.yz = rot(0.5) * q.yz;
  vec2 r = vec2(rbox(q + vec3(0.0, 0.0, 42.0), vec3(330.0, 72.0, 42.0), 10.0), YELLOW);
  r = U(r, palmButton(vec3(abs(q.x) - 215.0, q.y, q.z)));
  r = U(r, estop(q));
  float screws = cylZ(vec3(abs(q.x) - 310.0, abs(q.y) - 52.0, q.z - 0.5), 4.0, 1.0, 0.6);
  r = U(r, vec2(screws, STEEL));
  float plate = box(vec3(q.x - 110.0, q.y + 48.0, q.z - 0.3), vec3(40.0, 9.0, 0.4));
  r = U(r, vec2(plate, WHITE));
  float brk = box(vec3(abs(p.x) - 220.0, p.y - 770.0, p.z - 430.0), vec3(30.0, 5.0, 32.0));
  r = U(r, vec2(brk, DARK));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 450.0, 0.0), vec3(640.0, 460.0, 440.0)) < r.x) r = U(r, baseCabinet(p));
  if (box(p - vec3(0.0, 900.0, 0.0), vec3(620.0, 20.0, 420.0)) < r.x) r = U(r, vec2(rbox(p - vec3(0.0, 900.0, 0.0), vec3(620.0, 20.0, 420.0), 3.0), PLATE));
  if (box(p - vec3(0.0, 1460.0, 0.0), vec3(610.0, 560.0, 410.0)) < r.x) r = U(r, frame(p));
  if (box(p - vec3(0.0, 1720.0, 40.0), vec3(610.0, 600.0, 160.0)) < r.x) r = U(r, press(p));
  if (box(p - vec3(0.0, 1020.0, 40.0), vec3(190.0, 110.0, 150.0)) < r.x) r = U(r, fixture(p));
  if (box(p - vec3(0.0, 1380.0, 377.5), vec3(560.0, 440.0, 30.0)) < r.x) r = U(r, curtains(p));
  if (box(p - vec3(720.0, 1300.0, 420.0), vec3(260.0, 440.0, 200.0)) < r.x) r = U(r, hmiArm(p));
  if (box(p - vec3(577.5, 2150.0, -377.5), vec3(40.0, 160.0, 40.0)) < r.x) r = U(r, towerLight(p - vec3(577.5, 2000.0, -377.5), 0.0));
  if (box(p - vec3(0.0, 830.0, 470.0), vec3(345.0, 95.0, 100.0)) < r.x) r = U(r, twoHand(p));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == PLATE) return mat(vec3(0.66, 0.67, 0.68) * (0.94 + 0.08 * vnoise(p * vec3(0.3, 0.02, 0.02))), 0.62, 1.0);
  if (id == GUARD) return clearMat(vec3(0.97, 0.98, 0.99), 0.03, 0.95);
  if (id == ALU) return mat(vec3(0.8, 0.81, 0.83), 0.6, 1.0);
  if (id == ANODIZED) return mat(vec3(0.025, 0.026, 0.03), 0.36, 0.0);
  if (id == PART) return mat(vec3(0.82, 0.8, 0.77), 0.16, 1.0);
  if (id == SCREEN) {
    vec3 q = toHmi(p);
    return screen(screenHmi((q.xy + vec2(180.0, 130.0)) / vec2(360.0, 260.0), 5.0));
  }
  return libMat(id, p, n);
}
