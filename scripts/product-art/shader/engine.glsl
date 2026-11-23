const float ENV_WALL = 200.0, ENV_CEIL = 201.0, ENV_COLUMN = 210.0, ENV_UPRIGHT = 211.0, ENV_BEAM = 212.0;
const float ENV_LAMP = 213.0, ENV_LAMPBODY = 214.0, ENV_GOODS = 215.0, ENV_WRAP = 216.0, ENV_PALLET = 217.0;

vec3 yaw(vec3 d, float a) {
  float c = cos(a), s = sin(a);
  return vec3(c * d.x - s * d.z, d.y, s * d.x + c * d.z);
}

float mapD(vec3 p) { return sceneMap(p).x; }
float mapAll(vec3 p) { return min(p.y, sceneMap(p).x); }

bool hitsBound(vec3 ro, vec3 rd, out float t0, out float t1) {
  vec3 oc = ro - BC;
  float b = dot(oc, rd);
  float c = dot(oc, oc) - BR * BR;
  float h = b * b - c;
  if (h < 0.0) return false;
  h = sqrt(h);
  t0 = max(-b - h, 0.0);
  t1 = -b + h;
  return t1 > 0.0;
}

vec2 envMap(vec3 p) {
  vec2 r = vec2(1e9, -1.0);
  float H = uCeil;
  vec2 c = vec2(0.5 * (uRoom.x + uRoom.y), 0.5 * (uRoom.z + uRoom.w));
  float halfW = 0.5 * (uRoom.y - uRoom.x);
  vec3 q = vec3(rep(p.x - c.x, 6000.0), p.y - H * 0.5, p.z - uRoom.z - 170.0);
  float col = box(q, vec3(150.0, H * 0.5, 150.0));
  vec3 s = vec3(abs(p.x - c.x) - halfW + 170.0, p.y - H * 0.5, rep(p.z - c.y, 6000.0));
  col = min(col, box(s, vec3(150.0, H * 0.5, 150.0)));
  r = U(r, vec2(col - 3.0, ENV_COLUMN));
  float runHalf = halfW - 1800.0;
  float bay = 2700.0;
  vec3 k = vec3(p.x - c.x, p.y, p.z - uRoom.z - 1050.0);
  float bi = clamp(round(k.x / bay), -floor(runHalf / bay), floor(runHalf / bay));
  float up = box(vec3(k.x - bi * bay, p.y - 2600.0, abs(k.z) - 500.0), vec3(45.0, 2600.0, 40.0));
  r = U(r, vec2(up, ENV_UPRIGHT));
  float lim = floor(runHalf / bay) * bay;
  float by = p.y - 1600.0 - 1600.0 * clamp(round((p.y - 1600.0) / 1600.0), 0.0, 2.0);
  float beam = box(vec3(k.x, by, abs(k.z) - 500.0), vec3(lim, 60.0, 30.0));
  r = U(r, vec2(beam, ENV_BEAM));
  float ci = clamp(floor(k.x / bay), -floor(runHalf / bay), floor(runHalf / bay) - 1.0);
  float lx = k.x - (ci + 0.5) * bay;
  float side = sign(lx);
  float sx = abs(lx) - 650.0;
  float li = clamp(round((p.y - 700.0) / 1600.0), 0.0, 2.0);
  float base = li * 1600.0 + (li > 0.5 ? 60.0 : 0.0);
  vec2 hh = h22(vec2(ci * 3.1 + side, li * 7.7 + 1.3));
  float gh = 550.0 + 700.0 * hh.x;
  float pal = box(vec3(sx, p.y - base - 72.0, k.z), vec3(590.0, 72.0, 500.0));
  float goods = rbox(vec3(sx, p.y - base - 144.0 - gh * 0.5, k.z), vec3(565.0, gh * 0.5, 480.0), 25.0);
  if (hh.y < 0.18) goods = 1e9;
  if (hh.y < 0.1) pal = 1e9;
  r = U(r, vec2(pal, ENV_PALLET));
  r = U(r, vec2(goods, hh.y < 0.55 ? ENV_GOODS : ENV_WRAP));
  vec3 lq = vec3(rep(p.x - c.x - 3000.0, 6000.0), p.y - (H - 1100.0), rep(p.z - c.y - 3000.0, 6000.0));
  float body = cylY(lq - vec3(0.0, 90.0, 0.0), 240.0, 85.0, 40.0);
  body = min(body, capsule(lq, vec3(0.0, 150.0, 0.0), vec3(0.0, 1200.0, 0.0), 8.0));
  r = U(r, vec2(body, ENV_LAMPBODY));
  r = U(r, vec2(cylY(lq + vec3(0.0, 2.0, 0.0), 205.0, 6.0, 2.0), ENV_LAMP));
  return r;
}

vec3 envNormal(vec3 p) {
  vec3 n = vec3(0.0);
  for (int i = uZero; i < 4; i++) {
    vec3 s = 0.5773 * (2.0 * vec3(float(((i + 3) >> 1) & 1), float((i >> 1) & 1), float(i & 1)) - 1.0);
    n += s * envMap(p + s * 1.5).x;
  }
  return normalize(n);
}

vec3 calcNormal(vec3 p, float t) {
  float e = max(1.6e-5 * t, 2e-6 * BR);
  vec3 n = vec3(0.0);
  for (int i = uZero; i < 4; i++) {
    vec3 s = 0.5773 * (2.0 * vec3(float(((i + 3) >> 1) & 1), float((i >> 1) & 1), float(i & 1)) - 1.0);
    n += s * mapD(p + s * e);
  }
  return normalize(n);
}

float march(vec3 ro, vec3 rd, float tmax, float eps, out float id) {
  id = -1.0;
  float t0, t1;
  if (!hitsBound(ro, rd, t0, t1)) return 1e9;
  float t = t0;
  float end = min(t1, tmax);
  if (t > end) return 1e9;
  vec2 h = vec2(1e9, -1.0);
  for (int i = uZero; i < 360; i++) {
    h = sceneMap(ro + rd * t);
    if (abs(h.x) < eps * t + 1e-6 * BR) { id = h.y; return t; }
    t += h.x;
    if (t > end) return 1e9;
  }
  if (h.x < 0.004 * t) { id = h.y; return t; }
  return 1e9;
}

float marchEnv(vec3 ro, vec3 rd, float tmax, out float id) {
  id = -1.0;
  float t = 0.0;
  for (int i = uZero; i < 150; i++) {
    vec2 h = envMap(ro + rd * t);
    if (h.x < 3e-4 * t + 0.5) { id = h.y; return t; }
    t += h.x * 0.9;
    if (t > tmax) break;
  }
  return 1e9;
}

float shadow(vec3 ro, vec3 rd, float k) {
  float t0, t1;
  if (!hitsBound(ro, rd, t0, t1)) return 1.0;
  gClear = 0.0;
  float lo = 3e-4 * BR, hi = 0.045 * BR;
  float res = 1.0;
  float t = max(t0, lo);
  for (int i = uZero; i < 140; i++) {
    float h = mapD(ro + rd * t);
    res = min(res, k * h / t);
    t += clamp(h, lo, hi);
    if (res < 0.002 || t > t1) break;
  }
  gClear = 1.0;
  res = clamp(res, 0.0, 1.0);
  return res * res * (3.0 - 2.0 * res);
}

float ambientOcc(vec3 p, vec3 n, float t) {
  float s = 0.0055 * t;
  float occ = 0.0, sca = 1.0;
  gClear = 0.0;
  for (int i = uZero; i < 6; i++) {
    float h = (0.25 + 2.3 * float(i)) * s;
    float d = mapAll(p + n * h);
    occ += (h - d) / s * sca;
    sca *= 0.72;
  }
  gClear = 1.0;
  return clamp(1.0 - 0.065 * occ, 0.0, 1.0);
}

vec3 envAmbient(vec3 n) {
  return mix(vec3(0.2, 0.2, 0.19), vec3(0.5, 0.52, 0.55), n.y * 0.5 + 0.5);
}

vec3 envApprox(vec3 d) {
  vec3 c = mix(vec3(0.22, 0.22, 0.21), vec3(0.75, 0.78, 0.82), smoothstep(-0.25, 0.35, d.y));
  c += vec3(1.6, 1.7, 1.85) * smoothstep(0.05, 0.25, d.y) * (1.0 - smoothstep(0.35, 0.6, d.y));
  c += vec3(2.4, 2.3, 2.2) * smoothstep(0.75, 0.98, d.y);
  return c;
}

Mat floorMat(vec3 p) {
  vec2 q = p.xz;
  float n1 = fbm(vec3(q * 0.00035, 0.0));
  float n2 = fbm(vec3(q * 0.0035, 3.0));
  float n3 = vnoise(vec3(q * 0.09, 7.0));
  vec3 a = vec3(0.27, 0.285, 0.28) * (0.8 + 0.35 * n1) * (0.92 + 0.14 * n2) * (0.95 + 0.08 * n3);
  float stain = smoothstep(0.6, 0.76, fbm(vec3(q * 0.0011, 11.0)));
  a *= 1.0 - 0.28 * stain;
  float tyre = smoothstep(0.58, 0.72, vnoise(vec3(q.x * 0.00025, q.y * 0.018, 5.0))) * smoothstep(0.4, 0.6, vnoise(vec3(q * 0.0005, 9.0)));
  a *= 1.0 - 0.18 * tyre;
  vec2 jg = abs(vec2(rep(q.x - 1300.0, 6000.0), rep(q.y - 900.0, 6000.0)));
  float joint = 1.0 - smoothstep(2.5, 5.0, min(jg.x, jg.y));
  a *= 1.0 - 0.55 * joint;
  float rough = 0.16 + 0.22 * n2 + 0.3 * stain + 0.15 * tyre + 0.3 * joint;
  if (uLane.y > 0.0) {
    float lane = abs(abs(q.y - uLane.x) - uLane.y) - 38.0;
    float paint = (1.0 - smoothstep(-1.0, 1.0, lane)) * smoothstep(0.25, 0.45, fbm(vec3(q * 0.006, 2.0)));
    a = mix(a, vec3(0.72, 0.5, 0.03) * (0.85 + 0.2 * n3), paint);
    rough = mix(rough, 0.35, paint);
  }
  return mat(a, rough, 0.0);
}

Mat wallMat(vec3 p, inout vec3 n) {
  bool side = abs(n.x) > 0.5;
  float u = side ? p.z : p.x;
  float v = p.y;
  vec3 tang = side ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
  float g = fbm(vec3(u * 0.002, v * 0.002, side ? 5.0 : 1.0));
  vec2 c = vec2(0.5 * (uRoom.x + uRoom.y), 0.5 * (uRoom.z + uRoom.w));
  if (side && n.x < 0.0 && abs(p.z - c.y) < 2200.0 && v < 4600.0) {
    n = normalize(n + vec3(0.0, 0.3 * cos(v * 6.2831853 / 110.0), 0.0));
    return mat(vec3(0.24, 0.28, 0.31) * (0.85 + 0.25 * g), 0.45, 0.0);
  }
  if (v < 1250.0) return mat(vec3(0.13, 0.17, 0.16) * (0.8 + 0.35 * g) * (0.75 + 0.25 * smoothstep(0.0, 300.0, v)), 0.42, 0.0);
  if (v > 4900.0 && v < 5900.0) {
    float mull = min(abs(rep(u, 1500.0)), abs(v - 5400.0));
    if (mull < 45.0 || v < 4960.0 || v > 5840.0) return mat(vec3(0.35), 0.4, 0.0);
    return glow(vec3(0.02), 0.05, vec3(3.2, 3.45, 3.8) * (0.8 + 0.3 * g));
  }
  n = normalize(n + tang * 0.35 * sin(u * 6.2831853 / 250.0));
  float seam = 1.0 - smoothstep(4.0, 9.0, abs(rep(v - 1250.0, 1180.0)));
  return mat(vec3(0.6, 0.62, 0.63) * (0.86 + 0.18 * g) * (1.0 - 0.25 * seam), 0.5, 0.0);
}

Mat envMat(float id, vec3 p, inout vec3 n) {
  float g = fbm(p * 0.004);
  if (id < 200.5) return wallMat(p, n);
  if (id < 201.5) {
    float sky = 1.0 - smoothstep(550.0, 650.0, abs(rep(p.z, 6000.0)));
    return glow(vec3(0.06), 0.6, vec3(1.6, 1.7, 1.9) * sky);
  }
  if (id < 210.5) {
    if (p.y < 1200.0) {
      float st = step(0.5, fract((p.y + p.x + p.z) / 260.0));
      return mat(mix(vec3(0.02), vec3(0.75, 0.52, 0.02), st) * (0.8 + 0.3 * g), 0.45, 0.0);
    }
    return mat(vec3(0.3, 0.33, 0.37) * (0.85 + 0.25 * g), 0.45, 0.0);
  }
  if (id < 211.5) return mat(vec3(0.02, 0.07, 0.24) * (0.8 + 0.3 * g), 0.4, 0.0);
  if (id < 212.5) return mat(vec3(0.72, 0.2, 0.02) * (0.85 + 0.25 * g), 0.4, 0.0);
  if (id < 213.5) return glow(vec3(0.9), 0.2, vec3(30.0, 29.0, 26.0));
  if (id < 214.5) return mat(vec3(0.55, 0.56, 0.58), 0.38, 1.0);
  if (id < 215.5) return mat(vec3(0.44, 0.29, 0.15) * (0.8 + 0.35 * fbm(p * 0.01)), 0.75, 0.0);
  if (id < 216.5) return mat(vec3(0.62, 0.65, 0.68) * (0.85 + 0.2 * g), 0.18, 0.0);
  return mat(vec3(0.45, 0.33, 0.19) * (0.8 + 0.3 * fbm(p * vec3(0.02, 0.5, 0.5))), 0.75, 0.0);
}

Mat weatherMat(Mat m, vec3 p, vec3 n) {
  if (m.trans > 0.0) return m;
  float s = fbm(p * 0.0045 + 3.7);
  if (dot(m.emi, m.emi) > 0.0) {
    m.rough = clamp(m.rough + 0.12 * smoothstep(0.45, 0.75, s), 0.0, 1.0);
    return m;
  }
  float dust = smoothstep(0.55, 0.95, n.y) * smoothstep(0.35, 0.75, fbm(p * 0.02 + 1.3));
  float lum = dot(m.alb, vec3(0.3, 0.59, 0.11));
  float light = smoothstep(0.04, 0.3, lum);
  m.alb = mix(m.alb, vec3(0.36, 0.34, 0.31), 0.16 * dust * (1.0 - m.metal * 0.5) * (0.3 + 0.7 * light));
  float low = 1.0 - smoothstep(0.0, 260.0, p.y);
  m.alb *= 1.0 - 0.22 * low * smoothstep(0.3, 0.7, fbm(p * 0.015));
  float scratch = smoothstep(0.93, 0.985, 1.0 - abs(2.0 * vnoise(p * vec3(0.05, 0.9, 0.05) + n * 7.0) - 1.0)) * smoothstep(0.5, 0.7, vnoise(p * 0.01));
  m.alb = mix(m.alb, m.metal > 0.5 ? m.alb * 1.08 : m.alb * 0.8 + 0.06, 0.5 * scratch * (m.metal > 0.5 ? 1.0 : light));
  m.rough = clamp(m.rough * (0.82 + 0.38 * s) + 0.1 * dust + 0.06 * scratch, 0.03, 1.0);
  return m;
}

Mat getMat(float id, vec3 p, inout vec3 n) {
  if (id < 0.5) return floorMat(p);
  if (id > 199.5) return envMat(id, p, n);
  return weatherMat(sceneMat(id, p, n), p, n);
}

vec3 ggx(vec3 n, vec3 v, vec3 l, float r, vec3 F0) {
  vec3 h = normalize(v + l);
  float nv = max(dot(n, v), 1e-3), nh = max(dot(n, h), 0.0), vh = max(dot(v, h), 0.0), nl = max(dot(n, l), 0.0);
  float a = r * r;
  float a2 = a * a;
  float d = nh * nh * (a2 - 1.0) + 1.0;
  float D = a2 / (PI * d * d);
  float k = (r + 1.0) * (r + 1.0) / 8.0;
  float G = (nv / (nv * (1.0 - k) + k)) * (nl / (nl * (1.0 - k) + k));
  vec3 F = F0 + (1.0 - F0) * pow(1.0 - vh, 5.0);
  return D * G * F / (4.0 * nv);
}

const vec3 LIGHT_TOP = vec3(0.14, 1.0, 0.2);
const vec3 LIGHT_TOP_C = vec3(2.05, 1.97, 1.84);
const vec3 LIGHT_WIN = vec3(-0.85, 0.42, 0.32);
const vec3 LIGHT_WIN_C = vec3(0.8, 0.88, 1.02);

vec3 hemiDir(vec3 n, vec2 u) {
  float a = 6.2831853 * u.x;
  float r = sqrt(u.y);
  vec3 t = normalize(abs(n.y) < 0.9 ? cross(n, vec3(0.0, 1.0, 0.0)) : cross(n, vec3(1.0, 0.0, 0.0)));
  vec3 b = cross(n, t);
  return normalize(t * r * cos(a) + b * r * sin(a) + n * sqrt(1.0 - u.y));
}

vec3 radiance(vec3 ro, vec3 rd, vec2 rnd) {
  vec3 col = vec3(0.0);
  vec3 thr = vec3(1.0);
  float tacc = 0.0;
  float tPrimary = 0.0;
  float pix = 1.0 / (uRes.y * uLens);
  vec3 lights[2];
  lights[0] = normalize(LIGHT_TOP);
  lights[1] = normalize(yaw(LIGHT_WIN, uYaw));
  vec3 lightC[2];
  lightC[0] = LIGHT_TOP_C;
  lightC[1] = LIGHT_WIN_C;
  int b = 0;
  for (int pass = uZero; pass < 6; pass++) {
    float t = 1e9;
    float id = -1.0;
    vec3 n = vec3(0.0, 1.0, 0.0);
    if (rd.y < 0.0) { t = -ro.y / rd.y; id = 0.0; }
    if (rd.y > 0.0 && (uCeil - ro.y) / rd.y < t) { t = (uCeil - ro.y) / rd.y; id = ENV_CEIL; n = vec3(0.0, -1.0, 0.0); }
    if (rd.x < 0.0 && (uRoom.x - ro.x) / rd.x < t) { t = (uRoom.x - ro.x) / rd.x; id = ENV_WALL; n = vec3(1.0, 0.0, 0.0); }
    if (rd.x > 0.0 && (uRoom.y - ro.x) / rd.x < t) { t = (uRoom.y - ro.x) / rd.x; id = ENV_WALL; n = vec3(-1.0, 0.0, 0.0); }
    if (rd.z < 0.0 && (uRoom.z - ro.z) / rd.z < t) { t = (uRoom.z - ro.z) / rd.z; id = ENV_WALL; n = vec3(0.0, 0.0, 1.0); }
    if (rd.z > 0.0 && (uRoom.w - ro.z) / rd.z < t) { t = (uRoom.w - ro.z) / rd.z; id = ENV_WALL; n = vec3(0.0, 0.0, -1.0); }
    float eid;
    float te = marchEnv(ro, rd, t, eid);
    bool envProp = false;
    if (eid >= 0.0 && te < t) { t = te; id = eid; envProp = true; }
    float sid;
    float ts = march(ro, rd, t, b == 0 ? 0.5 * pix : 2.0 * pix, sid);
    bool sceneHit = sid >= 0.0;
    if (sceneHit) { t = ts; id = sid; }
    if (t > 1e8) break;
    vec3 p = ro + rd * t;
    float T = tacc + t;
    if (b == 0 && pass == 0) tPrimary = T;
    if (sceneHit) {
      n = calcNormal(p, T);
      if (dot(n, rd) > 0.0) n = normalize(n - rd * dot(n, rd) * 1.01);
    } else if (envProp) {
      n = envNormal(p);
    }
    Mat m = getMat(id, p, n);
    if (sceneHit && m.trans > 0.0 && h22(gl_FragCoord.xy * 0.37 + rnd * 113.0 + float(pass) * 5.31).x < m.trans) {
      thr *= m.alb;
      tacc = T;
      ro = p + rd * (7.0 / max(abs(dot(rd, n)), 0.15));
      continue;
    }
    if (m.trans > 0.0) m.alb = vec3(0.015);
    vec3 po = p + n * (3e-4 * T + 1e-5 * BR);
    float sh[2];
    for (int i = uZero; i < 2; i++) {
      if (b == 1 && i == 1) { sh[i] = 1.0; break; }
      sh[i] = shadow(po, lights[i], i == 0 ? 3.0 : 6.0);
    }
    float occ = (b == 0 && (sceneHit || id < 0.5)) ? ambientOcc(p, n, T) : 1.0;
    if (b == 1) {
      vec3 sc = m.alb * (1.0 - m.metal) * (lightC[0] * max(dot(n, lights[0]), 0.0) * sh[0] + lightC[1] * max(dot(n, lights[1]), 0.0) * 0.7 + envAmbient(n) * 0.7);
      sc += m.metal * m.alb * envApprox(reflect(rd, n)) * 0.8;
      col += min(thr * (sc + m.emi), vec3(1.5));
      break;
    }
    vec3 v = -rd;
    vec3 F0 = mix(vec3(0.04), m.alb, m.metal);
    float r = max(m.rough, 0.05);
    vec3 diff = vec3(0.0);
    vec3 spec = vec3(0.0);
    for (int i = 0; i < 2; i++) {
      float nl = max(dot(n, lights[i]), 0.0);
      diff += lightC[i] * nl * sh[i];
      spec += ggx(n, v, lights[i], max(r, 0.12), F0) * lightC[i] * nl * sh[i];
    }
    col += thr * (m.alb * (1.0 - m.metal) * (diff + envAmbient(n) * occ * 0.45) + spec + m.emi);
    vec3 F = F0 + (1.0 - F0) * pow(1.0 - max(dot(n, v), 0.0), 5.0) * (1.0 - r * 0.7);
    float fl = (F.x + F.y + F.z) / 3.0;
    vec2 u2 = fract(rnd * vec2(1.618, 2.414) + h22(gl_FragCoord.xy * 0.71 + float(pass) * 3.1));
    float ps = m.metal > 0.5 ? 1.0 : (m.rough < 0.7 ? clamp(fl * 3.0 + 0.1, 0.1, 0.65) : 0.0);
    vec3 dir;
    if (u2.x < ps) {
      float z = 1.0 - 2.0 * rnd.x;
      float ang = 2.0 * PI * rnd.y;
      vec3 rv = vec3(sqrt(1.0 - z * z) * cos(ang), sqrt(1.0 - z * z) * sin(ang), z);
      dir = normalize(reflect(rd, n) + rv * m.rough * m.rough * 2.2);
      if (dot(dir, n) < 0.0) dir = reflect(dir, n);
      thr *= F / ps * mix(1.0, occ, 0.6);
    } else {
      dir = hemiDir(n, vec2(u2.y, fract(u2.x * 7.31 + rnd.y)));
      thr *= m.alb * (1.0 - m.metal) * (1.0 - fl) / (1.0 - ps) * occ * 0.55;
    }
    ro = po;
    rd = dir;
    tacc = T;
    b++;
  }
  float haze = 1.0 - exp(-tPrimary * 0.0000045);
  return mix(col, vec3(0.75, 0.78, 0.82), haze);
}

vec3 aces(vec3 x) {
  return clamp((x * (2.51 * x + 0.03)) / (x * (2.43 * x + 0.59) + 0.14), 0.0, 1.0);
}

void main() {
  vec3 ww = normalize(uTa - uRo);
  vec3 uu = normalize(cross(ww, vec3(0.0, 1.0, 0.0)));
  vec3 vv = cross(uu, ww);
  float cr = cos(uRoll), sr = sin(uRoll);
  vec3 ru = uu * cr + vv * sr;
  vec3 rv = vv * cr - uu * sr;
  uu = ru;
  vv = rv;
  vec2 seedA = h22(gl_FragCoord.xy * 1.317);
  vec2 seedB = h22(gl_FragCoord.yx * 0.913 + 17.0);
  vec2 seedC = h22(gl_FragCoord.xy * 0.731 + 41.0);
  vec3 acc = vec3(0.0);
  for (int s = 0; s < 64; s++) {
    if (s >= uSamples) break;
    float fs = float(s);
    vec2 j = fract(seedA + fs * vec2(0.7548776662, 0.5698402910));
    vec2 lens = fract(seedB + fs * vec2(0.5698402910, 0.7548776662) + 0.37);
    vec2 rnd = fract(seedC + fs * vec2(0.6180339887, 0.4142135624));
    vec2 uv = (gl_FragCoord.xy + j - 0.5 * uRes) / uRes.y;
    vec3 rd = normalize(uv.x * uu + uv.y * vv + uLens * ww);
    vec3 fp = uRo + rd * (uFocus / dot(rd, ww));
    float lr = sqrt(lens.x) * uAperture;
    vec3 ro = uRo + (uu * cos(6.2831853 * lens.y) + vv * sin(6.2831853 * lens.y)) * lr;
    acc += min(radiance(ro, normalize(fp - ro), rnd), vec3(24.0));
  }
  vec3 col = acc / float(uSamples);
  col = aces(col * uExposure);
  col = pow(col, vec3(1.0 / 2.2));
  vec2 q = gl_FragCoord.xy / uRes;
  col *= 0.86 + 0.14 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.22);
  outColor = vec4(col, 1.0);
}
