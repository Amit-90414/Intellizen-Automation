const vec3 BC = vec3(150.0, 1100.0, 300.0);
const float BR = 2300.0;

const float WARN = 70.0;
const float SCR = 60.0, METER = 61.0, WBLACK = 62.0, WGREY = 63.0, WBLUE = 64.0, WRED = 65.0, WYEL = 66.0, INSUL = 67.0, EARTH = 68.0;

const vec3 CAB = vec3(800.0, 2100.0, 600.0);
const float DOOR = 1.95;
const float OPEN_X = 820.0;

vec3 toPlate(vec3 p) { return p - vec3(OPEN_X, 1100.0, -CAB.z * 0.5 + 24.0); }

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

vec2 screenPanel(vec3 p, vec2 hs, float d, float border, float sid) {
  float bez = rbox(p + vec3(0.0, 0.0, d * 0.5), vec3(hs, d * 0.5), 4.0);
  float glass = box(p + vec3(0.0, 0.0, 0.35), vec3(hs - border, 0.65));
  return U(vec2(bez, BLACK), vec2(glass, sid));
}

float duct(vec3 q, float L) {
  float body = box(q - vec3(0.0, 0.0, 40.0), vec3(L * 0.5, 40.0, 40.0));
  body = max(body, -box(q - vec3(0.0, 0.0, 43.0), vec3(L * 0.5 + 1.0, 38.0, 40.0)));
  body = max(body, -box(vec3(rep(q.x, 12.0), abs(q.y) - 39.0, q.z - 48.0), vec3(2.4, 3.0, 30.0)));
  float lid = rbox(q - vec3(0.0, 0.0, 81.5), vec3(L * 0.5, 41.5, 1.5), 1.0);
  return min(body, lid);
}

vec2 wireRun(vec3 q, float pitch, float x0, float x1, float y0, float y1, float z, float fy, float id) {
  float x = q.x - x0 - pitch * clamp(round((q.x - x0) / pitch), 0.0, floor((x1 - x0) / pitch + 0.01));
  float w = max(length(vec2(x, q.z - z)) - 1.5, abs(q.y - (y0 + y1) * 0.5) - (y1 - y0) * 0.5);
  float f = max(length(vec2(x, q.z - z)) - 2.1, abs(q.y - fy) - 5.0);
  return U(vec2(w, id), vec2(f, WHITE));
}

vec2 mccb(vec3 q, vec3 hs) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, hs.z), hs, 6.0), DARK);
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, hs.z * 2.0 + 10.0), vec3(hs.x * 0.62, hs.y * 0.48, 12.0), 6.0), DARK));
  vec3 h = q - vec3(0.0, 18.0, hs.z * 2.0 + 30.0);
  r = U(r, vec2(rbox(h, vec3(hs.x * 0.16, 30.0, 14.0), 5.0), BLACK));
  r = U(r, vec2(box(q - vec3(0.0, -hs.y * 0.3, hs.z * 2.0 + 22.4), vec3(hs.x * 0.5, 12.0, 0.4)), WHITE));
  float term = rbox(vec3(q.x - hs.x * 0.62 * clamp(round(q.x / (hs.x * 0.62)), -1.0, 1.0), abs(q.y) - hs.y + 14.0, q.z - hs.z * 1.2), vec3(hs.x * 0.24, 22.0, hs.z * 0.5), 3.0);
  r = U(r, vec2(term, BLACK));
  return r;
}

vec2 overload(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 36.0), vec3(22.0, 24.0, 36.0), 2.0), LGREY);
  r = U(r, vec2(cylZ(q - vec3(-8.0, 4.0, 73.0), 6.0, 2.0, 1.0), BLUEP));
  r = U(r, vec2(rbox(q - vec3(9.0, 4.0, 73.0), vec3(4.0, 6.0, 2.0), 1.0), RED));
  return r;
}

vec2 interior(vec3 q) {
  vec2 r = vec2(0.7 * BR, -1.0);
  float hd = duct(vec3(q.x, q.y - 340.0 + 260.0 * clamp(round((340.0 - q.y) / 260.0), 0.0, 3.0), q.z), 600.0);
  hd = min(hd, duct(vec3(q.y + 50.0, abs(q.x) - 340.0, q.z), 860.0));
  r = U(r, vec2(hd, LGREY));
  if (box(q - vec3(0.0, 850.0, 100.0), vec3(370.0, 110.0, 100.0)) < r.x) {
    float bars = box(vec3(q.x, q.y - 900.0 + 40.0 * clamp(round((900.0 - q.y) / 40.0), 0.0, 3.0), q.z - 95.0), vec3(320.0, 14.0, 5.0));
    r = U(r, vec2(bars, COPPER));
    vec3 s = vec3(q.x - 260.0 * clamp(round(q.x / 260.0), -1.0, 1.0), q.y - 842.0, q.z);
    r = U(r, vec2(rbox(s - vec3(0.0, 0.0, 60.0), vec3(18.0, 82.0, 30.0), 6.0), INSUL));
    r = U(r, vec2(box(q - vec3(0.0, 845.0, 175.0), vec3(330.0, 100.0, 2.0)), CLEAR));
    r = U(r, vec2(rbox(vec3(abs(q.x) - 332.0, q.y - 845.0, q.z - 90.0), vec3(3.0, 100.0, 86.0), 2.0), LGREY));
  }
  if (box(q - vec3(-40.0, 590.0, 100.0), vec3(330.0, 200.0, 110.0)) < r.x) {
    r = U(r, mccb(q - vec3(-170.0, 560.0, 0.0), vec3(110.0, 150.0, 75.0)));
    float k = clamp(round((q.x - 60.0) / 115.0), 0.0, 1.0);
    r = U(r, mccb(q - vec3(60.0 + k * 115.0, 585.0, 0.0), vec3(50.0, 110.0, 60.0)));
    float link = box(vec3(q.x + 170.0 - 68.2 * clamp(round((q.x + 170.0) / 68.2), -1.0, 1.0), q.y - 742.0, q.z - 100.0), vec3(12.0, 40.0, 3.0));
    r = U(r, vec2(link, COPPER));
  }
  if (box(q - vec3(0.0, 215.0, 60.0), vec3(320.0, 90.0, 70.0)) < r.x) {
    r = U(r, dinRail(q - vec3(0.0, 225.0, 0.0), 590.0));
    float c = clamp(round((q.x + 255.0) / 102.0), 0.0, 5.0);
    vec3 cq = q - vec3(-255.0 + c * 102.0, 225.0, 7.6);
    r = U(r, contactor(cq));
    r = U(r, overload(cq + vec3(0.0, 70.0, 0.0)));
    r = U(r, wireRun(cq, 14.0, -14.0, 14.0, 42.0, 76.0, 40.0, 46.0, c < 2.5 ? WBLACK : WGREY));
  }
  if (box(q - vec3(0.0, -50.0, 60.0), vec3(320.0, 92.0, 70.0)) < r.x) {
    r = U(r, dinRail(q - vec3(0.0, -50.0, 0.0), 590.0));
    vec3 m = q - vec3(0.0, -50.0, 7.6);
    r = U(r, mcb(m - vec3(-250.0, 0.0, 0.0), 4.0, 1.0));
    float k = clamp(round((m.x + 205.0) / 18.0), 0.0, 13.0);
    r = U(r, mcb(m - vec3(-205.0 + k * 18.0, 0.0, 0.0), 1.0, k == 9.0 ? -1.0 : 1.0));
    r = U(r, mcb(m - vec3(65.0, 0.0, 0.0), 3.0, 1.0));
    r = U(r, wireRun(q, 18.0, -277.0, 83.0, -6.0, 40.0, 34.0, -10.0, WBLACK));
    r = U(r, wireRun(q, 18.0, -277.0, 83.0, -140.0, -94.0, 34.0, -90.0, WBLUE));
  }
  if (box(q - vec3(0.0, -310.0, 40.0), vec3(320.0, 92.0, 60.0)) < r.x) {
    r = U(r, dinRail(q - vec3(0.0, -310.0, 0.0), 590.0));
    vec3 t = q - vec3(0.0, -310.0, 7.6);
    r = U(r, terminalBlocks(t - vec3(-50.0, 0.0, 0.0), 36.0, BLUEP));
    r = U(r, terminalBlocks(t - vec3(220.0, 0.0, 0.0), 5.0, EARTH));
    r = U(r, vec2(rbox(vec3(abs(t.x + 12.0) - 266.0, t.y, t.z - 20.0), vec3(4.0, 24.0, 20.0), 1.0), DARK));
    r = U(r, wireRun(q, 6.2, -273.2, 173.0, -280.0, -220.0, 30.0, -284.0, WGREY));
    r = U(r, wireRun(q, 6.2, -273.2, 173.0, -400.0, -340.0, 30.0, -336.0, WBLACK));
  }
  if (box(q - vec3(-20.0, -730.0, 60.0), vec3(230.0, 250.0, 40.0)) < r.x) {
    float cx = q.x + 200.0 - 120.0 * clamp(round((q.x + 200.0) / 120.0), 0.0, 3.0);
    float cab = max(length(vec2(cx, q.z - 60.0)) - 16.0, abs(q.y + 720.0) - 240.0);
    r = U(r, vec2(cab, CABLE));
    r = U(r, vec2(cylY(vec3(cx, q.y + 950.0, q.z - 60.0), 24.0, 14.0, 3.0), BLACK));
    r = U(r, vec2(cylY(vec3(cx, q.y + 510.0, q.z - 60.0), 19.0, 10.0, 2.0), BLACK));
    float tie = max(abs(length(vec2(cx, q.z - 60.0)) - 16.6) - 1.0, abs(q.y + 720.0 - 140.0 * clamp(round((q.y + 720.0) / 140.0), -1.0, 1.0)) - 2.5);
    r = U(r, vec2(tie, BLACK));
  }
  return r;
}

vec2 openCab(vec3 p) {
  vec3 hs = vec3(CAB.x * 0.5, (CAB.y - 100.0) * 0.5, CAB.z * 0.5);
  vec3 q = p - vec3(OPEN_X, (CAB.y + 100.0) * 0.5, 0.0);
  float shell = rbox(q, hs, 6.0);
  shell = max(shell, -box(q - vec3(0.0, 0.0, 20.0), vec3(hs.x - 16.0, hs.y - 16.0, hs.z)));
  vec2 r = vec2(shell, GREY);
  r = U(r, vec2(box(p - vec3(OPEN_X, 50.0, 0.0), vec3(hs.x - 4.0, 50.0, hs.z - 4.0)), DARK));
  r = U(r, vec2(box(q - vec3(0.0, 0.0, -hs.z + 22.0), vec3(hs.x - 36.0, hs.y - 36.0, 2.0)), ZINC));
  vec3 d = q - vec3(hs.x, 0.0, hs.z);
  d.xz = rot(DOOR) * d.xz;
  float door = rbox(d - vec3(-hs.x, 0.0, 12.0), vec3(hs.x, hs.y, 12.0), 5.0);
  door = max(door, -box(d - vec3(-hs.x, 0.0, -2.0), vec3(hs.x - 24.0, hs.y - 24.0, 12.0)));
  r = U(r, vec2(door, GREY));
  r = U(r, vec2(rbox(d - vec3(-hs.x, -250.0, 4.0), vec3(240.0, 160.0, 6.0), 3.0), MGREY));
  r = U(r, vec2(rbox(d - vec3(-hs.x * 2.0 + 70.0, 40.0, 30.0), vec3(14.0, 70.0, 8.0), 5.0), BLACK));
  vec3 hg = vec3(q.x - hs.x - 3.0, abs(q.y) - hs.y * 0.7, q.z - hs.z - 6.0);
  r = U(r, vec2(cylY(hg, 8.0, 40.0, 2.0), DARK));
  return r;
}

vec2 louver(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 6.0), vec3(130.0, 130.0, 6.0), 4.0), LGREY);
  float slats = max(rbox(vec3(q.x, rep(q.y, 13.0), q.z - 9.0), vec3(108.0, 2.2, 4.0), 1.0), abs(q.y) - 108.0);
  r.x = max(r.x, -max(box(vec3(q.x, rep(q.y + 6.5, 13.0), q.z - 12.0), vec3(110.0, 4.0, 6.0)), abs(q.y) - 108.0));
  r = U(r, vec2(slats, LGREY));
  return r;
}

vec2 doorTags(vec3 d) {
  vec2 r = vec2(box(d - vec3(0.0, 1840.0, 0.4), vec3(52.0, 48.0, 0.4)), WARN);
  vec3 t = d - vec3(0.0, 1975.0, 1.0);
  r = U(r, vec2(rbox(t, vec3(110.0, 20.0, 1.0), 1.5), WHITE));
  r = U(r, vec2(cylZ(vec3(abs(t.x) - 100.0, t.y, t.z - 1.0), 2.2, 0.8, 0.5), STEEL));
  return r;
}

vec2 doorLeft(vec3 d) {
  vec2 r = vec2(rbox(d - vec3(0.0, 1560.0, 6.0), vec3(48.0, 48.0, 6.0), 3.0), BLACK);
  r = U(r, vec2(box(d - vec3(0.0, 1572.0, 12.2), vec3(38.0, 26.0, 0.3)), METER));
  r = U(r, vec2(rbox(vec3(d.x + 33.0 - 22.0 * clamp(round((d.x + 33.0) / 22.0), 0.0, 3.0), d.y - 1528.0, d.z - 12.0), vec3(6.0, 4.0, 1.5), 1.2), DARK));
  vec3 pl = vec3(d.x - 90.0 * clamp(round(d.x / 90.0), -1.0, 1.0), d.y - 1400.0, d.z);
  float idx = clamp(round(d.x / 90.0), -1.0, 1.0);
  r = U(r, pilotLight(pl, idx < -0.5 ? LRED : (idx < 0.5 ? LAMBER : LBLUE)));
  r = U(r, vec2(box(pl - vec3(0.0, -34.0, 0.3), vec3(22.0, 7.0, 0.3)), WHITE));
  r = U(r, selectorSwitch(d - vec3(-70.0, 1270.0, 0.0), -0.6));
  r = U(r, pushButton(d - vec3(70.0, 1270.0, 0.0), BLACK));
  r = U(r, vec2(box(vec3(abs(d.x) - 70.0, d.y - 1236.0, d.z - 0.3), vec3(22.0, 7.0, 0.3)), WHITE));
  vec3 iso = d - vec3(0.0, 1050.0, 0.0);
  r = U(r, vec2(rbox(iso - vec3(0.0, 0.0, 2.0), vec3(60.0, 60.0, 2.0), 4.0), YELLOW));
  float knob = cylZ(iso - vec3(0.0, 0.0, 14.0), 26.0, 10.0, 4.0);
  vec3 hq = iso - vec3(0.0, 0.0, 32.0);
  hq.xy = rot(-0.5) * hq.xy;
  knob = smin(knob, rbox(hq, vec3(11.0, 55.0, 10.0), 6.0), 6.0);
  r = U(r, vec2(knob, RED));
  r = U(r, louver(d - vec3(0.0, 360.0, 0.0)));
  return r;
}

vec2 doorMid(vec3 d) {
  vec2 r = screenPanel(d - vec3(0.0, 1500.0, 9.0), vec2(140.0, 105.0), 9.0, 13.0, SCR);
  vec3 b = d - vec3(0.0, 1290.0, 0.0);
  float i = clamp(round(b.x / 70.0), -1.0, 1.0);
  vec3 bq = vec3(b.x - i * 70.0, b.y, b.z);
  r = U(r, pushButton(bq, i < -0.5 ? GREEN : (i < 0.5 ? RED : BLUEP)));
  r = U(r, vec2(box(bq - vec3(0.0, -34.0, 0.3), vec3(22.0, 7.0, 0.3)), WHITE));
  vec3 pq = d - vec3(0.0, 1190.0, 0.0);
  float j = clamp(round(pq.x / 70.0), -1.0, 1.0);
  r = U(r, pilotLight(vec3(pq.x - j * 70.0, pq.y, pq.z), j < -0.5 ? LGREEN : (j < 0.5 ? AMBER_OFF : RED_OFF)));
  r = U(r, estop(d - vec3(0.0, 1065.0, 0.0)));
  r = U(r, louver(d - vec3(0.0, 360.0, 0.0)));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(-820.0, 1050.0, 0.0), vec3(410.0, 1060.0, 360.0)) < r.x) {
    r = U(r, cabinet(p - vec3(-820.0, 0.0, 0.0), CAB));
    vec3 d = p - vec3(-820.0, 0.0, 300.0);
    if (box(d - vec3(0.0, 1000.0, 30.0), vec3(140.0, 700.0, 50.0)) < r.x) r = U(r, doorLeft(d));
    if (box(d - vec3(0.0, 1900.0, 1.0), vec3(115.0, 110.0, 3.0)) < r.x) r = U(r, doorTags(d));
  }
  if (box(p - vec3(0.0, 1050.0, 0.0), vec3(410.0, 1060.0, 360.0)) < r.x) {
    r = U(r, cabinet(p, CAB));
    vec3 d = p - vec3(0.0, 0.0, 300.0);
    if (box(d - vec3(0.0, 1000.0, 30.0), vec3(170.0, 700.0, 50.0)) < r.x) r = U(r, doorMid(d));
    if (box(d - vec3(0.0, 1900.0, 1.0), vec3(115.0, 110.0, 3.0)) < r.x) r = U(r, doorTags(d));
  }
  if (box(p - vec3(OPEN_X + 150.0, 1050.0, 400.0), vec3(600.0, 1060.0, 720.0)) < r.x) {
    r = U(r, openCab(p));
    vec3 q = toPlate(p);
    if (box(q - vec3(0.0, 0.0, 100.0), vec3(370.0, 970.0, 110.0)) < r.x) r = U(r, interior(q));
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == SCR) {
    vec2 uv = (p.xy - vec2(0.0, 1500.0)) / vec2(254.0, 184.0) + 0.5;
    return screen(screenTrend(uv, 2.0));
  }
  if (id == WARN) {
    float cx = p.x < -400.0 ? -820.0 : 0.0;
    return mat(warnSign(vec2(p.x - cx, p.y - 1840.0), 42.0, vec3(0.55, 0.56, 0.54)), 0.35, 0.0);
  }
  if (id == METER) {
    vec2 uv = (p.xy - vec2(-820.0, 1572.0)) / vec2(76.0, 52.0) + 0.5;
    vec3 c = vec3(0.05, 0.09, 0.07);
    for (int i = 0; i < 3; i++) {
      float y = 0.78 - float(i) * 0.28;
      c = mix(c, vec3(0.35, 0.95, 0.6), textLines(uv, vec2(0.58, y), vec2(0.3, 0.09), 1.0, float(i) + 3.0));
      c = mix(c, vec3(0.35, 0.95, 0.6) * 0.6, rect(uv, vec2(0.12, y), vec2(0.05, 0.06)));
    }
    return glow(vec3(0.01), 0.08, c * 1.3);
  }
  if (id == ZINC) return mat(vec3(0.66, 0.68, 0.7) * (0.92 + 0.12 * fbm(p * 0.02)), 0.62, 1.0);
  if (id == INSUL) return mat(vec3(0.32, 0.03, 0.02), 0.45, 0.0);
  if (id == EARTH) return mat(mix(vec3(0.03, 0.32, 0.06), vec3(0.75, 0.6, 0.02), step(0.0, sin(p.y * 0.3))), 0.4, 0.0);
  if (id == WBLACK) return mat(vec3(0.02), 0.38, 0.0);
  if (id == WGREY) return mat(vec3(0.3, 0.31, 0.32), 0.4, 0.0);
  if (id == WBLUE) return mat(vec3(0.02, 0.08, 0.36), 0.38, 0.0);
  if (id == WRED) return mat(vec3(0.5, 0.02, 0.02), 0.38, 0.0);
  if (id == WYEL) return mat(vec3(0.7, 0.5, 0.02), 0.38, 0.0);
  return libMat(id, p, n);
}
