 uniform vec2 uResolution;
 uniform vec2 uImageResolution;
 uniform float uTime;
 uniform sampler2D uTexture;

 uniform sampler2D disp;

 varying vec2 vUv;
 
 vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v){
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
           -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
  + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}


void main(void) {
    vec2 ratio = vec2(
        min((uResolution.x / uResolution.y) / (uImageResolution.x / uImageResolution.y), 1.0),
        min((uResolution.y / uResolution.x) / (uImageResolution.y / uImageResolution.x), 1.0)
    );

    vec2 uv = vec2(
        vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
        vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
    );

     float intensity = 0.2;
     float frequency = 1.0;//振動数
     float speed = 10.0;//振動速度
     float waveSpeed = 0.03;  // 波の速さ

     vec2 change = vec2(0.0,-1.0);

    vec4 disp = texture2D(disp, uv);
    vec2 dispVec = vec2(disp.x, disp.y);
    float dispClamp = clamp(dispVec.x,dispVec.y,vUv.x);
    float dist = uv.x + frequency;

    float offset = uTime * waveSpeed;
    vec2 offsetDispVec = dist + dispVec + vec2(offset, offset);


    float snoiseDistort = snoise(offsetDispVec * frequency);
    vec2 distortedPos = uv + snoiseDistort * intensity * 0.01;

    distortedPos = clamp(distortedPos, 0.0,1.0);

    vec4 texColor = texture2D(uTexture, distortedPos);


    gl_FragColor = texColor;
    // gl_FragColor = vec4(snoiseDistort,snoiseDistort,snoiseDistort,1.0);
}