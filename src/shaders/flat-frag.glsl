#version 300 es
precision highp float;

uniform vec3 u_Eye, u_Ref, u_Up;
uniform vec2 u_Dimensions;
uniform float u_Time;

in vec2 fs_Pos;
out vec4 out_Col;

void main() {
  // Main: Cast Rays from a Virtual Camera
  // Step 1: Use NDC coors of the current fragment (fs_Pos) to project ray
  float sx = fs_Pos.x;
  float sy = fs_Pos.y;
  // float sx = (2.0 * fs_Pos.x / u_Dimensions.x) - 1.0;
  // float sy = 1.0 - (2.0 * fs_Pos.y / u_Dimensions.y);

  // Step 2: Compute Aspect Ratio, Length of Vector from eye to ref, and FOVy
  float aspect_ratio = u_Dimensions.x / u_Dimensions.y;
  float len = length(u_Ref - u_Eye);
  float FOVy = 90.0;
  float alpha = FOVy/2.0;
  // float alpha = atan(u_Dimensions.y/ (2.0 * len));


  // Step 3: Compute camera's Right vec based on Up vec, Eye pt, and Ref pt
  // Orthogonal Basis Vectors
  vec3 N = normalize(u_Eye - u_Ref);
  vec3 R = normalize(cross(u_Up, N));
  vec3 U = cross(N, R);

  // Step 4: Compute the Vertical and Horizontal Vectors
  vec3 H = R * len * tan(alpha);
  vec3 V = U * len * tan(alpha) * aspect_ratio;

  // Find coordinates of point in 3D space and generate a ray direction
  vec3 P = u_Ref + sx * H + sy * V;
  vec3 dir = normalize(P - u_Eye);

  out_Col = vec4(0.5 * (dir + vec3(1.0, 1.0, 1.0)), 1.0);
  // out_Col = vec4(0.5 * (fs_Pos + vec2(1.0)), 0.5 * (sin(u_Time * 3.14159 * 0.01) + 1.0), 1.0);
}
