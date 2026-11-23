const vec3 BC = vec3(-80.0, 900.0, 0.0);
const float BR = 1450.0;

const float TUBE = 50.0, PSU = 51.0, DUCT = 52.0, VALVE = 53.0, MODULE = 54.0, PLUG = 55.0, WIRE_BLUE = 56.0;
const float FRAME = 58.0, PLATE = 59.0, GASKET = 61.0;

const vec3 BOX = vec3(-330.0, 900.0, -262.0);
const vec3 HINGE = vec3(-630.0, 900.0, -157.0);

vec3 toMotor(vec3 p) {
  vec3 q = p - vec3(430.0, 1027.0, 40.0);
  q.xz = rot(-0.4) * q.xz;
  return q;
}

vec3 toAir(vec3 p) {
  vec3 q = p - vec3(-250.0, 910.0, 160.0);
  q.xz = rot(-0.12) * q.xz;
  return q;
}

float tubes(vec3 g) {
  float best = 1e9;
  for (int k = uZero; k < 3; k++) {
    vec3 a = k == 0 ? vec3(-291.0, 76.0, 0.0) : (k == 1 ? vec3(-73.0, 76.0, 0.0) : vec3(212.0, 14.0, 40.0));
    vec3 b = k == 0 ? vec3(-291.0, 216.0, 0.0) : (k == 1 ? vec3(-73.0, 156.0, 0.0) : vec3(280.0, 14.0, 40.0));
    vec3 c = k == 0 ? vec3(109.0, 230.0, 18.0) : (k == 1 ? vec3(140.0, 170.0, 50.0) : vec3(310.0, 6.0, 140.0));
    vec3 d = k == 0 ? vec3(109.0, 87.0, 18.0) : (k == 1 ? vec3(140.0, 87.0, 50.0) : vec3(360.0, -6.0, 190.0));
    vec3 prev = a;
    for (int i = 1 + uZero; i <= 12; i++) {
      float t = float(i) / 12.0;
      float u = 1.0 - t;
      vec3 q = u * u * u * a + 3.0 * u * u * t * b + 3.0 * u * t * t * c + t * t * t * d;
      best = min(best, capsule(g, prev, q, 4.0));
      prev = q;
    }
  }
  return best;
}

vec2 duct(vec3 d, vec2 hs, float depth) {
  float body = box(d - vec3(0.0, 0.0, depth * 0.5), vec3(hs, depth * 0.5));
  float slots = max(abs(rep(d.x, 12.0)) - 2.6, max(hs.y - 3.0 - abs(d.y), max(4.0 - d.z, d.z - depth + 3.0)));
  body = max(body, -slots);
  float lid = rbox(d - vec3(0.0, 0.0, depth + 1.5), vec3(hs.x, hs.y + 1.5, 1.5), 1.0);
  return vec2(min(body, lid), DUCT);
}

vec2 psu(vec3 d) {
  float body = rbox(d - vec3(0.0, 0.0, 58.0), vec3(32.0, 62.0, 58.0), 3.0);
  float vents = max(abs(rep(d.z - 58.0, 9.0)) - 2.2, max(abs(d.x) - 24.0, max(abs(d.z - 58.0) - 44.0, 60.5 - abs(d.y))));
  body = max(body, -vents);
  vec2 r = vec2(body, PSU);
  float strip = rbox(d - vec3(0.0, -46.0, 116.5), vec3(29.0, 11.0, 2.5), 1.0);
  strip = max(strip, -cylZ(vec3(repLim(d.x, 9.5, -2.0, 2.0), d.y + 46.0, d.z - 119.5), 3.0, 2.0, 0.0));
  r = U(r, vec2(strip, BLACK));
  float screws = cylZ(vec3(repLim(d.x, 9.5, -2.0, 2.0), d.y + 46.0, d.z - 117.6), 2.4, 0.8, 0.3);
  r = U(r, vec2(screws, STEEL));
  r = U(r, vec2(cylZ(d - vec3(20.0, 44.0, 116.3), 2.2, 0.6, 0.4), LGREEN));
  float pot = cylZ(d - vec3(20.0, 30.0, 116.3), 2.6, 0.6, 0.3);
  pot = max(pot, -box(d - vec3(20.0, 30.0, 117.0), vec3(0.5, 2.8, 0.6)));
  r = U(r, vec2(pot, WHITE));
  return r;
}

vec2 plcModule(vec3 d, float w, float cpu) {
  float body = rbox(d - vec3(0.0, 0.0, 37.0), vec3(w * 0.5 - 0.5, 50.0, 37.0), 2.0);
  vec2 r = vec2(body, MODULE);
  float face = rbox(d - vec3(0.0, 0.0, 74.5), vec3(w * 0.5 - 3.0, 26.0, 1.5), 1.2);
  r = U(r, vec2(face, LGREY));
  float plugs = rbox(vec3(d.x, abs(d.y) - 38.0, d.z - 66.0), vec3(w * 0.5 - 4.0, 9.0, 8.0), 1.5);
  plugs = max(plugs, -box(vec3(rep(d.x, 5.0), abs(d.y) - 38.0, d.z - 74.0), vec3(1.6, 4.0, 2.0)));
  r = U(r, vec2(plugs, PLUG));
  float cell = clamp(round((d.y - 2.0) / 5.0), -3.0, 3.0);
  float led = box(vec3(d.x + w * 0.5 - 9.0, d.y - 2.0 - cell * 5.0, d.z - 76.2), vec3(1.5, 1.2, 0.5));
  r = U(r, vec2(led, mod(cell + cpu, 3.0) < 1.5 ? LGREEN : GREEN_OFF));
  if (cpu > 0.5) {
    r = U(r, vec2(box(d - vec3(6.0, -12.0, 76.0), vec3(6.0, 5.0, 1.0)), BLACK));
    r = U(r, vec2(box(d - vec3(6.0, 12.0, 76.2), vec3(8.0, 1.2, 0.5)), LGREEN));
  }
  return r;
}

vec2 enclosure(vec3 q) {
  float outer = rbox(q - vec3(0.0, 300.0, 0.0), vec3(300.0, 300.0, 105.0), 8.0);
  float inner = box(q - vec3(0.0, 300.0, 25.0), vec3(286.0, 286.0, 110.0));
  vec2 r = vec2(max(outer, -inner), GREY);
  float lip = max(abs(box2(q.xy - vec2(0.0, 300.0), vec2(292.0))) - 3.0, abs(q.z - 101.0) - 3.0);
  r = U(r, vec2(lip, BLACK));
  r = U(r, vec2(box(vec3(abs(q.x) - 300.0, abs(q.y - 300.0) - 270.0, q.z + 100.0), vec3(12.0, 15.0, 2.0)), ZINC));
  r = U(r, vec2(box(q - vec3(0.0, 300.0, -80.0), vec3(268.0, 268.0, 2.0)), ZINC));
  vec3 c = q - vec3(0.0, 300.0, -78.0);
  if (box(c - vec3(0.0, 0.0, 45.0), vec3(268.0, 268.0, 50.0)) < r.x) {
    vec3 h = vec3(c.x, c.y > 139.0 || c.y < -99.0 ? abs(c.y) - 238.0 : c.y - 40.0, c.z);
    vec3 v = vec3(c.y, abs(c.x) - 246.0, c.z);
    bool vert = box(v - vec3(0.0, 0.0, 31.0), vec3(263.0, 20.0, 32.0)) < box(h - vec3(0.0, 0.0, 31.0), vec3(222.0, 25.0, 32.0));
    r = U(r, duct(vert ? v : h, vert ? vec2(263.0, 20.0) : vec2(222.0, 25.0), 60.0));
  }
  if (box(vec3(c.x, abs(c.y - 15.0) - 125.0, c.z - 8.0), vec3(212.0, 18.0, 8.0)) < r.x) r = U(r, dinRail(vec3(c.x, abs(c.y - 15.0) - 125.0, c.z), 420.0));
  vec3 d = c - vec3(0.0, 140.0, 7.6);
  if (box(d - vec3(0.0, 0.0, 60.0), vec3(222.0, 64.0, 64.0)) < r.x) {
    r = U(r, psu(d - vec3(-185.0, 0.0, 0.0)));
    bool three = d.x < -95.0;
    r = U(r, mcb(vec3(three ? d.x + 122.0 : repLim(d.x + 66.0, 18.0, -1.0, 1.0), d.y, d.z), three ? 3.0 : 1.0, 1.0));
    r = U(r, contactor(vec3(repLim(d.x - 60.0, 50.0, -1.0, 2.0), d.y, d.z)));
  }
  vec3 e = c - vec3(0.0, -110.0, 7.6);
  if (box(e - vec3(0.0, 0.0, 40.0), vec3(222.0, 55.0, 45.0)) < r.x) {
    bool cpu = e.x < -119.0;
    r = U(r, plcModule(vec3(cpu ? e.x + 165.0 : repLim(e.x + 65.0, 36.0, -1.0, 1.0), e.y, e.z), cpu ? 90.0 : 36.0, cpu ? 1.0 : 0.0));
    r = U(r, terminalBlocks(e - vec3(100.0, 0.0, 0.0), 14.0, BLUEP));
  }
  if (box(c - vec3(0.0, 40.0, 40.0), vec3(222.0, 120.0, 40.0)) < r.x) {
    float wx = repLim(c.x - 85.0, 25.0, -3.0, 3.0);
    float wires = capsule(vec3(wx, c.y, c.z), vec3(0.0, 95.0, 34.0), vec3(0.0, 66.0, 34.0), 1.6);
    float lw = repLim(c.x - 100.0, 12.4, -7.0, 7.0);
    float lower = capsule(vec3(lw, c.y, c.z), vec3(0.0, -78.0, 30.0), vec3(0.0, 14.0, 30.0), 1.4);
    r = U(r, vec2(wires, CABLE));
    r = U(r, vec2(lower, WIRE_BLUE));
  }
  return r;
}

vec2 door(vec3 q) {
  float panel = rbox(q - vec3(300.0, 300.0, 12.0), vec3(300.0, 300.0, 12.0), 6.0);
  panel = max(panel, -box(q - vec3(300.0, 300.0, -2.0), vec3(282.0, 282.0, 12.0)));
  vec2 r = vec2(panel, GREY);
  float gasket = max(abs(box2(q.xy - vec2(300.0, 300.0), vec2(289.0))) - 4.0, abs(q.z - 1.0) - 3.5);
  r = U(r, vec2(gasket, GASKET));
  float pocket = rbox(q - vec3(300.0, 330.0, 6.0), vec3(150.0, 110.0, 4.0), 3.0);
  pocket = max(pocket, -box(q - vec3(300.0, 470.0, 3.0), vec3(140.0, 40.0, 6.0)));
  r = U(r, vec2(pocket, BLACK));
  vec3 h = q - vec3(560.0, 300.0, 30.0);
  r = U(r, vec2(min(rbox(h, vec3(13.0, 60.0, 8.0), 5.0), rbox(h + vec3(0.0, 0.0, 4.0), vec3(18.0, 80.0, 4.0), 3.0)), BLACK));
  r = U(r, vec2(cylY(vec3(q.x, abs(q.y - 300.0) - 210.0, q.z - 20.0), 7.0, 35.0, 2.0), DARK));
  return r;
}

vec2 manifold(vec3 m) {
  float base = rbox(m - vec3(0.0, 14.0, 0.0), vec3(62.0, 14.0, 42.0), 2.0);
  vec2 r = vec2(base, ALU);
  float ports = cylX(vec3(abs(m.x) - 66.0, m.y - 14.0, m.z), 6.5, 5.0, 1.5);
  r = U(r, vec2(ports, BLACK));
  vec3 s = vec3(repLim(m.x, 31.0, -1.0, 1.0), m.y, m.z);
  float body = rbox(s - vec3(0.0, 50.0, -6.0), vec3(14.0, 22.0, 36.0), 2.0);
  r = U(r, vec2(body, VALVE));
  float coil = rbox(s - vec3(0.0, 52.0, 42.0), vec3(14.0, 20.0, 12.0), 2.5);
  r = U(r, vec2(coil, BLACK));
  r = U(r, vec2(rbox(s - vec3(0.0, 72.4, 46.0), vec3(3.0, 0.8, 3.0), 0.6), LAMBER));
  vec3 f = vec3(s.x, m.y, abs(m.z + 6.0) - 16.0);
  r = U(r, vec2(cylY(f - vec3(0.0, 78.0, 0.0), 5.5, 6.0, 1.0), BLACK));
  r = U(r, vec2(cylY(f - vec3(0.0, 85.0, 0.0), 5.0, 1.6, 0.6), BLUEP));
  r = U(r, vec2(cylY(vec3(abs(m.x) - 50.0, m.y - 28.6, abs(m.z) - 30.0), 4.2, 1.2, 0.5), STEEL));
  return r;
}

vec2 pneumatics(vec3 g) {
  vec2 r = vec2(0.7 * BR, -1.0);
  float plate = rbox(g - vec3(0.0, -5.0, 0.0), vec3(350.0, 5.0, 130.0), 1.5);
  plate = max(plate, -cylY(vec3(abs(g.x) - 330.0, g.y, abs(g.z) - 110.0), 5.5, 8.0, 0.0));
  r = U(r, vec2(plate, PLATE));
  r = U(r, vec2(cylY(vec3(abs(g.x) - 330.0, g.y - 2.0, abs(g.z) - 110.0), 8.5, 2.5, 1.0), STEEL));
  vec3 cq = g - vec3(-300.0, 33.8, 0.0);
  if (box(cq - vec3(155.0, 0.0, 0.0), vec3(185.0, 50.0, 40.0)) < r.x) {
    r = U(r, pneuCylinder(cq, 40.0, 200.0, 70.0));
    float side = cq.x < 118.0 ? -1.0 : 1.0;
    vec3 fq = vec3(side < 0.0 ? cq.x + 4.0 : cq.x - 240.0, cq.y, cq.z);
    float foot = box(fq - vec3(0.0, -2.0, 0.0), vec3(4.0, 30.0, 34.0));
    foot = min(foot, box(fq - vec3(side * 18.0, -30.8, 0.0), vec3(18.0, 3.0, 34.0)));
    if (side > 0.0) foot = max(foot, -cylX(fq, 15.0, 6.0, 0.0));
    r = U(r, vec2(foot, ZINC));
    r = U(r, vec2(cylY(vec3(fq.x - side * 22.0, cq.y + 26.0, abs(cq.z) - 22.0), 6.0, 2.6, 1.0), STEEL));
  }
  vec3 mq = g - vec3(140.0, 0.0, 40.0);
  if (box(mq - vec3(0.0, 45.0, 0.0), vec3(76.0, 46.0, 58.0)) < r.x) r = U(r, manifold(mq));
  r = U(r, vec2(tubes(g), TUBE));
  vec3 cp = g - vec3(360.0, -6.0, 190.0);
  cp.xz = rot(-0.95) * cp.xz;
  float coupler = min(cylX(cp - vec3(18.0, 0.0, 0.0), 7.5, 18.0, 2.0), cylX(cp - vec3(30.0, 0.0, 0.0), 10.0, 6.0, 2.0));
  r = U(r, vec2(coupler, BRASS));
  r = U(r, vec2(rbox(g - vec3(-150.0, 33.8, 25.3), vec3(24.0, 8.0, 0.6), 0.5), PAPER));
  return r;
}

vec2 props(vec3 p) {
  vec3 k = p - vec3(90.0, 902.5, 270.0);
  k.xz = rot(0.5) * k.xz;
  float key = min(capsule(k, vec3(-45.0, 0.0, 0.0), vec3(45.0, 0.0, 0.0), 2.5), capsule(k, vec3(45.0, 0.0, 0.0), vec3(48.0, 0.0, 26.0), 2.5));
  vec2 r = vec2(key, BLACK);
  vec3 t = p - vec3(200.0, 900.6, 330.0);
  t.xz = rot(-0.25) * t.xz;
  vec3 t2 = vec3(t.x, t.y, abs(t.z - 6.0) - 6.0);
  float ties = rbox(t2, vec3(95.0, 0.6, 2.3), 0.5);
  ties = min(ties, rbox(t2 - vec3(-97.0, 1.5, 0.0), vec3(4.0, 2.2, 3.4), 1.0));
  r = U(r, vec2(ties, BLACK));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 800.0, 0.0), vec3(905.0, 800.0, 405.0)) < r.x) r = U(r, workbench(p, vec3(1800.0, 900.0, 800.0)));
  vec3 q = p - BOX;
  if (box(q - vec3(0.0, 300.0, 0.0), vec3(316.0, 306.0, 112.0)) < r.x) r = U(r, enclosure(q));
  vec3 dq = p - HINGE;
  dq.xz = rot(-1.8326) * dq.xz;
  if (box(dq - vec3(300.0, 300.0, 18.0), vec3(306.0, 306.0, 30.0)) < r.x) r = U(r, door(dq));
  vec3 m = toMotor(p);
  if (box(m - vec3(-10.0, 15.0, 0.0), vec3(240.0, 150.0, 140.0)) < r.x) {
    r = U(r, motor(m, 75.0, 240.0, BLUE));
    r = U(r, vec2(cylX(m - vec3(130.0, 0.0, 0.0), 30.0, 6.0, 2.0), BLUE));
    r = U(r, vec2(cylX(vec3(m.x - 136.0, abs(m.y) - 48.0, abs(m.z) - 48.0), 4.5, 3.0, 1.0), STEEL));
    r = U(r, vec2(box(m - vec3(185.0, 15.0, 0.0), vec3(28.0, 2.5, 4.0)), STEEL));
    r = U(r, vec2(rbox(m - vec3(-10.0, -121.0, 0.0), vec3(200.0, 6.0, 130.0), 1.5), FRAME));
    vec3 bq = vec3(abs(m.x) - 72.0, m.y + 73.8, abs(m.z) - 58.0);
    r = U(r, vec2(min(cylY(bq, 11.0, 1.2, 0.4), cylY(bq - vec3(0.0, 4.0, 0.0), 8.0, 3.0, 0.8)), ZINC));
    vec3 tb = m - vec3(19.2, 113.0, 41.8);
    r = U(r, vec2(rbox(tb, vec3(30.0, 21.0, 0.7), 1.5), PLATE));
    r = U(r, vec2(cylZ(vec3(abs(tb.x) - 26.0, abs(tb.y) - 17.0, tb.z - 0.8), 1.4, 0.6, 0.4), STEEL));
  }
  vec3 g = toAir(p);
  if (box(g - vec3(60.0, 110.0, 120.0), vec3(410.0, 130.0, 240.0)) < r.x) r = U(r, pneumatics(g));
  if (box(p - vec3(90.0, 910.0, 300.0), vec3(220.0, 15.0, 90.0)) < r.x) r = U(r, props(p));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == TUBE) return mat(vec3(0.03, 0.15, 0.5), 0.22, 0.0);
  if (id == PSU) return mat(vec3(0.6, 0.61, 0.63), 0.34 + 0.06 * vnoise(p * vec3(0.05, 2.0, 0.05)), 1.0);
  if (id == ZINC) return mat(vec3(0.66, 0.68, 0.7) * (0.92 + 0.12 * fbm(p * 0.03)), 0.62, 1.0);
  if (id == DUCT) return mat(vec3(0.48, 0.49, 0.48), 0.42, 0.0);
  if (id == VALVE) return mat(vec3(0.022, 0.024, 0.028), 0.26, 0.0);
  if (id == MODULE) return mat(vec3(0.045, 0.048, 0.052), 0.4, 0.0);
  if (id == PLUG) return mat(vec3(0.03), 0.45, 0.0);
  if (id == WIRE_BLUE) return mat(vec3(0.02, 0.06, 0.3), 0.35, 0.0);
  if (id == FRAME) return mat(vec3(0.06, 0.065, 0.07), 0.5, 0.0);
  if (id == PLATE) return mat(vec3(0.78, 0.79, 0.8), 0.36 + 0.06 * vnoise(p * vec3(0.4, 0.02, 0.02)), 1.0);
  if (id == GASKET) return mat(vec3(0.015), 0.6, 0.0);
  return libMat(id, p, n);
}
