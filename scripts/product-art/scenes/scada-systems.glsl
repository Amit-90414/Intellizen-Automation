const vec3 BC = vec3(450.0, 1000.0, -300.0);
const float BR = 2500.0;

const float NOTE = 70.0, FABRIC = 71.0;
const float SCR_L = 60.0, SCR_C = 61.0, SCR_R = 62.0, SCR_W = 63.0, DESKTOP = 64.0, RLCD = 65.0, PCBLUE = 66.0, PCYEL = 67.0, LEDG = 68.0, LEDB = 69.0;

const vec3 RACK = vec3(1700.0, 0.0, -520.0);
const vec3 WALL = vec3(0.0, 1760.0, -820.0);

vec3 toMon(vec3 p, float i) {
  vec3 q = p - vec3(650.0 * i, 1060.0, -190.0 + 90.0 * abs(i));
  q.xz = rot(-0.42 * i) * q.xz;
  return q;
}

vec3 screenAlarms(vec2 uv, float seed) {
  vec3 c = vec3(0.1, 0.11, 0.13);
  c = mix(c, vec3(0.05, 0.2, 0.4), rect(uv, vec2(0.5, 0.955), vec2(0.5, 0.045)));
  c = mix(c, vec3(0.85), textLines(uv, vec2(0.2, 0.955), vec2(0.15, 0.02), 1.0, seed));
  c = mix(c, vec3(0.16, 0.18, 0.22), rect(uv, vec2(0.5, 0.86), vec2(0.48, 0.03)));
  for (int i = 0; i < 11; i++) {
    float y = 0.79 - float(i) * 0.065;
    float k = h22(vec2(float(i), seed)).x;
    vec3 sev = k < 0.2 ? vec3(0.9, 0.15, 0.1) : (k < 0.55 ? vec3(0.95, 0.65, 0.1) : vec3(0.3, 0.6, 0.95));
    c = mix(c, i == 1 ? vec3(0.22, 0.12, 0.1) : vec3(0.12, 0.13, 0.16), rect(uv, vec2(0.5, y), vec2(0.48, 0.028)));
    c = mix(c, sev, rect(uv, vec2(0.035, y), vec2(0.01, 0.02)));
    c = mix(c, vec3(0.75), textLines(uv, vec2(0.17, y), vec2(0.1, 0.014), 1.0, seed + float(i)));
    c = mix(c, vec3(0.85), textLines(uv, vec2(0.55, y), vec2(0.25, 0.014), 1.0, seed + float(i) * 3.0));
    c = mix(c, vec3(0.6), textLines(uv, vec2(0.9, y), vec2(0.06, 0.014), 1.0, seed + float(i) * 7.0));
  }
  c = mix(c, vec3(0.15, 0.6, 0.28), rrect(uv, vec2(0.8, 0.05), vec2(0.15, 0.03), 0.008));
  return c;
}

vec2 screenPanel(vec3 p, vec2 hs, float d, float border, float sid) {
  float bez = rbox(p + vec3(0.0, 0.0, d * 0.5), vec3(hs, d * 0.5), 4.0);
  float glass = box(p + vec3(0.0, 0.0, 0.35), vec3(hs - border, 0.65));
  return U(vec2(bez, BLACK), vec2(glass, sid));
}

vec2 monitor(vec3 q, float sid) {
  vec2 r = screenPanel(q, vec2(312.0, 186.0), 18.0, 9.0, sid);
  r = U(r, vec2(rbox(q + vec3(0.0, 20.0, 40.0), vec3(250.0, 140.0, 24.0), 12.0), BLACK));
  r = U(r, vec2(rbox(q + vec3(0.0, 200.0, 62.0), vec3(18.0, 120.0, 10.0), 4.0), MGREY));
  r = U(r, vec2(rbox(q + vec3(0.0, 314.0, 40.0), vec3(120.0, 5.0, 95.0), 4.0), MGREY));
  r = U(r, vec2(cylZ(q - vec3(286.0, -172.0, 0.6), 2.0, 0.6, 0.3), LEDB));
  if (sid == SCR_L) {
    vec3 nq = q - vec3(-270.0, -150.0, 0.8);
    nq.xy = rot(0.08) * nq.xy;
    r = U(r, vec2(box(nq, vec3(36.0, 36.0, 0.3)), NOTE));
  }
  return r;
}

vec2 keyboard(vec3 k) {
  vec2 r = vec2(rbox(k, vec3(220.0, 9.0, 70.0), 6.0), BLACK);
  vec3 c = vec3(k.x + 9.5 - 19.0 * clamp(round((k.x + 9.5) / 19.0), -10.0, 11.0), k.y - 10.0, k.z - 19.0 * clamp(round(k.z / 19.0), -2.0, 2.0) - 4.0);
  r = U(r, vec2(rbox(c, vec3(8.0, 4.0, 8.0), 2.5), MGREY));
  return r;
}

vec2 desk(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(0.0, 725.0, 0.0), vec3(1250.0, 16.0, 420.0), 8.0), DESKTOP);
  r = U(r, vec2(rbox(vec3(abs(p.x) - 1200.0, p.y - 355.0, p.z), vec3(22.0, 355.0, 400.0), 6.0), MGREY));
  r = U(r, vec2(rbox(p - vec3(0.0, 430.0, -360.0), vec3(1180.0, 270.0, 10.0), 4.0), MGREY));
  float i = clamp(round(p.x / 650.0), -1.0, 1.0);
  vec3 m = toMon(p, i);
  if (box(m + vec3(0.0, 120.0, 40.0), vec3(330.0, 330.0, 140.0)) < r.x) r = U(r, monitor(m, SCR_C + i));
  float j = clamp(i + (p.x > i * 650.0 ? 1.0 : -1.0), -1.0, 1.0);
  vec3 m2 = toMon(p, j);
  if (j != i && box(m2 + vec3(0.0, 120.0, 40.0), vec3(330.0, 330.0, 140.0)) < r.x) r = U(r, monitor(m2, SCR_C + j));
  r = U(r, keyboard(p - vec3(0.0, 751.0, 170.0)));
  vec3 ms = p - vec3(330.0, 755.0, 190.0);
  r = U(r, vec2((length(ms / vec3(32.0, 18.0, 55.0)) - 1.0) * 17.0, BLACK));
  vec3 mug = p - vec3(-520.0, 741.0, 210.0);
  float cup = max(cylY(mug - vec3(0.0, 50.0, 0.0), 42.0, 50.0, 4.0), -cylY(mug - vec3(0.0, 60.0, 0.0), 37.0, 50.0, 2.0));
  cup = min(cup, max(torusZ(mug - vec3(46.0, 52.0, 0.0), 22.0, 5.5), 40.0 - mug.x));
  r = U(r, vec2(cup, WHITE));
  vec3 pa = p - vec3(-860.0, 744.0, 160.0);
  pa.xz = rot(0.12) * pa.xz;
  r = U(r, vec2(rbox(pa, vec3(105.0, 3.0, 150.0), 1.5), PAPER));
  vec3 pen = p - vec3(-760.0, 748.0, 150.0);
  pen.xz = rot(0.7) * pen.xz;
  r = U(r, vec2(capsule(pen, vec3(-70.0, 0.0, 0.0), vec3(70.0, 0.0, 0.0), 4.5), NAVY));
  float i2 = clamp(round(p.x / 650.0), -1.0, 1.0);
  vec3 cb = p - vec3(620.0 * i2, 740.0, -300.0 + 90.0 * abs(i2));
  r = U(r, vec2(capsule(cb, vec3(0.0, 120.0, 0.0), vec3(-40.0 * i2, 6.0, -60.0), 3.5), CABLE));
  r = U(r, vec2(cylY(p - vec3(0.0, 741.0, -330.0), 32.0, 2.0, 1.0), BLACK));
  return r;
}

vec2 wallScreen(vec3 w) {
  vec2 r = screenPanel(w, vec2(860.0, 490.0), 70.0, 12.0, SCR_W);
  vec3 s = vec3(abs(w.x) - 480.0, w.y, w.z + 95.0);
  r = U(r, vec2(rbox(s + vec3(0.0, 655.0, 0.0), vec3(35.0, 1105.0, 30.0), 5.0), DARK));
  r = U(r, vec2(rbox(s + vec3(0.0, 1760.0 - 12.0, -20.0), vec3(45.0, 12.0, 330.0), 4.0), DARK));
  r = U(r, vec2(rbox(w + vec3(0.0, 0.0, 85.0), vec3(500.0, 60.0, 10.0), 3.0), DARK));
  return r;
}

vec2 server(vec3 q, float n) {
  float h = n * 22.225 - 0.6;
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, -330.0), vec3(220.0, h, 330.0), 2.0), DARK);
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 4.0), vec3(241.0, h, 4.0), 1.5), MGREY));
  vec2 pitch = n > 1.5 ? vec2(98.0, 40.0) : vec2(19.0, 0.0);
  vec2 cells = n > 1.5 ? vec2(1.5, 0.5) : vec2(4.5, 0.0);
  vec2 bh = n > 1.5 ? vec2(46.0, 17.5) : vec2(8.0, h - 4.0);
  float bx = q.x + 30.0;
  bx = bx - pitch.x * (clamp(round(bx / pitch.x - (n > 1.5 ? 0.5 : 0.5)) + 0.5, -cells.x, cells.x));
  float by = n > 1.5 ? q.y - pitch.y * (clamp(round(q.y / pitch.y - 0.5) + 0.5, -cells.y, cells.y)) : q.y;
  vec3 b = vec3(bx, by, q.z - 8.0);
  r.x = max(r.x, -box(b - vec3(0.0, 0.0, 2.0), vec3(bh + 1.0, 3.0)));
  r = U(r, vec2(rbox(b, vec3(bh, 1.5), 0.8), DARK));
  r = U(r, vec2(cylZ(b - vec3(bh.x - 4.0, bh.y - 4.0, 1.6), 1.2, 0.5, 0.2), LEDG));
  r = U(r, vec2(rbox(vec3(abs(q.x) - 228.0, q.y, q.z - 14.0), vec3(6.0, h - 4.0, 8.0), 3.0), MGREY));
  r = U(r, vec2(cylZ(q - vec3(190.0, 0.0, 9.0), 3.0, 1.0, 0.4), LEDB));
  r = U(r, vec2(box(q - vec3(-208.0, h - 9.0, 8.3), vec3(9.0, 4.5, 0.2)), WHITE));
  return r;
}

vec2 netUnit(vec3 q, float leds) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, -200.0), vec3(220.0, 21.6, 200.0), 2.0), DARK);
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 3.0), vec3(241.0, 21.6, 3.0), 1.0), BLACK));
  vec3 pq = vec3(q.x + 8.0 - 16.0 * clamp(round((q.x + 8.0) / 16.0), -11.0, 12.0), q.y - (q.y > 0.0 ? 9.0 : -9.0), q.z - 6.0);
  r.x = max(r.x, -box(pq, vec3(6.0, 5.5, 5.0)));
  r = U(r, vec2(box(pq + vec3(0.0, 0.0, 4.0), vec3(6.0, 5.5, 0.6)), MGREY));
  if (leds > 0.5) r = U(r, vec2(cylZ(vec3(pq.x - 4.5, q.y - (q.y > 0.0 ? 17.5 : -17.5), q.z - 6.0), 1.0, 0.4, 0.2), LEDG));
  return r;
}

vec2 rack(vec3 k) {
  vec3 c = k - vec3(0.0, 1010.0, 0.0);
  float shell = rbox(c, vec3(300.0, 1000.0, 500.0), 5.0);
  shell = max(shell, -box(c - vec3(0.0, 0.0, 40.0), vec3(268.0, 965.0, 480.0)));
  vec2 r = vec2(shell, DARK);
  r = U(r, vec2(cylY(vec3(abs(k.x) - 250.0, k.y - 5.0, abs(k.z) - 450.0), 25.0, 5.0, 2.0), BLACK));
  vec3 rl = vec3(abs(k.x) - 247.0, k.y - 1010.0, k.z - 455.0);
  float rails = box(rl, vec3(9.0, 940.0, 1.5));
  rails = max(rails, -box(vec3(rl.x, rep(k.y, 15.875), rl.z), vec3(3.0, 3.0, 4.0)));
  r = U(r, vec2(rails, ZINC));
  vec3 f = k - vec3(0.0, 0.0, 452.0);
  float y0 = 100.0;
  float u = clamp(floor((k.y - y0) / 44.45), 0.0, 41.0);
  if (u < 3.0) {
    vec3 q = f - vec3(0.0, y0 + 1.5 * 44.45, 0.0);
    r = U(r, vec2(rbox(q - vec3(0.0, 0.0, -300.0), vec3(220.0, 66.0, 300.0), 2.0), DARK));
    float face = rbox(q - vec3(0.0, 0.0, 6.0), vec3(241.0, 66.0, 6.0), 3.0);
    face = max(face, -max(box(vec3(rep(q.x, 8.0), q.y, q.z - 12.0), vec3(1.8, 40.0, 3.0)), abs(q.x - 90.0) - 130.0));
    r = U(r, vec2(face, BLACK));
    r = U(r, vec2(box(q - vec3(-150.0, 18.0, 12.4), vec3(45.0, 20.0, 0.4)), RLCD));
    r = U(r, vec2(rbox(vec3(q.x + 150.0 - 30.0 * clamp(round((q.x + 150.0) / 30.0), -1.0, 1.0), q.y + 30.0, q.z - 13.0), vec3(9.0, 6.0, 2.0), 2.0), MGREY));
  } else if (u < 9.0) {
    float s = 3.0 + 2.0 * floor((u - 3.0) / 2.0);
    r = U(r, server(f - vec3(0.0, y0 + (s + 1.0) * 44.45, 0.0), 2.0));
  } else if (u == 10.0 || u == 12.0) {
    r = U(r, netUnit(f - vec3(0.0, y0 + (u + 0.5) * 44.45, 0.0), 0.0));
  } else if (u == 11.0) {
    r = U(r, netUnit(f - vec3(0.0, y0 + 11.5 * 44.45, 0.0), 1.0));
  } else if (u == 13.0) {
    vec3 q = f - vec3(0.0, y0 + 13.5 * 44.45, 0.0);
    r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 1.5), vec3(241.0, 21.8, 1.5), 0.8), BLACK));
    vec3 rg = vec3(q.x - 80.0 * clamp(round(q.x / 80.0), -2.0, 2.0), q.y, q.z - 30.0);
    r = U(r, vec2(max(length(vec2(length(rg.xz) - 22.0, rg.y)) - 4.0, -rg.z), BLACK));
  } else if (u > 13.5 && u < 17.5) {
    r = U(r, server(f - vec3(0.0, y0 + (u + 0.5) * 44.45, 0.0), 1.0));
  } else if (u > 17.5 && u < 19.5) {
    r = U(r, server(f - vec3(0.0, y0 + 19.0 * 44.45, 0.0), 2.0));
  } else if (u == 21.0) {
    vec3 q = f - vec3(0.0, y0 + 21.5 * 44.45, 0.0);
    r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 2.0), vec3(241.0, 21.8, 2.0), 0.8), DARK));
    r = U(r, vec2(rbox(q - vec3(0.0, -6.0, 10.0), vec3(70.0, 5.0, 6.0), 3.0), MGREY));
  } else if (u > 21.5 && u < 23.5) {
    r = U(r, server(f - vec3(0.0, y0 + 23.0 * 44.45, 0.0), 2.0));
  } else {
    vec3 q = f - vec3(0.0, y0 + (u + 0.5) * 44.45, 0.0);
    r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 1.5), vec3(241.0, 21.8, 1.5), 0.8), BLACK));
  }
  vec3 pc = vec3(f.x + 8.0 - 32.0 * clamp(round((f.x + 8.0) / 32.0), -5.0, 6.0), f.y - y0 - 11.0 * 44.45, f.z);
  float loop = max(length(vec2(length(vec2(pc.y, pc.z - 12.0)) - 26.0, pc.x)) - 2.6, -pc.z + 12.0);
  r = U(r, vec2(loop, mod(round((f.x + 8.0) / 32.0), 2.0) < 0.5 ? PCBLUE : PCYEL));
  vec3 pc2 = vec3(pc.x, f.y - y0 - 12.0 * 44.45, f.z);
  float loop2 = max(length(vec2(length(vec2(pc2.y, pc2.z - 12.0)) - 24.0, pc2.x - 6.0)) - 2.6, -pc2.z + 12.0);
  r = U(r, vec2(loop2, PCBLUE));
  r = U(r, vec2(rbox(c - vec3(0.0, 1000.0 - 14.0, 500.0), vec3(80.0, 9.0, 1.0), 1.0), WHITE));
  return r;
}

vec3 toRack(vec3 p) {
  vec3 k = p - RACK;
  k.xz = rot(-0.38) * k.xz;
  return k;
}

vec2 chair(vec3 c) {
  float a = atan(c.z, c.x);
  float sector = 6.2831853 / 5.0;
  vec2 lc = rot(-sector * round(a / sector)) * c.xz;
  vec3 leg = vec3(lc.x, c.y, lc.y);
  vec2 r = vec2(capsule(leg, vec3(30.0, 75.0, 0.0), vec3(310.0, 58.0, 0.0), 16.0), BLACK);
  r = U(r, vec2(cylY(vec3(leg.x - 310.0, c.y - 30.0, leg.z), 24.0, 12.0, 8.0), BLACK));
  r = U(r, vec2(cylY(c - vec3(0.0, 85.0, 0.0), 40.0, 25.0, 8.0), BLACK));
  r = U(r, vec2(cylY(c - vec3(0.0, 250.0, 0.0), 26.0, 150.0, 4.0), CHROME));
  r = U(r, vec2(rbox(c - vec3(0.0, 420.0, 0.0), vec3(110.0, 18.0, 110.0), 10.0), DARK));
  vec3 s = c - vec3(0.0, 475.0, 0.0);
  r = U(r, vec2(rbox(s, vec3(245.0, 38.0, 240.0), 34.0), FABRIC));
  r = U(r, vec2(rbox(c - vec3(0.0, 560.0, -250.0), vec3(40.0, 140.0, 14.0), 8.0), DARK));
  vec3 b = c - vec3(0.0, 860.0, -275.0);
  b.yz = rot(0.12) * b.yz;
  r = U(r, vec2(rbox(b, vec3(230.0, 260.0, 42.0), 38.0), FABRIC));
  vec3 ar = vec3(abs(c.x) - 255.0, c.y - 620.0, c.z + 20.0);
  r = U(r, vec2(rbox(ar, vec3(22.0, 10.0, 130.0), 8.0), BLACK));
  r = U(r, vec2(rbox(ar + vec3(0.0, 70.0, -40.0), vec3(12.0, 70.0, 14.0), 5.0), BLACK));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 640.0, 0.0), vec3(1260.0, 650.0, 430.0)) < r.x) r = U(r, desk(p));
  vec3 w = p - WALL;
  if (box(w + vec3(0.0, 380.0, 120.0), vec3(880.0, 1400.0, 360.0)) < r.x) r = U(r, wallScreen(w));
  vec3 k = toRack(p);
  if (box(k - vec3(0.0, 1010.0, 20.0), vec3(310.0, 1015.0, 540.0)) < r.x) r = U(r, rack(k));
  vec3 c = p - vec3(180.0, 0.0, 820.0);
  c.xz = rot(0.5) * c.xz;
  if (box(c - vec3(0.0, 560.0, -60.0), vec3(340.0, 570.0, 340.0)) < r.x) r = U(r, chair(c));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id >= SCR_L && id <= SCR_R) {
    float i = id - SCR_C;
    vec3 m = toMon(p, i);
    vec2 uv = m.xy / vec2(606.0, 354.0) + 0.5;
    vec3 c = i < -0.5 ? screenTrend(uv, 3.0) : (i < 0.5 ? screenScada(uv, 1.0) : screenAlarms(uv, 2.0));
    return glow(vec3(0.004), 0.42, c * 1.5);
  }
  if (id == SCR_W) {
    vec2 uv = (p.xy - WALL.xy) / vec2(1696.0, 956.0) + 0.5;
    return glow(vec3(0.004), 0.42, screenScada(uv, 6.0) * 1.5);
  }
  if (id == RLCD) {
    vec3 k = toRack(p);
    vec2 uv = (k.xy - vec2(-150.0, 100.0 + 1.5 * 44.45 + 18.0)) / vec2(90.0, 40.0) + 0.5;
    vec3 c = mix(vec3(0.05, 0.12, 0.2), vec3(0.6, 0.85, 1.0), textLines(uv, vec2(0.5, 0.5), vec2(0.4, 0.3), 2.0, 4.0));
    return glow(vec3(0.01), 0.08, c * 1.1);
  }
  if (id == FABRIC) return mat(vec3(0.03, 0.035, 0.04) * (0.85 + 0.3 * vnoise(p * 0.6)), 0.8, 0.0);
  if (id == NOTE) return mat(vec3(0.85, 0.72, 0.15), 0.6, 0.0);
  if (id == DESKTOP) return mat(vec3(0.52, 0.5, 0.47), 0.32, 0.0);
  if (id == PCBLUE) return mat(vec3(0.03, 0.12, 0.45), 0.35, 0.0);
  if (id == PCYEL) return mat(vec3(0.7, 0.5, 0.02), 0.35, 0.0);
  if (id == LEDG) return glow(vec3(0.05), 0.2, vec3(0.25, 2.2, 0.4));
  if (id == LEDB) return glow(vec3(0.05), 0.2, vec3(0.3, 0.9, 2.6));
  if (id == ZINC) return mat(vec3(0.66, 0.68, 0.7), 0.62, 1.0);
  return libMat(id, p, n);
}
