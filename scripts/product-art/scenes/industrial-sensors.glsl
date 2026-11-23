const vec3 BC = vec3(0.0, 760.0, -40.0);
const float BR = 1150.0;

const float PBT = 50.0, PBT_FACE = 51.0, NUT_PLASTIC = 52.0, LENS = 53.0, FACE_BLUE = 54.0;

float thread(vec3 p, float r0, float depth, float pitch, float x0, float x1) {
  float a = atan(p.z, p.y) / (2.0 * PI);
  float t = abs(fract(p.x / pitch + a) - 0.5) * 2.0;
  float r = r0 + depth * smoothstep(0.15, 0.85, t);
  return max((length(p.yz) - r) * 0.7, max(x0 - p.x, p.x - x1));
}

bool show(float v) { return uVariant < 0.5 || abs(uVariant - v) < 0.5; }

vec3 toM18(vec3 p) { return p - vec3(0.0, 11.9, 0.0); }

vec3 toM30(vec3 p) {
  vec3 q = p - vec3(52.0, 17.9, -96.0);
  q.xz = rot(-0.38) * q.xz;
  return q;
}

vec3 toPhoto(vec3 p) {
  vec3 q = p - vec3(-92.0, 0.0, -72.0);
  q.xz = rot(0.42) * q.xz;
  return q;
}

vec2 capacitive(vec3 p) {
  vec2 r = vec2(thread(p, 14.2, 0.75, 1.5, -30.0, 31.0), PBT);
  r = U(r, vec2(cylX(p - vec3(33.5, 0.0, 0.0), 14.6, 3.2, 2.6), PBT_FACE));
  float n1 = hexZ(vec3(p.z, p.y, p.x - 14.0), 17.9, 2.8, 1.06);
  float n2 = hexZ(vec3(p.z, p.y, p.x + 16.0), 17.9, 2.8, 1.06);
  r = U(r, vec2(min(n1, n2) - 0.15, NUT_PLASTIC));
  r = U(r, vec2(cylX(p + vec3(36.0, 0.0, 0.0), 14.6, 6.0, 1.0), PBT));
  r = U(r, vec2(cylX(p + vec3(42.4, 0.0, 0.0), 14.9, 0.7, 0.3), LAMBER));
  float back = cylX(p + vec3(47.5, 0.0, 0.0), 13.2, 4.5, 2.0);
  back = max(back, -cylX(p + vec3(52.0, -6.5, 0.0), 2.8, 1.2, 0.0));
  r = U(r, vec2(back, BLACK));
  float pot = cylX(p + vec3(51.5, -6.5, 0.0), 2.3, 0.6, 0.3);
  pot = max(pot, -box(p + vec3(52.4, -6.5, 0.0), vec3(0.8, 0.45, 2.6)));
  r = U(r, vec2(pot, BRASS));
  float rel = max((length(p.yz) - mix(6.0, 4.0, clamp((-52.0 - p.x) / 12.0, 0.0, 1.0))) * 0.9, max(p.x + 51.5, -64.0 - p.x));
  r = U(r, vec2(rel, BLACK));
  return r;
}

vec2 photoSensor(vec3 p) {
  vec3 q = p - vec3(0.0, 46.0, 0.0);
  float body = rbox(q, vec3(10.0, 25.0, 16.0), 2.6);
  body = max(body, -cylX(vec3(q.x, abs(q.y + 4.0) - 12.0, q.z + 6.0), 1.7, 12.0, 0.0));
  vec2 r = vec2(body, MGREY);
  float front = rbox(q - vec3(0.0, 0.0, 15.0), vec3(10.4, 25.4, 2.6), 2.4);
  r = U(r, vec2(front, BLACK));
  float lens = rbox(q - vec3(0.0, 6.0, 17.2), vec3(7.4, 13.5, 0.9), 2.0);
  r = U(r, vec2(lens, LENS));
  r = U(r, vec2(cylY(q - vec3(-4.6, 25.2, -8.0), 1.8, 0.7, 0.4), LAMBER));
  r = U(r, vec2(cylY(q - vec3(4.6, 25.2, -8.0), 1.8, 0.7, 0.4), LGREEN));
  float pot = cylY(q - vec3(0.0, 25.4, 3.0), 2.6, 0.7, 0.3);
  pot = max(pot, -box(q - vec3(0.0, 26.0, 3.0), vec3(2.8, 0.6, 0.4)));
  r = U(r, vec2(pot, WHITE));
  float m8 = cylY(p - vec3(0.0, 17.0, -4.0), 4.0, 5.0, 0.6);
  float knurl = cylY(p - vec3(0.0, 9.0, -4.0), 5.2, 4.0, 0.8) + 0.25 * step(0.0, sin(atan(p.z + 4.0, p.x) * 18.0));
  r = U(r, vec2(min(m8, knurl), STEEL));
  float plate = box(vec3(q.x + 11.6, q.y + 8.0, q.z + 2.0), vec3(1.2, 36.0, 17.0));
  plate = max(plate, -cylX(vec3(q.x + 11.6, abs(q.y + 4.0) - 12.0, q.z + 6.0), 2.2, 3.0, 0.0));
  float foot = box(vec3(q.x + 34.0, p.y - 1.2, q.z + 2.0), vec3(23.6, 1.2, 17.0));
  foot = max(foot, -rbox(vec3(q.x + 38.0, p.y - 1.2, q.z + 2.0), vec3(9.0, 3.0, 3.0), 2.9));
  float bend = max(length(vec2(q.x + 10.4, p.y - 2.4 - 0.0)) - 2.4, max(abs(q.z + 2.0) - 17.0, q.x + 10.4));
  r = U(r, vec2(min(min(plate, foot), bend) - 0.2, ZINC));
  float screws = cylX(vec3(q.x - 10.8, abs(q.y + 4.0) - 12.0, q.z + 6.0), 3.0, 1.2, 0.6);
  screws = max(screws, -box(vec3(q.x - 12.0, abs(q.y + 4.0) - 12.0, q.z + 6.0), vec3(0.6, 0.5, 3.2)));
  r = U(r, vec2(screws, STEEL));
  return r;
}

vec2 sceneMap(vec3 world) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(world - vec3(0.0, 800.0, -20.0), vec3(760.0, 820.0, 400.0)) < r.x) r = U(r, workbench(world - vec3(0.0, 0.0, -20.0), vec3(1500.0, 900.0, 750.0)));
  vec3 p = world - vec3(0.0, 900.0, 0.0);
  if (show(1.0)) {
    vec3 a = toM18(p);
    if (box(a + vec3(10.0, 0.0, 0.0), vec3(56.0, 14.0, 14.0)) < r.x) r = U(r, sensorM18(a, FACE_BLUE));
    float c1 = capsule(a, vec3(-52.0, 0.0, 0.0), vec3(-62.0, -1.2, 0.6), 2.6);
    c1 = smin(c1, capsule(a, vec3(-62.0, -1.2, 0.6), vec3(-73.0, -4.8, 5.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-73.0, -4.8, 5.0), vec3(-83.0, -8.4, 14.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-83.0, -8.4, 14.0), vec3(-89.0, -9.3, 29.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-89.0, -9.3, 29.0), vec3(-89.0, -9.3, 50.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-89.0, -9.3, 50.0), vec3(-82.0, -9.3, 70.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-82.0, -9.3, 70.0), vec3(-66.0, -9.3, 92.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-66.0, -9.3, 92.0), vec3(-30.0, -9.3, 150.0), 2.6), 1.2);
    c1 = smin(c1, capsule(a, vec3(-30.0, -9.3, 150.0), vec3(40.0, -9.3, 290.0), 2.6), 1.2);
    r = U(r, vec2(c1, CABLE));
  }
  if (show(3.0)) {
    vec3 b = toM30(p);
    if (box(b + vec3(14.0, 0.0, 0.0), vec3(54.0, 21.0, 21.0)) < r.x) r = U(r, capacitive(b));
    float c2 = capsule(b, vec3(-63.0, 0.0, 0.0), vec3(-74.0, -2.0, -1.0), 3.2);
    c2 = smin(c2, capsule(b, vec3(-74.0, -2.0, -1.0), vec3(-88.0, -9.0, -6.0), 3.2), 1.5);
    c2 = smin(c2, capsule(b, vec3(-88.0, -9.0, -6.0), vec3(-102.0, -14.7, -16.0), 3.2), 1.5);
    c2 = smin(c2, capsule(b, vec3(-102.0, -14.7, -16.0), vec3(-118.0, -14.7, -40.0), 3.2), 1.5);
    c2 = smin(c2, capsule(b, vec3(-118.0, -14.7, -40.0), vec3(-122.0, -14.7, -80.0), 3.2), 1.5);
    c2 = smin(c2, capsule(b, vec3(-122.0, -14.7, -80.0), vec3(-100.0, -14.7, -200.0), 3.2), 1.5);
    r = U(r, vec2(c2, CABLE));
  }
  if (show(2.0)) {
    vec3 c = toPhoto(p);
    if (box(c - vec3(-14.0, 38.0, 0.0), vec3(48.0, 40.0, 22.0)) < r.x) r = U(r, photoSensor(c));
    float c3 = capsule(c, vec3(0.0, 5.0, -4.0), vec3(0.0, 2.6, -14.0), 2.4);
    c3 = smin(c3, capsule(c, vec3(0.0, 2.6, -14.0), vec3(6.0, 2.4, -40.0), 2.4), 1.2);
    c3 = smin(c3, capsule(c, vec3(6.0, 2.4, -40.0), vec3(30.0, 2.4, -70.0), 2.4), 1.2);
    c3 = smin(c3, capsule(c, vec3(30.0, 2.4, -70.0), vec3(70.0, 2.4, -90.0), 2.4), 1.2);
    c3 = smin(c3, capsule(c, vec3(70.0, 2.4, -90.0), vec3(120.0, 2.4, -112.0), 2.4), 1.2);
    c3 = smin(c3, capsule(c, vec3(120.0, 2.4, -112.0), vec3(185.0, 2.4, -150.0), 2.4), 1.2);
    c3 = smin(c3, capsule(c, vec3(185.0, 2.4, -150.0), vec3(300.0, 2.4, -168.0), 2.4), 1.2);
    c3 = min(c3, cylY(c - vec3(0.0, 4.0, -4.0), 3.6, 2.0, 0.8));
    r = U(r, vec2(c3, CABLE));
  }
  return r;
}

Mat sceneMat(float id, vec3 world, vec3 n) {
  vec3 p = world - vec3(0.0, 900.0, 0.0);
  if (id == PBT) return mat(vec3(0.15, 0.155, 0.16), 0.42, 0.0);
  if (id == PBT_FACE) return mat(vec3(0.34, 0.2, 0.05), 0.45, 0.0);
  if (id == NUT_PLASTIC) return mat(vec3(0.03), 0.4, 0.0);
  if (id == LENS) return mat(vec3(0.02, 0.006, 0.006), 0.04, 0.0);
  if (id == FACE_BLUE) return mat(vec3(0.07, 0.1, 0.17), 0.42, 0.0);
  return libMat(id, p, n);
}
