const vec3 BC = vec3(600.0, 700.0, -600.0);
const float BR = 2700.0;

const float SS = 50.0, CHAIN = 51.0, HDPE = 52.0, CAPC = 53.0, BLABEL = 54.0, ROLL = 55.0, LINER = 56.0, LENS = 57.0, PLATE = 58.0, LABEL = 59.0, HMI = 60.0, FORK = 61.0, PRBODY = 62.0, WEB = 63.0, WARN = 64.0, IDPLATE = 65.0;

const float BTOP = 900.0;
const float LINE_Z = 100.0;
const vec3 PA = vec3(1450.0, 0.0, -1640.0);
const float CZ = -1200.0;

float segXZ(vec3 p, vec2 a, vec2 b) {
  vec2 pa = p.xz - a, ba = b - a;
  float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
  return length(pa - ba * h);
}

vec2 photoEye(vec3 p) {
  vec3 q = p - vec3(0.0, 0.0, 16.0);
  vec2 r = vec2(rbox(q, vec3(10.0, 25.0, 16.0), 2.6), MGREY);
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 15.0), vec3(10.4, 25.4, 2.6), 2.4), BLACK));
  r = U(r, vec2(rbox(q - vec3(0.0, 6.0, 17.2), vec3(7.4, 13.5, 0.9), 2.0), LENS));
  r = U(r, vec2(cylY(q - vec3(-4.6, 25.2, -8.0), 1.8, 0.7, 0.4), LAMBER));
  r = U(r, vec2(cylY(q - vec3(4.6, 25.2, -8.0), 1.8, 0.7, 0.4), LGREEN));
  r = U(r, vec2(min(cylY(q - vec3(0.0, -30.0, -4.0), 4.0, 5.0, 0.6), cylY(q - vec3(0.0, -38.0, -4.0), 5.2, 4.0, 0.8)), STEEL));
  r = U(r, vec2(box(p - vec3(0.0, -6.0, -1.2), vec3(17.0, 42.0, 1.2)) - 0.2, ZINC));
  r = U(r, vec2(capsule(q, vec3(0.0, -42.0, -4.0), vec3(0.0, -80.0, -12.0), 2.4), CABLE));
  return r;
}

vec2 bottle(vec3 p, float state) {
  float body = cylY(p - vec3(0.0, 72.0, 0.0), 33.0, 72.0, 9.0);
  float shoulder = coneY(p - vec3(0.0, 157.0, 0.0), 32.0, 14.0, 15.0);
  float neck = cylY(p - vec3(0.0, 179.0, 0.0), 13.0, 8.0, 1.0);
  float b = smin(smin(body, shoulder, 8.0), neck, 3.0);
  vec2 r = vec2(b, HDPE);
  float cap = cylY(p - vec3(0.0, 195.0, 0.0), 16.5, 10.0, 2.0);
  cap += 0.35 * smoothstep(-0.3, 0.3, sin(atan(p.z, p.x) * 36.0)) * step(abs(p.y - 193.0), 7.0);
  r = U(r, vec2(cap * 0.9, CAPC));
  if (state > 0.5) {
    float band = max(abs(length(p.xz) - 33.0) - 0.35, abs(p.y - 76.0) - 44.0);
    if (state < 1.5) band = max(band, p.z - 8.0);
    r = U(r, vec2(band, BLABEL));
  }
  return r;
}

vec2 slatConveyor(vec3 p, float L) {
  vec3 q = vec3(p.x, p.y - BTOP, p.z - LINE_Z);
  float chain = box(q + vec3(0.0, 4.0, 0.0), vec3(L * 0.5, 4.0, 57.0));
  chain = max(chain, -box(vec3(rep(q.x, 38.1), q.y, q.z), vec3(0.5, 1.5, 60.0)));
  vec2 r = vec2(chain, CHAIN);
  float side = rbox(vec3(q.x, q.y + 34.0, abs(q.z) - 76.0), vec3(L * 0.5 + 10.0, 40.0, 2.0), 1.0);
  side = min(side, box(q + vec3(0.0, 72.0, 0.0), vec3(L * 0.5 + 10.0, 2.0, 76.0)));
  r = U(r, vec2(side, SS));
  float rails = length(vec2(q.y - 82.0, abs(q.z) - 40.0)) - 5.0;
  rails = max(rails, abs(q.x) - L * 0.5);
  float bx = rep(q.x + 200.0, 400.0);
  float posts = cylY(vec3(bx, q.y - 40.0, abs(q.z) - 80.0), 4.5, 42.0, 0.0);
  posts = max(posts, abs(q.x) - L * 0.5);
  float stubs = cylZ(vec3(bx, q.y - 82.0, abs(q.z) - 60.0), 4.5, 20.0, 0.0);
  stubs = max(stubs, abs(q.x) - L * 0.5);
  float clamps = rbox(vec3(bx, q.y - 82.0, abs(q.z) - 80.0), vec3(9.0, 9.0, 9.0), 2.0);
  clamps = max(clamps, abs(q.x) - L * 0.5);
  r = U(r, vec2(min(min(rails, posts), stubs), CHROME));
  r = U(r, vec2(clamps, BLACK));
  float legs = cylY(vec3(abs(q.x) - L * 0.5 + 60.0, p.y - (BTOP - 80.0) * 0.5, q.z), 22.0, (BTOP - 80.0) * 0.5, 2.0);
  r = U(r, vec2(legs, SS));
  float feet = cylY(vec3(abs(q.x) - L * 0.5 + 60.0, p.y - 6.0, q.z), 30.0, 6.0, 2.0);
  r = U(r, vec2(feet, BLACK));
  return r;
}

vec2 machineBase(vec3 p) {
  vec3 q = p - vec3(0.0, 450.0, -20.0);
  float body = rbox(q, vec3(700.0, 370.0, 300.0), 8.0);
  float seams = max(abs(box2(vec2(abs(q.x) - 350.0, q.y), vec2(330.0, 340.0))) - 1.2, abs(q.z - 300.0) - 3.0);
  body = max(body, -seams);
  vec2 r = vec2(body, SS);
  float handles = rbox(vec3(abs(q.x) - 80.0, q.y - 120.0, q.z - 306.0), vec3(8.0, 50.0, 6.0), 3.0);
  r = U(r, vec2(handles, BLACK));
  vec3 f = vec3(abs(p.x) - 640.0, p.y, abs(p.z + 20.0) - 250.0);
  float feet = min(cylY(f - vec3(0.0, 45.0, 0.0), 10.0, 40.0, 0.0), cylY(f - vec3(0.0, 8.0, 0.0), 32.0, 8.0, 3.0));
  r = U(r, vec2(feet, STEEL));
  return r;
}

vec2 labelHead(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(-60.0, 870.0, -300.0), vec3(300.0, 46.0, 150.0), 8.0), SS);
  float plate = rbox(p - vec3(-60.0, 921.0, -280.0), vec3(330.0, 5.0, 190.0), 4.0);
  plate = max(plate, -(p.z + 60.0));
  r = U(r, vec2(plate, PLATE));
  vec3 u = p - vec3(-210.0, 926.0, -300.0);
  float flange = cylY(u - vec3(0.0, 3.0, 0.0), 160.0, 3.0, 1.5);
  r = U(r, vec2(flange, PLATE));
  float roll = cylY(u - vec3(0.0, 52.0, 0.0), 132.0, 46.0, 1.5);
  roll = max(roll, -cylY(u - vec3(0.0, 52.0, 0.0), 40.0, 60.0, 0.0));
  r = U(r, vec2(roll, ROLL));
  float core = max(cylY(u - vec3(0.0, 52.0, 0.0), 40.0, 47.0, 0.5), -cylY(u - vec3(0.0, 52.0, 0.0), 34.0, 60.0, 0.0));
  r = U(r, vec2(core, CARD));
  float hub = cylY(u - vec3(0.0, 60.0, 0.0), 34.0, 54.0, 3.0);
  hub = min(hub, cylY(u - vec3(0.0, 118.0, 0.0), 48.0, 5.0, 2.0));
  r = U(r, vec2(hub, ALU));
  r = U(r, vec2(cylY(u - vec3(0.0, 126.0, 0.0), 14.0, 6.0, 2.0), BLACK));
  vec3 w = p - vec3(120.0, 926.0, -330.0);
  float rew = cylY(w - vec3(0.0, 50.0, 0.0), 62.0, 46.0, 1.0);
  rew = min(rew, cylY(w - vec3(0.0, 3.0, 0.0), 90.0, 3.0, 1.5));
  r = U(r, vec2(rew, LINER));
  float rhub = cylY(w - vec3(0.0, 60.0, 0.0), 30.0, 52.0, 3.0);
  rhub = min(rhub, cylY(w - vec3(0.0, 112.0, 0.0), 40.0, 4.0, 2.0));
  r = U(r, vec2(rhub, ALU));
  vec2 rollers[4] = vec2[4](vec2(-20.0, -120.0), vec2(90.0, -70.0), vec2(170.0, -150.0), vec2(-90.0, -200.0));
  float rl = 1e9;
  for (int i = 0; i < 4; i++) rl = min(rl, cylY(p - vec3(rollers[i].x, 976.0, rollers[i].y), 12.0, 52.0, 2.0));
  r = U(r, vec2(rl, ALU));
  float drive = cylY(p - vec3(150.0, 976.0, -40.0), 26.0, 50.0, 3.0);
  r = U(r, vec2(drive, RUBBER));
  float peel = rbox(p - vec3(60.0, 976.0, 20.0), vec3(40.0, 50.0, 2.0), 1.5);
  vec3 pq = p - vec3(80.0, 976.0, 30.0);
  pq.xz = rot(0.5) * pq.xz;
  peel = min(peel, rbox(pq, vec3(36.0, 50.0, 1.5), 1.0));
  r = U(r, vec2(peel, STEEL));
  float brush = cylY(p - vec3(-30.0, 976.0, 38.0), 18.0, 48.0, 3.0);
  r = U(r, vec2(brush, BLACK));
  float fork = rbox(p - vec3(-62.0, 976.0, -128.0), vec3(18.0, 30.0, 14.0), 3.0);
  r = U(r, vec2(fork, FORK));
  r = U(r, vec2(cylY(p - vec3(-62.0, 1008.0, -128.0), 2.0, 1.0, 0.5), LAMBER));
  if (abs(p.y - 976.0) < 50.0) {
    float web = segXZ(p, vec2(-210.0 + 132.0, -300.0 + 40.0), vec2(-90.0, -188.0));
    web = min(web, segXZ(p, vec2(-90.0, -188.0), vec2(-20.0, -108.0)));
    web = min(web, segXZ(p, vec2(-20.0, -108.0), vec2(60.0, 22.0)));
    float liner = segXZ(p, vec2(95.0, 38.0), vec2(176.0, -40.0));
    liner = min(liner, segXZ(p, vec2(176.0, -40.0), vec2(182.0, -150.0)));
    liner = min(liner, segXZ(p, vec2(182.0, -150.0), vec2(120.0 + 62.0, -330.0)));
    r = U(r, vec2(max(web - 0.4, abs(p.y - 976.0) - 45.0), WEB));
    r = U(r, vec2(max(liner - 0.3, abs(p.y - 976.0) - 45.0), LINER));
  }
  float post = cylY(p - vec3(-60.0, 700.0, -420.0), 32.0, 300.0, 3.0);
  r = U(r, vec2(post, SS));
  return r;
}

vec2 paUnit(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 860.0, 0.0), vec3(40.0, 840.0, 40.0), 3.0), ALU);
  r.x = max(r.x, -box(vec3(abs(q.x) - 40.0, q.y - 860.0, q.z), vec3(3.0, 850.0, 4.0)));
  r = U(r, vec2(rbox(q - vec3(0.0, 8.0, 0.0), vec3(160.0, 8.0, 160.0), 3.0), ZINC));
  float arm = rbox(q - vec3(0.0, 1660.0, 230.0), vec3(40.0, 40.0, 290.0), 3.0);
  arm = max(arm, -box(vec3(abs(q.x) - 40.0, q.y - 1660.0, q.z - 230.0), vec3(3.0, 4.0, 300.0)));
  r = U(r, vec2(arm, ALU));
  vec3 b = q - vec3(0.0, 1420.0, 300.0);
  float body = rbox(b, vec3(140.0, 170.0, 190.0), 8.0);
  r = U(r, vec2(body, PRBODY));
  float side = rbox(b - vec3(141.0, 20.0, -10.0), vec3(3.0, 130.0, 160.0), 4.0);
  r = U(r, vec2(side, LGREY));
  r = U(r, vec2(rbox(b - vec3(-60.0, 80.0, 191.0), vec3(50.0, 40.0, 2.0), 3.0), BLACK));
  r = U(r, vec2(cylZ(b - vec3(-90.0, 130.0, 191.0), 3.0, 1.0, 0.5), LGREEN));
  vec3 c = vec3(1240.0 - q.y, q.x, q.z - 440.0);
  r = U(r, pneuCylinder(c, 32.0, 100.0, 30.0));
  vec3 pad = q - vec3(0.0, 1062.0, 440.0);
  r = U(r, vec2(rbox(pad, vec3(58.0, 9.0, 42.0), 3.0), ALU));
  r = U(r, vec2(rbox(pad + vec3(0.0, 12.0, 0.0), vec3(55.0, 3.0, 39.0), 2.0), BLACK));
  r = U(r, vec2(box(pad + vec3(0.0, 15.4, 0.0), vec3(50.0, 0.3, 34.0)), LABEL));
  r = U(r, vec2(capsule(q, vec3(60.0, 1100.0, 420.0), vec3(110.0, 1300.0, 380.0), 3.0), ORANGE));
  return r;
}

vec3 bottleCell(vec3 p, out float cell) {
  cell = clamp(round(p.x / 120.0), -10.0, 10.0);
  return vec3(p.x - cell * 120.0 - (h22(vec2(cell, 1.7)).x - 0.5) * 22.0, p.y - BTOP, p.z - LINE_Z);
}

vec3 cartonCell(vec3 p, out float cell) {
  float x = p.x - 1450.0;
  cell = clamp(round(x / 520.0), -1.0, 2.0);
  vec2 h = h22(vec2(cell, 4.1)) - 0.5;
  vec3 q = vec3(x - cell * 520.0, p.y - 750.0, p.z - CZ - h.y * 40.0);
  q.xz = rot(h.x * 0.12) * q.xz;
  return q;
}

void pickEye(vec3 q, inout float best, inout float second, inout vec3 bq) {
  float d = box(q - vec3(0.0, -20.0, 16.0), vec3(18.0, 70.0, 20.0));
  if (d < best) {
    second = best;
    best = d;
    bq = q;
  } else {
    second = min(second, d);
  }
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (uVariant < 1.5) {
    if (box(p - vec3(0.0, 450.0, -20.0), vec3(710.0, 460.0, 310.0)) < r.x) r = U(r, machineBase(p));
    if (box(p - vec3(0.0, 800.0, LINE_Z), vec3(1300.0, 820.0, 100.0)) < r.x) r = U(r, slatConveyor(p, 2500.0));
    float cell;
    vec3 bq = bottleCell(p, cell);
    if (box(bq - vec3(0.0, 105.0, 0.0), vec3(40.0, 110.0, 40.0)) < r.x) r = U(r, bottle(bq, cell > 0.5 ? 2.0 : (cell > -0.5 ? 1.0 : 0.0)));
    if (box(p - vec3(-60.0, 800.0, -250.0), vec3(370.0, 340.0, 260.0)) < r.x) r = U(r, labelHead(p));
    vec3 eq = vec3(0.0);
    float best = 1e9, second = 1e9;
    pickEye(p - vec3(-320.0, 1010.0, LINE_Z - 92.0), best, second, eq);
    vec3 ck = p - vec3(420.0, 1000.0, LINE_Z + 92.0);
    pickEye(vec3(-ck.x, ck.y, -ck.z), best, second, eq);
    if (best < r.x) {
      vec2 e = photoEye(eq);
      e.x = min(e.x, second);
      r = U(r, e);
    }
    vec3 rq = p.x < 50.0 ? p - vec3(-320.0, 950.0, 4.0) : vec3(p.x - 420.0, p.y - 950.0, LINE_Z + 96.0 - p.z);
    r = U(r, vec2(cylY(rq, 5.0, 46.0, 1.0), CHROME));
    r = U(r, vec2(rbox(rq - vec3(0.0, -36.0, 10.0), vec3(9.0, 7.0, 12.0), 2.0), ZINC));
    vec3 hp = p - vec3(560.0, 0.0, -250.0);
    if (box(hp - vec3(0.0, 1180.0, 70.0), vec3(200.0, 380.0, 160.0)) < r.x) {
      r = U(r, vec2(cylY(hp - vec3(0.0, 1130.0, 0.0), 24.0, 310.0, 3.0), SS));
      r = U(r, vec2(cylZ(hp - vec3(0.0, 1430.0, 50.0), 20.0, 60.0, 3.0), SS));
      vec3 hq = hp - vec3(0.0, 1400.0, 150.0);
      hq.yz = rot(0.18) * hq.yz;
      r = U(r, vec2(rbox(hq + vec3(0.0, 0.0, 40.0), vec3(60.0, 60.0, 20.0), 6.0), DARK));
      r = U(r, hmiPanel(hq, vec2(165.0, 120.0), 46.0, 16.0, HMI));
    }
    r = U(r, vec2(box(p - vec3(-560.0, 700.0, 280.3), vec3(45.0, 15.0, 0.3)), IDPLATE));
    r = U(r, vec2(box(p - vec3(140.0, 870.0, -149.7), vec3(13.0, 13.0, 0.3)), WARN));
    float hc = capsule(p, vec3(586.0, 1380.0, -232.0), vec3(586.0, 830.0, -232.0), 4.0);
    r = U(r, vec2(hc, CABLE));
    float ties = max(length(vec2(p.x - 568.0, p.z + 244.0)) - 35.5, abs(rep(p.y - 900.0, 160.0)) - 2.0);
    ties = max(max(ties, 34.0 - length(vec2(p.x - 568.0, p.z + 244.0))), abs(p.y - 1100.0) - 260.0);
    r = U(r, vec2(ties, BLACK));
    vec3 tq = p - vec3(-640.0, 820.0, -280.0);
    if (box(tq - vec3(0.0, 150.0, 0.0), vec3(40.0, 160.0, 40.0)) < r.x) r = U(r, towerLight(tq, 0.0));
  }
  if (uVariant < 0.5 || uVariant > 1.5) {
    vec3 cq = p - vec3(1600.0, 0.0, CZ);
    if (box(cq - vec3(0.0, 380.0, 0.0), vec3(1030.0, 400.0, 310.0)) < r.x) r = U(r, beltConveyor(cq, 2000.0, 500.0, 750.0, BELT));
    float cell;
    vec3 c = cartonCell(p, cell);
    if (box(c - vec3(0.0, 140.0, 0.0), vec3(210.0, 150.0, 170.0)) < r.x) {
      r = U(r, carton(c, vec3(200.0, 130.0, 160.0)));
      if (cell > 0.5) r = U(r, vec2(box(c - vec3(0.0, 260.6, 0.0), vec3(50.0, 0.4, 34.0)), LABEL));
    }
    vec3 aq = p - PA;
    if (box(aq - vec3(0.0, 860.0, 250.0), vec3(200.0, 870.0, 320.0)) < r.x) r = U(r, paUnit(aq));
  }
  return r;
}

float barcodeInk(vec2 uv, float seed) {
  float ink = textLines(uv, vec2(0.36, 0.86), vec2(0.28, 0.07), 2.0, seed);
  vec2 b = (uv - vec2(0.07, 0.3)) / vec2(0.6, 0.36);
  if (b.x > 0.0 && b.x < 1.0 && b.y > 0.0 && b.y < 1.0) {
    float m = floor(b.x * 95.0);
    bool guard = m < 3.0 || m > 91.0 || (m > 45.0 && m < 50.0);
    ink = max(ink, guard ? 1.0 - mod(m, 2.0) : step(0.48, h22(vec2(m, seed)).x));
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
  return ink;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == CARD) {
    Mat m = libMat(id, p, n);
    m.alb *= 1.0 - 0.16 * smoothstep(0.55, 0.78, fbm(p * 0.013 + 3.0)) - 0.06 * smoothstep(0.6, 0.9, vnoise(p * 0.08));
    return m;
  }
  if (id == WARN) {
    vec2 uv = (p.xy - vec2(140.0, 870.0)) / 26.0 + 0.5;
    vec2 t = uv - vec2(0.5, 0.42);
    float tri = max(abs(t.x) * 1.732 + t.y - 0.34, -t.y - 0.2);
    float ink = max(cover(abs(tri) - 0.035), max(rect(uv, vec2(0.5, 0.47), vec2(0.035, 0.1)), disc(uv, vec2(0.5, 0.3), 0.04)));
    return mat(mix(vec3(0.85, 0.6, 0.02), vec3(0.015), ink), 0.35, 0.0);
  }
  if (id == IDPLATE) {
    float rivet = smoothstep(2.2, 1.4, length(abs(p.xy - vec2(-560.0, 700.0)) - vec2(40.0, 10.0)));
    return mat(vec3(0.76, 0.77, 0.78) * (0.92 + 0.08 * vnoise(vec3(p.x * 3.0, p.y * 0.05, 1.0))) * (1.0 - 0.4 * rivet), 0.28, 1.0);
  }
  if (id == SS) return mat(vec3(0.78, 0.78, 0.77), 0.3 + 0.08 * vnoise(p * vec3(0.02, 0.6, 0.02)), 1.0);
  if (id == CHAIN) return mat(vec3(0.74, 0.74, 0.72), 0.36, 0.0);
  if (id == HDPE) return mat(vec3(0.8, 0.8, 0.78), 0.42, 0.0);
  if (id == CAPC) return mat(vec3(0.02, 0.12, 0.42), 0.32, 0.0);
  if (id == BLABEL) {
    float cell;
    vec3 q = bottleCell(p, cell);
    vec2 uv = vec2(atan(q.z, q.x) / 6.2831853 + 0.5, (q.y - 32.0) / 88.0);
    vec3 c = vec3(0.012, 0.2, 0.22);
    c = mix(c, vec3(0.75, 0.32, 0.02), rect(uv, vec2(0.5, 0.93), vec2(0.5, 0.035)));
    c = mix(c, vec3(0.8), textLines(uv, vec2(0.48, 0.66), vec2(0.13, 0.12), 2.0, 3.0));
    c = mix(c, vec3(0.8), textLines(uv, vec2(0.45, 0.36), vec2(0.1, 0.12), 3.0, 7.0));
    vec2 w = (uv - vec2(0.62, 0.12)) / vec2(0.2, 0.68);
    float panel = step(0.0, w.x) * step(w.x, 1.0) * step(0.0, w.y) * step(w.y, 1.0);
    c = mix(c, vec3(0.82), panel);
    c = mix(c, vec3(0.015), panel * barcodeInk(w, 2.0 + cell));
    return mat(c, 0.3, 0.0);
  }
  if (id == ROLL) {
    float gap = step(abs(n.y), 0.5) * smoothstep(0.004, 0.0, abs(fract(atan(n.z, n.x) * 3.2) - 0.5) - 0.47);
    return mat(vec3(0.84, 0.84, 0.82) * (1.0 - 0.3 * gap), 0.4, 0.0);
  }
  if (id == WEB) return mat(vec3(0.84, 0.84, 0.82), 0.4, 0.0);
  if (id == LINER) return mat(vec3(0.72, 0.6, 0.32), 0.2, 0.0);
  if (id == LENS) return mat(vec3(0.02, 0.006, 0.006), 0.04, 0.0);
  if (id == PLATE) return mat(vec3(0.07, 0.075, 0.08), 0.32, 0.0);
  if (id == FORK) return mat(vec3(0.05, 0.12, 0.24), 0.36, 0.0);
  if (id == PRBODY) return mat(vec3(0.05, 0.055, 0.06), 0.38, 0.0);
  if (id == LABEL) {
    if (p.y < 1030.0) {
      float cell;
      vec3 c = cartonCell(p, cell);
      return mat(mix(vec3(0.82, 0.82, 0.8), vec3(0.015), barcodeInk(vec2(c.x / 100.0 + 0.5, 0.5 - c.z / 68.0), cell)), 0.45, 0.0);
    }
    return mat(vec3(0.82, 0.82, 0.8), 0.45, 0.0);
  }
  if (id == HMI) {
    vec3 hq = p - vec3(560.0, 1400.0, -100.0);
    hq.yz = rot(0.18) * hq.yz;
    return screen(screenHmi(vec2(hq.x / 298.0 + 0.5, hq.y / 208.0 + 0.5), 5.0));
  }
  return libMat(id, p, n);
}
