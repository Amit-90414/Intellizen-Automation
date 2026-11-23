const vec3 BC = vec3(1400.0, 600.0, -100.0);
const float BR = 3100.0;

const float PRBODY = 50.0, LABEL = 51.0, SLOT = 52.0, LCD = 53.0, ROLL = 54.0, KEYCAP = 55.0, SCANWIN = 56.0, SS = 58.0, LID = 59.0, WARN = 60.0, IDPLATE = 61.0;

const float CH = 800.0;
const vec3 PRINTER = vec3(-1260.0, 880.0, -260.0);
const vec3 SCANNER = vec3(550.0, 1250.0, 0.0);
const vec3 DESKC = vec3(3500.0, 0.0, 0.0);

float barcodeInk(vec2 uv, float seed) {
  float ink = textLines(uv, vec2(0.36, 0.86), vec2(0.28, 0.07), 2.0, seed);
  vec2 b = (uv - vec2(0.07, 0.3)) / vec2(0.6, 0.36);
  if (b.x > 0.0 && b.x < 1.0 && b.y > 0.0 && b.y < 1.0) {
    float m = floor(b.x * 95.0);
    bool guard = m < 3.0 || m > 91.0 || (m > 45.0 && m < 50.0);
    float bar = guard ? 1.0 - mod(m, 2.0) : step(0.48, h22(vec2(m, seed)).x);
    ink = max(ink, bar * step(guard ? -0.06 : 0.0, b.y));
  }
  vec2 d = (uv - vec2(0.73, 0.3)) / vec2(0.21, 0.36);
  if (d.x > 0.0 && d.x < 1.0 && d.y > 0.0 && d.y < 1.0) {
    vec2 c = floor(d * 14.0);
    float cell = step(0.5, h22(c + seed * 7.0).x);
    if (c.x < 0.5 || c.y < 0.5) cell = 1.0;
    if (c.x > 12.5) cell = mod(c.y, 2.0);
    if (c.y > 12.5) cell = 1.0 - mod(c.x, 2.0);
    ink = max(ink, cell);
  }
  ink = max(ink, textLines(uv, vec2(0.37, 0.17), vec2(0.3, 0.05), 1.0, seed + 3.0));
  ink = max(ink, textLines(uv, vec2(0.83, 0.17), vec2(0.1, 0.05), 1.0, seed + 5.0));
  return ink;
}

Mat labelMat(vec2 uv, float seed) {
  float ink = barcodeInk(uv, seed);
  float edge = step(0.0, uv.x) * step(uv.x, 1.0) * step(0.0, uv.y) * step(uv.y, 1.0);
  return mat(mix(vec3(0.82, 0.82, 0.8), vec3(0.015), ink * edge), mix(0.5, 0.35, ink), 0.0);
}

vec2 standTable(vec3 p, vec2 hs, float h) {
  float top = rbox(p - vec3(0.0, h - 12.0, 0.0), vec3(hs.x, 12.0, hs.y), 3.0);
  vec2 r = vec2(top, SS);
  vec3 lq = vec3(abs(p.x) - hs.x + 40.0, p.y - (h - 24.0) * 0.5, abs(p.z) - hs.y + 40.0);
  float legs = rbox(lq, vec3(20.0, (h - 24.0) * 0.5, 20.0), 2.0);
  float rail = rbox(vec3(abs(p.x) - hs.x + 40.0, p.y - 180.0, p.z), vec3(15.0, 15.0, hs.y - 40.0), 2.0);
  rail = min(rail, rbox(vec3(p.x, p.y - 180.0, abs(p.z) - hs.y + 40.0), vec3(hs.x - 40.0, 15.0, 15.0), 2.0));
  r = U(r, vec2(min(legs, rail), SS));
  float feet = cylY(vec3(lq.x, p.y - 5.0, lq.z), 24.0, 5.0, 2.0);
  r = U(r, vec2(feet, BLACK));
  return r;
}

vec2 industrialPrinter(vec3 p) {
  vec3 q = p - vec3(0.0, 160.0, 0.0);
  float body = rbox(q, vec3(130.0, 150.0, 230.0), 7.0);
  float cavity = box(q - vec3(62.0, 18.0, -10.0), vec3(60.0, 112.0, 196.0));
  body = max(body, -cavity);
  float slot = box(q - vec3(-10.0, -62.0, 230.0), vec3(70.0, 3.0, 20.0));
  body = max(body, -slot);
  float panelCut = rbox(q - vec3(-58.0, 70.0, 232.0), vec3(58.0, 62.0, 4.0), 4.0);
  body = max(body, -panelCut);
  vec2 r = vec2(body, PRBODY);
  float door = max(rbox(q - vec3(127.0, 18.0, -10.0), vec3(5.0, 120.0, 204.0), 4.0), -rbox(q - vec3(127.0, 34.0, -60.0), vec3(8.0, 72.0, 112.0), 12.0));
  r = U(r, vec2(door, LID));
  if (gClear > 0.5) r = U(r, vec2(rbox(q - vec3(129.0, 34.0, -60.0), vec3(1.5, 74.0, 114.0), 1.0), CLEAR));
  r = U(r, vec2(box(q - vec3(131.2, -118.0, 150.0), vec3(0.4, 16.0, 42.0)), IDPLATE));
  r = U(r, vec2(box(q - vec3(-40.0, -112.0, 230.3), vec3(14.0, 14.0, 0.3)), WARN));
  float handle = rbox(q - vec3(134.0, 70.0, 172.0), vec3(4.0, 40.0, 10.0), 3.0);
  r = U(r, vec2(handle, BLACK));
  vec3 m = q - vec3(62.0, 28.0, -70.0);
  float roll = cylX(m, 82.0, 52.0, 2.0);
  roll = max(roll, -cylX(m, 38.0, 60.0, 0.0));
  r = U(r, vec2(roll, ROLL));
  float core = max(cylX(m, 38.0, 54.0, 0.5), -cylX(m, 32.0, 60.0, 0.0));
  r = U(r, vec2(core, CARD));
  float spindle = cylX(m + vec3(4.0, 0.0, 0.0), 20.0, 58.0, 2.0);
  r = U(r, vec2(spindle, ALU));
  float ribbon = cylX(q - vec3(62.0, 92.0, 110.0), 30.0, 50.0, 2.0);
  ribbon = min(ribbon, cylX(q - vec3(62.0, 62.0, 172.0), 22.0, 50.0, 2.0));
  r = U(r, vec2(ribbon, BLACK));
  float head = rbox(q - vec3(62.0, -50.0, 150.0), vec3(54.0, 18.0, 40.0), 4.0);
  r = U(r, vec2(head, MGREY));
  float platen = cylX(q - vec3(62.0, -70.0, 196.0), 9.0, 52.0, 1.0);
  r = U(r, vec2(platen, BLACK));
  float web = box(q - vec3(62.0, -61.5, 60.0), vec3(52.0, 0.4, 140.0));
  r = U(r, vec2(web, PAPER));
  float panel = rbox(q - vec3(-58.0, 70.0, 227.0), vec3(54.0, 58.0, 2.0), 3.0);
  r = U(r, vec2(panel, BLACK));
  float lcd = box(q - vec3(-58.0, 92.0, 229.6), vec3(42.0, 22.0, 0.4));
  r = U(r, vec2(lcd, LCD));
  vec3 kq = vec3(0.0, q.y - 40.0, q.z - 230.0);
  kq.x = q.x + 58.0 - 22.0 * (clamp(floor((q.x + 58.0) / 22.0), -2.0, 1.0) + 0.5);
  float keys = rbox(kq, vec3(8.0, 6.0, 2.0), 2.0);
  r = U(r, vec2(keys, KEYCAP));
  r = U(r, vec2(cylZ(q - vec3(-96.0, 120.0, 229.6), 2.6, 1.0, 0.6), LGREEN));
  r = U(r, vec2(cylZ(q - vec3(-84.0, 120.0, 229.6), 2.6, 1.0, 0.6), AMBER_OFF));
  vec3 lq = q - vec3(-10.0, -66.0, 262.0);
  lq.yz = rot(-0.12) * lq.yz;
  float label = box(lq, vec3(52.0, 0.35, 34.0));
  r = U(r, vec2(label, LABEL));
  float feet = cylY(vec3(abs(p.x) - 100.0, p.y - 4.0, abs(p.z) - 190.0), 14.0, 4.0, 2.0);
  r = U(r, vec2(feet, BLACK));
  return r;
}

vec2 fixedScanner(vec3 p) {
  float body = rbox(p - vec3(0.0, 4.0, 0.0), vec3(58.0, 28.0, 44.0), 7.0);
  body = smin(body, rbox(p + vec3(0.0, 22.0, 0.0), vec3(50.0, 12.0, 38.0), 6.0), 4.0);
  vec2 r = vec2(body, DARK);
  r = U(r, vec2(rbox(p + vec3(0.0, 34.4, 0.0), vec3(40.0, 1.0, 28.0), 1.0), SCANWIN));
  r = U(r, vec2(cylZ(p - vec3(40.0, 16.0, 44.0), 2.4, 1.0, 0.5), LGREEN));
  r = U(r, vec2(box(p - vec3(-28.0, 10.0, 44.3), vec3(11.0, 11.0, 0.3)), WARN));
  r = U(r, vec2(min(cylX(p - vec3(-64.0, 8.0, 0.0), 6.0, 8.0, 1.0), cylX(p - vec3(-70.0, 8.0, 0.0), 7.5, 4.0, 1.5)), STEEL));
  r = U(r, vec2(rbox(p - vec3(0.0, 36.0, 0.0), vec3(30.0, 4.0, 30.0), 2.0), ZINC));
  float screws = cylY(vec3(abs(p.x) - 22.0, p.y - 40.5, abs(p.z) - 22.0), 3.0, 1.0, 0.6);
  r = U(r, vec2(screws, STEEL));
  return r;
}

vec2 profile(vec3 p, vec3 hs) {
  float d = rbox(p, hs, 2.0);
  vec3 a = abs(p);
  float g1 = box(vec3(p.x, p.y, a.z - hs.z), vec3(hs.x + 1.0, 4.0, 3.0));
  float g2 = box(vec3(a.x - hs.x, p.y, p.z), vec3(3.0, hs.y + 1.0, 4.0));
  if (hs.y > hs.x && hs.y > hs.z) {
    g1 = box(vec3(p.x, p.y, a.z - hs.z), vec3(4.0, hs.y + 1.0, 3.0));
    g2 = box(vec3(a.x - hs.x, p.y, p.z), vec3(3.0, hs.y + 1.0, 4.0));
  } else if (hs.z > hs.x) {
    g1 = box(vec3(a.x - hs.x, p.y, p.z), vec3(3.0, 4.0, hs.z + 1.0));
    g2 = box(vec3(p.x, a.y - hs.y, p.z), vec3(4.0, 3.0, hs.z + 1.0));
  }
  return vec2(max(d, -min(g1, g2)), ALU);
}

vec2 desktopPrinter(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(0.0, 40.0, 0.0), vec3(110.0, 40.0, 140.0), 16.0), DARK);
  float lid = rbox(p - vec3(0.0, 105.0, -8.0), vec3(108.0, 62.0, 132.0), 34.0);
  lid = max(lid, 66.0 - p.y);
  r = U(r, vec2(lid, LID));
  float seam = box(p - vec3(0.0, 70.0, 0.0), vec3(112.0, 1.2, 142.0));
  r.x = max(r.x, -seam);
  float slot = box(p - vec3(0.0, 72.0, 140.0), vec3(60.0, 2.5, 8.0));
  r.x = max(r.x, -slot);
  vec3 lq = p - vec3(0.0, 71.0, 166.0);
  lq.yz = rot(-0.2) * lq.yz;
  float label = box(lq, vec3(50.0, 0.3, 26.0));
  r = U(r, vec2(label, LABEL));
  r = U(r, vec2(rbox(p - vec3(70.0, 140.0, 108.0), vec3(12.0, 4.0, 10.0), 3.0), KEYCAP));
  r = U(r, vec2(cylY(p - vec3(40.0, 142.0, 110.0), 3.0, 1.0, 0.6), LGREEN));
  float feet = cylY(vec3(abs(p.x) - 80.0, p.y - 2.0, abs(p.z) - 110.0), 10.0, 2.0, 1.0);
  r = U(r, vec2(feet, BLACK));
  return r;
}

vec2 labelRoll(vec3 p) {
  float roll = cylY(p - vec3(0.0, 50.0, 0.0), 62.0, 50.0, 1.5);
  roll = max(roll, -cylY(p - vec3(0.0, 50.0, 0.0), 38.0, 60.0, 0.0));
  vec2 r = vec2(roll, ROLL);
  float core = max(cylY(p - vec3(0.0, 50.0, 0.0), 38.0, 51.0, 0.5), -cylY(p - vec3(0.0, 50.0, 0.0), 33.0, 60.0, 0.0));
  return U(r, vec2(core, CARD));
}

vec2 handScanner(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(0.0, 8.0, 0.0), vec3(48.0, 8.0, 60.0), 6.0), BLACK);
  vec3 g = p - vec3(0.0, 80.0, -6.0);
  g.yz = rot(0.22) * g.yz;
  float grip = rbox(g, vec3(17.0, 70.0, 22.0), 12.0);
  vec3 h = p - vec3(0.0, 168.0, 18.0);
  float head = rbox(h, vec3(28.0, 26.0, 52.0), 14.0);
  head = smin(head, grip, 10.0);
  r = U(r, vec2(head, MGREY));
  float win = rbox(h - vec3(0.0, 0.0, 52.0), vec3(20.0, 16.0, 2.0), 3.0);
  r = U(r, vec2(win, SCANWIN));
  float trig = rbox(g - vec3(0.0, 46.0, 24.0), vec3(8.0, 16.0, 6.0), 4.0);
  r = U(r, vec2(trig, ORANGE));
  return r;
}

vec3 cartonCell(vec3 p) {
  float x = p.x + 40.0;
  float cell = clamp(round(x / 560.0), -1.0, 1.0);
  vec2 h = h22(vec2(cell, 7.3)) - 0.5;
  vec3 q = vec3(x - cell * 560.0, p.y - CH, p.z - 10.0 - h.y * 50.0);
  q.xz = rot(h.x * 0.14) * q.xz;
  return q;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (uVariant < 1.5) {
    if (box(p - vec3(0.0, 400.0, 0.0), vec3(930.0, 420.0, 300.0)) < r.x) r = U(r, beltConveyor(p, 1800.0, 460.0, CH, BELT));
    vec3 c = cartonCell(p);
    if (box(c - vec3(0.0, 140.0, 0.0), vec3(190.0, 150.0, 160.0)) < r.x) {
      r = U(r, carton(c, vec3(180.0, 135.0, 150.0)));
      r = U(r, vec2(box(c - vec3(30.0, 270.6, -10.0), vec3(50.0, 0.4, 75.0)), LABEL));
    }
    vec3 t = p - vec3(PRINTER.x, 0.0, PRINTER.z);
    if (box(t - vec3(0.0, 450.0, 0.0), vec3(330.0, 460.0, 280.0)) < r.x) r = U(r, standTable(t, vec2(320.0, 270.0), PRINTER.y));
    vec3 pq = p - PRINTER;
    if (box(pq - vec3(0.0, 160.0, 30.0), vec3(140.0, 165.0, 270.0)) < r.x) r = U(r, industrialPrinter(pq));
    vec3 post = p - vec3(SCANNER.x, 0.0, -300.0);
    if (box(post - vec3(0.0, 700.0, 150.0), vec3(40.0, 720.0, 180.0)) < r.x) {
      r = U(r, profile(post - vec3(0.0, 705.0, 0.0), vec3(20.0, 645.0, 20.0)));
      r = U(r, profile(post - vec3(0.0, 1330.0, 160.0), vec3(20.0, 20.0, 180.0)));
      r = U(r, vec2(rbox(post - vec3(0.0, 40.0, 0.0), vec3(80.0, 6.0, 80.0), 3.0), ZINC));
      r = U(r, vec2(rbox(post - vec3(0.0, 1305.0, 300.0), vec3(8.0, 25.0, 30.0), 2.0), ZINC));
    }
    vec3 sq = p - SCANNER;
    if (box(sq, vec3(80.0, 50.0, 60.0)) < r.x) r = U(r, fixedScanner(sq));
    if (box(p - vec3(SCANNER.x - 40.0, 700.0, -150.0), vec3(50.0, 700.0, 170.0)) < r.x) {
      float cab = capsule(p, vec3(SCANNER.x - 76.0, SCANNER.y + 8.0, 0.0), vec3(SCANNER.x - 76.0, 1296.0, -36.0), 3.5);
      cab = smin(cab, capsule(p, vec3(SCANNER.x - 76.0, 1296.0, -36.0), vec3(SCANNER.x - 26.0, 1326.0, -90.0), 3.5), 4.0);
      cab = smin(cab, capsule(p, vec3(SCANNER.x - 26.0, 1326.0, -90.0), vec3(SCANNER.x - 26.0, 1326.0, -300.0), 3.5), 4.0);
      cab = smin(cab, capsule(p, vec3(SCANNER.x - 26.0, 1326.0, -300.0), vec3(SCANNER.x - 26.0, 60.0, -300.0), 3.5), 4.0);
      r = U(r, vec2(cab, CABLE));
      float tie = max(abs(box2(vec2(p.x - SCANNER.x + 3.0, p.y - 1330.0), vec2(26.5, 22.5))) - 0.9, abs(rep(p.z + 30.0, 120.0)) - 2.2);
      tie = max(tie, abs(p.z + 185.0) - 100.0);
      float tie2 = max(abs(box2(vec2(p.x - SCANNER.x + 3.0, p.z + 300.0), vec2(26.5, 22.5))) - 0.9, abs(rep(p.y - 100.0, 300.0)) - 2.2);
      tie2 = max(tie2, abs(p.y - 700.0) - 560.0);
      r = U(r, vec2(min(tie, tie2), BLACK));
    }
    r = U(r, vec2(box(p - vec3(-760.0, CH - 28.0, 260.3), vec3(40.0, 13.0, 0.3)), IDPLATE));
    r = U(r, vec2(box(p - vec3(-660.0, CH - 28.0, 260.3), vec3(13.0, 13.0, 0.3)), WARN));
  }
  if (uVariant < 0.5 || uVariant > 1.5) {
    vec3 d = p - DESKC;
    if (box(d - vec3(0.0, 820.0, 0.0), vec3(770.0, 830.0, 390.0)) < r.x) r = U(r, workbench(d, vec3(1500.0, 900.0, 750.0)));
    float pc = capsule(d, vec3(-88.0, 935.0, -196.0), vec3(-104.0, 905.0, -290.0), 3.0);
    pc = smin(pc, capsule(d, vec3(-104.0, 905.0, -290.0), vec3(-130.0, 905.0, -372.0), 3.0), 6.0);
    pc = smin(pc, capsule(d, vec3(-130.0, 905.0, -372.0), vec3(-150.0, 860.0, -384.0), 3.0), 6.0);
    pc = smin(pc, capsule(d, vec3(-150.0, 860.0, -384.0), vec3(-160.0, 380.0, -392.0), 3.0), 6.0);
    r = U(r, vec2(pc, CABLE));
    vec3 dp = d - vec3(-60.0, 900.0, -60.0);
    dp.xz = rot(0.18) * dp.xz;
    if (box(dp - vec3(0.0, 90.0, 20.0), vec3(120.0, 100.0, 190.0)) < r.x) r = U(r, desktopPrinter(dp));
    vec3 rq = d - vec3(240.0, 900.0, 70.0);
    if (box(rq - vec3(0.0, 50.0, 0.0), vec3(70.0, 55.0, 70.0)) < r.x) r = U(r, labelRoll(rq));
    vec3 rr = d - vec3(380.0, 962.0, -110.0);
    rr = vec3(rr.y, rr.x + 50.0, rr.z);
    if (box(rr - vec3(0.0, 50.0, 0.0), vec3(70.0, 55.0, 70.0)) < r.x) r = U(r, labelRoll(rr));
    vec3 hq = d - vec3(-380.0, 900.0, 40.0);
    hq.xz = rot(-0.5) * hq.xz;
    if (box(hq - vec3(0.0, 120.0, 10.0), vec3(60.0, 130.0, 90.0)) < r.x) r = U(r, handScanner(hq));
    vec3 l1 = d - vec3(120.0, 900.4, 210.0);
    l1.xz = rot(0.25) * l1.xz;
    vec3 l2 = d - vec3(-150.0, 900.4, 230.0);
    l2.xz = rot(-0.12) * l2.xz;
    float lab = min(box(l1, vec3(50.0, 0.3, 34.0)), box(l2, vec3(50.0, 0.3, 34.0)));
    r = U(r, vec2(lab, LABEL));
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == LABEL) {
    if (p.x > 2000.0) {
      vec3 d = p - DESKC;
      vec3 l1 = d - vec3(120.0, 900.4, 210.0);
      l1.xz = rot(0.25) * l1.xz;
      vec3 l2 = d - vec3(-150.0, 900.4, 230.0);
      l2.xz = rot(-0.12) * l2.xz;
      vec3 dp = d - vec3(-60.0, 900.0, -60.0);
      dp.xz = rot(0.18) * dp.xz;
      vec3 lq = dp - vec3(0.0, 71.0, 166.0);
      lq.yz = rot(-0.2) * lq.yz;
      if (length(l1.xz) < 70.0) return labelMat(vec2(l1.x / 100.0 + 0.5, 0.5 - l1.z / 68.0), 4.0);
      if (length(l2.xz) < 70.0) return labelMat(vec2(l2.x / 100.0 + 0.5, 0.5 - l2.z / 68.0), 6.0);
      return labelMat(vec2(lq.x / 100.0 + 0.5, 0.5 - lq.z / 52.0), 8.0);
    }
    if (p.y > CH + 200.0) {
      vec3 c = cartonCell(p) - vec3(30.0, 270.6, -10.0);
      Mat m = labelMat(vec2(0.5 - c.z / 150.0, 0.5 - c.x / 100.0), 1.0 + floor((p.x + 40.0) / 560.0 + 0.5));
      m.emi += vec3(7.0, 0.15, 0.08) * smoothstep(2.2, 0.8, abs(p.x - SCANNER.x)) * step(abs(p.z - SCANNER.z), 70.0);
      return m;
    }
    vec3 q = p - PRINTER - vec3(-10.0, 160.0 - 66.0, 262.0);
    q.yz = rot(-0.12) * q.yz;
    return labelMat(vec2(q.x / 104.0 + 0.5, 0.5 - q.z / 68.0), 2.0);
  }
  if (id == CARD || id == TAPE) {
    Mat m = libMat(id, p, n);
    m.emi += vec3(5.0, 0.12, 0.06) * smoothstep(2.2, 0.8, abs(p.x - SCANNER.x)) * step(abs(p.z - SCANNER.z), 140.0) * step(0.8, n.y) * step(CH + 200.0, p.y);
    if (id == CARD) m.alb *= 1.0 - 0.16 * smoothstep(0.55, 0.78, fbm(p * 0.013 + 3.0)) - 0.06 * smoothstep(0.6, 0.9, vnoise(p * 0.08));
    return m;
  }
  if (id == WARN) {
    vec3 c1 = vec3(-660.0, CH - 28.0, 13.0);
    vec3 c2 = vec3(SCANNER.x - 28.0, SCANNER.y + 10.0, 11.0);
    vec3 c3 = vec3(PRINTER.x - 40.0, PRINTER.y + 48.0, 14.0);
    vec3 c = length(p.xy - c1.xy) < 40.0 ? c1 : (length(p.xy - c2.xy) < 40.0 ? c2 : c3);
    vec2 uv = (p.xy - c.xy) / (2.0 * c.z) + 0.5;
    vec2 t = uv - vec2(0.5, 0.42);
    float tri = max(abs(t.x) * 1.732 + t.y - 0.34, -t.y - 0.2);
    float ink = max(cover(abs(tri) - 0.035), max(rect(uv, vec2(0.5, 0.47), vec2(0.035, 0.1)), disc(uv, vec2(0.5, 0.3), 0.04)));
    return mat(mix(vec3(0.85, 0.6, 0.02), vec3(0.015), ink), 0.35, 0.0);
  }
  if (id == IDPLATE) {
    vec2 d = abs(n.z) > 0.5 ? abs(p.xy - vec2(-760.0, CH - 28.0)) - vec2(35.0, 8.0) : abs(p.zy - vec2(PRINTER.z + 150.0, PRINTER.y + 42.0)) - vec2(37.0, 11.0);
    float rivet = smoothstep(2.2, 1.4, length(d));
    vec2 g = abs(n.z) > 0.5 ? p.xy : p.zy;
    return mat(vec3(0.76, 0.77, 0.78) * (0.92 + 0.08 * vnoise(vec3(g.x * 3.0, g.y * 0.05, 1.0))) * (1.0 - 0.4 * rivet), 0.28, 1.0);
  }
  if (id == PRBODY) return mat(vec3(0.05, 0.055, 0.06), 0.38, 0.0);
  if (id == LID) return mat(vec3(0.3, 0.31, 0.32), 0.32, 0.0);
  if (id == LCD) {
    vec2 uv = (p.xy - (PRINTER.xy + vec2(-58.0 - 42.0, 160.0 + 92.0 - 22.0))) / vec2(84.0, 44.0);
    vec3 c = vec3(0.12, 0.22, 0.42);
    c = mix(c, vec3(0.75, 0.85, 1.0), textLines(uv, vec2(0.45, 0.72), vec2(0.38, 0.12), 1.0, 2.0));
    c = mix(c, vec3(0.75, 0.85, 1.0), textLines(uv, vec2(0.4, 0.38), vec2(0.32, 0.1), 1.0, 5.0));
    c = mix(c, vec3(0.75, 0.85, 1.0), rect(uv, vec2(0.5, 0.14), vec2(0.4, 0.035)) * step(uv.x, 0.62));
    return screen(c * 0.8);
  }
  if (id == ROLL) {
    bool lying = p.x < 0.0 || p.x > DESKC.x + 300.0;
    float a = lying ? atan(n.z, n.y) : atan(n.z, n.x);
    float side = lying ? step(abs(n.x), 0.5) : step(abs(n.y), 0.5);
    float gap = side * smoothstep(0.004, 0.0, abs(fract(a * 1.27) - 0.5) - 0.47);
    return mat(vec3(0.84, 0.84, 0.82) * (1.0 - 0.25 * gap), 0.45, 0.0);
  }
  if (id == KEYCAP) return mat(vec3(0.32, 0.33, 0.34), 0.4, 0.0);
  if (id == SCANWIN) return glow(vec3(0.01), 0.04, vec3(0.6, 0.02, 0.01));
  if (id == SS) return mat(vec3(0.78, 0.78, 0.77), 0.32 + 0.08 * vnoise(p * vec3(0.02, 0.5, 0.02)), 1.0);
  return libMat(id, p, n);
}
