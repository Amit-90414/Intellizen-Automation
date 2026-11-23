const vec3 BC = vec3(200.0, 800.0, -300.0);
const float BR = 2300.0;

const float FACE = 50.0, LEGEND = 51.0, DUCT = 52.0, RELAY = 53.0, PLUG = 54.0, WIRE_BLUE = 55.0, WIRE_RED = 56.0;
const float FRAME = 58.0, PLATE = 59.0, GASKET = 61.0, WARN = 62.0, HANDLE = 63.0, SCREEN = 60.0;

const vec3 FN = vec3(0.0, 0.9063, 0.4226);
const vec3 FU = vec3(0.0, 0.4226, -0.9063);
const vec3 FO = vec3(0.0, 950.0, 0.0);
const vec3 ENC = vec3(-1250.0, 800.0, -470.0);
const vec3 BENCH = vec3(1350.0, 0.0, -300.0);

vec3 gDev = vec3(1e5);
float gKind = 0.0;
float gDevD = 1e9;
vec3 gStop = vec3(1e5);
float gStopD = 1e9;

void offerDevice(vec3 q, float kind) {
  float d = box(q - vec3(0.0, 0.0, 10.0), vec3(16.0, 16.0, 14.0));
  if (d < gDevD) {
    gDevD = d;
    gDev = q;
    gKind = kind;
  }
}

void offerStop(vec3 q) {
  float d = box(q - vec3(0.0, 0.0, 14.0), vec3(32.0, 32.0, 16.0));
  if (d < gStopD) {
    gStopD = d;
    gStop = q;
  }
}

vec3 toFace(vec3 p) {
  vec3 q = p - FO;
  return vec3(q.x, dot(q, FU), dot(q, FN));
}

vec2 opDevice(vec3 q, float kind) {
  float bezel = cylZ(q - vec3(0.0, 0.0, 3.5), 14.5, 3.5, 1.4);
  bezel = max(bezel, -cylZ(q - vec3(0.0, 0.0, 7.0), 11.6, 3.0, 0.0));
  vec2 r = vec2(bezel, CHROME);
  if (kind < 4.5) {
    float cap = cylZ(q - vec3(0.0, 0.0, 5.5), 11.0, 3.0, 1.6);
    cap = max(cap, -max(length(q - vec3(0.0, 0.0, 40.0)) - 32.0, -1.0));
    float id = kind < 0.5 ? GREEN : (kind < 1.5 ? RED : (kind < 2.5 ? BLUEP : (kind < 3.5 ? BLACK : WHITE)));
    r = U(r, vec2(cap, id));
  } else if (kind < 7.5) {
    float dome = max(length(q - vec3(0.0, 0.0, 1.0)) - 12.0, 5.0 - q.z);
    dome = min(dome, cylZ(q - vec3(0.0, 0.0, 5.0), 11.0, 3.0, 0.5));
    r = U(r, vec2(dome, kind < 5.5 ? LGREEN : (kind < 6.5 ? AMBER_OFF : RED_OFF)));
  } else {
    float knob = cylZ(q - vec3(0.0, 0.0, 9.0), 11.5, 4.0, 1.5);
    vec3 k = q - vec3(0.0, 0.0, 16.0);
    k.xy = rot(kind < 8.5 ? -0.65 : (kind < 9.5 ? 0.65 : 0.0)) * k.xy;
    knob = smin(knob, rbox(k, vec3(4.0, 13.0, 6.0), 2.5), 1.5);
    r = U(r, vec2(knob, BLACK));
  }
  return r;
}

vec2 duct(vec3 d, vec2 hs, float depth) {
  float body = box(d - vec3(0.0, 0.0, depth * 0.5), vec3(hs, depth * 0.5));
  float slots = max(abs(rep(d.x, 12.0)) - 2.6, max(hs.y - 3.0 - abs(d.y), max(4.0 - d.z, d.z - depth + 3.0)));
  body = max(body, -slots);
  float lid = rbox(d - vec3(0.0, 0.0, depth + 1.5), vec3(hs.x, hs.y + 1.5, 1.5), 1.0);
  return vec2(min(body, lid), DUCT);
}

vec2 idPlate(vec3 q, vec2 hs) {
  vec2 r = vec2(rbox(q, vec3(hs, 0.6), 1.5), PLATE);
  r = U(r, vec2(cylZ(vec3(abs(q.x) - hs.x + 5.0, abs(q.y) - hs.y + 5.0, q.z - 0.7), 1.5, 0.6, 0.4), STEEL));
  return r;
}

vec2 console(vec3 p) {
  float body = rbox(p - vec3(0.0, 540.0, 0.0), vec3(350.0, 540.0, 250.0), 10.0);
  body = smax(body, dot(p - FO, FN), 8.0);
  float slot = max(abs(box2(p.xy - vec2(0.0, 470.0), vec2(318.0, 335.0))) - 1.4, abs(p.z - 250.0) - 3.0);
  body = max(body, -slot);
  vec2 r = vec2(body, GREY);
  r = U(r, vec2(box(p - vec3(0.0, 45.0, 0.0), vec3(344.0, 45.0, 244.0)), DARK));
  vec3 hq = p - vec3(270.0, 560.0, 259.0);
  float handle = rbox(hq, vec3(12.0, 60.0, 8.0), 5.0);
  handle = min(handle, rbox(hq + vec3(0.0, 0.0, 5.0), vec3(18.0, 80.0, 4.0), 3.0));
  r = U(r, vec2(handle, BLACK));
  r = U(r, vec2(cylY(vec3(p.x + 322.0, abs(p.y - 470.0) - 240.0, p.z - 253.0), 6.0, 35.0, 2.0), DARK));
  r = U(r, idPlate(p - vec3(-200.0, 720.0, 251.0), vec2(45.0, 28.0)));
  vec3 f = toFace(p);
  r = U(r, vec2(rbox(f - vec3(0.0, 0.0, 0.5), vec3(318.0, 248.0, 2.0), 3.0), FACE));
  r = U(r, vec2(cylZ(vec3(abs(f.x) - 305.0, abs(f.y) - 235.0, f.z - 2.6), 3.2, 0.7, 0.5), STEEL));
  if (box(f - vec3(0.0, 0.0, 22.0), vec3(320.0, 250.0, 30.0)) < r.x) {
    r = U(r, hmiPanel(f - vec3(-140.0, 50.0, 10.5), vec2(150.0, 105.0), 40.0, 14.0, SCREEN));
    float cl = clamp(round((f.x - 225.0) / 60.0), -1.0, 1.0);
    vec3 lq = vec3(f.x - 225.0 - cl * 60.0, f.y - 10.0, f.z - 2.5);
    float cb = clamp(round((f.x + 25.0) / 75.0), -3.0, 3.0);
    vec3 bq = vec3(f.x + 25.0 - cb * 75.0, f.y + 150.0, f.z - 2.5);
    offerDevice(lq, 6.0 + cl);
    offerDevice(bq, cb < 0.5 ? cb + 3.0 : (cb < 2.5 ? cb + 7.0 : 4.0));
    offerStop(f - vec3(225.0, 130.0, 2.5));
    float tags = min(rbox(vec3(bq.x, bq.y + 30.0, bq.z - 0.4), vec3(20.0, 6.5, 0.6), 0.6), rbox(vec3(lq.x, lq.y + 30.0, lq.z - 0.4), vec3(20.0, 6.5, 0.6), 0.6));
    r = U(r, vec2(tags, LEGEND));
  }
  r = U(r, vec2(rbox(p - vec3(290.0, 1048.0, -212.0), vec3(34.0, 22.0, 34.0), 4.0), DARK));
  if (box(p - vec3(290.0, 1220.0, -212.0), vec3(40.0, 160.0, 40.0)) < r.x) r = U(r, towerLight(p - vec3(290.0, 1068.0, -212.0), 0.0));
  float conduit = capsule(p, vec3(-250.0, 20.0, -262.0), vec3(-250.0, 20.0, -900.0), 16.0);
  r = U(r, vec2(conduit, BLACK));
  return r;
}

vec2 safetyRelay(vec3 d) {
  vec2 r = vec2(rbox(d - vec3(0.0, 0.0, 57.0), vec3(11.0, 47.0, 57.0), 1.5), RELAY);
  r = U(r, vec2(rbox(d - vec3(0.0, 4.0, 113.6), vec3(9.6, 28.0, 1.2), 1.0), MGREY));
  float plugs = rbox(vec3(d.x, abs(d.y) - 52.0, d.z - 95.0), vec3(10.8, 8.0, 15.0), 1.5);
  plugs = max(plugs, -cylZ(vec3(d.x, abs(d.y) - 52.0, d.z - 111.0), 3.2, 2.0, 0.0));
  r = U(r, vec2(plugs, PLUG));
  r = U(r, vec2(cylZ(vec3(d.x, abs(d.y) - 52.0, d.z - 109.6), 2.4, 0.8, 0.3), STEEL));
  float cell = clamp(round((d.y - 20.0) / 8.0), -2.0, 0.0);
  float led = cylZ(vec3(d.x, d.y - 20.0 - cell * 8.0, d.z - 115.0), 1.8, 0.6, 0.4);
  r = U(r, vec2(led, cell > -1.5 ? LGREEN : GREEN_OFF));
  float knob = cylZ(d - vec3(0.0, -12.0, 115.4), 5.0, 1.6, 0.8);
  knob = max(knob, -box(d - vec3(0.0, -12.0, 117.0), vec3(0.6, 4.2, 0.8)));
  r = U(r, vec2(knob, MGREY));
  return r;
}

vec2 panelPlate(vec3 c) {
  vec2 r = vec2(box(c + vec3(0.0, 0.0, 2.0), vec3(278.0, 378.0, 2.0)), ZINC);
  if (box(c - vec3(0.0, 0.0, 31.0), vec3(278.0, 378.0, 32.0)) < r.x) {
    float hy = c.y > 212.0 ? c.y - 340.0 : (c.y > -42.0 ? c.y - 85.0 : (c.y > -255.0 ? c.y + 170.0 : c.y + 340.0));
    vec3 h = vec3(c.x, hy, c.z);
    vec3 v = vec3(c.y, abs(c.x) - 252.0, c.z);
    bool vert = box(v - vec3(0.0, 0.0, 31.0), vec3(375.0, 22.0, 32.0)) < box(h - vec3(0.0, 0.0, 31.0), vec3(226.0, 25.0, 32.0));
    r = U(r, duct(vert ? v : h, vert ? vec2(375.0, 22.0) : vec2(226.0, 25.0), 60.0));
  }
  float rail = c.y > 88.0 ? 0.0 : (c.y > -148.0 ? 1.0 : 2.0);
  vec3 rl = c - vec3(0.0, rail < 0.5 ? 215.0 : (rail < 1.5 ? -40.0 : -255.0), 0.0);
  if (box(rl - vec3(0.0, 0.0, 8.0), vec3(222.0, 18.0, 8.0)) < r.x) r = U(r, dinRail(rl, 444.0));
  vec3 u = rl - vec3(0.0, 0.0, 7.6);
  if (box(u - vec3(0.0, 0.0, 60.0), vec3(222.0, 60.0, 62.0)) < r.x) {
    float kind;
    vec3 m = u;
    if (rail < 0.5) {
      kind = u.x < -142.0 ? 0.0 : (u.x < -82.0 ? 1.0 : 2.0);
      m.x = kind < 0.5 ? repLim(u.x + 181.0, 23.0, -1.0, 1.0) : (kind < 1.5 ? u.x + 114.0 : repLim(u.x - 50.0, 50.0, -2.0, 1.0));
    } else if (rail < 1.5) {
      kind = u.x < -98.0 ? 0.0 : (u.x < 26.0 ? 2.0 : 1.0);
      m.x = kind < 0.5 ? repLim(u.x + 167.0, 23.0, -1.0, 2.0) : (kind < 1.5 ? repLim(u.x - 90.0, 18.0, -3.0, 3.0) : repLim(u.x + 20.0, 50.0, -1.0, 0.0));
    } else {
      kind = u.x < -132.0 ? 1.0 : 3.0;
      m.x = kind < 1.5 ? repLim(u.x + 186.0, 18.0, -1.0, 1.0) : u.x - 50.0;
    }
    if (kind < 0.5) r = U(r, safetyRelay(m));
    else if (kind < 1.5) r = U(r, mcb(m, rail < 0.5 ? 2.0 : 1.0, 1.0));
    else if (kind < 2.5) r = U(r, contactor(m));
    else r = U(r, terminalBlocks(m, 26.0, GREEN));
  }
  if (box(c - vec3(0.0, -40.0, 40.0), vec3(226.0, 210.0, 20.0)) < r.x) {
    float wa = capsule(vec3(repLim(c.x + 165.0, 23.0, -1.0, 6.0), c.y, c.z), vec3(0.0, 160.0, 36.0), vec3(0.0, 112.0, 36.0), 1.5);
    float wb = capsule(vec3(repLim(c.x + 140.0, 23.0, -1.0, 6.0), abs(c.y + 40.0), c.z), vec3(0.0, 52.0, 36.0), vec3(0.0, 102.0, 36.0), 1.5);
    float wc = capsule(vec3(repLim(c.x - 50.0, 12.4, -13.0, 13.0), c.y, c.z), vec3(0.0, -224.0, 32.0), vec3(0.0, -197.0, 32.0), 1.4);
    r = U(r, vec2(min(wa, wb), WIRE_RED));
    r = U(r, vec2(wc, WIRE_BLUE));
  }
  return r;
}

vec2 door(vec3 q) {
  float panel = rbox(q - vec3(300.0, 400.0, 12.0), vec3(300.0, 400.0, 12.0), 6.0);
  panel = max(panel, -box(q - vec3(300.0, 400.0, -2.0), vec3(282.0, 382.0, 12.0)));
  vec2 r = vec2(panel, GREY);
  float gasket = max(abs(box2(q.xy - vec2(300.0, 400.0), vec2(289.0, 389.0))) - 4.0, abs(q.z - 1.0) - 3.5);
  r = U(r, vec2(gasket, GASKET));
  float pocket = rbox(q - vec3(300.0, 430.0, 6.0), vec3(160.0, 130.0, 4.0), 3.0);
  pocket = max(pocket, -box(q - vec3(300.0, 595.0, 3.0), vec3(150.0, 50.0, 6.0)));
  r = U(r, vec2(pocket, BLACK));
  vec3 h = q - vec3(560.0, 400.0, 30.0);
  r = U(r, vec2(min(rbox(h, vec3(13.0, 60.0, 8.0), 5.0), rbox(h + vec3(0.0, 0.0, 4.0), vec3(18.0, 80.0, 4.0), 3.0)), BLACK));
  r = U(r, vec2(cylY(vec3(q.x, abs(q.y - 400.0) - 290.0, q.z - 20.0), 7.0, 35.0, 2.0), DARK));
  vec3 w = q - vec3(300.0, 640.0, 24.6);
  float tri = max(max(-w.y - 22.0, dot(w.xy, vec2(0.866, 0.5)) - 22.0), dot(w.xy, vec2(-0.866, 0.5)) - 22.0);
  r = U(r, vec2(max(tri, abs(w.z) - 0.6), WARN));
  r = U(r, idPlate(q - vec3(300.0, 120.0, 24.6), vec2(50.0, 30.0)));
  return r;
}

vec2 wallCabinet(vec3 q) {
  float outer = rbox(q - vec3(0.0, 400.0, 0.0), vec3(300.0, 400.0, 125.0), 8.0);
  float inner = box(q - vec3(0.0, 400.0, 25.0), vec3(286.0, 386.0, 130.0));
  vec2 r = vec2(max(outer, -inner), GREY);
  float lip = max(abs(box2(q.xy - vec2(0.0, 400.0), vec2(292.0, 392.0))) - 3.0, abs(q.z - 121.0) - 3.0);
  r = U(r, vec2(lip, BLACK));
  float glands = cylY(vec3(abs(q.x - 40.0) - 70.0, q.y + 8.0, q.z), 13.0, 9.0, 2.0);
  r = U(r, vec2(glands, BLACK));
  vec3 c = q - vec3(0.0, 400.0, -96.0);
  if (box(c - vec3(0.0, 0.0, 30.0), vec3(280.0, 380.0, 64.0)) < r.x) r = U(r, panelPlate(c));
  return r;
}

vec2 stand(vec3 s) {
  float posts = rbox(vec3(abs(s.x) - 230.0, s.y - 830.0, s.z + 150.0), vec3(25.0, 830.0, 30.0), 2.0);
  posts = max(posts, -box(vec3(abs(s.x) - 230.0, s.y - 830.0, s.z + 120.0), vec3(18.0, 840.0, 8.0)));
  float rails = rbox(vec3(s.x, abs(s.y - 1200.0) - 360.0, s.z + 140.0), vec3(260.0, 25.0, 15.0), 2.0);
  float feet = rbox(vec3(abs(s.x) - 230.0, s.y - 5.0, s.z + 120.0), vec3(50.0, 5.0, 220.0), 2.0);
  vec2 r = vec2(min(min(posts, rails), feet), FRAME);
  r = U(r, vec2(cylY(vec3(abs(s.x) - 230.0, s.y - 12.0, abs(s.z + 120.0) - 180.0), 9.0, 3.0, 1.0), ZINC));
  return r;
}

vec2 deviceBody(vec3 q) {
  vec2 r = vec2(rbox(q - vec3(0.0, 0.0, 13.0), vec3(15.0, 21.0, 13.0), 2.0), LGREY);
  r = U(r, vec2(cylX(vec3(abs(q.x) - 15.4, abs(q.y) - 11.0, q.z - 13.0), 2.6, 0.8, 0.3), STEEL));
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, 31.0), vec3(16.0, 16.0, 5.0), 2.0), BLACK));
  r = U(r, vec2(cylZ(q - vec3(0.0, 0.0, 42.0), 11.0, 7.0, 0.5), BLACK));
  return r;
}

vec2 benchItems(vec3 b) {
  vec2 r = vec2(0.7 * BR, -1.0);
  vec3 e = b - vec3(-250.0, 900.0, -60.0);
  e.xz = rot(0.3) * e.xz;
  if (box(e - vec3(0.0, 40.0, 0.0), vec3(50.0, 42.0, 70.0)) < r.x) {
    r = U(r, vec2(rbox(e - vec3(0.0, 40.0, 0.0), vec3(44.0, 40.0, 44.0), 7.0), YELLOW));
    r = U(r, vec2(cylZ(vec3(e.x, e.y - 28.0, e.z - 47.0), 9.0, 6.0, 2.0), BLACK));
  }
  offerStop(vec3(e.x, -e.z, e.y - 80.0));
  float c = capsule(e, vec3(0.0, 28.0, 56.0), vec3(0.0, 22.0, 90.0), 4.4);
  c = min(c, capsule(e, vec3(0.0, 22.0, 90.0), vec3(-30.0, 4.4, 150.0), 4.4));
  c = min(c, capsule(e, vec3(-30.0, 4.4, 150.0), vec3(-160.0, 4.4, 230.0), 4.4));
  c = min(c, capsule(e, vec3(-160.0, 4.4, 230.0), vec3(-260.0, 4.4, 250.0), 4.4));
  r = U(r, vec2(c, CABLE));
  vec3 k = b - vec3(120.0, 900.0, -40.0);
  k.xz = rot(-0.18) * k.xz;
  vec3 kb = vec3(k.x, -k.z, k.y);
  if (box(kb - vec3(0.0, 0.0, 38.0), vec3(48.0, 112.0, 40.0)) < r.x) {
    float shell = rbox(kb - vec3(0.0, 0.0, 36.0), vec3(42.0, 105.0, 36.0), 5.0);
    shell = max(shell, -rbox(kb - vec3(0.0, 0.0, 30.0), vec3(38.0, 101.0, 36.0), 3.0));
    shell = max(shell, -cylZ(vec3(kb.x, repLim(kb.y, 65.0, -1.0, 1.0), kb.z - 70.0), 11.2, 4.0, 0.0));
    r = U(r, vec2(shell, LGREY));
    r = U(r, vec2(cylZ(vec3(abs(kb.x) - 34.0, abs(kb.y) - 97.0, kb.z - 72.2), 2.4, 0.6, 0.4), STEEL));
  }
  vec3 fq = kb - vec3(0.0, clamp(round(kb.y / 65.0), 0.0, 1.0) * 65.0, 72.0);
  offerDevice(fq, kb.y > 32.5 ? 1.0 : 0.0);
  float best = 1e9;
  float pick = 0.0;
  for (int i = uZero; i < 3; i++) {
    vec3 pos = i == 0 ? vec3(-60.0, 900.0, 140.0) : (i == 1 ? vec3(30.0, 900.0, 170.0) : vec3(-140.0, 900.0, 160.0));
    float dd = length(b.xz - pos.xz);
    if (dd < best) {
      best = dd;
      pick = float(i);
    }
  }
  vec3 pos = pick < 0.5 ? vec3(-60.0, 900.0, 140.0) : (pick < 1.5 ? vec3(30.0, 900.0, 170.0) : vec3(-140.0, 900.0, 160.0));
  vec3 q = b - pos;
  q.xz = rot(0.5 + pick * 1.3) * q.xz;
  q = vec3(q.x, -q.z, q.y);
  if (box(q - vec3(0.0, 0.0, 30.0), vec3(26.0, 26.0, 32.0)) < r.x) r = U(r, deviceBody(q));
  offerDevice(q - vec3(0.0, 0.0, 49.0), pick < 0.5 ? 5.0 : (pick < 1.5 ? 10.0 : 2.0));
  vec3 sd = b - vec3(230.0, 911.0, 120.0);
  sd.xz = rot(0.7) * sd.xz;
  float handle = rbox(sd - vec3(-40.0, 0.0, 0.0), vec3(45.0, 10.0, 10.0), 8.0);
  float shaft = cylX(sd - vec3(45.0, 0.0, 0.0), 3.0, 45.0, 0.5);
  r = U(r, vec2(handle, HANDLE));
  r = U(r, vec2(shaft, CHROME));
  vec3 t = b - vec3(260.0, 900.6, -150.0);
  t.xz = rot(0.2) * t.xz;
  vec3 t2 = vec3(t.x, t.y, abs(t.z - 6.0) - 6.0);
  float ties = min(rbox(t2, vec3(80.0, 0.6, 2.0), 0.5), rbox(t2 - vec3(-82.0, 1.5, 0.0), vec3(3.5, 2.2, 3.0), 1.0));
  r = U(r, vec2(ties, WHITE));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  gDevD = 1e9;
  gStopD = 1e9;
  if (box(p - vec3(0.0, 700.0, -300.0), vec3(360.0, 700.0, 620.0)) < r.x) r = U(r, console(p));
  vec3 s = p - vec3(ENC.x, 0.0, ENC.z);
  if (box(s - vec3(0.0, 830.0, -100.0), vec3(320.0, 840.0, 260.0)) < r.x) r = U(r, stand(s));
  vec3 q = p - ENC;
  if (box(q - vec3(0.0, 400.0, 0.0), vec3(316.0, 420.0, 130.0)) < r.x) r = U(r, wallCabinet(q));
  vec3 dq = p - (ENC + vec3(-300.0, 0.0, 125.0));
  dq.xz = rot(-1.92) * dq.xz;
  if (box(dq - vec3(300.0, 400.0, 18.0), vec3(306.0, 406.0, 30.0)) < r.x) r = U(r, door(dq));
  float cab = capsule(p, ENC + vec3(-30.0, -18.0, 0.0), ENC + vec3(-30.0, -500.0, 10.0), 7.0);
  cab = min(cab, capsule(p, ENC + vec3(-30.0, -500.0, 10.0), ENC + vec3(-30.0, -793.0, 120.0), 7.0));
  cab = min(cab, capsule(p, ENC + vec3(110.0, -18.0, 0.0), ENC + vec3(110.0, -560.0, 10.0), 7.0));
  cab = min(cab, capsule(p, ENC + vec3(110.0, -560.0, 10.0), ENC + vec3(160.0, -793.0, 200.0), 7.0));
  r = U(r, vec2(cab, CABLE));
  vec3 b = p - BENCH;
  if (box(b - vec3(0.0, 800.0, 0.0), vec3(755.0, 800.0, 380.0)) < r.x) r = U(r, workbench(b, vec3(1500.0, 900.0, 750.0)));
  if (box(b - vec3(0.0, 960.0, 0.0), vec3(420.0, 70.0, 300.0)) < r.x) r = U(r, benchItems(b));
  if (gDevD < r.x) r = U(r, opDevice(gDev, gKind));
  if (gStopD < r.x) r = U(r, estop(gStop));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == SCREEN) {
    vec3 f = toFace(p);
    vec2 uv = (f.xy - vec2(-140.0 - 136.0, 50.0 - 91.0)) / vec2(272.0, 182.0);
    return screen(screenHmi(uv, 7.0));
  }
  if (id == FACE) return mat(vec3(0.05, 0.053, 0.058), 0.4, 0.0);
  if (id == LEGEND) return mat(vec3(0.72, 0.72, 0.7), 0.45, 0.0);
  if (id == DUCT) return mat(vec3(0.48, 0.49, 0.48), 0.42, 0.0);
  if (id == RELAY) return mat(vec3(0.86, 0.6, 0.02), 0.38, 0.0);
  if (id == PLUG) return mat(vec3(0.03), 0.45, 0.0);
  if (id == WIRE_BLUE) return mat(vec3(0.02, 0.06, 0.3), 0.35, 0.0);
  if (id == WIRE_RED) return mat(vec3(0.4, 0.02, 0.02), 0.35, 0.0);
  if (id == ZINC) return mat(vec3(0.66, 0.68, 0.7) * (0.92 + 0.12 * fbm(p * 0.03)), 0.62, 1.0);
  if (id == FRAME) return mat(vec3(0.06, 0.065, 0.07), 0.5, 0.0);
  if (id == PLATE) return mat(vec3(0.78, 0.79, 0.8), 0.36 + 0.06 * vnoise(p * vec3(0.4, 0.02, 0.02)), 1.0);
  if (id == GASKET) return mat(vec3(0.015), 0.6, 0.0);
  if (id == WARN) return mat(vec3(0.85, 0.6, 0.02), 0.4, 0.0);
  if (id == HANDLE) return mat(vec3(0.5, 0.03, 0.02), 0.3, 0.0);
  return libMat(id, p, n);
}
