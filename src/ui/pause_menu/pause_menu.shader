shader_type canvas_item;

void fragment()
{
    vec4 original = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

    vec3 sepia;
    sepia.r = dot(original.rgb, vec3(0.393, 0.769, 0.189));
    sepia.g = dot(original.rgb, vec3(0.349, 0.686, 0.168));
    sepia.b = dot(original.rgb, vec3(0.272, 0.534, 0.131));

    COLOR.rgb = sepia;
}
