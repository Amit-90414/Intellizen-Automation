const vec3 BC = vec3(500.0, 900.0, -100.0);
const float BR = 2600.0;

const float WARN = 68.0, GMOTOR = 69.0;
const float VLCD = 60.0, PUMP = 61.0, GAUGE = 62.0, PIPE = 63.0, WBLACK = 64.0, WGREY = 65.0, WBLUE = 66.0, LEDS = 67.0;

const vec3 CAB = vec3(800.0, 2000.0, 400.0);
const vec3 CABPOS = vec3(-1000.0, 0.0, -400.0);
const float DOOR = 1.95;
const vec3 SKID = vec3(100.0, 0.0, 250.0);
const vec3 CONV = vec3(1350.0, 0.0, -450.0);

vec3 toPlate(vec3 p) { return p - CABPOS - vec3(0.0, 1050.0, -CAB.z * 0.5 + 24.0); }

float triSd(vec2 p, float r) {
  const float k = 1.7320508;
  p.x = abs(p.x) - r;
  p.y = p.y + r / k;
  if (p.x + k * p.y > 0.0) p = vec2(p.x - k * p.y, -k * p.x - p.y) * 0.5;
  p.x -= clamp(p.x, -2.0 * r, 0.0);
  return -length(p) * sign(p.y);
}

float ink(float d) { return smoothstep(0.35, -0.35, d); }

vec3 warnSign(vec2 q, float r, vec3 base) {
  float t = triSd(q, r) - r * 0.06;
  vec3 c = mix(base, vec3(0.015), ink(t));
  c = mix(c, vec3(0.86, 0.6, 0.02), ink(t + r * 0.12));
  vec2 b = q / r;
  float bolt = box2(rot(-0.5) * (b - vec2(0.05, 0.1)), vec2(0.055, 0.2));
  bolt = min(bolt, box2(rot(-0.5) * (b - vec2(-0.05, -0.2)), vec2(0.055, 0.19)));
  bolt = min(bolt, box2(b - vec2(0.0, -0.05), vec2(0.12, 0.04)));
  return mix(c, vec3(0.015), ink(bolt * r));
}

float duct(vec3 q, float L) {
  float body = box(q - vec3(0.0, 0.0, 30.0), vec3(L * 0.5, 30.0, 30.0));
  body = max(body, -box(q - vec3(0.0, 0.0, 33.0), vec3(L * 0.5 + 1.0, 28.0, 30.0)));
  body = max(body, -box(vec3(rep(q.x, 12.0), abs(q.y) - 29.0, q.z - 38.0), vec3(2.4, 3.0, 21.0)));
  float lid = rbox(q - vec3(0.0, 0.0, 61.5), vec3(L * 0.5, 31.5, 1.5), 1.0);
  return min(body, lid);
}

vec2 wireRun(vec3 q, float pitch, float x0, float x1, float y0, float y1, float z, float rad, float id) {
  float x = q.x - x0 - pitch * clamp(round((q.x - x0) / pitch), 0.0, floor((x1 - x0) / pitch + 0.01));
  float w = max(length(vec2(x, q.z - z)) - rad, abs(q.y - (y0 + y1) * 0.5) - (y1 - y0) * 0.5);
  return vec2(w, id);
}

vec2 vfd(vec3 q, vec3 hs) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, hs.z * 0.45), vec3(hs.x - 4.0, hs.y, hs.z * 0.45), 4.0), BLACK);
  float fins = max(rbox(vec3(rep(q.x, 9.0), q.y, q.z - hs.z * 0.45), vec3(1.6, hs.y - 6.0, hs.z * 0.45), 0.8), abs(q.x) - hs.x + 2.0);
  r = U(r, vec2(fins, BLACK));
  vec3 f = q - vec3(0.0, 0.0, hs.z * 1.35);
  float cover = rbox(f, vec3(hs.x, hs.y - 8.0, hs.z * 0.45), 10.0);
  cover = max(cover, -box(vec3(f.x, f.y + hs.y * 0.72 - 7.0 * clamp(round((f.y + hs.y * 0.72) / 7.0), -3.0, 3.0), f.z - hs.z * 0.45), vec3(hs.x * 0.7, 1.4, 3.0)));
  r = U(r, vec2(cover, LGREY));
  vec3 k = f - vec3(0.0, hs.y * 0.4, hs.z * 0.45);
  r = U(r, vec2(rbox(k, vec3(hs.x * 0.62, hs.y * 0.3, 5.0), 4.0), DARK));
  r = U(r, vec2(box(k - vec3(0.0, hs.y * 0.13, 5.2), vec3(hs.x * 0.48, hs.y * 0.09, 0.3)), VLCD));
  vec3 bq = vec3(k.x + hs.x * 0.36 - hs.x * 0.24 * clamp(round((k.x + hs.x * 0.36) / (hs.x * 0.24)), 0.0, 3.0), k.y + hs.y * 0.12, k.z - 5.5);
  r = U(r, vec2(rbox(bq, vec3(7.0, 5.0, 1.8), 1.5), MGREY));
  r = U(r, vec2(cylZ(k - vec3(0.0, -hs.y * 0.21, 7.0), 9.0, 3.0, 1.5), MGREY));
  r = U(r, vec2(cylZ(k - vec3(-hs.x * 0.45, hs.y * 0.24, 5.4), 1.8, 0.6, 0.3), LEDS));
  r = U(r, vec2(box(f - vec3(0.0, -hs.y * 0.22, hs.z * 0.45 + 0.2), vec3(hs.x * 0.5, 9.0, 0.3)), WHITE));
  r = U(r, vec2(box(f - vec3(hs.x * 0.68, -hs.y * 0.55, hs.z * 0.45 + 0.2), vec3(13.0, 12.0, 0.3)), WARN));
  return r;
}

vec2 mccb(vec3 q, vec3 hs) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, hs.z), hs, 6.0), DARK);
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, hs.z * 2.0 + 10.0), vec3(hs.x * 0.62, hs.y * 0.48, 12.0), 6.0), DARK));
  r = U(r, vec2(rbox(q - vec3(0.0, 18.0, hs.z * 2.0 + 30.0), vec3(hs.x * 0.16, 28.0, 14.0), 5.0), BLACK));
  r = U(r, vec2(box(q - vec3(0.0, -hs.y * 0.3, hs.z * 2.0 + 22.4), vec3(hs.x * 0.5, 10.0, 0.4)), WHITE));
  return r;
}

vec2 interior(vec3 q) {
  vec2 r = vec2(0.7 * BR, -1.0);
  float hd = duct(q - vec3(0.0, 820.0, 0.0), 600.0);
  hd = min(hd, duct(vec3(q.x, q.y - 300.0 + 280.0 * clamp(round((300.0 - q.y) / 280.0), 0.0, 2.0), q.z), 600.0));
  hd = min(hd, duct(vec3(q.y - 150.0, abs(q.x) - 330.0, q.z), 1400.0));
  r = U(r, vec2(hd, LGREY));
  if (box(q - vec3(0.0, 560.0, 110.0), vec3(300.0, 160.0, 120.0)) < r.x) {
    r = U(r, mccb(q - vec3(-240.0, 600.0, 0.0), vec3(52.0, 110.0, 60.0)));
    float k = clamp(round((q.x + 95.0) / 140.0), 0.0, 2.0);
    r = U(r, vfd(q - vec3(-95.0 + k * 140.0, 560.0, 0.0), vec3(64.0, 148.0, 100.0)));
  }
  if (box(q - vec3(0.0, 440.0, 50.0), vec3(300.0, 140.0, 60.0)) < r.x) {
    r = U(r, wireRun(q, 140.0, -95.0, 185.0, 330.0, 414.0, 40.0, 6.0, WBLACK));
    r = U(r, wireRun(q, 140.0, -75.0, 205.0, 330.0, 414.0, 40.0, 6.0, WBLACK));
    r = U(r, wireRun(q, 140.0, -115.0, 165.0, 330.0, 414.0, 40.0, 6.0, WBLACK));
    r = U(r, wireRun(q, 22.0, -262.0, -218.0, 712.0, 790.0, 40.0, 4.0, WBLACK));
  }
  if (box(q - vec3(0.0, 160.0, 60.0), vec3(300.0, 90.0, 70.0)) < r.x) {
    r = U(r, dinRail(q - vec3(0.0, 160.0, 0.0), 590.0));
    vec3 d = q - vec3(0.0, 160.0, 7.6);
    float c = clamp(round((d.x + 250.0) / 50.0), 0.0, 2.0);
    r = U(r, contactor(d - vec3(-250.0 + c * 50.0, 0.0, 0.0)));
    float m = clamp(round((d.x + 80.0) / 18.0), 0.0, 8.0);
    r = U(r, mcb(d - vec3(-80.0 + m * 18.0, 0.0, 0.0), 1.0, 1.0));
    r = U(r, wireRun(q, 18.0, -80.0, 64.0, 206.0, 270.0, 34.0, 1.4, WBLUE));
    r = U(r, wireRun(q, 18.0, -80.0, 64.0, 50.0, 114.0, 34.0, 1.4, WGREY));
  }
  if (box(q - vec3(0.0, -120.0, 40.0), vec3(300.0, 90.0, 60.0)) < r.x) {
    r = U(r, dinRail(q - vec3(0.0, -120.0, 0.0), 590.0));
    r = U(r, terminalBlocks(q - vec3(-30.0, -120.0, 7.6), 40.0, BLUEP));
    r = U(r, wireRun(q, 6.2, -278.0, 218.0, -90.0, -50.0, 30.0, 1.4, WGREY));
    r = U(r, wireRun(q, 6.2, -278.0, 218.0, -230.0, -150.0, 30.0, 1.4, WBLACK));
  }
  if (box(q - vec3(0.0, -640.0, 60.0), vec3(300.0, 300.0, 40.0)) < r.x) {
    float cx = q.x + 200.0 - 130.0 * clamp(round((q.x + 200.0) / 130.0), 0.0, 3.0);
    r = U(r, vec2(max(length(vec2(cx, q.z - 60.0)) - 15.0, abs(q.y + 620.0) - 300.0), CABLE));
    r = U(r, vec2(cylY(vec3(cx, q.y + 900.0, q.z - 60.0), 23.0, 14.0, 3.0), BLACK));
  }
  return r;
}

vec2 openCab(vec3 p) {
  vec3 hs = vec3(CAB.x * 0.5, (CAB.y - 100.0) * 0.5, CAB.z * 0.5);
  vec3 q = p - CABPOS - vec3(0.0, (CAB.y + 100.0) * 0.5, 0.0);
  float shell = rbox(q, hs, 6.0);
  shell = max(shell, -box(q - vec3(0.0, 0.0, 20.0), vec3(hs.x - 16.0, hs.y - 16.0, hs.z)));
  vec2 r = vec2(shell, GREY);
  r = U(r, vec2(box(q + vec3(0.0, hs.y + 50.0, 0.0), vec3(hs.x - 4.0, 50.0, hs.z - 4.0)), DARK));
  r = U(r, vec2(box(q - vec3(0.0, 0.0, -hs.z + 22.0), vec3(hs.x - 36.0, hs.y - 36.0, 2.0)), ZINC));
  vec3 d = q - vec3(-hs.x, 0.0, hs.z);
  d.xz = rot(-DOOR) * d.xz;
  float door = rbox(d - vec3(hs.x, 0.0, 12.0), vec3(hs.x, hs.y, 12.0), 5.0);
  door = max(door, -box(d - vec3(hs.x, 0.0, -2.0), vec3(hs.x - 24.0, hs.y - 24.0, 12.0)));
  r = U(r, vec2(door, GREY));
  r = U(r, vec2(rbox(d - vec3(hs.x, -300.0, 4.0), vec3(220.0, 150.0, 6.0), 3.0), MGREY));
  vec3 iso = d - vec3(hs.x, 380.0, 24.0);
  r = U(r, vec2(rbox(iso - vec3(0.0, 0.0, 2.0), vec3(58.0, 58.0, 2.0), 4.0), YELLOW));
  float knob = cylZ(iso - vec3(0.0, 0.0, 14.0), 25.0, 10.0, 4.0);
  vec3 hq = iso - vec3(0.0, 0.0, 30.0);
  hq.xy = rot(-0.5) * hq.xy;
  r = U(r, vec2(smin(knob, rbox(hq, vec3(10.0, 52.0, 10.0), 6.0), 6.0), RED));
  r = U(r, vec2(cylY(vec3(q.x + hs.x + 3.0, abs(q.y) - hs.y * 0.7, q.z - hs.z - 6.0), 8.0, 40.0, 2.0), DARK));
  return r;
}

vec2 flangeMotor(vec3 p, float R, float L, float paint) {
  float body = cylX(p, R, L * 0.5, 8.0);
  float a = atan(p.z, p.y);
  float rr = length(p.yz);
  float fin = max(max(rr - R - 10.0, abs(rep(a, 6.2831853 / 28.0)) * rr - 2.0), abs(p.x) - L * 0.5 + 14.0);
  body = min(body, fin);
  body = min(body, cylX(vec3(abs(p.x) - L * 0.5, p.yz), R + 3.0, 10.0, 4.0));
  vec2 r = vec2(body, paint);
  float fan = cylX(p + vec3(L * 0.5 + 44.0, 0.0, 0.0), R + 2.0, 34.0, 10.0);
  fan = max(fan, -max(max(abs(rep(p.y, 8.0)) - 2.0, -p.x - L * 0.5 - 76.0), rr - R * 0.72));
  r = U(r, vec2(fan, paint));
  vec3 tb = p - vec3(0.0, R + 30.0, 0.0);
  r = U(r, vec2(rbox(tb, vec3(R * 0.6, 26.0, R * 0.6), 6.0), paint));
  r = U(r, vec2(cylZ(tb - vec3(0.0, -4.0, R * 0.6 + 8.0), 9.0, 8.0, 2.0), BLACK));
  return r;
}

float pipeBend(vec3 p, vec2 c, float R, float r, float qx, float qy) {
  vec3 q = vec3(p.x - c.x, p.y - c.y, p.z);
  float d = length(vec2(length(q.xy) - R, q.z)) - r;
  return max(d, max(-q.x * qx, -q.y * qy));
}

float flange(vec3 q, float r, float h) {
  float f = cylX(q, r, h, 2.0);
  float a = atan(q.z, q.y);
  vec2 b = vec2(length(q.yz) * cos(rep(a, 0.785398)) - r * 0.8, length(q.yz) * sin(rep(a, 0.785398)));
  float bolt = max(length(b) - r * 0.07, abs(q.x) - h - 5.0);
  return min(f, bolt);
}

vec2 skid(vec3 k) {
  float rails = rbox(vec3(k.x, k.y - 40.0, abs(k.z) - 150.0), vec3(560.0, 40.0, 35.0), 3.0);
  float cross = rbox(vec3(k.x - 530.0 * clamp(round(k.x / 530.0), -1.0, 1.0), k.y - 40.0, k.z), vec3(35.0, 38.0, 150.0), 3.0);
  vec2 r = vec2(min(rails, cross), MGREY);
  r = U(r, vec2(cylY(vec3(abs(k.x) - 500.0, k.y - 82.0, abs(k.z) - 150.0), 12.0, 3.0, 1.5), STEEL));
  vec3 m = k - vec3(-240.0, 250.0, 0.0);
  r = U(r, motor(m, 130.0, 380.0, BLUE));
  vec3 np = m - vec3(30.4, 130.0 + 72.0 + 0.4, 0.0);
  r = U(r, vec2(rbox(np, vec3(42.0, 0.6, 30.0), 1.0), ALU));
  r = U(r, vec2(cylY(vec3(abs(np.x) - 36.0, np.y - 0.6, abs(np.z) - 24.0), 1.8, 0.6, 0.4), STEEL));
  vec3 c = k - vec3(50.0, 250.0, 0.0);
  float hubs = cylX(vec3(abs(c.x) - 22.0, c.yz), 52.0, 18.0, 4.0);
  r = U(r, vec2(hubs, STEEL));
  r = U(r, vec2(cylX(c, 48.0, 5.0, 2.0), BLACK));
  r = U(r, vec2(cylX(k - vec3(105.0, 250.0, 0.0), 24.0, 20.0, 1.0), STEEL));
  vec3 pu = k - vec3(0.0, 250.0, 0.0);
  float frame = cylX(pu - vec3(220.0, 0.0, 0.0), 72.0, 100.0, 10.0);
  frame = smin(frame, rbox(pu - vec3(220.0, -122.0, 0.0), vec3(60.0, 50.0, 70.0), 8.0), 20.0);
  float casing = smin(cylX(pu - vec3(395.0, 0.0, 0.0), 158.0, 55.0, 26.0), cylX(pu - vec3(395.0, 12.0, 10.0), 162.0, 48.0, 26.0), 18.0);
  casing = smin(casing, rbox(pu - vec3(395.0, -140.0, 0.0), vec3(50.0, 30.0, 110.0), 6.0), 16.0);
  casing = smin(casing, cylX(pu - vec3(330.0, 0.0, 0.0), 105.0, 22.0, 6.0), 12.0);
  casing = smin(casing, cylX(pu - vec3(490.0, 0.0, 0.0), 64.0, 50.0, 4.0), 14.0);
  casing = smin(casing, cylY(pu - vec3(395.0, 190.0, 0.0), 52.0, 45.0, 4.0), 14.0);
  r = U(r, vec2(min(frame, casing), PUMP));
  vec3 pp = pu - vec3(225.0, 0.0, 0.0);
  float plate = max(abs(length(pp.yz) - 72.8) - 0.6, max(abs(pp.x) - 32.0, max(abs(pp.y) - 20.0, -pp.z)));
  r = U(r, vec2(plate, ALU));
  r = U(r, vec2(flange(pu - vec3(545.0, 0.0, 0.0), 102.0, 10.0), PUMP));
  r = U(r, vec2(flange(vec3(pu.y - 240.0, pu.x - 395.0, pu.z), 88.0, 10.0), PUMP));
  float sp = cylX(pu - vec3(650.0, 0.0, 0.0), 58.0, 95.0, 0.0);
  sp = min(sp, pipeBend(pu, vec2(745.0, -120.0), 120.0, 58.0, 1.0, 1.0));
  sp = min(sp, cylY(pu - vec3(865.0, -185.0, 0.0), 58.0, 65.0, 0.0));
  float dp = cylY(pu - vec3(395.0, 390.0, 0.0), 48.0, 140.0, 0.0);
  dp = min(dp, pipeBend(vec3(pu.z, pu.y, pu.x - 395.0), vec2(-110.0, 530.0), 110.0, 48.0, 1.0, 1.0));
  dp = min(dp, cylZ(pu - vec3(395.0, 640.0, -405.0), 48.0, 295.0, 0.0));
  dp = min(dp, pipeBend(vec3(pu.z, pu.y, pu.x - 395.0), vec2(-700.0, 750.0), 110.0, 48.0, -1.0, -1.0));
  r = U(r, vec2(min(sp, dp), PIPE));
  r = U(r, vec2(flange(pu - vec3(560.0, 0.0, 0.0), 100.0, 9.0), PIPE));
  vec3 g = pu - vec3(395.0, 430.0, 52.0);
  r = U(r, vec2(cylZ(g - vec3(0.0, 0.0, 12.0), 12.0, 12.0, 1.0), BRASS));
  r = U(r, vec2(cylZ(vec3(g.x, g.y - 70.0, g.z - 30.0), 50.0, 16.0, 6.0), CHROME));
  r = U(r, vec2(cylY(vec3(g.x, g.y - 30.0, g.z - 30.0), 8.0, 24.0, 1.0), BRASS));
  r = U(r, vec2(cylZ(vec3(g.x, g.y - 70.0, g.z - 46.5), 43.0, 0.5, 0.0), GAUGE));
  return r;
}

vec2 drive(vec3 c) {
  vec2 r = beltConveyor(c, 1600.0, 400.0, 750.0, BELT);
  vec3 g = c - vec3(762.0, 690.0, 290.0);
  float gb = rbox(g, vec3(80.0, 110.0, 58.0), 14.0);
  gb = smin(gb, cylZ(g - vec3(0.0, 28.0, -40.0), 70.0, 40.0, 8.0), 10.0);
  gb = max(gb, -box(vec3(g.x, g.y - 22.0 * clamp(round(g.y / 22.0), -3.0, 3.0), g.z - 58.0), vec3(68.0, 2.5, 3.0)));
  r = U(r, vec2(gb, GMOTOR));
  r = U(r, vec2(cylZ(vec3(abs(g.x) - 62.0, abs(g.y) - 92.0, g.z - 58.0), 5.0, 2.0, 1.0), STEEL));
  r = U(r, vec2(cylX(g + vec3(95.0, 30.0, 0.0), 82.0, 15.0, 4.0), GMOTOR));
  r = U(r, flangeMotor(g + vec3(245.0, 30.0, 0.0), 78.0, 220.0, GMOTOR));
  r = U(r, vec2(rbox(g - vec3(0.0, -150.0, -40.0), vec3(12.0, 60.0, 8.0), 3.0), DARK));
  vec3 k1 = c - vec3(-150.0, 750.0, 8.0);
  k1.xz = rot(0.07) * k1.xz;
  r = U(r, carton(k1, vec3(160.0, 110.0, 130.0)));
  vec3 k2 = c - vec3(-565.0, 750.0, -12.0);
  k2.xz = rot(-0.04) * k2.xz;
  r = U(r, carton(k2, vec3(160.0, 110.0, 130.0)));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - CABPOS - vec3(-100.0, 1050.0, 380.0), vec3(600.0, 1060.0, 620.0)) < r.x) {
    r = U(r, openCab(p));
    vec3 q = toPlate(p);
    if (box(q - vec3(0.0, 150.0, 80.0), vec3(370.0, 820.0, 90.0)) < r.x) r = U(r, interior(q));
  }
  vec3 k = p - SKID;
  if (box(k - vec3(250.0, 380.0, -220.0), vec3(820.0, 400.0, 600.0)) < r.x) r = U(r, skid(k));
  vec3 c = p - CONV;
  if (box(c - vec3(0.0, 420.0, 60.0), vec3(860.0, 440.0, 380.0)) < r.x) r = U(r, drive(c));
  float cab = capsule(p, vec3(-110.0, 412.0, 345.0), vec3(-110.0, 300.0, 410.0), 11.0);
  cab = smin(cab, capsule(p, vec3(-110.0, 300.0, 410.0), vec3(-130.0, 11.0, 440.0), 11.0), 20.0);
  cab = smin(cab, capsule(p, vec3(-130.0, 11.0, 440.0), vec3(-520.0, 11.0, 300.0), 11.0), 20.0);
  cab = smin(cab, capsule(p, vec3(-520.0, 11.0, 300.0), vec3(-760.0, 11.0, -240.0), 11.0), 20.0);
  r = U(r, vec2(cab, CABLE));
  vec3 rs = p - SKID - vec3(395.0, 250.0, -810.0);
  if (box(rs - vec3(0.0, 3400.0, 0.0), vec3(80.0, 2700.0, 80.0)) < r.x) {
    r = U(r, vec2(cylY(rs - vec3(0.0, 3350.0, 0.0), 48.0, 2600.0, 0.0), PIPE));
    r = U(r, vec2(cylY(vec3(rs.x, rs.y - 1500.0 - 1200.0 * clamp(round((rs.y - 1500.0) / 1200.0), 0.0, 3.0), rs.z), 104.0, 9.0, 2.0), PIPE));
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == WARN) {
    vec3 q = toPlate(p);
    float k = clamp(round((q.x + 95.0) / 140.0), 0.0, 2.0);
    vec2 uv = q.xy - vec2(-95.0 + k * 140.0 + 64.0 * 0.68, 560.0 - 148.0 * 0.55);
    return mat(warnSign(uv, 10.0, vec3(0.6, 0.61, 0.6)), 0.35, 0.0);
  }
  if (id == VLCD) {
    vec3 q = toPlate(p);
    float k = clamp(round((q.x + 95.0) / 140.0), 0.0, 2.0);
    vec2 uv = (q.xy - vec2(-95.0 + k * 140.0, 560.0 + 148.0 * 0.53)) / vec2(61.0, 27.0) + 0.5;
    vec3 c = vec3(0.04, 0.07, 0.1);
    c = mix(c, vec3(0.6, 0.85, 1.0), textLines(uv, vec2(0.45, 0.62), vec2(0.38, 0.2), 1.0, k + 1.0));
    c = mix(c, vec3(0.4, 0.6, 0.8), 0.7 * textLines(uv, vec2(0.4, 0.22), vec2(0.32, 0.12), 1.0, k + 7.0));
    return glow(vec3(0.01), 0.08, c * 1.2);
  }
  if (id == GAUGE) {
    vec3 g = p - SKID - vec3(395.0, 250.0 + 430.0 + 70.0, 52.0 + 30.0);
    vec2 uv = g.xy / 43.0;
    float a = atan(uv.x, uv.y);
    float rr = length(uv);
    vec3 c = vec3(0.85);
    float ticks = step(0.78, rr) * step(rr, 0.9) * step(abs(rep(a, 0.2618)), 0.03) * step(abs(a), 2.36);
    c = mix(c, vec3(0.05), ticks);
    c = mix(c, vec3(0.6, 0.05, 0.03), step(0.82, rr) * step(rr, 0.9) * step(1.6, a) * step(a, 2.36));
    vec2 nd = rot(-0.6) * uv;
    c = mix(c, vec3(0.05), step(abs(nd.x), 0.025) * step(-0.1, nd.y) * step(nd.y, 0.72));
    c = mix(c, vec3(0.05), step(rr, 0.07));
    return mat(c, 0.15, 0.0);
  }
  if (id == PUMP) return mat(vec3(0.36, 0.035, 0.025), 0.34, 0.0);
  if (id == GMOTOR) return mat(vec3(0.15, 0.17, 0.19), 0.4, 0.0);
  if (id == PIPE) return mat(vec3(0.3, 0.32, 0.33), 0.42, 0.0);
  if (id == LEDS) return glow(vec3(0.05), 0.2, vec3(0.25, 2.2, 0.4));
  if (id == ZINC) return mat(vec3(0.66, 0.68, 0.7) * (0.92 + 0.12 * fbm(p * 0.02)), 0.62, 1.0);
  if (id == WBLACK) return mat(vec3(0.02), 0.38, 0.0);
  if (id == WGREY) return mat(vec3(0.3, 0.31, 0.32), 0.4, 0.0);
  if (id == WBLUE) return mat(vec3(0.02, 0.08, 0.36), 0.38, 0.0);
  return libMat(id, p, n);
}
