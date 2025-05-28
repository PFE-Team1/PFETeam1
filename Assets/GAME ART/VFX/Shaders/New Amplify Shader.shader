// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_Dist_intensity("Dist_intensity", Range( 0 , 1)) = 0.5032024
		_Disolve_Cursor2("Disolve_Cursor", Float) = 0.37
		_Noise_Back("Noise_Back", 2D) = "white" {}
		_Noise_Scale1("Noise_Scale", Float) = 4.35
		_Noise_Back_Deform("Noise_Back_Deform", Range( 0 , 1)) = 0.03789261
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
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
		_B_Min_degrade("B_Min_degrade", Float) = 0
		_B_Max_degrade("B_Max_degrade", Float) = 0
		_H_Min_degrade("H_Min_degrade", Float) = 0
		_H_Max_degrade("H_Max_degrade", Float) = 0
		_N2_Y_Scale("N2_Y_Scale", Float) = 0
		_N2_X_Scale("N2_X_Scale", Float) = 0
		_HDR("HDR", Float) = 0

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
			sampler2D _TextureSample2;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _HDR;
			float _Smooth_H;
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
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Noise_Scale1;
			float _Disolve_Cursor2;
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

			
					float2 voronoihash34( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi34( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash34( n + g );
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

				Gradient gradient72 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord41 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult40 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult26 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner29 = ( 1.0 * _Time.y * appendResult26 + ase_positionWS.xy);
				float time34 = panner29.x;
				float2 voronoiSmoothId34 = 0;
				float voronoiSmooth34 = 0.0;
				float2 coords34 = ase_positionWS.xy * _Dist_Scale;
				float2 id34 = 0;
				float2 uv34 = 0;
				float fade34 = 0.5;
				float voroi34 = 0;
				float rest34 = 0;
				for( int it34 = 0; it34 <2; it34++ ){
				voroi34 += fade34 * voronoi34( coords34, time34, id34, uv34, voronoiSmooth34,voronoiSmoothId34 );
				rest34 += fade34;
				coords34 *= 2;
				fade34 *= 0.5;
				}//Voronoi34
				voroi34 /= rest34;
				float smoothstepResult39 = smoothstep( _Dist_Min , _Dist_Max , voroi34);
				float2 appendResult14 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult11 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner16 = ( 1.0 * _Time.y * appendResult14 + (ase_positionWS*float3( appendResult11 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D24 = snoise( panner16*2.17 );
				simplePerlin2D24 = simplePerlin2D24*0.5 + 0.5;
				float2 appendResult28 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner32 = ( 1.0 * _Time.y * appendResult28 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode42 = tex2D( _Noise_Back, ( ( simplePerlin2D24 * _Noise_Back_Deform ) + panner32 ) );
				float4 appendResult51 = (float4(tex2DNode42.rgb , tex2DNode42.r));
				float smoothstepResult69 = smoothstep( 1.37 , 0.0 , (appendResult51).a);
				float2 texCoord43 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult64 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord43.x ));
				float smoothstepResult65 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord43.x - _Smooth_G ));
				float smoothstepResult66 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord43.y - _Smooth_B ));
				float smoothstepResult67 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord43.y ));
				float temp_output_71_0 = ( tex2D( _Brush_Tex, ( (texCoord41*_Tex_Scale + appendResult40) + ( smoothstepResult39 * _Dist_intensity ) ) ).r * smoothstepResult69 * ( smoothstepResult64 * smoothstepResult65 * smoothstepResult66 * smoothstepResult67 ) );
				float4 appendResult76 = (float4(( SampleGradient( gradient72, temp_output_71_0 ) * _HDR ).rgb , temp_output_71_0));
				float2 temp_cast_8 = (_Noise_Scale1).xx;
				float2 texCoord84 = IN.texCoord0.xy * temp_cast_8 + float2( 0,0 );
				float temp_output_89_0 = ( tex2D( _TextureSample2, texCoord84 ).r + 0.0 );
				float2 temp_output_34_0_g4 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g4 = temp_output_34_0_g4;
				float2 appendResult50_g4 = (float2(( 1.0 * ( length( temp_output_34_0_g4 ) * 2.0 ) ) , ( ( atan2( break39_g4.x , break39_g4.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float temp_output_2_0_g5 = step( ( 1.0 - temp_output_89_0 ) , ( appendResult50_g4.x + _Disolve_Cursor2 ) );
				float4 appendResult4_g6 = (float4(( appendResult76 * temp_output_71_0 ).rgb , ( (temp_output_2_0_g5).x * 0.0 )));
				
				float4 Color = appendResult4_g6;

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
			sampler2D _TextureSample2;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _HDR;
			float _Smooth_H;
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
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Noise_Scale1;
			float _Disolve_Cursor2;
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

			
					float2 voronoihash34( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi34( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash34( n + g );
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

				Gradient gradient72 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord41 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult40 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult26 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner29 = ( 1.0 * _Time.y * appendResult26 + ase_positionWS.xy);
				float time34 = panner29.x;
				float2 voronoiSmoothId34 = 0;
				float voronoiSmooth34 = 0.0;
				float2 coords34 = ase_positionWS.xy * _Dist_Scale;
				float2 id34 = 0;
				float2 uv34 = 0;
				float fade34 = 0.5;
				float voroi34 = 0;
				float rest34 = 0;
				for( int it34 = 0; it34 <2; it34++ ){
				voroi34 += fade34 * voronoi34( coords34, time34, id34, uv34, voronoiSmooth34,voronoiSmoothId34 );
				rest34 += fade34;
				coords34 *= 2;
				fade34 *= 0.5;
				}//Voronoi34
				voroi34 /= rest34;
				float smoothstepResult39 = smoothstep( _Dist_Min , _Dist_Max , voroi34);
				float2 appendResult14 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult11 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner16 = ( 1.0 * _Time.y * appendResult14 + (ase_positionWS*float3( appendResult11 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D24 = snoise( panner16*2.17 );
				simplePerlin2D24 = simplePerlin2D24*0.5 + 0.5;
				float2 appendResult28 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner32 = ( 1.0 * _Time.y * appendResult28 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode42 = tex2D( _Noise_Back, ( ( simplePerlin2D24 * _Noise_Back_Deform ) + panner32 ) );
				float4 appendResult51 = (float4(tex2DNode42.rgb , tex2DNode42.r));
				float smoothstepResult69 = smoothstep( 1.37 , 0.0 , (appendResult51).a);
				float2 texCoord43 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult64 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord43.x ));
				float smoothstepResult65 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord43.x - _Smooth_G ));
				float smoothstepResult66 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord43.y - _Smooth_B ));
				float smoothstepResult67 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord43.y ));
				float temp_output_71_0 = ( tex2D( _Brush_Tex, ( (texCoord41*_Tex_Scale + appendResult40) + ( smoothstepResult39 * _Dist_intensity ) ) ).r * smoothstepResult69 * ( smoothstepResult64 * smoothstepResult65 * smoothstepResult66 * smoothstepResult67 ) );
				float4 appendResult76 = (float4(( SampleGradient( gradient72, temp_output_71_0 ) * _HDR ).rgb , temp_output_71_0));
				float2 temp_cast_8 = (_Noise_Scale1).xx;
				float2 texCoord84 = IN.texCoord0.xy * temp_cast_8 + float2( 0,0 );
				float temp_output_89_0 = ( tex2D( _TextureSample2, texCoord84 ).r + 0.0 );
				float2 temp_output_34_0_g4 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g4 = temp_output_34_0_g4;
				float2 appendResult50_g4 = (float2(( 1.0 * ( length( temp_output_34_0_g4 ) * 2.0 ) ) , ( ( atan2( break39_g4.x , break39_g4.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float temp_output_2_0_g5 = step( ( 1.0 - temp_output_89_0 ) , ( appendResult50_g4.x + _Disolve_Cursor2 ) );
				float4 appendResult4_g6 = (float4(( appendResult76 * temp_output_71_0 ).rgb , ( (temp_output_2_0_g5).x * 0.0 )));
				
				float4 Color = appendResult4_g6;

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
			sampler2D _TextureSample2;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _HDR;
			float _Smooth_H;
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
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Noise_Scale1;
			float _Disolve_Cursor2;
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

			
					float2 voronoihash34( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi34( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash34( n + g );
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
				Gradient gradient72 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord41 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult40 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult26 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner29 = ( 1.0 * _Time.y * appendResult26 + ase_positionWS.xy);
				float time34 = panner29.x;
				float2 voronoiSmoothId34 = 0;
				float voronoiSmooth34 = 0.0;
				float2 coords34 = ase_positionWS.xy * _Dist_Scale;
				float2 id34 = 0;
				float2 uv34 = 0;
				float fade34 = 0.5;
				float voroi34 = 0;
				float rest34 = 0;
				for( int it34 = 0; it34 <2; it34++ ){
				voroi34 += fade34 * voronoi34( coords34, time34, id34, uv34, voronoiSmooth34,voronoiSmoothId34 );
				rest34 += fade34;
				coords34 *= 2;
				fade34 *= 0.5;
				}//Voronoi34
				voroi34 /= rest34;
				float smoothstepResult39 = smoothstep( _Dist_Min , _Dist_Max , voroi34);
				float2 appendResult14 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult11 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner16 = ( 1.0 * _Time.y * appendResult14 + (ase_positionWS*float3( appendResult11 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D24 = snoise( panner16*2.17 );
				simplePerlin2D24 = simplePerlin2D24*0.5 + 0.5;
				float2 appendResult28 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner32 = ( 1.0 * _Time.y * appendResult28 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode42 = tex2D( _Noise_Back, ( ( simplePerlin2D24 * _Noise_Back_Deform ) + panner32 ) );
				float4 appendResult51 = (float4(tex2DNode42.rgb , tex2DNode42.r));
				float smoothstepResult69 = smoothstep( 1.37 , 0.0 , (appendResult51).a);
				float2 texCoord43 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult64 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord43.x ));
				float smoothstepResult65 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord43.x - _Smooth_G ));
				float smoothstepResult66 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord43.y - _Smooth_B ));
				float smoothstepResult67 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord43.y ));
				float temp_output_71_0 = ( tex2D( _Brush_Tex, ( (texCoord41*_Tex_Scale + appendResult40) + ( smoothstepResult39 * _Dist_intensity ) ) ).r * smoothstepResult69 * ( smoothstepResult64 * smoothstepResult65 * smoothstepResult66 * smoothstepResult67 ) );
				float4 appendResult76 = (float4(( SampleGradient( gradient72, temp_output_71_0 ) * _HDR ).rgb , temp_output_71_0));
				float2 temp_cast_8 = (_Noise_Scale1).xx;
				float2 texCoord84 = IN.ase_texcoord.xy * temp_cast_8 + float2( 0,0 );
				float temp_output_89_0 = ( tex2D( _TextureSample2, texCoord84 ).r + 0.0 );
				float2 temp_output_34_0_g4 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g4 = temp_output_34_0_g4;
				float2 appendResult50_g4 = (float2(( 1.0 * ( length( temp_output_34_0_g4 ) * 2.0 ) ) , ( ( atan2( break39_g4.x , break39_g4.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float temp_output_2_0_g5 = step( ( 1.0 - temp_output_89_0 ) , ( appendResult50_g4.x + _Disolve_Cursor2 ) );
				float4 appendResult4_g6 = (float4(( appendResult76 * temp_output_71_0 ).rgb , ( (temp_output_2_0_g5).x * 0.0 )));
				
				float4 Color = appendResult4_g6;

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
			sampler2D _TextureSample2;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tex_Scale;
			float _HDR;
			float _Smooth_H;
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
			float _Dist_Pan_Speed;
			float _Dist_Scale;
			float _Dist_Max;
			float _Dist_Min;
			float _Divide_Offset;
			float _Dist_intensity;
			float _Noise_Scale1;
			float _Disolve_Cursor2;
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

			
					float2 voronoihash34( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi34( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash34( n + g );
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
				Gradient gradient72 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord41 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult40 = (float2(0.0 , -( _Dist_intensity / _Divide_Offset )));
				float2 appendResult26 = (float2(0.0 , _Dist_Pan_Speed));
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner29 = ( 1.0 * _Time.y * appendResult26 + ase_positionWS.xy);
				float time34 = panner29.x;
				float2 voronoiSmoothId34 = 0;
				float voronoiSmooth34 = 0.0;
				float2 coords34 = ase_positionWS.xy * _Dist_Scale;
				float2 id34 = 0;
				float2 uv34 = 0;
				float fade34 = 0.5;
				float voroi34 = 0;
				float rest34 = 0;
				for( int it34 = 0; it34 <2; it34++ ){
				voroi34 += fade34 * voronoi34( coords34, time34, id34, uv34, voronoiSmooth34,voronoiSmoothId34 );
				rest34 += fade34;
				coords34 *= 2;
				fade34 *= 0.5;
				}//Voronoi34
				voroi34 /= rest34;
				float smoothstepResult39 = smoothstep( _Dist_Min , _Dist_Max , voroi34);
				float2 appendResult14 = (float2(0.0 , _N2_Back_Speed));
				float2 appendResult11 = (float2(_N2_X_Scale , _N2_Y_Scale));
				float2 panner16 = ( 1.0 * _Time.y * appendResult14 + (ase_positionWS*float3( appendResult11 ,  0.0 ) + 0.0).xy);
				float simplePerlin2D24 = snoise( panner16*2.17 );
				simplePerlin2D24 = simplePerlin2D24*0.5 + 0.5;
				float2 appendResult28 = (float2(0.0 , _Noise_Back_Spped));
				float2 panner32 = ( 1.0 * _Time.y * appendResult28 + (ase_positionWS*_Noise_Back_Scale + 0.0).xy);
				float4 tex2DNode42 = tex2D( _Noise_Back, ( ( simplePerlin2D24 * _Noise_Back_Deform ) + panner32 ) );
				float4 appendResult51 = (float4(tex2DNode42.rgb , tex2DNode42.r));
				float smoothstepResult69 = smoothstep( 1.37 , 0.0 , (appendResult51).a);
				float2 texCoord43 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult64 = smoothstep( _D_Min_degrade , _D_Max_degrade , ( _Smooth_D - texCoord43.x ));
				float smoothstepResult65 = smoothstep( _G_Min_degrade , _G_Max_degrade , ( texCoord43.x - _Smooth_G ));
				float smoothstepResult66 = smoothstep( _B_Min_degrade , _B_Max_degrade , ( texCoord43.y - _Smooth_B ));
				float smoothstepResult67 = smoothstep( _H_Min_degrade , _H_Max_degrade , ( _Smooth_H - texCoord43.y ));
				float temp_output_71_0 = ( tex2D( _Brush_Tex, ( (texCoord41*_Tex_Scale + appendResult40) + ( smoothstepResult39 * _Dist_intensity ) ) ).r * smoothstepResult69 * ( smoothstepResult64 * smoothstepResult65 * smoothstepResult66 * smoothstepResult67 ) );
				float4 appendResult76 = (float4(( SampleGradient( gradient72, temp_output_71_0 ) * _HDR ).rgb , temp_output_71_0));
				float2 temp_cast_8 = (_Noise_Scale1).xx;
				float2 texCoord84 = IN.ase_texcoord.xy * temp_cast_8 + float2( 0,0 );
				float temp_output_89_0 = ( tex2D( _TextureSample2, texCoord84 ).r + 0.0 );
				float2 temp_output_34_0_g4 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g4 = temp_output_34_0_g4;
				float2 appendResult50_g4 = (float2(( 1.0 * ( length( temp_output_34_0_g4 ) * 2.0 ) ) , ( ( atan2( break39_g4.x , break39_g4.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float temp_output_2_0_g5 = step( ( 1.0 - temp_output_89_0 ) , ( appendResult50_g4.x + _Disolve_Cursor2 ) );
				float4 appendResult4_g6 = (float4(( appendResult76 * temp_output_71_0 ).rgb , ( (temp_output_2_0_g5).x * 0.0 )));
				
				float4 Color = appendResult4_g6;
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
Node;AmplifyShaderEditor.CommentaryNode;4;-2182.182,-1218.202;Inherit;False;2414;707;Noise_Back;20;63;51;42;36;32;31;28;27;25;24;20;17;16;15;14;13;12;11;10;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2150.182,-962.202;Inherit;False;Property;_N2_X_Scale;N2_X_Scale;29;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2150.182,-882.202;Inherit;False;Property;_N2_Y_Scale;N2_Y_Scale;28;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1958.182,-978.202;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-2134.182,-1122.202;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;13;-2006.182,-786.202;Inherit;False;Property;_N2_Back_Speed;N2_Back_Speed;12;0;Create;True;0;0;0;False;0;False;0.06;-0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;-3014.182,237.798;Inherit;False;1518;675;Noise;10;77;39;38;37;34;33;29;26;21;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1702.182,-850.202;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;15;-1782.182,-1090.202;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;16;-1494.182,-1090.202;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.06,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-1526.182,-722.202;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;18;-1302.182,-466.202;Inherit;False;Property;_Noise_Back_Spped;Noise_Back_Spped;18;0;Create;True;0;0;0;False;0;False;0;-0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2982.182,461.798;Inherit;False;Property;_Dist_Pan_Speed;Dist_Pan_Speed;11;0;Create;True;0;0;0;False;0;False;1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1494.182,-562.202;Inherit;False;Property;_Noise_Back_Scale;Noise_Back_Scale;19;0;Create;True;0;0;0;False;0;False;1.83;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;21;-2966.182,285.798;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;-1798.182,125.798;Inherit;False;Property;_Dist_intensity;Dist_intensity;0;0;Create;True;0;0;0;False;0;False;0.5032024;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1798.182,-34.202;Inherit;False;Property;_Divide_Offset;Divide_Offset;16;0;Create;True;0;0;0;False;0;False;4.7;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;-1222.182,-1090.202;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.17;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1318.182,-818.202;Inherit;False;Property;_Noise_Back_Deform;Noise_Back_Deform;4;0;Create;True;0;0;0;False;0;False;0.03789261;0.163;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-2726.182,461.798;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;27;-1174.182,-722.202;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1062.182,-562.202;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;29;-2518.182,413.798;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-1398.182,45.798;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-918.182,-1010.202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-918.182,-770.202;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2502.182,685.798;Inherit;False;Property;_Dist_Scale;Dist_Scale;15;0;Create;True;0;0;0;False;0;False;1;2.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-1014.182,685.798;Inherit;False;1275;723;Degrade;12;70;65;64;57;56;55;54;53;52;45;44;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;34;-2166.182,381.798;Inherit;True;0;0;1;0;2;True;4;False;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NegateNode;35;-1206.182,29.798;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-742.182,-946.202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2102.182,701.798;Inherit;False;Property;_Dist_Min;Dist_Min;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2070.182,797.798;Inherit;False;Property;_Dist_Max;Dist_Max;13;0;Create;True;0;0;0;False;0;False;1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;39;-1750.182,365.798;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1014.182,-18.202;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1206.182,-322.202;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-566.182,-962.202;Inherit;True;Property;_Noise_Back;Noise_Back;2;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;9a2e1e543103aaa44a58c847f43f3ab5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-918.182,973.798;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-950.182,749.798;Inherit;False;Property;_Smooth_D;Smooth_D;6;0;Create;True;0;0;0;False;0;False;0.9728891;1.12;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-934.182,1245.798;Inherit;False;Property;_Smooth_G;Smooth_G;9;0;Create;True;0;0;0;False;0;False;0.9714883;0.41;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-902.182,1501.798;Inherit;False;Property;_Smooth_B;Smooth_B;7;0;Create;True;0;0;0;False;0;False;0.9714883;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-998.182,1837.798;Inherit;False;Property;_Smooth_H;Smooth_H;8;0;Create;True;0;0;0;False;0;False;0.9714883;1.310932;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;48;-1238.182,-162.202;Inherit;False;Property;_Tex_Scale;Tex_Scale;17;0;Create;True;0;0;0;False;0;False;1,1;4.23,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;7;-518.182,2141.798;Inherit;False;Property;_H_Max_degrade;H_Max_degrade;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-566.182,2061.798;Inherit;False;Property;_H_Min_degrade;H_Min_degrade;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-902.182,253.798;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;50;-806.182,-66.202;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-230.182,-962.202;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-534.182,1101.798;Inherit;True;2;0;FLOAT;0.93;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-550.182,717.798;Inherit;True;2;0;FLOAT;0.93;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-486.182,941.798;Inherit;False;Property;_D_Min_degrade;D_Min_degrade;20;0;Create;True;0;0;0;False;0;False;0.15;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-486.182,1021.798;Inherit;False;Property;_D_Max_degrade;D_Max_degrade;23;0;Create;True;0;0;0;False;0;False;0.46;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-518.182,1325.798;Inherit;False;Property;_G_Min_degrade;G_Min_degrade;21;0;Create;True;0;0;0;False;0;False;0;-0.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-518.182,1405.798;Inherit;False;Property;_G_Max_degrade;G_Max_degrade;22;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-518.182,1485.798;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-486.182,1709.798;Inherit;False;Property;_B_Min_degrade;B_Min_degrade;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-438.182,1789.798;Inherit;False;Property;_B_Max_degrade;B_Max_degrade;25;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-630.182,1837.798;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;495.8694,-393.1193;Inherit;False;Property;_Noise_Scale1;Noise_Scale;3;0;Create;True;0;0;0;False;0;False;4.35;1.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-454.182,-34.202;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;63;41.81799,-962.202;Inherit;True;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;64;-246.182,717.798;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;65;-278.182,1101.798;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.67;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;66;-246.182,1485.798;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;67;-262.182,1853.798;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;719.8694,-425.1193;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;68;-150.182,-162.202;Inherit;True;Property;_Brush_Tex;_Brush_Tex;10;0;Create;True;0;0;0;False;0;False;-1;8956793f9998699479029495a21097c3;9ca0bd696107918428e1f750a8a41cab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;69;297.818,-866.202;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1.37;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;57.81799,1005.798;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;85;751.8694,22.88074;Inherit;True;Polar Coordinates;-1;;4;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;3;FLOAT2;0;FLOAT;55;FLOAT;56
Node;AmplifyShaderEditor.SamplerNode;86;1007.869,-345.1193;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;babe5b65a5abcae47aba08de105876bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;633.818,-530.202;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;72;601.818,-914.202;Inherit;False;0;7;2;1,0.9177689,0.5801887,0.07490654;1,0.6212161,0.1273585,0.2264744;1,0.8959579,0.5562341,0.3083696;1,0.6196079,0.1254902,0.4337987;1,0.9254902,0.6196079,0.6550546;1,0.6196079,0.1254902,0.9198596;1,0.9242194,0.6179246,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;1247.869,326.8807;Inherit;False;Property;_Disolve_Cursor2;Disolve_Cursor;1;0;Create;True;0;0;0;False;0;False;0.37;2.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;88;1183.869,70.88074;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;89;1359.869,-297.1193;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;73;889.818,-658.202;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;1049.818,-370.202;Inherit;False;Property;_HDR;HDR;30;0;Create;True;0;0;0;False;0;False;0;13.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;1471.869,70.88074;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;91;1695.869,-25.11926;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1241.818,-658.202;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;82;901.7164,-485.6402;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;92;1839.869,-25.11926;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;1497.818,-674.202;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;93;1999.869,-41.11926;Inherit;False;Alpha Split;-1;;5;07dab7960105b86429ac8eebd729ed6d;0;1;2;FLOAT;0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1753.818,-578.202;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;2223.869,-73.11926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2870.182,637.798;Inherit;True;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-2166.182,-1250.202;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;2000,212;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;80;1808,244;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;95;1695.869,-313.1193;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;96;2480,-384;Inherit;False;Alpha Merge;-1;;6;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2880,-448;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;14;1;13;0
WireConnection;15;0;12;0
WireConnection;15;1;11;0
WireConnection;16;0;15;0
WireConnection;16;2;14;0
WireConnection;24;0;16;0
WireConnection;26;1;19;0
WireConnection;27;0;17;0
WireConnection;27;1;20;0
WireConnection;28;1;18;0
WireConnection;29;0;21;0
WireConnection;29;2;26;0
WireConnection;30;0;22;0
WireConnection;30;1;23;0
WireConnection;31;0;24;0
WireConnection;31;1;25;0
WireConnection;32;0;27;0
WireConnection;32;2;28;0
WireConnection;34;0;21;0
WireConnection;34;1;29;0
WireConnection;34;2;33;0
WireConnection;35;0;30;0
WireConnection;36;0;31;0
WireConnection;36;1;32;0
WireConnection;39;0;34;0
WireConnection;39;1;37;0
WireConnection;39;2;38;0
WireConnection;40;1;35;0
WireConnection;42;1;36;0
WireConnection;49;0;39;0
WireConnection;49;1;22;0
WireConnection;50;0;41;0
WireConnection;50;1;48;0
WireConnection;50;2;40;0
WireConnection;51;0;42;5
WireConnection;51;3;42;1
WireConnection;52;0;43;1
WireConnection;52;1;45;0
WireConnection;53;0;44;0
WireConnection;53;1;43;1
WireConnection;58;0;43;2
WireConnection;58;1;46;0
WireConnection;61;0;47;0
WireConnection;61;1;43;2
WireConnection;62;0;50;0
WireConnection;62;1;49;0
WireConnection;63;0;51;0
WireConnection;64;0;53;0
WireConnection;64;1;54;0
WireConnection;64;2;55;0
WireConnection;65;0;52;0
WireConnection;65;1;56;0
WireConnection;65;2;57;0
WireConnection;66;0;58;0
WireConnection;66;1;59;0
WireConnection;66;2;60;0
WireConnection;67;0;61;0
WireConnection;67;1;8;0
WireConnection;67;2;7;0
WireConnection;84;0;83;0
WireConnection;68;1;62;0
WireConnection;69;0;63;0
WireConnection;70;0;64;0
WireConnection;70;1;65;0
WireConnection;70;2;66;0
WireConnection;70;3;67;0
WireConnection;86;1;84;0
WireConnection;71;0;68;1
WireConnection;71;1;69;0
WireConnection;71;2;70;0
WireConnection;88;0;85;0
WireConnection;89;0;86;1
WireConnection;73;0;72;0
WireConnection;73;1;71;0
WireConnection;90;0;88;0
WireConnection;90;1;87;0
WireConnection;91;0;89;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;82;0;71;0
WireConnection;92;0;91;0
WireConnection;92;1;90;0
WireConnection;76;0;75;0
WireConnection;76;3;82;0
WireConnection;93;2;92;0
WireConnection;81;0;76;0
WireConnection;81;1;71;0
WireConnection;94;0;93;6
WireConnection;79;1;80;0
WireConnection;95;0;89;0
WireConnection;96;2;81;0
WireConnection;96;3;94;0
WireConnection;0;1;96;0
ASEEND*/
//CHKSM=3C376C6D3D676CE2BF3AF27826A77F49569A38F4