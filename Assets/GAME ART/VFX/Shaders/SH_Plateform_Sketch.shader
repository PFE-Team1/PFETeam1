// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Plateform_Sketch"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_Dist_intensity("Dist_intensity", Range( 0 , 1)) = 0.5032024
		_Noise_Back("Noise_Back", 2D) = "white" {}
		_Noise_Back_Deform("Noise_Back_Deform", Range( 0 , 1)) = 0.03789261
		_Smooth_D("Smooth_D", Range( 0 , 3)) = 0.9728891
		_Smooth_B("Smooth_B", Range( 0 , 3)) = 0.9714883
		_Smooth_H("Smooth_H", Range( 0 , 3)) = 0.9714883
		_Smooth_G("Smooth_G", Range( 0 , 3)) = 0.9714883
		_Brush_Tex("_Brush_Tex", 2D) = "white" {}
		_Dist_Pan_Speed("Dist_Pan_Speed", Float) = 1
		_N2_Back_Speed("N2_Back_Speed", Float) = 0.06
		_Dist_Max("Dist_Max", Float) = 1
		_Dist_Min("Dist_Min", Float) = 0
		_Dist_Scale("Dist_Scale", Float) = 1
		_Divide_Offset("Divide_Offset", Float) = 4.7
		_Tex_Scale("Tex_Scale", Vector) = (1,1,0,0)
		_Noise_Back_Spped("Noise_Back_Spped", Float) = 0
		_Noise_Back_Scale("Noise_Back_Scale", Float) = 1.83
		_D_Min_degrade("D_Min_degrade", Float) = 0.15
		_G_Min_degrade("G_Min_degrade", Float) = 0
		_G_Max_degrade("G_Max_degrade", Float) = 0
		_D_Max_degrade("D_Max_degrade", Float) = 0.46
		_B_Min_degrade("B_Min_degrade", Float) = -0.28
		_B_Max_degrade("B_Max_degrade", Float) = 0
		_H_Min_degrade("H_Min_degrade", Float) = 0
		_H_Max_degrade("H_Max_degrade", Float) = 0.33
		_Intensity_Noise_Max("Intensity_Noise_Max", Float) = 0
		_N2_Y_Scale("N2_Y_Scale", Float) = 0
		_Intensity_Noise_Min("Intensity_Noise_Min", Float) = 0
		_N2_X_Scale("N2_X_Scale", Float) = 0
		_HDR("HDR", Float) = 0.75

		[HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Off

		HLSLINCLUDE
		#pragma target 2.0
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		ENDHLSL

		
		Pass
		{
			Name "Sprite Unlit"
            Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEUNLIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"


			sampler2D _Brush_Tex;
			sampler2D _Noise_Back;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _H_Max_degrade;
			float _H_Min_degrade;
			float _Smooth_B;
			float _B_Max_degrade;
			float _B_Min_degrade;
			float _Smooth_G;
			float _G_Max_degrade;
			float _G_Min_degrade;
			float _Smooth_D;
			float _D_Max_degrade;
			float _D_Min_degrade;
			float _Noise_Back_Scale;
			float _Noise_Back_Spped;
			float _Noise_Back_Deform;
			float _N2_Y_Scale;
			float _N2_X_Scale;
			float _N2_Back_Speed;
			float _Intensity_Noise_Max;
			float _Intensity_Noise_Min;
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Smooth_H;
			float _HDR;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			
					float2 voronoihash75( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi75( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash75( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_positionWS = TransformObjectToWorld( ( v.positionOS ).xyz );
				o.ase_texcoord3.xyz = ase_positionWS;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;
				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				Gradient gradient167 = NewGradient( 0, 3, 2, float4( 0, 0, 0, 0 ), float4( 0.2735849, 0.09803922, 0.02968139, 0.5017471 ), float4( 1, 0.7333333, 0.3058824, 1 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord78 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult94 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult162 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner82 = ( 1.0 * _Time.y * appendResult162 + ase_positionWS.xy);
				float time75 = panner82.x;
				float2 voronoiSmoothId75 = 0;
				float voronoiSmooth75 = 0.0;
				float2 coords75 = ase_positionWS.xy * _Dist_Scale;
				float2 id75 = 0;
				float2 uv75 = 0;
				float fade75 = 0.5;
				float voroi75 = 0;
				float rest75 = 0;
				for( int it75 = 0; it75 <2; it75++ ){
				voroi75 += fade75 * voronoi75( coords75, time75, id75, uv75, voronoiSmooth75,voronoiSmoothId75 );
				rest75 += fade75;
				coords75 *= 2;
				fade75 *= 0.5;
				}//Voronoi75
				voroi75 /= rest75;
				float smoothstepResult77 = smoothstep( _Dist_Min , _Dist_Max , voroi75);
				float2 appendResult111 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult161 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner112 = ( 1.0 * _Time.y * appendResult111 + (ase_positionWS*float3( appendResult161 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D113 = snoise( panner112*2.17 );
				simplePerlin2D113 = simplePerlin2D113*0.5 + 0.5;
				float2 appendResult165 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner137 = ( 1.0 * _Time.y * appendResult165 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode56 = tex2D( _Noise_Back, ( ( simplePerlin2D113 * _Noise_Back_Deform ) + panner137 ) );
				float4 appendResult57 = (float4(tex2DNode56.rgb , tex2DNode56.r));
				float smoothstepResult134 = smoothstep( _Intensity_Noise_Min , _Intensity_Noise_Max , (appendResult57).a);
				float2 texCoord119 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult122 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord119.x ));
				float smoothstepResult127 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord119.x - _Smooth_G ));
				float smoothstepResult144 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord119.y - _Smooth_B ));
				float smoothstepResult150 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord119.y ));
				float temp_output_135_0 = ( tex2D( _Brush_Tex, ( (texCoord78*_Tex_Scale + appendResult94) + ( smoothstepResult77 * _Dist_intensity ) ) ).r * smoothstepResult134 * ( smoothstepResult122 * smoothstepResult127 * smoothstepResult144 * smoothstepResult150 ) );
				float4 appendResult96 = (float4(( SampleGradient( gradient167, temp_output_135_0 ) * _HDR ).rgb , temp_output_135_0));
				float4 temp_output_2_0_g14 = ( appendResult96 * temp_output_135_0 );
				float smoothstepResult213 = smoothstep( 0.0 , 0.5 , temp_output_135_0);
				float4 appendResult4_g15 = (float4((temp_output_2_0_g14).rgb , smoothstepResult213));
				
				float4 Color = appendResult4_g15;

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.texCoord0.xy);
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture);
				#endif

				#if defined(DEBUG_DISPLAY)
				SurfaceData2D surfaceData;
				InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
				InputData2D inputData;
				InitializeInputData(IN.positionWS.xy, half2(IN.texCoord0.xy), inputData);
				half4 debugColor = 0;

				SETUP_DEBUG_DATA_2D(inputData, IN.positionWS);

				if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
				{
					return debugColor;
				}
				#endif

				Color *= IN.color * _RendererColor;
				return Color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "Sprite Unlit Forward"
            Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEFORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"


			sampler2D _Brush_Tex;
			sampler2D _Noise_Back;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _H_Max_degrade;
			float _H_Min_degrade;
			float _Smooth_B;
			float _B_Max_degrade;
			float _B_Min_degrade;
			float _Smooth_G;
			float _G_Max_degrade;
			float _G_Min_degrade;
			float _Smooth_D;
			float _D_Max_degrade;
			float _D_Min_degrade;
			float _Noise_Back_Scale;
			float _Noise_Back_Spped;
			float _Noise_Back_Deform;
			float _N2_Y_Scale;
			float _N2_X_Scale;
			float _N2_Back_Speed;
			float _Intensity_Noise_Max;
			float _Intensity_Noise_Min;
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Smooth_H;
			float _HDR;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			
					float2 voronoihash75( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi75( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash75( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_positionWS = TransformObjectToWorld( ( v.positionOS ).xyz );
				o.ase_texcoord3.xyz = ase_positionWS;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				Gradient gradient167 = NewGradient( 0, 3, 2, float4( 0, 0, 0, 0 ), float4( 0.2735849, 0.09803922, 0.02968139, 0.5017471 ), float4( 1, 0.7333333, 0.3058824, 1 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord78 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult94 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult162 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner82 = ( 1.0 * _Time.y * appendResult162 + ase_positionWS.xy);
				float time75 = panner82.x;
				float2 voronoiSmoothId75 = 0;
				float voronoiSmooth75 = 0.0;
				float2 coords75 = ase_positionWS.xy * _Dist_Scale;
				float2 id75 = 0;
				float2 uv75 = 0;
				float fade75 = 0.5;
				float voroi75 = 0;
				float rest75 = 0;
				for( int it75 = 0; it75 <2; it75++ ){
				voroi75 += fade75 * voronoi75( coords75, time75, id75, uv75, voronoiSmooth75,voronoiSmoothId75 );
				rest75 += fade75;
				coords75 *= 2;
				fade75 *= 0.5;
				}//Voronoi75
				voroi75 /= rest75;
				float smoothstepResult77 = smoothstep( _Dist_Min , _Dist_Max , voroi75);
				float2 appendResult111 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult161 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner112 = ( 1.0 * _Time.y * appendResult111 + (ase_positionWS*float3( appendResult161 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D113 = snoise( panner112*2.17 );
				simplePerlin2D113 = simplePerlin2D113*0.5 + 0.5;
				float2 appendResult165 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner137 = ( 1.0 * _Time.y * appendResult165 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode56 = tex2D( _Noise_Back, ( ( simplePerlin2D113 * _Noise_Back_Deform ) + panner137 ) );
				float4 appendResult57 = (float4(tex2DNode56.rgb , tex2DNode56.r));
				float smoothstepResult134 = smoothstep( _Intensity_Noise_Min , _Intensity_Noise_Max , (appendResult57).a);
				float2 texCoord119 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult122 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord119.x ));
				float smoothstepResult127 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord119.x - _Smooth_G ));
				float smoothstepResult144 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord119.y - _Smooth_B ));
				float smoothstepResult150 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord119.y ));
				float temp_output_135_0 = ( tex2D( _Brush_Tex, ( (texCoord78*_Tex_Scale + appendResult94) + ( smoothstepResult77 * _Dist_intensity ) ) ).r * smoothstepResult134 * ( smoothstepResult122 * smoothstepResult127 * smoothstepResult144 * smoothstepResult150 ) );
				float4 appendResult96 = (float4(( SampleGradient( gradient167, temp_output_135_0 ) * _HDR ).rgb , temp_output_135_0));
				float4 temp_output_2_0_g14 = ( appendResult96 * temp_output_135_0 );
				float smoothstepResult213 = smoothstep( 0.0 , 0.5 , temp_output_135_0);
				float4 appendResult4_g15 = (float4((temp_output_2_0_g14).rgb , smoothstepResult213));
				
				float4 Color = appendResult4_g15;

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif


				#if defined(DEBUG_DISPLAY)
					SurfaceData2D surfaceData;
					InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
					InputData2D inputData;
					InitializeInputData(IN.positionWS.xy, half2(IN.texCoord0.xy), inputData);
					half4 debugColor = 0;

					SETUP_DEBUG_DATA_2D(inputData, IN.positionWS);

					if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
					{
						return debugColor;
					}
				#endif

				Color *= IN.color * _RendererColor;
				return Color;
			}

			ENDHLSL
		}
		
        Pass
        {
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }

            Cull Off

            HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENESELECTIONPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"


			sampler2D _Brush_Tex;
			sampler2D _Noise_Back;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _H_Max_degrade;
			float _H_Min_degrade;
			float _Smooth_B;
			float _B_Max_degrade;
			float _B_Min_degrade;
			float _Smooth_G;
			float _G_Max_degrade;
			float _G_Min_degrade;
			float _Smooth_D;
			float _D_Max_degrade;
			float _D_Min_degrade;
			float _Noise_Back_Scale;
			float _Noise_Back_Spped;
			float _Noise_Back_Deform;
			float _N2_Y_Scale;
			float _N2_X_Scale;
			float _N2_Back_Speed;
			float _Intensity_Noise_Max;
			float _Intensity_Noise_Min;
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Smooth_H;
			float _HDR;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            int _ObjectId;
            int _PassValue;

			
					float2 voronoihash75( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi75( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash75( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_positionWS = TransformObjectToWorld( ( v.positionOS ).xyz );
				o.ase_texcoord1.xyz = ase_positionWS;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN) : SV_TARGET
			{
				Gradient gradient167 = NewGradient( 0, 3, 2, float4( 0, 0, 0, 0 ), float4( 0.2735849, 0.09803922, 0.02968139, 0.5017471 ), float4( 1, 0.7333333, 0.3058824, 1 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord78 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult94 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult162 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner82 = ( 1.0 * _Time.y * appendResult162 + ase_positionWS.xy);
				float time75 = panner82.x;
				float2 voronoiSmoothId75 = 0;
				float voronoiSmooth75 = 0.0;
				float2 coords75 = ase_positionWS.xy * _Dist_Scale;
				float2 id75 = 0;
				float2 uv75 = 0;
				float fade75 = 0.5;
				float voroi75 = 0;
				float rest75 = 0;
				for( int it75 = 0; it75 <2; it75++ ){
				voroi75 += fade75 * voronoi75( coords75, time75, id75, uv75, voronoiSmooth75,voronoiSmoothId75 );
				rest75 += fade75;
				coords75 *= 2;
				fade75 *= 0.5;
				}//Voronoi75
				voroi75 /= rest75;
				float smoothstepResult77 = smoothstep( _Dist_Min , _Dist_Max , voroi75);
				float2 appendResult111 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult161 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner112 = ( 1.0 * _Time.y * appendResult111 + (ase_positionWS*float3( appendResult161 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D113 = snoise( panner112*2.17 );
				simplePerlin2D113 = simplePerlin2D113*0.5 + 0.5;
				float2 appendResult165 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner137 = ( 1.0 * _Time.y * appendResult165 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode56 = tex2D( _Noise_Back, ( ( simplePerlin2D113 * _Noise_Back_Deform ) + panner137 ) );
				float4 appendResult57 = (float4(tex2DNode56.rgb , tex2DNode56.r));
				float smoothstepResult134 = smoothstep( _Intensity_Noise_Min , _Intensity_Noise_Max , (appendResult57).a);
				float2 texCoord119 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult122 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord119.x ));
				float smoothstepResult127 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord119.x - _Smooth_G ));
				float smoothstepResult144 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord119.y - _Smooth_B ));
				float smoothstepResult150 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord119.y ));
				float temp_output_135_0 = ( tex2D( _Brush_Tex, ( (texCoord78*_Tex_Scale + appendResult94) + ( smoothstepResult77 * _Dist_intensity ) ) ).r * smoothstepResult134 * ( smoothstepResult122 * smoothstepResult127 * smoothstepResult144 * smoothstepResult150 ) );
				float4 appendResult96 = (float4(( SampleGradient( gradient167, temp_output_135_0 ) * _HDR ).rgb , temp_output_135_0));
				float4 temp_output_2_0_g14 = ( appendResult96 * temp_output_135_0 );
				float smoothstepResult213 = smoothstep( 0.0 , 0.5 , temp_output_135_0);
				float4 appendResult4_g15 = (float4((temp_output_2_0_g14).rgb , smoothstepResult213));
				
				float4 Color = appendResult4_g15;

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}

            ENDHLSL
        }

		
        Pass
        {
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

			Cull Off

            HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENEPICKINGPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        	#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"


			sampler2D _Brush_Tex;
			sampler2D _Noise_Back;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _H_Max_degrade;
			float _H_Min_degrade;
			float _Smooth_B;
			float _B_Max_degrade;
			float _B_Min_degrade;
			float _Smooth_G;
			float _G_Max_degrade;
			float _G_Min_degrade;
			float _Smooth_D;
			float _D_Max_degrade;
			float _D_Min_degrade;
			float _Noise_Back_Scale;
			float _Noise_Back_Spped;
			float _Noise_Back_Deform;
			float _N2_Y_Scale;
			float _N2_X_Scale;
			float _N2_Back_Speed;
			float _Intensity_Noise_Max;
			float _Intensity_Noise_Min;
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Smooth_H;
			float _HDR;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			
					float2 voronoihash75( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi75( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash75( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_positionWS = TransformObjectToWorld( ( v.positionOS ).xyz );
				o.ase_texcoord1.xyz = ase_positionWS;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				Gradient gradient167 = NewGradient( 0, 3, 2, float4( 0, 0, 0, 0 ), float4( 0.2735849, 0.09803922, 0.02968139, 0.5017471 ), float4( 1, 0.7333333, 0.3058824, 1 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord78 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult94 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult162 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner82 = ( 1.0 * _Time.y * appendResult162 + ase_positionWS.xy);
				float time75 = panner82.x;
				float2 voronoiSmoothId75 = 0;
				float voronoiSmooth75 = 0.0;
				float2 coords75 = ase_positionWS.xy * _Dist_Scale;
				float2 id75 = 0;
				float2 uv75 = 0;
				float fade75 = 0.5;
				float voroi75 = 0;
				float rest75 = 0;
				for( int it75 = 0; it75 <2; it75++ ){
				voroi75 += fade75 * voronoi75( coords75, time75, id75, uv75, voronoiSmooth75,voronoiSmoothId75 );
				rest75 += fade75;
				coords75 *= 2;
				fade75 *= 0.5;
				}//Voronoi75
				voroi75 /= rest75;
				float smoothstepResult77 = smoothstep( _Dist_Min , _Dist_Max , voroi75);
				float2 appendResult111 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult161 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner112 = ( 1.0 * _Time.y * appendResult111 + (ase_positionWS*float3( appendResult161 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D113 = snoise( panner112*2.17 );
				simplePerlin2D113 = simplePerlin2D113*0.5 + 0.5;
				float2 appendResult165 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner137 = ( 1.0 * _Time.y * appendResult165 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode56 = tex2D( _Noise_Back, ( ( simplePerlin2D113 * _Noise_Back_Deform ) + panner137 ) );
				float4 appendResult57 = (float4(tex2DNode56.rgb , tex2DNode56.r));
				float smoothstepResult134 = smoothstep( _Intensity_Noise_Min , _Intensity_Noise_Max , (appendResult57).a);
				float2 texCoord119 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult122 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord119.x ));
				float smoothstepResult127 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord119.x - _Smooth_G ));
				float smoothstepResult144 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord119.y - _Smooth_B ));
				float smoothstepResult150 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord119.y ));
				float temp_output_135_0 = ( tex2D( _Brush_Tex, ( (texCoord78*_Tex_Scale + appendResult94) + ( smoothstepResult77 * _Dist_intensity ) ) ).r * smoothstepResult134 * ( smoothstepResult122 * smoothstepResult127 * smoothstepResult144 * smoothstepResult150 ) );
				float4 appendResult96 = (float4(( SampleGradient( gradient167, temp_output_135_0 ) * _HDR ).rgb , temp_output_135_0));
				float4 temp_output_2_0_g14 = ( appendResult96 * temp_output_135_0 );
				float smoothstepResult213 = smoothstep( 0.0 , 0.5 , temp_output_135_0);
				float4 appendResult4_g15 = (float4((temp_output_2_0_g14).rgb , smoothstepResult213));
				
				float4 Color = appendResult4_g15;
				half4 outColor = _SelectionID;
				return outColor;
			}

            ENDHLSL
        }
		
	}
	CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.CommentaryNode;118;-2304,-1168;Inherit;False;2414;707;Noise_Back;20;108;109;110;111;112;113;114;115;117;57;56;136;137;157;159;160;161;163;164;214;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-2272,-832;Inherit;False;Property;_N2_Y_Scale;N2_Y_Scale;26;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-2272,-912;Inherit;False;Property;_N2_X_Scale;N2_X_Scale;28;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;-2080,-928;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;157;-2256,-1072;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;109;-2128,-736;Inherit;False;Property;_N2_Back_Speed;N2_Back_Speed;9;0;Create;True;0;0;0;False;0;False;0.06;-0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;-1824,-800;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;93;-3136,288;Inherit;False;1518;675;Noise;10;83;88;87;82;84;86;85;77;75;162;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;110;-1904,-1040;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;112;-1616,-1040;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.06,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;163;-1648,-672;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;138;-1424,-416;Inherit;False;Property;_Noise_Back_Spped;Noise_Back_Spped;15;0;Create;True;0;0;0;False;0;False;0;-0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3104,512;Inherit;False;Property;_Dist_Pan_Speed;Dist_Pan_Speed;8;0;Create;True;0;0;0;False;0;False;1;-3.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1616,-512;Inherit;False;Property;_Noise_Back_Scale;Noise_Back_Scale;16;0;Create;True;0;0;0;False;0;False;1.83;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;88;-3088,336;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;76;-1920,176;Inherit;False;Property;_Dist_intensity;Dist_intensity;0;0;Create;True;0;0;0;False;0;False;0.5032024;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1920,16;Inherit;False;Property;_Divide_Offset;Divide_Offset;13;0;Create;True;0;0;0;False;0;False;4.7;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;113;-1344,-1040;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.17;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1440,-768;Inherit;False;Property;_Noise_Back_Deform;Noise_Back_Deform;2;0;Create;True;0;0;0;False;0;False;0.03789261;0.029;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;162;-2848,512;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;164;-1296,-672;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;165;-1184,-512;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;82;-2640,464;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;91;-1520,96;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1040,-960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;137;-1040,-720;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2624,736;Inherit;False;Property;_Dist_Scale;Dist_Scale;12;0;Create;True;0;0;0;False;0;False;1;2.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;75;-2288,432;Inherit;True;0;0;1;0;2;True;4;False;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NegateNode;90;-1328,80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-1136,736;Inherit;False;1275;723;Degrade;11;119;120;121;123;125;126;127;122;139;140;141;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-864,-896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2224,752;Inherit;False;Property;_Dist_Min;Dist_Min;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2192,848;Inherit;False;Property;_Dist_Max;Dist_Max;10;0;Create;True;0;0;0;False;0;False;1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;77;-1872,416;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-1136,32;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-1328,-272;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;56;-688,-912;Inherit;True;Property;_Noise_Back;Noise_Back;1;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;9a2e1e543103aaa44a58c847f43f3ab5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TextureCoordinatesNode;119;-1040,1024;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;120;-1072,800;Inherit;False;Property;_Smooth_D;Smooth_D;3;0;Create;True;0;0;0;False;0;False;0.9728891;1.12;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1056,1296;Inherit;False;Property;_Smooth_G;Smooth_G;6;0;Create;True;0;0;0;False;0;False;0.9714883;0.41;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-1024,1552;Inherit;False;Property;_Smooth_B;Smooth_B;4;0;Create;True;0;0;0;False;0;False;0.9714883;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-1120,1888;Inherit;False;Property;_Smooth_H;Smooth_H;5;0;Create;True;0;0;0;False;0;False;0.9714883;1.31093;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;101;-1360,-112;Inherit;False;Property;_Tex_Scale;Tex_Scale;14;0;Create;True;0;0;0;False;0;False;1,1;4.23,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-1024,304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;89;-928,-16;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-352,-912;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;126;-656,1152;Inherit;True;2;0;FLOAT;0.93;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;121;-672,768;Inherit;True;2;0;FLOAT;0.93;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-608,992;Inherit;False;Property;_D_Min_degrade;D_Min_degrade;17;0;Create;True;0;0;0;False;0;False;0.15;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-608,1072;Inherit;False;Property;_D_Max_degrade;D_Max_degrade;20;0;Create;True;0;0;0;False;0;False;0.46;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-640,1376;Inherit;False;Property;_G_Min_degrade;G_Min_degrade;18;0;Create;True;0;0;0;False;0;False;0;-0.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-640,1456;Inherit;False;Property;_G_Max_degrade;G_Max_degrade;19;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;143;-640,1536;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-608,1760;Inherit;False;Property;_B_Min_degrade;B_Min_degrade;21;0;Create;True;0;0;0;False;0;False;-0.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-560,1840;Inherit;False;Property;_B_Max_degrade;B_Max_degrade;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;148;-752,1888;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-640,2192;Inherit;False;Property;_H_Max_degrade;H_Max_degrade;24;0;Create;True;0;0;0;False;0;False;0.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-688,2112;Inherit;False;Property;_H_Min_degrade;H_Min_degrade;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-576,16;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;133;-80,-912;Inherit;True;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;122;-368,768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;127;-400,1152;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.67;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;144;-368,1536;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;150;-384,1904;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-192,-496;Inherit;False;Property;_Intensity_Noise_Max;Intensity_Noise_Max;25;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-192,-576;Inherit;False;Property;_Intensity_Noise_Min;Intensity_Noise_Min;27;0;Create;True;0;0;0;False;0;False;0;-1.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-272,-112;Inherit;True;Property;_Brush_Tex;_Brush_Tex;7;0;Create;True;0;0;0;False;0;False;-1;8956793f9998699479029495a21097c3;9ca0bd696107918428e1f750a8a41cab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;134;176,-816;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1.37;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-64,1056;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;512,-480;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;167;480,-864;Inherit;False;0;3;2;0,0,0,0;0.2735849,0.09803922,0.02968139,0.5017471;1,0.7333333,0.3058824,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;166;768,-608;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;154;928,-320;Inherit;False;Property;_HDR;HDR;29;0;Create;True;0;0;0;False;0;False;0.75;15.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;1120,-608;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;96;1376,-624;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;1632,-528;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;213;1472,-32;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;183;1872,-384;Inherit;True;Alpha Split;-1;;14;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;84;-2992,688;Inherit;True;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-2288,-1200;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;212;2400,208;Inherit;True;Alpha Merge;-1;;15;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2800,-64;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;SH_Plateform_Sketch;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;161;0;159;0
WireConnection;161;1;160;0
WireConnection;111;1;109;0
WireConnection;110;0;157;0
WireConnection;110;1;161;0
WireConnection;112;0;110;0
WireConnection;112;2;111;0
WireConnection;113;0;112;0
WireConnection;162;1;83;0
WireConnection;164;0;163;0
WireConnection;164;1;136;0
WireConnection;165;1;138;0
WireConnection;82;0;88;0
WireConnection;82;2;162;0
WireConnection;91;0;76;0
WireConnection;91;1;95;0
WireConnection;115;0;113;0
WireConnection;115;1;114;0
WireConnection;137;0;164;0
WireConnection;137;2;165;0
WireConnection;75;0;88;0
WireConnection;75;1;82;0
WireConnection;75;2;87;0
WireConnection;90;0;91;0
WireConnection;117;0;115;0
WireConnection;117;1;137;0
WireConnection;77;0;75;0
WireConnection;77;1;85;0
WireConnection;77;2;86;0
WireConnection;94;1;90;0
WireConnection;56;1;117;0
WireConnection;79;0;77;0
WireConnection;79;1;76;0
WireConnection;89;0;78;0
WireConnection;89;1;101;0
WireConnection;89;2;94;0
WireConnection;57;0;56;5
WireConnection;57;3;56;1
WireConnection;126;0;119;1
WireConnection;126;1;125;0
WireConnection;121;0;120;0
WireConnection;121;1;119;1
WireConnection;143;0;119;2
WireConnection;143;1;145;0
WireConnection;148;0;149;0
WireConnection;148;1;119;2
WireConnection;80;0;89;0
WireConnection;80;1;79;0
WireConnection;133;0;57;0
WireConnection;122;0;121;0
WireConnection;122;1;139;0
WireConnection;122;2;140;0
WireConnection;127;0;126;0
WireConnection;127;1;141;0
WireConnection;127;2;142;0
WireConnection;144;0;143;0
WireConnection;144;1;146;0
WireConnection;144;2;147;0
WireConnection;150;0;148;0
WireConnection;150;1;151;0
WireConnection;150;2;152;0
WireConnection;81;1;80;0
WireConnection;134;0;133;0
WireConnection;134;1;214;0
WireConnection;134;2;215;0
WireConnection;123;0;122;0
WireConnection;123;1;127;0
WireConnection;123;2;144;0
WireConnection;123;3;150;0
WireConnection;135;0;81;1
WireConnection;135;1;134;0
WireConnection;135;2;123;0
WireConnection;166;0;167;0
WireConnection;166;1;135;0
WireConnection;153;0;166;0
WireConnection;153;1;154;0
WireConnection;96;0;153;0
WireConnection;96;3;135;0
WireConnection;168;0;96;0
WireConnection;168;1;135;0
WireConnection;213;0;135;0
WireConnection;183;2;168;0
WireConnection;212;2;183;0
WireConnection;212;3;213;0
WireConnection;0;1;212;0
ASEEND*/
//CHKSM=DB680FDD2637EEE6181908421740DC13486749F0