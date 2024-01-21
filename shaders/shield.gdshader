shader_type spatial;
uniform vec3 color : source_color = vec3(0.0, 0.0, 1.0);

void vertex() {
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );
    MODELVIEW_MATRIX = modified_model_view;
}

void fragment() {
	float d = sqrt(pow(UV.x - 0.5,2) + pow(UV.y - 0.5,2));
	ALBEDO = color;
	ALPHA = d * (1.0 - float(d > 0.5));
}