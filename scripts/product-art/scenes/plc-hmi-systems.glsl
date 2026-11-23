const vec3 BC = vec3(350.0, 1050.0, 300.0);
const float BR = 2000.0;

const float WARN = 71.0, WARN_SIDE = 72.0;
const float SCR = 60.0, LEDS = 62.0, EARTH = 64.0, WBLUE = 66.0, WBLACK = 67.0, WGREY = 68.0, WRED = 69.0, PATCH = 70.0;

const vec3 CAB = vec3(800.0, 2000.0, 400.0);
const float DOOR = 1.95;

vec3 toPlate(vec3 p) { return p - vec3(0.0, 1050.0, -CAB.z * 0.5 + 24.0); }

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

vec3 toHead(vec3 p) {
  vec3 q = p - vec3(1000.0, 1250.0, 280.0);
  q.xz = rot(-0.32) * q.xz;
  q.yz = rot(0.26) * q.yz;
  return q;
}

vec2 screenPanel(vec3 p, vec2 hs, float d, float border, float sid) {
  float bez = rbox(p + vec3(0.0, 0.0, d * 0.5), vec3(hs, d * 0.5), 4.0);
  float glass = box(p + vec3(0.0, 0.0, 0.35), vec3(hs - border, 0.65));
  return U(vec2(bez, BLACK), vec2(glass, sid));
}

float duct(vec3 q, float L) {
  float body = box(q - vec3(0.0, 0.0, 30.0), vec3(L * 0.5, 30.0, 30.0));
  body = max(body, -box(q - vec3(0.0, 0.0, 33.0), vec3(L * 0.5 + 1.0, 28.0, 30.0)));
  body = max(body, -box(vec3(rep(q.x, 12.0), abs(q.y) - 29.0, q.z - 38.0), vec3(2.4, 3.0, 21.0)));
  float lid = rbox(q - vec3(0.0, 0.0, 61.5), vec3(L * 0.5, 31.5, 1.5), 1.0);
  return min(body, lid);
}

vec2 wireRun(vec3 q, float pitch, float x0, float x1, float y0, float y1, float z, float fy, float id) {
  float x = q.x - x0 - pitch * clamp(round((q.x - x0) / pitch), 0.0, floor((x1 - x0) / pitch + 0.01));
  float w = max(length(vec2(x, q.z - z)) - 1.3, abs(q.y - (y0 + y1) * 0.5) - (y1 - y0) * 0.5);
  float f = max(length(vec2(x, q.z - z)) - 1.9, abs(q.y - fy) - 5.0);
  return U(vec2(w, id), vec2(f, WHITE));
}

vec2 wireSlant(vec3 q, float pitch, float x0, float x1, vec2 a, vec2 b, float id) {
  float x = q.x - x0 - pitch * clamp(round((q.x - x0) / pitch), 0.0, floor((x1 - x0) / pitch + 0.01));
  vec2 pa = q.yz - a, ba = b - a;
  float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
  return vec2(length(vec3(x, pa - ba * h)) - 1.3, id);
}

vec2 ioModule(vec3 q, float w) {
  float hw = w * 0.5 - 0.5;
  float body = rbox(q - vec3(0.0, 0.0, 36.0), vec3(hw, 50.0, 36.0), 1.5);
  vec2 r = vec2(body, DARK);
  r = U(r, vec2(rbox(q - vec3(0.0, -10.0, 72.4), vec3(hw - 1.6, 30.0, 1.0), 0.7), MGREY));
  r = U(r, vec2(box(q - vec3(-hw + 7.0, 30.0, 72.2), vec3(3.6, 13.0, 0.5)), LEDS));
  r = U(r, vec2(box(q - vec3(3.5, 30.0, 72.2), vec3(hw - 9.0, 13.0, 0.3)), WHITE));
  r = U(r, vec2(box(q - vec3(0.0, -10.0, 73.6), vec3(hw - 4.0, 4.0, 0.2)), WHITE));
  return r;
}

vec2 cpuModule(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 40.0), vec3(39.5, 50.0, 40.0), 2.0), DARK);
  r = U(r, vec2(box(q - vec3(-28.0, 30.0, 80.2), vec3(3.6, 13.0, 0.5)), LEDS));
  float ports = rbox(vec3(q.x - 14.0, abs(q.y + 18.0) - 9.0, q.z - 80.0), vec3(8.0, 6.5, 3.0), 0.8);
  r.x = max(r.x, -ports);
  r = U(r, vec2(box(vec3(q.x - 14.0, abs(q.y + 18.0) - 9.0, q.z - 77.5), vec3(7.0, 5.5, 0.5)), BLACK));
  r = U(r, vec2(rbox(q - vec3(-18.0, -14.0, 80.6), vec3(14.0, 24.0, 0.8), 0.5), MGREY));
  r = U(r, vec2(box(q - vec3(14.0, 22.0, 80.2), vec3(9.0, 1.2, 0.6)), BLACK));
  return r;
}

vec2 psu(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 55.0), vec3(29.5, 62.0, 55.0), 2.0), ALU);
  r.x = max(r.x, -box(vec3(rep(q.x, 6.0), abs(q.y) - 62.0, q.z - 60.0), vec3(1.2, 4.0, 30.0)));
  r = U(r, vec2(rbox(vec3(q.x, abs(q.y) - 48.0, q.z - 106.0), vec3(26.0, 9.0, 6.0), 1.0), BLACK));
  r = U(r, vec2(max(cylZ(vec3(rep(q.x, 10.0), abs(q.y) - 48.0, q.z - 112.0), 2.6, 0.8, 0.3), abs(q.x) - 24.0), STEEL));
  r = U(r, vec2(cylZ(q - vec3(-14.0, 20.0, 110.0), 2.4, 0.8, 0.4), LGREEN));
  r = U(r, vec2(cylZ(q - vec3(10.0, 20.0, 110.0), 3.2, 0.8, 0.4), WHITE));
  return r;
}

vec2 netSwitch(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 42.0), vec3(22.5, 55.0, 42.0), 2.0), DARK);
  vec3 pq = vec3(q.x, q.y + 8.0 - 16.0 * clamp(round((q.y + 8.0) / 16.0), -2.0, 1.0), q.z - 84.0);
  r.x = max(r.x, -box(pq, vec3(7.0, 5.5, 6.0)));
  r = U(r, vec2(box(pq + vec3(0.0, 0.0, 4.0), vec3(7.0, 5.5, 0.6)), BLACK));
  vec3 lq = vec3(q.x - 12.0, q.y + 8.0 - 16.0 * clamp(round((q.y + 8.0) / 16.0), -2.0, 1.0), q.z - 84.0);
  r = U(r, vec2(cylZ(lq, 1.4, 0.5, 0.3), LGREEN));
  r = U(r, vec2(box(q - vec3(0.0, 44.0, 84.3), vec3(16.0, 3.0, 0.5)), WHITE));
  return r;
}

vec2 relay(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 16.0), vec3(7.5, 40.0, 16.0), 1.2), MGREY);
  r = U(r, vec2(rbox(q - vec3(0.0, 4.0, 46.0), vec3(6.8, 18.0, 14.0), 1.5), WHITE));
  r = U(r, vec2(cylZ(q - vec3(0.0, -28.0, 33.0), 1.6, 0.6, 0.3), LAMBER));
  r = U(r, vec2(cylZ(vec3(q.x, abs(q.y) - 33.0, q.z - 32.5), 2.2, 0.8, 0.3), STEEL));
  return r;
}

vec2 slimModule(vec3 q, float front) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 50.0), vec3(11.0, 50.0, 50.0), 1.5), LGREY);
  r = U(r, vec2(rbox(vec3(q.x, abs(q.y) - 42.0, q.z - 96.0), vec3(10.0, 8.0, 6.0), 1.0), BLACK));
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 100.4), vec3(9.0, 24.0, 0.8), 0.5), front));
  r = U(r, vec2(cylZ(q - vec3(0.0, 16.0, 101.6), 1.6, 0.6, 0.3), LGREEN));
  r = U(r, vec2(cylZ(q - vec3(0.0, 8.0, 101.6), 1.6, 0.6, 0.3), LGREEN));
  return r;
}

vec2 mpcb(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 40.0), vec3(22.0, 45.0, 40.0), 2.0), LGREY);
  r = U(r, vec2(rbox(q - vec3(0.0, 6.0, 84.0), vec3(16.0, 20.0, 5.0), 3.0), DARK));
  vec3 k = q - vec3(0.0, 6.0, 94.0);
  float knob = cylZ(k, 12.0, 4.0, 2.0);
  knob = min(knob, rbox(k - vec3(0.0, 0.0, 5.0), vec3(3.5, 12.0, 4.0), 1.5));
  r = U(r, vec2(knob, BLACK));
  r = U(r, vec2(rbox(vec3(q.x, abs(q.y) - 37.0, q.z - 52.0), vec3(21.0, 8.0, 28.0), 1.5), MGREY));
  return r;
}

vec2 rowA(vec3 q) {
  vec2 r = dinRail(q, 600.0);
  vec3 d = q - vec3(0.0, 0.0, 7.6);
  r = U(r, psu(d - vec3(-255.0, 0.0, 0.0)));
  r = U(r, cpuModule(d - vec3(-180.0, 0.0, 0.0)));
  float m = clamp(round((d.x + 118.0) / 36.0), 0.0, 5.0);
  r = U(r, ioModule(d - vec3(-118.0 + m * 36.0, 0.0, 0.0), 35.0));
  r = U(r, netSwitch(d - vec3(128.0, 0.0, 0.0)));
  r = U(r, terminalBlocks(d - vec3(225.0, 0.0, 0.0), 8.0, LGREY));
  return r;
}

vec2 rowB(vec3 q) {
  vec2 r = dinRail(q, 600.0);
  vec3 d = q - vec3(0.0, 0.0, 7.6);
  r = U(r, mcb(d - vec3(-258.0, 0.0, 0.0), 3.0, 1.0));
  float k = clamp(round((d.x + 219.0) / 18.0), 0.0, 7.0);
  r = U(r, mcb(d - vec3(-219.0 + k * 18.0, 0.0, 0.0), 1.0, k == 5.0 ? -1.0 : 1.0));
  float j = clamp(round((d.x + 64.0) / 16.0), 0.0, 9.0);
  r = U(r, relay(d - vec3(-64.0 + j * 16.0, 0.0, 0.0)));
  float s = clamp(round((d.x - 110.0) / 23.0), 0.0, 2.0);
  r = U(r, slimModule(d - vec3(110.0 + s * 23.0, 0.0, 0.0), s < 1.5 ? YELLOW : DARK));
  return r;
}

vec2 rowC(vec3 q) {
  vec2 r = dinRail(q, 600.0);
  vec3 d = q - vec3(0.0, 0.0, 7.6);
  float c = clamp(round((d.x + 255.0) / 48.0), 0.0, 3.0);
  vec3 cq = d - vec3(-255.0 + c * 48.0, 0.0, 0.0);
  r = U(r, contactor(cq));
  r = U(r, wireRun(cq, 14.0, -14.0, 14.0, 42.0, 100.0, 36.0, 46.0, WBLACK));
  r = U(r, wireRun(cq, 14.0, -14.0, 14.0, -100.0, -42.0, 36.0, -46.0, WBLACK));
  float m = clamp(round((d.x + 40.0) / 47.0), 0.0, 1.0);
  r = U(r, mpcb(d - vec3(-40.0 + m * 47.0, 0.0, 0.0)));
  return r;
}

vec2 rowD(vec3 q) {
  vec2 r = dinRail(q, 600.0);
  vec3 d = q - vec3(0.0, 0.0, 7.6);
  r = U(r, terminalBlocks(d - vec3(-60.0, 0.0, 0.0), 34.0, BLUEP));
  r = U(r, terminalBlocks(d - vec3(190.0, 0.0, 0.0), 4.0, EARTH));
  vec2 e = vec2(rbox(vec3(abs(d.x + 26.0) - 250.0, d.y, d.z - 20.0), vec3(4.0, 24.0, 20.0), 1.0), DARK);
  r = U(r, e);
  return r;
}

vec2 interior(vec3 q) {
  vec2 r = vec2(0.7 * BR, -1.0);
  float hd = duct(q - vec3(0.0, 820.0, 0.0), 600.0);
  hd = min(hd, duct(vec3(q.x, q.y - 520.0 + 260.0 * clamp(round((520.0 - q.y) / 260.0), 0.0, 4.0), q.z), 600.0));
  hd = min(hd, duct(vec3(q.y - 150.0, abs(q.x) - 330.0, q.z), 1400.0));
  r = U(r, vec2(hd, LGREY));
  if (box(q - vec3(0.0, 680.0, 60.0), vec3(300.0, 66.0, 70.0)) < r.x) r = U(r, rowA(q - vec3(0.0, 680.0, 0.0)));
  if (box(q - vec3(0.0, 400.0, 60.0), vec3(300.0, 52.0, 70.0)) < r.x) r = U(r, rowB(q - vec3(0.0, 400.0, 0.0)));
  if (box(q - vec3(0.0, 130.0, 60.0), vec3(300.0, 100.0, 70.0)) < r.x) r = U(r, rowC(q - vec3(0.0, 130.0, 0.0)));
  if (box(q - vec3(0.0, -260.0, 40.0), vec3(300.0, 166.0, 50.0)) < r.x) r = U(r, rowD(q - vec3(0.0, q.y < -260.0 ? -390.0 : -130.0, 0.0)));
  if (box(q - vec3(-40.0, -730.0, 60.0), vec3(240.0, 190.0, 40.0)) < r.x) {
    float cx = q.x + 220.0 - 90.0 * clamp(round((q.x + 220.0) / 90.0), 0.0, 4.0);
    float cb = max(length(vec2(cx, q.z - 55.0)) - 9.0, abs(q.y + 735.0) - 180.0);
    r = U(r, vec2(cb, CABLE));
    float tie = max(abs(length(vec2(cx, q.z - 55.0)) - 9.6) - 0.9, abs(q.y + 640.0 - 120.0 * clamp(round((q.y + 640.0) / 120.0), -1.0, 1.0)) - 2.2);
    r = U(r, vec2(tie, BLACK));
    r = U(r, vec2(cylY(vec3(cx, q.y + 905.0, q.z - 55.0), 16.0, 10.0, 2.0), BLACK));
  }
  if (box(q - vec3(0.0, 445.0, 45.0), vec3(300.0, 215.0, 55.0)) < r.x) {
    r = U(r, wireSlant(q, 4.5, -130.0, 76.0, vec2(655.0, 79.0), vec2(546.0, 44.0), WBLUE));
    r = U(r, wireRun(q, 18.0, -276.0, -95.0, 444.0, 492.0, 35.0, 438.0, WBLACK));
    r = U(r, wireRun(q, 18.0, -276.0, -95.0, 290.0, 356.0, 35.0, 362.0, WGREY));
    r = U(r, wireRun(q, 16.0, -64.0, 80.0, 290.0, 362.0, 22.0, 366.0, WBLUE));
  }
  if (box(q - vec3(0.0, -160.0, 40.0), vec3(300.0, 200.0, 50.0)) < r.x) {
    r = U(r, wireRun(q, 6.2, -270.8, 151.0, -98.0, -30.0, 30.0, -94.0, WBLUE));
    r = U(r, wireRun(q, 6.2, -270.8, 151.0, -230.0, -162.0, 30.0, -166.0, WGREY));
    r = U(r, wireRun(q, 6.2, -270.8, 151.0, -358.0, -290.0, 30.0, -354.0, WBLUE));
  }
  return r;
}

vec2 openCab(vec3 p) {
  vec3 hs = vec3(CAB.x * 0.5, (CAB.y - 100.0) * 0.5, CAB.z * 0.5);
  vec3 q = p - vec3(0.0, (CAB.y + 100.0) * 0.5, 0.0);
  float shell = rbox(q, hs, 6.0);
  shell = max(shell, -box(q - vec3(0.0, 0.0, 20.0), vec3(hs.x - 16.0, hs.y - 16.0, hs.z)));
  vec2 r = vec2(shell, GREY);
  r = U(r, vec2(box(p - vec3(0.0, 50.0, 0.0), vec3(hs.x - 4.0, 50.0, hs.z - 4.0)), DARK));
  r = U(r, vec2(box(q - vec3(0.0, 0.0, -hs.z + 22.0), vec3(hs.x - 36.0, hs.y - 36.0, 2.0)), ZINC));
  vec3 g = q - vec3(hs.x + 5.0, -320.0, 0.0);
  float grille = rbox(g, vec3(6.0, 125.0, 125.0), 4.0);
  grille = max(grille, -max(box(vec3(g.x - 6.0, rep(g.y, 12.0), g.z), vec3(3.0, 3.0, 105.0)), abs(g.y) - 105.0));
  r = U(r, vec2(grille, LGREY));
  r = U(r, vec2(box(q - vec3(hs.x + 0.3, 330.0, -20.0), vec3(0.4, 48.0, 52.0)), WARN_SIDE));
  vec3 d = q - vec3(-hs.x, 0.0, hs.z);
  d.xz = rot(-DOOR) * d.xz;
  float door = rbox(d - vec3(hs.x, 0.0, 12.0), vec3(hs.x, hs.y, 12.0), 5.0);
  door = max(door, -box(d - vec3(hs.x, 0.0, -2.0), vec3(hs.x - 24.0, hs.y - 24.0, 12.0)));
  r = U(r, vec2(door, GREY));
  r = U(r, vec2(rbox(d - vec3(hs.x, -300.0, 4.0), vec3(220.0, 150.0, 6.0), 3.0), MGREY));
  r = U(r, vec2(box(d - vec3(hs.x, 120.0, 9.6), vec3(52.0, 48.0, 0.4)), WARN));
  vec3 rp = d - vec3(hs.x, 620.0, 9.4);
  r = U(r, vec2(rbox(rp, vec3(90.0, 55.0, 0.6), 2.0), ALU));
  r = U(r, vec2(cylZ(vec3(abs(rp.x) - 80.0, abs(rp.y) - 45.0, rp.z + 0.8), 2.4, 1.0, 0.6), STEEL));
  r = U(r, vec2(rbox(d - vec3(hs.x * 2.0 - 70.0, 40.0, 30.0), vec3(14.0, 70.0, 8.0), 5.0), BLACK));
  vec3 hg = vec3(q.x + hs.x + 3.0, abs(q.y) - hs.y * 0.7, q.z - hs.z - 6.0);
  r = U(r, vec2(cylY(hg, 8.0, 40.0, 2.0), DARK));
  return r;
}

vec2 pedestal(vec3 p) {
  vec3 b = p - vec3(1000.0, 0.0, 280.0);
  vec2 r = vec2(rbox(b - vec3(0.0, 8.0, 0.0), vec3(220.0, 8.0, 220.0), 4.0), GREY);
  r = U(r, vec2(cylY(vec3(abs(b.x) - 180.0, b.y - 18.0, abs(b.z) - 180.0), 9.0, 3.0, 1.0), STEEL));
  r = U(r, vec2(cylY(b - vec3(0.0, 540.0, 0.0), 42.0, 530.0, 2.0), ALU));
  r = U(r, vec2(cylY(b - vec3(0.0, 1048.0, 0.0), 70.0, 10.0, 3.0), GREY));
  vec3 h = toHead(p);
  float head = rbox(h, vec3(235.0, 205.0, 85.0), 10.0);
  r = U(r, vec2(head, GREY));
  r = U(r, screenPanel(h - vec3(0.0, 50.0, 86.0), vec2(170.0, 122.0), 8.0, 15.0, SCR));
  r = U(r, vec2(rbox(h - vec3(0.0, 189.0, 85.6), vec3(70.0, 8.0, 0.8), 1.0), WHITE));
  r = U(r, vec2(cylZ(vec3(abs(h.x) - 63.0, h.y - 189.0, h.z - 86.6), 1.6, 0.6, 0.4), STEEL));
  vec3 bq = h - vec3(0.0, -148.0, 86.0);
  r = U(r, pushButton(bq - vec3(-165.0, 0.0, 0.0), GREEN));
  r = U(r, pushButton(bq - vec3(-100.0, 0.0, 0.0), RED));
  r = U(r, selectorSwitch(bq - vec3(-35.0, 0.0, 0.0), 0.6));
  r = U(r, pilotLight(bq - vec3(30.0, 0.0, 0.0), LAMBER));
  r = U(r, estop(bq - vec3(145.0, 0.0, 0.0)));
  float plates = box(vec3(bq.x + 100.0 - 65.0 * clamp(round((bq.x + 100.0) / 65.0), -1.0, 2.0), bq.y + 30.0, bq.z - 0.3), vec3(18.0, 6.0, 0.3));
  r = U(r, vec2(plates, WHITE));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(-100.0, 1050.0, 380.0), vec3(600.0, 1060.0, 620.0)) < r.x) {
    r = U(r, openCab(p));
    vec3 q = toPlate(p);
    if (box(q - vec3(0.0, 150.0, 50.0), vec3(370.0, 820.0, 60.0)) < r.x) r = U(r, interior(q));
  }
  if (box(p - vec3(280.0, 2150.0, -100.0), vec3(40.0, 160.0, 40.0)) < r.x) r = U(r, towerLight(p - vec3(280.0, 2000.0, -100.0), 0.0));
  if (box(p - vec3(1000.0, 760.0, 300.0), vec3(320.0, 760.0, 320.0)) < r.x) r = U(r, pedestal(p));
  float c = capsule(p, vec3(960.0, 14.0, 250.0), vec3(700.0, 14.0, 160.0), 13.0);
  c = smin(c, capsule(p, vec3(700.0, 14.0, 160.0), vec3(420.0, 14.0, 60.0), 13.0), 8.0);
  r = U(r, vec2(c, CABLE));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == SCR) {
    vec3 h = toHead(p) - vec3(0.0, 50.0, 0.0);
    return screen(screenHmi(h.xy / vec2(310.0, 214.0) + 0.5, 4.0));
  }
  if (id == WARN) {
    vec2 q = rot(-DOOR) * (p.xz - vec2(-CAB.x * 0.5, CAB.z * 0.5));
    return mat(warnSign(vec2(q.x - CAB.x * 0.5, p.y - 1050.0 - 120.0), 42.0, vec3(0.55, 0.56, 0.54)), 0.35, 0.0);
  }
  if (id == WARN_SIDE) return mat(warnSign(vec2(-(p.z + 20.0), p.y - 1050.0 - 330.0), 42.0, vec3(0.55, 0.56, 0.54)), 0.35, 0.0);
  if (id == LEDS) {
    vec2 g = vec2(rep(p.x - 0.5, 3.6), rep(p.y - 1.0, 3.2));
    float on = step(0.45, h22(floor(p.xy / vec2(3.6, 3.2) + 0.5)).x);
    float spot = smoothstep(1.0, 0.7, length(g));
    return glow(vec3(0.03), 0.2, spot * on * vec3(0.25, 2.2, 0.4));
  }
  if (id == ZINC) return mat(vec3(0.66, 0.68, 0.7) * (0.92 + 0.12 * fbm(p * 0.02)), 0.62, 1.0);
  if (id == ALU) return mat(vec3(0.78, 0.79, 0.81), 0.6, 1.0);
  if (id == EARTH) return mat(mix(vec3(0.03, 0.32, 0.06), vec3(0.75, 0.6, 0.02), step(0.0, sin(p.y * 0.3))), 0.4, 0.0);
  if (id == WBLUE) return mat(vec3(0.02, 0.08, 0.36), 0.38, 0.0);
  if (id == WBLACK) return mat(vec3(0.02), 0.38, 0.0);
  if (id == WGREY) return mat(vec3(0.3, 0.31, 0.32), 0.4, 0.0);
  if (id == WRED) return mat(vec3(0.5, 0.02, 0.02), 0.38, 0.0);
  if (id == PATCH) return mat(vec3(0.04, 0.25, 0.08), 0.4, 0.0);
  return libMat(id, p, n);
}
