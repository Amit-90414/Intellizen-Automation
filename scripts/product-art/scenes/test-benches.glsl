const vec3 BC = vec3(0.0, 1000.0, 0.0);
const float BR = 1700.0;

const float WORKTOP = 50.0, BIN_GREEN = 51.0, BIN_RED = 52.0, CASTALU = 53.0, DIAL = 54.0, LCD = 55.0, SCREEN = 56.0, ANODIZED = 57.0, SEAL = 58.0, BOWL = 59.0;
const vec2 HMI_C = vec2(-360.0, 1560.0);
const vec2 HMI_HS = vec2(190.0, 140.0);

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

float extr(vec3 q, float h, float w) {
  float d = rbox(q, vec3(w, h, w), 2.5);
  vec3 a = abs(q);
  float g = min(box(vec3(a.x - w, q.y, q.z), vec3(3.5, h + 1.0, 4.0)), box(vec3(q.x, q.y, a.z - w), vec3(4.0, h + 1.0, 3.5)));
  return max(d, -g);
}

vec2 valveBody(vec3 q) {
  float b = rbox(q - vec3(0.0, 45.0, 0.0), vec3(70.0, 45.0, 55.0), 8.0);
  b = smin(b, cylX(q - vec3(0.0, 45.0, 0.0), 30.0, 88.0, 4.0), 6.0);
  b = smin(b, cylY(q - vec3(0.0, 95.0, 0.0), 26.0, 10.0, 3.0), 5.0);
  b = max(b, -cylX(q - vec3(0.0, 45.0, 0.0), 14.0, 100.0, 0.0));
  b = max(b, -cylY(q - vec3(0.0, 100.0, 0.0), 12.0, 20.0, 0.0));
  b = max(b, -cylZ(vec3(abs(q.x) - 50.0, abs(q.y - 45.0) - 30.0, q.z - 55.0), 3.5, 8.0, 0.0));
  return vec2(b, CASTALU);
}

vec2 bench(vec3 p) {
  vec3 l = vec3(abs(p.x) - 765.0, p.y - 440.0, abs(p.z) - 365.0);
  vec2 r = vec2(rbox(l, vec3(25.0, 440.0, 25.0), 3.0), GREY);
  r = U(r, vec2(rbox(vec3(p.x, p.y - 840.0, abs(p.z) - 365.0), vec3(790.0, 30.0, 25.0), 3.0), GREY));
  r = U(r, vec2(rbox(vec3(abs(p.x) - 765.0, p.y - 840.0, p.z), vec3(25.0, 30.0, 390.0), 3.0), GREY));
  r = U(r, vec2(rbox(p - vec3(0.0, 200.0, 0.0), vec3(790.0, 12.0, 390.0), 3.0), GREY));
  r = U(r, vec2(rbox(p - vec3(0.0, 885.0, 0.0), vec3(810.0, 15.0, 410.0), 4.0), WORKTOP));
  vec3 f = vec3(abs(p.x) - 765.0, p.y, abs(p.z) - 365.0);
  r = U(r, vec2(cylY(f - vec3(0.0, 9.0, 0.0), 30.0, 9.0, 3.0), BLACK));
  r = U(r, vec2(cylY(f - vec3(0.0, 30.0, 0.0), 9.0, 14.0, 1.0), STEEL));
  r = U(r, vec2(extr(vec3(abs(p.x) - 760.0, p.y - 1410.0, p.z + 360.0), 510.0, 22.5), ALU));
  r = U(r, vec2(extr(vec3(p.y - 1897.5, p.x, p.z + 360.0), 737.5, 22.5), ALU));
  r = U(r, vec2(rbox(p - vec3(0.0, 1440.0, -362.0), vec3(737.0, 420.0, 2.0), 1.0), GREY));
  r = U(r, vec2(cylZ(vec3(abs(p.x) - 715.0, abs(p.y - 1440.0) - 390.0, p.z + 359.0), 4.0, 1.5, 0.6), STEEL));
  return r;
}

vec2 gauges(vec3 p) {
  vec3 g = vec3(repLim(p.x - 250.0, 150.0, -1.0, 1.0), p.y - 1690.0, p.z + 360.0);
  vec2 r = vec2(max(cylZ(g - vec3(0.0, 0.0, 18.0), 52.0, 18.0, 4.0), -cylZ(g - vec3(0.0, 0.0, 36.0), 47.0, 2.5, 0.0)), BLACK);
  r = U(r, vec2(torusZ(g - vec3(0.0, 0.0, 36.0), 50.0, 4.0), CHROME));
  r = U(r, vec2(max(length(g.xy) - 49.0, abs(g.z - 34.5) - 0.6), DIAL));
  r = U(r, vec2(cylZ(g - vec3(0.0, 0.0, 36.0), 4.0, 1.5, 1.0), BLACK));
  return r;
}

vec2 panelDevices(vec3 p) {
  vec3 q = p - vec3(0.0, 0.0, -360.0);
  vec2 r = hmiPanel(q - vec3(HMI_C, 0.0) - vec3(0.0, 0.0, 6.0), HMI_HS, 6.0, 18.0, SCREEN);
  vec3 m = q - vec3(250.0, 1500.0, 0.0);
  r = U(r, vec2(rbox(m - vec3(0.0, 0.0, 30.0), vec3(150.0, 55.0, 30.0), 5.0), DARK));
  r = U(r, vec2(box(m - vec3(-35.0, 0.0, 60.2), vec3(95.0, 30.0, 0.4)), LCD));
  r = U(r, vec2(cylZ(vec3(m.x - 100.0, abs(m.y) - 18.0, m.z - 60.0), 7.0, 2.0, 1.5), MGREY));
  r = U(r, pushButton(q - vec3(100.0, 1330.0, 0.0), GREEN));
  r = U(r, pushButton(q - vec3(180.0, 1330.0, 0.0), RED));
  r = U(r, pilotLight(q - vec3(260.0, 1330.0, 0.0), LGREEN));
  r = U(r, pilotLight(q - vec3(340.0, 1330.0, 0.0), RED_OFF));
  r = U(r, selectorSwitch(q - vec3(420.0, 1330.0, 0.0), -0.6));
  r = U(r, estop(q - vec3(600.0, 1330.0, 0.0)));
  r = U(r, warning(q - vec3(600.0, 1760.0, 0.5), 50.0));
  r = U(r, vec2(rbox(q - vec3(-360.0, 1350.0, 0.8), vec3(80.0, 20.0, 0.8), 0.6), PAPER));
  r = U(r, towerLight(p - vec3(640.0, 1920.0, -360.0), 0.0));
  return r;
}

vec2 fixture(vec3 p) {
  vec3 f = p - vec3(-40.0, 900.0, 60.0);
  vec2 r = vec2(rbox(f - vec3(0.0, 12.0, 0.0), vec3(260.0, 12.0, 190.0), 3.0), ANODIZED);
  r = U(r, vec2(rbox(f - vec3(0.0, 40.0, 0.0), vec3(95.0, 16.0, 80.0), 2.0), ALU));
  r = U(r, valveBody(f - vec3(0.0, 56.0, 0.0)));
  r = U(r, vec2(extr(vec3(abs(f.x) - 230.0, f.y - 300.0, f.z + 120.0), 276.0, 22.5), ALU));
  r = U(r, vec2(extr(vec3(f.y - 598.5, f.x, f.z + 120.0), 252.5, 22.5), ALU));
  r = U(r, vec2(rbox(f - vec3(0.0, 564.0, -60.0), vec3(90.0, 12.0, 85.0), 2.0), ANODIZED));
  r = U(r, pneuCylinder(vec3(762.0 - f.y, f.x, f.z), 63.0, 150.0, 174.0));
  r = U(r, vec2(rbox(f - vec3(0.0, 380.0, 0.0), vec3(60.0, 22.0, 60.0), 4.0), ANODIZED));
  r = U(r, vec2(cylY(vec3(abs(f.x) - 45.0, f.y - 490.0, f.z), 8.0, 110.0, 1.0), CHROME));
  r = U(r, vec2(cylY(f - vec3(0.0, 266.0, 0.0), 22.0, 96.0, 3.0), STEEL));
  r = U(r, vec2(cylY(f - vec3(0.0, 172.0, 0.0), 28.0, 6.0, 2.5), SEAL));
  vec3 cq = vec3(f.x + 230.0, f.y - 75.0, f.z);
  r = U(r, pneuCylinder(cq, 32.0, 60.0, 30.0));
  r = U(r, vec2(rbox(cq - vec3(50.0, -30.0, 0.0), vec3(55.0, 20.0, 34.0), 2.0), ANODIZED));
  r = U(r, vec2(rbox(cq - vec3(130.0, 0.0, 0.0), vec3(6.0, 22.0, 22.0), 2.0), SEAL));
  float hose = cable(p, vec3(25.0, 1280.0, 60.0), vec3(320.0, 1240.0, 20.0), vec3(350.0, 1482.0, -296.0), 5.0);
  r = U(r, vec2(hose, BLUEP));
  return r;
}

vec2 bin(vec3 q) {
  float outer = rbox(q - vec3(0.0, 90.0, 0.0), vec3(150.0, 90.0, 115.0), 8.0);
  float inner = rbox(q - vec3(0.0, 105.0, 0.0), vec3(140.0, 90.0, 105.0), 6.0);
  float lip = max(rbox(q - vec3(0.0, 175.0, 0.0), vec3(156.0, 5.0, 121.0), 3.0), -box(q - vec3(0.0, 175.0, 0.0), vec3(141.0, 10.0, 106.0)));
  return vec2(min(max(outer, -inner), lip), 0.0);
}

vec2 bins(vec3 p) {
  vec3 g = p - vec3(560.0, 900.0, 130.0);
  vec2 b1 = bin(g);
  vec2 r = vec2(b1.x, BIN_GREEN);
  vec3 h = p - vec3(560.0, 900.0, -150.0);
  h.xz = rot(0.05) * h.xz;
  r = U(r, vec2(bin(h).x, BIN_RED));
  r = U(r, valveBody(vec3(g.x + 50.0, g.y - 15.0, g.z - 30.0)));
  vec3 g2 = g - vec3(60.0, 15.0, -40.0);
  g2.xz = rot(0.7) * g2.xz;
  r = U(r, valveBody(g2));
  vec3 g3 = g - vec3(5.0, 90.0, 10.0);
  g3.xy = rot(0.35) * g3.xy;
  g3.xz = rot(-0.4) * g3.xz;
  r = U(r, valveBody(g3));
  vec3 h2 = h - vec3(-20.0, 15.0, 0.0);
  h2.xz = rot(1.2) * h2.xz;
  r = U(r, valveBody(h2));
  return r;
}

vec2 tray(vec3 p) {
  vec3 t = p - vec3(-590.0, 900.0, 140.0);
  vec2 r = vec2(max(rbox(t - vec3(0.0, 20.0, 0.0), vec3(160.0, 20.0, 200.0), 4.0), -rbox(t - vec3(0.0, 28.0, 0.0), vec3(152.0, 20.0, 192.0), 3.0)), MGREY);
  vec3 a = vec3(t.x, t.y - 8.0, t.z - 100.0);
  r = U(r, valveBody(a - vec3(-70.0, 0.0, 0.0)));
  r = U(r, valveBody(a - vec3(75.0, 0.0, 0.0)));
  vec3 b = t - vec3(-10.0, 8.0, -95.0);
  b.xz = rot(0.15) * b.xz;
  r = U(r, valveBody(b));
  return r;
}

vec2 frl(vec3 p) {
  vec3 q = p - vec3(-765.0, 700.0, 390.0);
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 8.0), vec3(60.0, 30.0, 8.0), 2.0), DARK);
  vec3 u = vec3(repLim(q.x, 50.0, -0.5, 0.5), q.y, q.z - 50.0);
  r = U(r, vec2(rbox(u, vec3(22.0, 26.0, 26.0), 4.0), MGREY));
  r = U(r, vec2(cylY(u - vec3(0.0, -60.0, 0.0), 18.0, 34.0, 8.0), BOWL));
  r = U(r, vec2(cylY(u - vec3(0.0, 38.0, 0.0), 12.0, 12.0, 3.0), BLACK));
  r = U(r, vec2(cylZ(q - vec3(-25.0, 0.0, 82.0), 20.0, 6.0, 2.0), BLACK));
  r = U(r, vec2(cylZ(q - vec3(-25.0, 0.0, 88.5), 17.0, 0.5, 0.2), DIAL));
  return r;
}

vec2 shelfCrate(vec3 p) {
  vec3 q = p - vec3(-380.0, 212.0, 40.0);
  q.xz = rot(-0.06) * q.xz;
  vec2 r = vec2(bin(q).x, MGREY);
  r = U(r, valveBody(q - vec3(-60.0, 15.0, -20.0)));
  vec3 b = q - vec3(70.0, 15.0, 30.0);
  b.xz = rot(0.9) * b.xz;
  r = U(r, valveBody(b));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 960.0, 0.0), vec3(820.0, 960.0, 420.0)) < r.x) r = U(r, bench(p));
  if (box(p - vec3(250.0, 1690.0, -320.0), vec3(210.0, 60.0, 45.0)) < r.x) r = U(r, gauges(p));
  if (box(p - vec3(80.0, 1640.0, -300.0), vec3(700.0, 600.0, 70.0)) < r.x) r = U(r, panelDevices(p));
  if (box(p - vec3(-40.0, 1240.0, 30.0), vec3(300.0, 360.0, 230.0)) < r.x) r = U(r, fixture(p));
  if (box(p - vec3(560.0, 1000.0, -10.0), vec3(175.0, 110.0, 290.0)) < r.x) r = U(r, bins(p));
  if (box(p - vec3(-590.0, 960.0, 140.0), vec3(175.0, 80.0, 215.0)) < r.x) r = U(r, tray(p));
  if (box(p - vec3(-380.0, 300.0, 40.0), vec3(170.0, 100.0, 135.0)) < r.x) r = U(r, shelfCrate(p));
  if (box(p - vec3(-740.0, 680.0, 440.0), vec3(110.0, 120.0, 70.0)) < r.x) r = U(r, frl(p));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == WORKTOP) return mat(vec3(0.16, 0.17, 0.18) * (0.95 + 0.1 * fbm(p * 0.02)), 0.55, 0.0);
  if (id == BIN_GREEN) return mat(vec3(0.025, 0.2, 0.06), 0.42, 0.0);
  if (id == BIN_RED) return mat(vec3(0.42, 0.025, 0.02), 0.42, 0.0);
  if (id == CASTALU) return mat(vec3(0.62, 0.63, 0.64) * (0.88 + 0.2 * fbm(p * 0.15)), 0.58, 1.0);
  if (id == ANODIZED) return mat(vec3(0.025, 0.026, 0.03), 0.38, 0.0);
  if (id == SEAL) return mat(vec3(0.015), 0.6, 0.0);
  if (id == BOWL) return mat(vec3(0.5, 0.45, 0.3), 0.08, 0.0);
  if (id == ALU) return mat(vec3(0.8, 0.81, 0.83), 0.6, 1.0);
  if (id == DIAL) {
    vec2 c = p.z > 0.0 ? vec2(-790.0, 700.0) : vec2(250.0 + 150.0 * clamp(round((p.x - 250.0) / 150.0), -1.0, 1.0), 1690.0);
    float R = p.z > 0.0 ? 17.0 : 48.0;
    vec2 uv = (p.xy - c) / R;
    float rr = length(uv);
    float a = atan(uv.x, uv.y);
    vec3 col = vec3(0.86, 0.86, 0.84);
    float ticks = step(abs(rep(a, 0.2356)) * rr, 0.012) * step(0.74, rr) * step(rr, 0.86) * step(abs(a), 2.36);
    col = mix(col, vec3(0.05), ticks);
    col = mix(col, vec3(0.6, 0.05, 0.03), step(1.6, a) * step(a, 2.36) * step(0.66, rr) * step(rr, 0.72));
    float na = -0.6 + 0.25 * sin(c.x * 0.05);
    vec2 nd = vec2(sin(na), cos(na));
    float needle = abs(dot(uv, vec2(nd.y, -nd.x))) - 0.025 * (1.0 - clamp(dot(uv, nd), 0.0, 0.8));
    col = mix(col, vec3(0.04), step(needle, 0.0) * step(-0.1, dot(uv, nd)) * step(dot(uv, nd), 0.8));
    col = mix(col, vec3(0.05), step(rr, 0.08));
    col = mix(col, vec3(0.1), step(0.97, rr));
    return mat(col, 0.12, 0.0);
  }
  if (id == LCD) {
    vec2 uv = (p.xy - vec2(215.0 - 95.0, 1500.0 - 30.0)) / vec2(190.0, 60.0);
    vec3 col = vec3(0.04, 0.06, 0.05);
    float cell = floor(uv.x * 6.0);
    vec2 g = vec2(fract(uv.x * 6.0), uv.y);
    float seg = max(step(abs(g.y - 0.5), 0.05), max(step(abs(g.y - 0.85), 0.05), step(abs(g.y - 0.15), 0.05))) * step(abs(g.x - 0.5), 0.3);
    seg = max(seg, step(abs(g.x - 0.2), 0.05) * step(abs(g.y - 0.5), 0.35) * step(0.4, h22(vec2(cell, 3.0)).x));
    seg = max(seg, step(abs(g.x - 0.8), 0.05) * step(abs(g.y - 0.5), 0.35));
    seg *= step(0.1, uv.y) * step(uv.y, 0.9) * step(0.5, uv.x * 6.0) * step(uv.x * 6.0, 5.5);
    col = mix(col, vec3(0.3, 1.2, 0.5), seg * step(abs(g.y - 0.5), 0.4));
    return glow(vec3(0.01), 0.08, col);
  }
  if (id == SCREEN) {
    vec2 uv = (p.xy - (HMI_C - HMI_HS + 18.0)) / (2.0 * (HMI_HS - 18.0));
    return screen(screenTrend(uv, 4.0));
  }
  return libMat(id, p, n);
}
