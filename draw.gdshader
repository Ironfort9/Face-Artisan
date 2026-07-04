shader_type texture_blit;
render_mode blend_mix;

uniform sampler2D albedo_texture : hint_blit_source0;
uniform sampler2D normal_texture : hint_blit_source1;
uniform sampler2D ao_texture : hint_default_white;
uniform sampler2D roughness_texture : hint_default_white;
uniform sampler2D metalic_texture : hint_default_black;
uniform vec2 texture_size = vec2(1024.0, 1024.0);

void blit() {
	vec2 screen_uv = FRAGCOORD.xy / texture_size;
	vec4 albedo_color = texture(albedo_texture, screen_uv);
	vec4 normal_color = texture(normal_texture, screen_uv);
	float ao = texture(ao_texture, screen_uv).r;
	float roughness = texture(roughness_texture, screen_uv).r;
	float metalic = texture(metalic_texture, screen_uv).r;

	float radius = round(length(UV * 2.0 - 1.0));
	float alpha = 1.0 - radius;

	// Output albedo
	COLOR0 = vec4(MODULATE.rgb * albedo_color.rgb, albedo_color.a * alpha);

	// Output normal
	COLOR1 = vec4(normal_color.rgb, alpha);

	// Output ORM
	COLOR2 = vec4(ao, roughness, metalic, alpha);
}