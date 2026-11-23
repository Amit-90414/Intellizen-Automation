#version 300 es
precision highp float;
precision highp int;

uniform vec2 uRes;
uniform int uSamples;
uniform int uZero;
uniform float uExposure;
uniform vec3 uRo;
uniform vec3 uTa;
uniform float uLens;
uniform float uFocus;
uniform float uAperture;
uniform float uYaw;
uniform float uRoll;
uniform vec4 uRoom;
uniform float uCeil;
uniform vec2 uLane;
uniform float uVariant;
out vec4 outColor;

const float PI = 3.14159265;

struct Mat {
  vec3 alb;
  float rough;
  float metal;
  vec3 emi;
  float trans;
};

float gClear = 1.0;

Mat mat(vec3 alb, float rough, float metal) { return Mat(alb, rough, metal, vec3(0.0), 0.0); }
Mat glow(vec3 alb, float rough, vec3 emi) { return Mat(alb, rough, 0.0, emi, 0.0); }
Mat clearMat(vec3 tint, float rough, float trans) { return Mat(tint, rough, 0.0, vec3(0.0), trans); }

vec2 h22(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.xx + p3.yz) * p3.zy);
}

float h31(vec3 p) {
  p = fract(p * 0.1031);
  p += dot(p, p.zyx + 31.32);
  return fract((p.x + p.y) * p.z);
}

float vnoise(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);
  return mix(mix(mix(h31(i), h31(i + vec3(1, 0, 0)), f.x), mix(h31(i + vec3(0, 1, 0)), h31(i + vec3(1, 1, 0)), f.x), f.y),
             mix(mix(h31(i + vec3(0, 0, 1)), h31(i + vec3(1, 0, 1)), f.x), mix(h31(i + vec3(0, 1, 1)), h31(i + vec3(1, 1, 1)), f.x), f.y), f.z);
}

float fbm(vec3 p) {
  return 0.5 * vnoise(p) + 0.25 * vnoise(p * 2.03) + 0.125 * vnoise(p * 4.01);
}

mat2 rot(float a) {
  float c = cos(a), s = sin(a);
  return mat2(c, s, -s, c);
}

float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
  return mix(b, a, h) - k * h * (1.0 - h);
}

float smax(float a, float b, float k) { return -smin(-a, -b, k); }

vec2 U(vec2 a, vec2 b) { return a.x < b.x ? a : b; }

float box(vec3 p, vec3 b) {
  vec3 q = abs(p) - b;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float rbox(vec3 p, vec3 b, float r) {
  vec3 q = abs(p) - b + r;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0) - r;
}

float box2(vec2 p, vec2 b) {
  vec2 q = abs(p) - b;
  return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
}

float cyl(vec2 q, float y, float r, float h, float rr) {
  vec2 d = vec2(length(q) - r + rr, abs(y) - h + rr);
  return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - rr;
}

float cylY(vec3 p, float r, float h, float rr) { return cyl(p.xz, p.y, r, h, rr); }
float cylX(vec3 p, float r, float h, float rr) { return cyl(p.yz, p.x, r, h, rr); }
float cylZ(vec3 p, float r, float h, float rr) { return cyl(p.xy, p.z, r, h, rr); }

float capsule(vec3 p, vec3 a, vec3 b, float r) {
  vec3 pa = p - a, ba = b - a;
  float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
  return length(pa - ba * h) - r;
}

float torusY(vec3 p, float R, float r) { return length(vec2(length(p.xz) - R, p.y)) - r; }
float torusZ(vec3 p, float R, float r) { return length(vec2(length(p.xy) - R, p.z)) - r; }
float torusX(vec3 p, float R, float r) { return length(vec2(length(p.yz) - R, p.x)) - r; }

float hexZ(vec3 p, float apo, float h, float ch) {
  const vec3 k = vec3(-0.8660254, 0.5, 0.57735);
  vec3 q = abs(p);
  q.xy -= 2.0 * min(dot(k.xy, q.xy), 0.0) * k.xy;
  vec2 d = vec2(length(q.xy - vec2(clamp(q.x, -k.z * apo, k.z * apo), apo)) * sign(q.y - apo), q.z - h);
  float hex = min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
  float c = (length(p.xy) + 0.62 * abs(p.z) - apo * ch - 0.62 * h) / 1.1758;
  return max(hex, c);
}

float coneY(vec3 p, float r0, float r1, float h) {
  vec2 q = vec2(length(p.xz), p.y);
  vec2 k1 = vec2(r1, h);
  vec2 k2 = vec2(r1 - r0, 2.0 * h);
  vec2 ca = vec2(q.x - min(q.x, q.y < 0.0 ? r0 : r1), abs(q.y) - h);
  vec2 cb = q - k1 + k2 * clamp(dot(k1 - q, k2) / dot(k2, k2), 0.0, 1.0);
  float s = (cb.x < 0.0 && ca.y < 0.0) ? -1.0 : 1.0;
  return s * sqrt(min(dot(ca, ca), dot(cb, cb)));
}

float bound(vec3 p, vec3 c, vec3 b) { return box(p - c, b); }

float rep(float x, float s) { return x - s * round(x / s); }

float repLim(float x, float s, float lo, float hi) { return x - s * clamp(round(x / s), lo, hi); }
