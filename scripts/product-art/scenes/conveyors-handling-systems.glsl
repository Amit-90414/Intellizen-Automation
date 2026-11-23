const vec3 BC = vec3(-600.0, 600.0, -900.0);
const float BR = 3000.0;

const float MODULAR = 50.0, UHMW = 51.0, TOTE = 52.0, LENS = 53.0, REFL = 54.0, GEAR = 55.0, SS = 56.0, WARN = 57.0, IDPLATE = 58.0;

const float H = 760.0;
const float DIV = 0.70;

vec2 photoEye(vec3 p) {
  vec3 q = p - vec3(0.0, 0.0, 16.0);
  float body = rbox(q, vec3(10.0, 25.0, 16.0), 2.6);
  vec2 r = vec2(body, MGREY);
  float front = rbox(q - vec3(0.0, 0.0, 15.0), vec3(10.4, 25.4, 2.6), 2.4);
  r = U(r, vec2(front, BLACK));
  float lens = rbox(q - vec3(0.0, 6.0, 17.2), vec3(7.4, 13.5, 0.9), 2.0);
  r = U(r, vec2(lens, LENS));
  r = U(r, vec2(cylY(q - vec3(-4.6, 25.2, -8.0), 1.8, 0.7, 0.4), LAMBER));
  r = U(r, vec2(cylY(q - vec3(4.6, 25.2, -8.0), 1.8, 0.7, 0.4), LGREEN));
  float m8 = cylY(q - vec3(0.0, -30.0, -4.0), 4.0, 5.0, 0.6);
  float nut = cylY(q - vec3(0.0, -38.0, -4.0), 5.2, 4.0, 0.8);
  r = U(r, vec2(min(m8, nut), STEEL));
  float plate = box(p - vec3(0.0, -6.0, -1.2), vec3(17.0, 42.0, 1.2));
  r = U(r, vec2(plate - 0.2, ZINC));
  float c = capsule(q, vec3(0.0, -42.0, -4.0), vec3(0.0, -70.0, -10.0), 2.4);
  r = U(r, vec2(c, CABLE));
  return r;
}

vec2 reflector(vec3 p) {
  float housing = cylZ(p - vec3(0.0, 0.0, 4.0), 26.0, 4.0, 2.0);
  vec2 r = vec2(housing, BLACK);
  r = U(r, vec2(cylZ(p - vec3(0.0, 0.0, 8.2), 22.0, 0.6, 0.4), REFL));
  float plate = box(p - vec3(0.0, -12.0, -1.2), vec3(30.0, 40.0, 1.2));
  r = U(r, vec2(plate - 0.2, ZINC));
  return r;
}

vec2 modularConveyor(vec3 p, float L, float W) {
  vec3 q = p - vec3(0.0, H, 0.0);
  float side = rbox(vec3(q.x, q.y + 50.0, abs(q.z) - W * 0.5 - 12.0), vec3(L * 0.5, 58.0, 2.5), 1.2);
  side = min(side, rbox(vec3(q.x, q.y + 106.0, abs(q.z) - W * 0.5 - 2.0), vec3(L * 0.5, 2.5, 12.0), 1.2));
  vec2 r = vec2(side, SS);
  float st = box2(vec2(q.x, q.y + 42.0), vec2(L * 0.5 - 44.0, 0.0)) - 42.0;
  float belt = max(abs(st + 7.0) - 7.0, abs(q.z) - W * 0.5 + 1.0);
  belt = max(belt, -box(vec3(rep(q.x, 25.4), q.y, q.z), vec3(0.6, 1.8, W * 0.5 + 2.0)));
  float row = mod(floor(q.x / 25.4 + 0.5), 2.0);
  belt = max(belt, -box(vec3(q.x, q.y, rep(q.z + row * 76.0, 152.0)), vec3(L, 1.2, 0.5)));
  r = U(r, vec2(belt, MODULAR));
  float lx = abs(q.x) - L * 0.5 + 140.0;
  float legs = rbox(vec3(lx, p.y - (H - 110.0) * 0.5, abs(q.z) - W * 0.5 - 30.0), vec3(20.0, (H - 110.0) * 0.5, 20.0), 2.0);
  float bar = rbox(vec3(lx, p.y - 180.0, q.z), vec3(20.0, 20.0, W * 0.5 + 30.0), 2.0);
  float cross = rbox(vec3(lx, q.y + 120.0, q.z), vec3(20.0, 14.0, W * 0.5 + 14.0), 2.0);
  r = U(r, vec2(min(min(legs, bar), cross), SS));
  float foot = cylY(vec3(lx, p.y - 6.0, abs(q.z) - W * 0.5 - 30.0), 28.0, 6.0, 2.0);
  float stud = cylY(vec3(lx, p.y - 30.0, abs(q.z) - W * 0.5 - 30.0), 8.0, 20.0, 0.0);
  r = U(r, vec2(foot, BLACK));
  r = U(r, vec2(stud, STEEL));
  return r;
}

vec2 gearMotor(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(0.0, -10.0, 58.0), vec3(72.0, 92.0, 46.0), 12.0), GEAR);
  r = U(r, vec2(cylZ(p - vec3(0.0, 0.0, 8.0), 34.0, 8.0, 2.0), GEAR));
  vec3 m = p - vec3(150.0, -62.0, 66.0);
  float rr = length(m.yz);
  float body = cylX(m, 58.0, 120.0, 8.0);
  float fin = max(max(rr - 68.0, abs(rep(atan(m.z, m.y), 6.2831853 / 28.0)) * rr - 2.2), abs(m.x) - 104.0);
  body = min(body, fin);
  float fan = cylX(m - vec3(166.0, 0.0, 0.0), 60.0, 44.0, 12.0);
  fan = max(fan, -max(max(abs(rep(m.y, 8.0)) - 2.0, m.x - 206.0), rr - 44.0));
  r = U(r, vec2(min(body, fan), GEAR));
  float tb = rbox(m - vec3(-20.0, 86.0, 0.0), vec3(42.0, 28.0, 40.0), 6.0);
  r = U(r, vec2(tb, GEAR));
  r = U(r, vec2(cylZ(m - vec3(-20.0, 82.0, 46.0), 9.0, 8.0, 2.0), BLACK));
  return r;
}

vec2 tote(vec3 p, vec3 hs) {
  vec3 q = p - vec3(0.0, hs.y, 0.0);
  float s = rbox(q, hs, 10.0);
  s = max(s, -rbox(q - vec3(0.0, 8.0, 0.0), vec3(hs.x - 6.0, hs.y, hs.z - 6.0), 6.0));
  s = max(s, -box(vec3(q.x, rep(q.y + 20.0, 36.0), abs(q.z) - hs.z), vec3(hs.x - 24.0, 9.0, 1.6)));
  s = max(s, -box(vec3(abs(q.x) - hs.x, rep(q.y + 20.0, 36.0), q.z), vec3(1.6, 9.0, hs.z - 24.0)));
  s = max(s, -rbox(vec3(abs(q.x) - hs.x, q.y - hs.y + 30.0, q.z), vec3(8.0, 14.0, 50.0), 6.0));
  return vec2(s, TOTE);
}

void pickCarton(vec3 q, vec3 hs, inout float best, inout float second, inout vec3 bq, inout vec3 bh) {
  float d = box(q - vec3(0.0, hs.y, 0.0), hs + 1.0);
  if (d < best) {
    second = best;
    best = d;
    bq = q;
    bh = hs;
  } else {
    second = min(second, d);
  }
}

void pickEye(vec3 q, inout float best, inout float second, inout vec3 bq) {
  float d = box(q - vec3(0.0, -10.0, 16.0), vec3(18.0, 64.0, 20.0));
  if (d < best) {
    second = best;
    best = d;
    bq = q;
  } else {
    second = min(second, d);
  }
}

void pickReflector(vec3 q, inout float best, inout float second, inout vec3 bq) {
  float d = box(q - vec3(0.0, -12.0, 3.0), vec3(30.0, 42.0, 6.0));
  if (d < best) {
    second = best;
    best = d;
    bq = q;
  } else {
    second = min(second, d);
  }
}

vec3 toModular(vec3 p) { return vec3(p.z + 1450.0, p.y, -(p.x - 1060.0)); }

vec3 toDiverter(vec3 p) {
  vec3 q = p - vec3(420.0, H, 345.0);
  q.xz = rot(DIV) * q.xz;
  return q;
}

vec2 diverter(vec3 q) {
  float arm = rbox(q - vec3(440.0, 92.0, -8.0), vec3(440.0, 62.0, 7.0), 3.0);
  vec2 r = vec2(arm, ALU);
  float face = rbox(q - vec3(440.0, 92.0, -18.0), vec3(436.0, 58.0, 4.0), 2.0);
  r = U(r, vec2(face, UHMW));
  float hub = cylY(q - vec3(0.0, 60.0, 0.0), 26.0, 90.0, 4.0);
  float lever = rbox(q - vec3(-36.0, 40.0, 30.0), vec3(48.0, 10.0, 14.0), 4.0);
  hub = min(hub, lever);
  r = U(r, vec2(hub, MGREY));
  float cap = cylY(q - vec3(0.0, 170.0, 0.0), 18.0, 5.0, 2.0);
  r = U(r, vec2(cap, STEEL));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  vec3 bq = p - vec3(-1920.0, 0.0, 0.0);
  if (box(bq - vec3(0.0, 380.0, 0.0), vec3(830.0, 400.0, 320.0)) < r.x) r = U(r, beltConveyor(bq, 1600.0, 500.0, H, BELT));
  vec3 gq = bq - vec3(-762.0, H - 32.0, 292.0);
  if (box(gq - vec3(150.0, -40.0, 80.0), vec3(330.0, 150.0, 120.0)) < r.x) r = U(r, gearMotor(gq));
  vec3 rq = p - vec3(200.0, 0.0, 0.0);
  if (box(rq - vec3(0.0, 380.0, 0.0), vec3(1300.0, 400.0, 340.0)) < r.x) r = U(r, rollerConveyor(rq, 2560.0, 600.0, H, 80.0));
  vec3 mq = toModular(p);
  if (box(mq - vec3(0.0, 380.0, 0.0), vec3(1020.0, 400.0, 320.0)) < r.x) r = U(r, modularConveyor(mq, 2000.0, 480.0));
  float dead = rbox(p - vec3(1060.0, H - 4.0, -380.0), vec3(250.0, 4.0, 72.0), 2.0);
  r = U(r, vec2(dead, SS));
  vec3 dq = toDiverter(p);
  if (box(dq - vec3(440.0, 90.0, 0.0), vec3(500.0, 100.0, 50.0)) < r.x) r = U(r, diverter(dq));
  vec3 cy = p - vec3(60.0, H + 40.0, 400.0);
  if (box(cy - vec3(200.0, -20.0, -20.0), vec3(260.0, 70.0, 80.0)) < r.x) {
    r = U(r, pneuCylinder(cy, 40.0, 220.0, 60.0));
    r = U(r, vec2(rbox(cy - vec3(9.0, -40.0, 0.0), vec3(12.0, 18.0, 30.0), 3.0), ZINC));
    r = U(r, vec2(rbox(cy - vec3(190.0, -60.0, -40.0), vec3(210.0, 6.0, 52.0), 2.0), ZINC));
  }
  vec3 cq = vec3(0.0), ch = vec3(1.0);
  float best = 1e9, second = 1e9;
  float bc = clamp(round((bq.x + 380.0) / 700.0), 0.0, 1.0);
  vec3 b1 = vec3(bq.x + 380.0 - 700.0 * bc, p.y - H, p.z - 12.0 + 26.0 * bc);
  b1.xz = rot(0.05 - 0.09 * bc) * b1.xz;
  pickCarton(b1, vec3(180.0, 120.0, 150.0), best, second, cq, ch);
  vec3 c1 = p - vec3(-650.0, H, 18.0);
  c1.xz = rot(0.035) * c1.xz;
  pickCarton(c1, vec3(200.0, 135.0, 160.0), best, second, cq, ch);
  vec3 c2 = p - vec3(540.0, H, 20.0);
  c2.xz = rot(DIV) * c2.xz;
  pickCarton(c2, vec3(180.0, 130.0, 150.0), best, second, cq, ch);
  float mc = clamp(round((380.0 - mq.x) / 1030.0), 0.0, 1.0);
  vec3 c3 = vec3(mq.x - 380.0 + 1030.0 * mc, mq.y - H, mq.z + 14.0 - 30.0 * mc);
  c3.xz = rot(-0.04 + 0.1 * mc) * c3.xz;
  pickCarton(c3, vec3(160.0, 110.0, 140.0), best, second, cq, ch);
  if (best < r.x) {
    vec2 c = carton(cq, ch);
    c.x = min(c.x, second);
    r = U(r, c);
  }
  r = U(r, vec2(box(p - vec3(-2570.0, H - 28.0, 280.3), vec3(13.0, 13.0, 0.3)), WARN));
  r = U(r, vec2(box(p - vec3(-800.0, H - 20.0, 312.3), vec3(40.0, 13.0, 0.3)), IDPLATE));
  r = U(r, vec2(box(p - vec3(-2682.0, H - 42.0, 396.3), vec3(30.0, 18.0, 0.3)), IDPLATE));
  vec3 t1 = p - vec3(-80.0, H, 0.0);
  if (box(t1 - vec3(0.0, 120.0, 0.0), vec3(210.0, 130.0, 160.0)) < r.x) r = U(r, tote(t1, vec3(200.0, 115.0, 150.0)));
  vec3 s1 = p - vec3(-1300.0, H + 50.0, 282.0);
  vec3 s2 = p - vec3(-420.0, H + 60.0, 313.0);
  vec3 s3 = vec3(mq.x - 100.0, mq.y - H - 50.0, abs(mq.z) - 257.0);
  vec3 eq = vec3(0.0);
  best = 1e9;
  second = 1e9;
  pickEye(p - vec3(-1300.0, H + 50.0, -282.0), best, second, eq);
  pickEye(p - vec3(-420.0, H + 60.0, -313.0), best, second, eq);
  if (mq.z > 0.0) pickEye(vec3(-s3.x, s3.y, -s3.z), best, second, eq);
  if (best < r.x) {
    vec2 e = photoEye(eq);
    e.x = min(e.x, second);
    r = U(r, e);
  }
  best = 1e9;
  second = 1e9;
  pickReflector(vec3(-s1.x, s1.y, -s1.z), best, second, eq);
  pickReflector(vec3(-s2.x, s2.y, -s2.z), best, second, eq);
  if (mq.z < 0.0) pickReflector(vec3(-s3.x, s3.y, -s3.z), best, second, eq);
  if (best < r.x) {
    vec2 e = reflector(eq);
    e.x = min(e.x, second);
    r = U(r, e);
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == CARD) {
    Mat m = libMat(id, p, n);
    m.alb *= 1.0 - 0.16 * smoothstep(0.55, 0.78, fbm(p * 0.013 + 3.0)) - 0.06 * smoothstep(0.6, 0.9, vnoise(p * 0.08));
    return m;
  }
  if (id == WARN) {
    vec2 uv = (p.xy - vec2(-2570.0, H - 28.0)) / 26.0 + 0.5;
    vec2 t = uv - vec2(0.5, 0.42);
    float tri = max(abs(t.x) * 1.732 + t.y - 0.34, -t.y - 0.2);
    float ink = max(cover(abs(tri) - 0.035), max(rect(uv, vec2(0.5, 0.47), vec2(0.035, 0.1)), disc(uv, vec2(0.5, 0.3), 0.04)));
    return mat(mix(vec3(0.85, 0.6, 0.02), vec3(0.015), ink), 0.35, 0.0);
  }
  if (id == IDPLATE) {
    vec2 c = p.x < -2000.0 ? vec2(-2682.0, H - 42.0) : vec2(-800.0, H - 20.0);
    vec2 hs = p.x < -2000.0 ? vec2(25.0, 13.0) : vec2(35.0, 8.0);
    float rivet = smoothstep(2.2, 1.4, length(abs(p.xy - c) - hs));
    return mat(vec3(0.76, 0.77, 0.78) * (0.92 + 0.08 * vnoise(vec3(p.x * 3.0, p.y * 0.05, 1.0))) * (1.0 - 0.4 * rivet), 0.28, 1.0);
  }
  if (id == MODULAR) return mat(vec3(0.04, 0.1, 0.22), 0.34, 0.0);
  if (id == UHMW) return mat(vec3(0.82, 0.83, 0.8), 0.42, 0.0);
  if (id == TOTE) return mat(vec3(0.025, 0.1, 0.3), 0.38, 0.0);
  if (id == LENS) return mat(vec3(0.02, 0.006, 0.006), 0.04, 0.0);
  if (id == REFL) {
    vec2 g = fract(p.xy * 0.25) - 0.5;
    return mat(vec3(0.5, 0.03, 0.02) * (0.8 + 0.4 * step(0.0, g.x * g.y)), 0.1, 0.0);
  }
  if (id == GEAR) return mat(vec3(0.06, 0.08, 0.1), 0.42, 0.0);
  if (id == SS) return mat(vec3(0.78, 0.78, 0.77), 0.3 + 0.08 * vnoise(p * vec3(0.02, 0.5, 0.02)), 1.0);
  return libMat(id, p, n);
}
