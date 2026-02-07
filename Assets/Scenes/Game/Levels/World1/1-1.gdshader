shader_type canvas_item;

uniform sampler2D screen_tecture:hint_screen_texture,repeat_disable,filter_linear_mipmap;

uniform float f:hint_range(0.0,5.0);

void fragment() {
	COLOR.rgb = texture(screen_tecture,SCREEN_UV,f).rgb;
}
