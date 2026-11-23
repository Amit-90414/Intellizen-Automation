const vec3 BC = vec3(1000.0, 900.0, -200.0);
const float BR = 4200.0;

const float A1 = -2.598, A2 = 0.2, A3 = 0.091, A5 = -0.291;
const float RING = 60.0, SCREEN_HMI = 61.0;

vec2 palletLoad(vec3 p) {
  vec2 r = pallet(p);
  vec3 q = p - vec3(0.0, 144.0, 0.0);
  float z = q.z - 201.0 - 402.0 * clamp(round((q.z - 201.0) / 402.0), -1.0, 0.0);
  float layer = clamp(round((q.y - 131.0) / 262.0), 0.0, 1.0);
  r = U(r, carton(vec3(repLim(q.x, 402.0, -1.0, 1.0), q.y - layer * 262.0, z), vec3(199.0, 130.0, 199.0)));
  r = U(r, carton(vec3(q.x - 402.0 * clamp(round(q.x / 402.0), -1.0, 0.0), q.y - 524.0, z), vec3(199.0, 130.0, 199.0)));
  return r;
}

vec2 visionGantry(vec3 p) {
  float posts = rbox(vec3(p.x, p.y - 780.0, abs(p.z) - 400.0), vec3(25.0, 780.0, 25.0), 2.0);
  float feet = rbox(vec3(p.x, p.y - 5.0, abs(p.z) - 400.0), vec3(70.0, 5.0, 70.0), 2.0);
  float beam = rbox(p - vec3(0.0, 1530.0, 0.0), vec3(30.0, 30.0, 445.0), 2.0);
  beam = max(beam, -box(vec3(abs(p.x) - 30.0, p.y - 1530.0, p.z), vec3(3.0, 4.0, 446.0)));
  vec2 r = vec2(min(min(posts, beam), feet), ALU);
  float brackets = rbox(vec3(p.x, p.y - 1530.0, abs(p.z) - 400.0), vec3(40.0, 40.0, 40.0), 3.0);
  r = U(r, vec2(brackets, MGREY));
  float plate = rbox(p - vec3(0.0, 1440.0, 0.0), vec3(40.0, 60.0, 4.0), 2.0);
  r = U(r, vec2(plate, MGREY));
  vec3 c = p - vec3(0.0, 1390.0, 34.0);
  float body = rbox(c, vec3(29.0, 45.0, 29.0), 3.0);
  float fins = max(abs(rep(c.y, 8.0)) - 2.0, box(c, vec3(31.0, 30.0, 31.0)));
  body = min(body, fins);
  r = U(r, vec2(body, DARK));
  float lens = cylY(c + vec3(0.0, 62.0, 0.0), 20.0, 18.0, 2.0);
  r = U(r, vec2(lens, BLACK));
  float lensRing = cylY(c + vec3(0.0, 72.0, 0.0), 21.0, 3.0, 1.0);
  r = U(r, vec2(lensRing, CHROME));
  float ring = cylY(c + vec3(0.0, 120.0, 0.0), 95.0, 14.0, 4.0);
  ring = max(ring, -cylY(c + vec3(0.0, 120.0, 0.0), 42.0, 20.0, 0.0));
  r = U(r, vec2(ring, DARK));
  float diffuser = max(cylY(c + vec3(0.0, 134.6, 0.0), 88.0, 1.0, 0.5), -cylY(c + vec3(0.0, 134.6, 0.0), 48.0, 3.0, 0.0));
  r = U(r, vec2(diffuser, RING));
  float arms = rbox(vec3(abs(c.x) - 70.0, c.y + 90.0, c.z), vec3(5.0, 32.0, 10.0), 2.0);
  r = U(r, vec2(arms, MGREY));
  float wire = capsule(p, vec3(0.0, 1435.0, 34.0 - 30.0), vec3(0.0, 1490.0, -10.0), 4.5);
  wire = min(wire, capsule(p, vec3(0.0, 1490.0, -10.0), vec3(0.0, 1500.0, -380.0), 4.5));
  wire = min(wire, capsule(p, vec3(0.0, 1500.0, -380.0), vec3(-36.0, 1300.0, -400.0), 4.5));
  r = U(r, vec2(wire, CABLE));
  return r;
}

vec2 filterFan(vec3 p) {
  float frame = rbox(p - vec3(0.0, 0.0, 6.0), vec3(105.0, 105.0, 6.0), 4.0);
  frame = max(frame, -box(p - vec3(0.0, 0.0, 12.0), vec3(88.0, 88.0, 4.0)));
  float louvers = max(rbox(vec3(p.x, rep(p.y, 14.0), p.z - 6.0), vec3(88.0, 2.0, 5.0), 1.0), abs(p.y) - 88.0);
  return vec2(min(frame, louvers), LGREY);
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  float ped = rbox(p - vec3(0.0, 200.0, 0.0), vec3(300.0, 200.0, 300.0), 8.0);
  r = U(r, vec2(ped, MGREY));
  vec3 rp = p - vec3(0.0, 400.0, 0.0);
  if (length(rp - vec3(-250.0, 700.0, 150.0)) - 1150.0 < r.x) r = U(r, robotArm(rp, A1, A2, A3, A5, 0.0));
  vec3 held = p - vec3(-752.0, 900.0, 452.0);
  held.xz = rot(A1) * held.xz;
  if (box(held - vec3(0.0, 140.0, 0.0), vec3(210.0, 150.0, 210.0)) < r.x) r = U(r, carton(held, vec3(199.0, 130.0, 199.0)));
  vec3 cp = p - vec3(2250.0, 0.0, 0.0);
  if (box(cp - vec3(0.0, 380.0, 0.0), vec3(1520.0, 400.0, 300.0)) < r.x) r = U(r, beltConveyor(cp, 3000.0, 500.0, 750.0, BELT));
  vec3 bp = vec3(repLim(p.x - 1550.0, 680.0, 0.0, 3.0), p.y - 750.0, p.z - 10.0);
  if (box(bp - vec3(0.0, 140.0, 0.0), vec3(210.0, 150.0, 160.0)) < r.x) r = U(r, carton(bp, vec3(200.0, 130.0, 150.0)));
  vec3 gp = p - vec3(2910.0, 0.0, 0.0);
  if (box(gp - vec3(0.0, 800.0, 0.0), vec3(110.0, 800.0, 480.0)) < r.x) r = U(r, visionGantry(gp));
  vec3 sp = p - vec3(-1150.0, 0.0, 250.0);
  if (box(sp - vec3(0.0, 450.0, 0.0), vec3(610.0, 460.0, 410.0)) < r.x) r = U(r, palletLoad(sp));
  vec3 fb = vec3(repLim(p.x + 700.0, 1260.0, -1.0, 1.0), p.y, p.z + 1350.0);
  if (box(fb - vec3(0.0, 1000.0, 0.0), vec3(700.0, 1010.0, 60.0)) < r.x) r = U(r, fencePanel(fb, 1200.0, 2000.0));
  vec3 fs = vec3(repLim(p.z + 720.0, 1260.0, 0.0, 1.0), p.y, p.x + 1960.0);
  if (box(fs - vec3(0.0, 1000.0, 0.0), vec3(700.0, 1010.0, 60.0)) < r.x) r = U(r, fencePanel(fs, 1200.0, 2000.0));
  vec3 kp = p - vec3(2050.0, 0.0, -1150.0);
  if (box(kp - vec3(0.0, 1150.0, 0.0), vec3(620.0, 1160.0, 280.0)) < r.x) {
    r = U(r, cabinet(vec3(kp.x + 300.0, kp.yz), vec3(600.0, 2000.0, 500.0)));
    r = U(r, cabinet(vec3(kp.x - 300.0, kp.yz), vec3(600.0, 2000.0, 500.0)));
    r = U(r, towerLight(kp - vec3(450.0, 2000.0, 0.0), 0.0));
    r = U(r, hmiPanel(kp - vec3(-300.0, 1350.0, 254.0), vec2(160.0, 115.0), 40.0, 16.0, SCREEN_HMI));
    r = U(r, estop(kp - vec3(-300.0, 1130.0, 254.0)));
    r = U(r, pushButton(kp - vec3(-380.0, 1130.0, 254.0), GREEN));
    r = U(r, pushButton(kp - vec3(-220.0, 1130.0, 254.0), BLACK));
    r = U(r, filterFan(kp - vec3(300.0, 420.0, 254.0)));
    r = U(r, filterFan(kp - vec3(-300.0, 420.0, 254.0)));
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == RING) return glow(vec3(0.9), 0.2, vec3(3.2, 3.3, 3.4));
  if (id == SCREEN_HMI) {
    vec2 uv = (p.xy - vec2(2050.0 - 300.0 - 144.0, 1350.0 - 99.0)) / vec2(288.0, 198.0);
    return screen(screenHmi(uv, 5.0));
  }
  return libMat(id, p, n);
}
