const vec3 BC = vec3(450.0, 1300.0, 0.0);
const float BR = 2600.0;

const float OLD = 50.0, SCREEN = 51.0, PLATE_ID = 52.0, CONDUIT = 53.0, DIE = 54.0, SCREEN2 = 55.0;
const float HMI_ANGLE = 0.42;
const vec3 HMI_AT = vec3(-640.0, 1430.0, 470.0);

float triangle2(vec2 p, float r) {
  const float k = 1.7320508;
  p.x = abs(p.x) - r;
  p.y = p.y + r / k;
  if (p.x + k * p.y > 0.0) p = vec2(p.x - k * p.y, -k * p.x - p.y) / 2.0;
  p.x -= clamp(p.x, -2.0 * r, 0.0);
  return -length(p) * sign(p.y);
}

vec2 warning(vec3 q, float r) {
  float outer = max(triangle2(q.xy, r) - 3.0, abs(q.z - 0.3) - 0.3);
  vec2 res = vec2(outer, BLACK);
  float inner = max(triangle2(q.xy, r * 0.78) - 2.0, abs(q.z - 0.5) - 0.5);
  res = U(res, vec2(inner, YELLOW));
  float bar = rbox(vec3(q.x, q.y + r * 0.02, q.z - 0.6), vec3(r * 0.06, r * 0.22, 0.6), r * 0.05);
  float dot2 = max(length(q.xy + vec2(0.0, r * 0.36)) - r * 0.07, abs(q.z - 0.6) - 0.6);
  res = U(res, vec2(min(bar, dot2), BLACK));
  return res;
}

vec2 idPlate(vec3 q, vec2 hs) {
  vec2 r = vec2(rbox(q, vec3(hs, 0.8), 0.6), PLATE_ID);
  r = U(r, vec2(cylZ(vec3(abs(q.x) - hs.x + 7.0, abs(q.y) - hs.y + 7.0, q.z - 0.8), 2.4, 0.8, 0.6), STEEL));
  return r;
}

vec2 oldPress(vec3 p) {
  vec2 outer = vec2(p.z + 200.0, p.y - 1200.0);
  float c = box2(outer, vec2(460.0, 1160.0)) - 40.0;
  float throat = box2(vec2(p.z - 150.0, p.y - 1220.0), vec2(330.0, 190.0)) - 90.0;
  c = max(c, -throat);
  vec2 d = vec2(c + 10.0, abs(p.x) - 290.0);
  float body = min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - 10.0;
  float rib = rbox(vec3(abs(p.x) - 300.0, p.y - 1250.0, p.z + 520.0), vec3(18.0, 1050.0, 60.0), 8.0);
  body = min(body, rib);
  body = min(body, rbox(p - vec3(0.0, 60.0, -200.0), vec3(360.0, 60.0, 540.0), 10.0));
  vec2 r = vec2(body, OLD);
  r = U(r, vec2(rbox(p - vec3(0.0, 965.0, 20.0), vec3(280.0, 25.0, 270.0), 3.0), STEEL));
  r = U(r, vec2(rbox(p - vec3(0.0, 1030.0, 130.0), vec3(200.0, 40.0, 130.0), 3.0), DIE));
  r = U(r, vec2(rbox(p - vec3(0.0, 1290.0, 130.0), vec3(200.0, 40.0, 130.0), 3.0), DIE));
  r = U(r, vec2(cylY(vec3(abs(p.x) - 165.0, p.y - 1160.0, p.z - 40.0), 18.0, 95.0, 2.0), CHROME));
  r = U(r, vec2(rbox(p - vec3(0.0, 1415.0, 140.0), vec3(220.0, 85.0, 140.0), 6.0), OLD));
  r = U(r, vec2(rbox(vec3(abs(p.x) - 250.0, p.y - 1420.0, p.z - 285.0), vec3(22.0, 90.0, 16.0), 3.0), STEEL));
  r = U(r, vec2(cylZ(vec3(abs(p.x) - 250.0, abs(p.y - 1420.0) - 55.0, p.z - 302.0), 7.0, 3.0, 1.5), DARK));
  vec3 f = vec3(p.x - 380.0, p.y - 2000.0, p.z + 350.0);
  float rr = length(f.yz);
  float wheel = max(abs(rr - 395.0) - 35.0, abs(f.x) - 48.0);
  float web = max(rr - 370.0, abs(f.x) - 12.0);
  float a = atan(f.z, f.y);
  float hole = length(vec2(rep(a, 6.2831853 / 5.0) * 240.0, rr - 240.0)) - 85.0;
  web = max(web, -hole);
  float hub = cylX(f, 115.0, 60.0, 8.0);
  r = U(r, vec2(min(min(wheel, web), hub), OLD));
  r = U(r, vec2(cylX(f - vec3(70.0, 0.0, 0.0), 45.0, 12.0, 3.0), STEEL));
  r = U(r, vec2(cylX(f + vec3(60.0, 0.0, 0.0), 60.0, 40.0, 4.0), STEEL));
  vec3 cl = vec3(p.x + 360.0, p.y - 2000.0, p.z + 350.0);
  r = U(r, vec2(cylX(cl, 250.0, 60.0, 20.0), OLD));
  r = U(r, vec2(cylX(cl + vec3(70.0, 0.0, 0.0), 120.0, 20.0, 8.0), DARK));
  vec3 m = p - vec3(150.0, 2580.0, -500.0);
  r = U(r, motor(m, 140.0, 380.0, OLD));
  r = U(r, vec2(cylX(p - vec3(380.0, 2580.0, -500.0), 90.0, 28.0, 3.0), DARK));
  float belt = capsule(vec3(rep(p.x - 374.0, 16.0), p.y, p.z), vec3(0.0, 2580.0, -590.0), vec3(0.0, 2000.0, -780.0), 7.0);
  belt = min(belt, capsule(vec3(rep(p.x - 374.0, 16.0), p.y, p.z), vec3(0.0, 2580.0, -410.0), vec3(0.0, 2000.0, 80.0), 7.0));
  belt = max(belt, abs(p.x - 382.0) - 16.0);
  r = U(r, vec2(belt, BLACK));
  r = U(r, vec2(capsule(p, vec3(-306.0, 2300.0, 200.0), vec3(-306.0, 1600.0, 200.0), 5.0), COPPER));
  r = U(r, vec2(cylY(vec3(p.x + 312.0, p.y - 2330.0, p.z - 200.0), 14.0, 22.0, 3.0), BRASS));
  r = U(r, idPlate(vec3(p.z + 100.0, p.y - 700.0, -(p.x + 300.0)), vec2(80.0, 50.0)));
  r = U(r, vec2(cylY(vec3(abs(p.x) - 320.0, p.y - 126.0, abs(p.z + 200.0) - 470.0), 16.0, 6.0, 2.0), DARK));
  r = U(r, warning(p - vec3(0.0, 2050.0, 300.0), 70.0));
  return r;
}

vec2 retrofit(vec3 p) {
  vec2 r = lightCurtain(vec3(-(p.z - 320.0), p.y - 900.0, p.x + 330.0), 660.0);
  r = U(r, lightCurtain(vec3(p.z - 320.0, p.y - 900.0, -(p.x - 330.0)), 660.0));
  float brk = rbox(vec3(abs(p.x) - 318.0, abs(p.y - 1230.0) - 305.0, p.z - 300.0), vec3(26.0, 10.0, 26.0), 2.0);
  r = U(r, vec2(brk, DARK));
  vec3 s1 = vec3(-abs(p.x), p.y, p.z) - vec3(-245.0, 1030.0, 285.0);
  r = U(r, vec2(rbox(s1 - vec3(-10.0, -35.0, 0.0), vec3(26.0, 3.0, 20.0), 1.0), ZINC));
  r = U(r, vec2(rbox(s1 - vec3(-34.0, -10.0, 0.0), vec3(3.0, 28.0, 20.0), 1.0), ZINC));
  r = U(r, sensorM18(vec3(s1.x + 10.0, s1.y + 6.0, s1.z), BLUEP));
  r = U(r, vec2(cable(vec3(-abs(p.x), p.y, p.z), vec3(-300.0, 1024.0, 285.0), vec3(-330.0, 1000.0, 300.0), vec3(-310.0, 920.0, 250.0), 2.6), CABLE));
  vec3 e = p - vec3(-180.0, 1760.0, 300.0);
  r = U(r, vec2(rbox(e - vec3(0.0, 0.0, 40.0), vec3(60.0, 60.0, 40.0), 6.0), YELLOW));
  r = U(r, estop(e - vec3(0.0, 0.0, 80.0)));
  r = U(r, vec2(capsule(p, vec3(-180.0, 1700.0, 330.0), vec3(-180.0, 1640.0, 305.0), 5.0), CABLE));
  return r;
}

vec3 toHmi(vec3 p) {
  vec3 q = p - HMI_AT;
  q.xz = rot(HMI_ANGLE) * q.xz;
  return q;
}

vec2 pendant(vec3 p) {
  vec2 r = vec2(rbox(p - vec3(-308.0, 1700.0, 200.0), vec3(8.0, 40.0, 40.0), 3.0), DARK);
  r = U(r, vec2(capsule(p, vec3(-316.0, 1700.0, 200.0), vec3(-668.0, 1700.0, 406.0), 22.0), GREY));
  r = U(r, vec2(cylY(p - vec3(-668.0, 1700.0, 406.0), 30.0, 26.0, 5.0), GREY));
  r = U(r, vec2(capsule(p, vec3(-668.0, 1700.0, 406.0), vec3(-668.0, 1600.0, 406.0), 22.0), GREY));
  vec3 q = toHmi(p);
  r = U(r, vec2(rbox(q - vec3(0.0, 0.0, -70.0), vec3(150.0, 110.0, 30.0), 8.0), GREY));
  r = U(r, vec2(rbox(q - vec3(0.0, 125.0, -70.0), vec3(40.0, 30.0, 30.0), 6.0), GREY));
  r = U(r, hmiPanel(q, vec2(175.0, 130.0), 46.0, 18.0, SCREEN));
  return r;
}

vec2 conduit(vec3 p) {
  float d = cable(p, vec3(1050.0, 2000.0, -120.0), vec3(950.0, 2700.0, -120.0), vec3(150.0, 2400.0, -60.0), 17.0);
  return vec2(d, CONDUIT);
}

vec2 newCabinet(vec3 p) {
  vec2 r = cabinet(p, vec3(800.0, 2000.0, 500.0));
  vec3 d = p - vec3(-40.0, 0.0, 250.0);
  r = U(r, hmiPanel(d - vec3(-60.0, 1460.0, 9.0), vec2(200.0, 150.0), 9.0, 20.0, SCREEN2));
  r = U(r, pushButton(d - vec3(-200.0, 1180.0, 0.0), GREEN));
  r = U(r, pushButton(d - vec3(-120.0, 1180.0, 0.0), RED));
  r = U(r, selectorSwitch(d - vec3(-40.0, 1180.0, 0.0), 0.6));
  r = U(r, pilotLight(d - vec3(40.0, 1180.0, 0.0), LGREEN));
  r = U(r, pilotLight(d - vec3(120.0, 1180.0, 0.0), AMBER_OFF));
  r = U(r, idPlate(d - vec3(-60.0, 1060.0, 0.5), vec2(70.0, 22.0)));
  r = U(r, warning(d - vec3(-60.0, 1780.0, 0.6), 55.0));
  r = U(r, towerLight(p - vec3(250.0, 2000.0, 0.0), 0.0));
  vec3 sq = vec3(p.x - 400.0, p.y - 1450.0, p.z - 120.0);
  r = U(r, vec2(rbox(sq - vec3(1.5, 0.0, 0.0), vec3(1.5, 52.0, 52.0), 3.0), YELLOW));
  float hub = cylX(sq - vec3(12.0, 0.0, 0.0), 22.0, 9.0, 4.0);
  hub = smin(hub, rbox(sq - vec3(20.0, 22.0, 0.0), vec3(8.0, 42.0, 11.0), 5.0), 6.0);
  r = U(r, vec2(hub, RED));
  r = U(r, vec2(cylY(p - vec3(-200.0, 2010.0, 0.0), 24.0, 12.0, 3.0), BLACK));
  return r;
}

vec2 sceneMap(vec3 p) {
  vec2 r = vec2(0.7 * BR, -1.0);
  if (box(p - vec3(0.0, 1380.0, -220.0), vec3(500.0, 1400.0, 620.0)) < r.x) r = U(r, oldPress(p));
  if (box(p - vec3(0.0, 1300.0, 300.0), vec3(380.0, 520.0, 60.0)) < r.x) r = U(r, retrofit(p));
  if (box(p - vec3(-520.0, 1550.0, 330.0), vec3(260.0, 220.0, 220.0)) < r.x) r = U(r, pendant(p));
  if (box(p - vec3(600.0, 2350.0, -100.0), vec3(500.0, 400.0, 60.0)) < r.x) r = U(r, conduit(p));
  if (box(p - vec3(1250.0, 1150.0, -120.0), vec3(450.0, 1160.0, 300.0)) < r.x) r = U(r, newCabinet(p - vec3(1250.0, 0.0, -120.0)));
  return r;
}

Mat sceneMat(float id, vec3 p, vec3 n) {
  if (id == OLD) {
    float w = fbm(p * 0.01);
    float chip = smoothstep(0.62, 0.66, fbm(p * 0.035 + 3.0));
    vec3 c = mix(vec3(0.075, 0.115, 0.1), vec3(0.06, 0.09, 0.085), w);
    return mat(mix(c, vec3(0.16, 0.15, 0.14), chip * 0.7), mix(0.5, 0.6, w), 0.0);
  }
  if (id == DIE) return mat(vec3(0.32, 0.33, 0.34), 0.62, 1.0);
  if (id == PLATE_ID) return mat(vec3(0.75, 0.76, 0.77), 0.4, 1.0);
  if (id == CONDUIT) {
    float rib = 0.85 + 0.15 * step(0.5, fract(dot(p, vec3(0.12))));
    return mat(vec3(0.16, 0.17, 0.18) * rib, 0.5, 0.0);
  }
  if (id == SCREEN) {
    vec3 q = toHmi(p);
    return screen(screenHmi((q.xy + vec2(157.0, 112.0)) / vec2(314.0, 224.0), 7.0));
  }
  if (id == SCREEN2) {
    vec2 uv = (p.xy - vec2(1250.0 - 40.0 - 60.0 - 180.0, 1460.0 - 130.0)) / vec2(360.0, 260.0);
    return screen(screenTrend(uv, 2.0));
  }
  if (id == ALU) return mat(vec3(0.8, 0.81, 0.83), 0.6, 1.0);
  return libMat(id, p, n);
}
