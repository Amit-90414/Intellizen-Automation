const vec3 BC = vec3(300.0, 900.0, -100.0);
const float BR = 3300.0;

const float A1 = -0.08, A2 = 0.32, A3 = 0.12, A5 = -0.44;

vec2 cartonStack(vec3 p) {
  vec2 r = pallet(p);
  vec3 q = p - vec3(0.0, 144.0, 0.0);
  float z = q.z - 201.0 - 402.0 * clamp(round((q.z - 201.0) / 402.0), -1.0, 0.0);
  float layer = clamp(round((q.y - 131.0) / 262.0), 0.0, 1.0);
  r = U(r, carton(vec3(repLim(q.x, 402.0, -1.0, 1.0), q.y - layer * 262.0, z), vec3(199.0, 130.0, 199.0)));
  r = U(r, carton(vec3(q.x - 402.0 * clamp(round(q.x / 402.0), -1.0, 0.0), q.y - 524.0, z), vec3(199.0, 130.0, 199.0)));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  float ped = rbox(p - vec3(0.0, 200.0, 0.0), vec3(300.0, 200.0, 300.0), 8.0);
  r = U(r, vec2(ped, MGREY));
  vec3 rp = p - vec3(0.0, 400.0, 0.0);
  if (length(rp - vec3(250.0, 700.0, 0.0)) - 1150.0 < r.x) r = U(r, robotArm(rp, A1, A2, A3, A5, 0.0));
  vec3 held = p - vec3(915.0, 806.0, 10.0);
  if (box(held - vec3(0.0, 140.0, 0.0), vec3(210.0, 150.0, 160.0)) < r.x) r = U(r, carton(held, vec3(200.0, 130.0, 150.0)));
  vec3 cp = p - vec3(1700.0, 0.0, 0.0);
  if (box(cp - vec3(0.0, 380.0, 0.0), vec3(1020.0, 400.0, 300.0)) < r.x) r = U(r, beltConveyor(cp, 2000.0, 500.0, 750.0, BELT));
  vec3 bp = vec3(repLim(p.x - 1550.0, 560.0, 0.0, 1.0), p.y - 750.0, p.z - 10.0);
  if (box(bp - vec3(0.0, 140.0, 0.0), vec3(210.0, 150.0, 160.0)) < r.x) r = U(r, carton(bp, vec3(200.0, 130.0, 150.0)));
  vec3 sp = p - vec3(-1150.0, 0.0, 250.0);
  if (box(sp - vec3(0.0, 450.0, 0.0), vec3(610.0, 460.0, 410.0)) < r.x) r = U(r, cartonStack(sp));
  vec3 fb = vec3(repLim(p.x + 700.0, 1260.0, -1.0, 1.0), p.y, p.z + 1350.0);
  if (box(fb - vec3(0.0, 1000.0, 0.0), vec3(700.0, 1010.0, 60.0)) < r.x) r = U(r, fencePanel(fb, 1200.0, 2000.0));
  vec3 fs = vec3(repLim(p.z + 720.0, 1260.0, 0.0, 1.0), p.y, p.x + 1960.0);
  if (box(fs - vec3(0.0, 1000.0, 0.0), vec3(700.0, 1010.0, 60.0)) < r.x) r = U(r, fencePanel(fs, 1200.0, 2000.0));
  vec3 kp = p - vec3(1950.0, 0.0, -1200.0);
  if (box(kp - vec3(0.0, 1150.0, 0.0), vec3(420.0, 1160.0, 280.0)) < r.x) {
    r = U(r, cabinet(kp, vec3(800.0, 2000.0, 500.0)));
    r = U(r, towerLight(kp - vec3(280.0, 2000.0, 0.0), 0.0));
    r = U(r, hmiPanel(kp - vec3(-140.0, 1350.0, 254.0), vec2(160.0, 115.0), 40.0, 16.0, 60.0));
  }
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == 60.0) {
    vec2 uv = (p.xy - vec2(1950.0 - 140.0 - 144.0, 1350.0 - 99.0)) / vec2(288.0, 198.0);
    return screen(screenHmi(uv, 3.0));
  }
  return libMat(id, p, n);
}
