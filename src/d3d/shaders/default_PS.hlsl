struct VS_out {
	float4 Position		: POSITION;
	float3 TexCoord0	: TEXCOORD0;
	float4 Color		: COLOR0;
};

sampler2D tex0 : register(s0);

float4 fogColor : register(c0);
#ifdef EMISSIVE
float4 fxParams : register(c1);
#define emissiveMult (fxParams.x)
#endif

float4 main(VS_out input) : COLOR
{
#ifdef EMISSIVE
	float4 color = tex2D(tex0, input.TexCoord0.xy);
	color.rgb = color.rgb * (1.0 + emissiveMult);
#else
	float4 color = input.Color;
#ifdef TEX
	color *= tex2D(tex0, input.TexCoord0.xy);
#endif
	color.rgb = lerp(fogColor.rgb, color.rgb, input.TexCoord0.z);
#endif
	return color;
}
