// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Door"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_HDR("HDR", Float) = 0
		_Texture_1("Texture_1", 2D) = "white" {}
		_Texture1_Tilling("Texture1_Tilling", Vector) = (1,1,0,0)
		_Texture1_Speed("Texture1_Speed", Vector) = (-0.35,0,0,0)
		_Texture_2("Texture_2", 2D) = "white" {}
		_Texture2_Tilling("Texture2_Tilling", Vector) = (1,1,0,0)
		_Texture2_Speed("Texture2_Speed", Vector) = (-0.35,0,0,0)
		_Displacement_Texture2("Displacement_Texture2", Vector) = (0,0,0,0)
		_SmoothMin_Tex_2("SmoothMin_Tex_2", Float) = 0
		_Noise_Pan_Speed("Noise_Pan_Speed", Float) = 1
		_SmoothMax_Tex_2("SmoothMax_Tex_2", Float) = 1
		_Texture_3("Texture_3", 2D) = "white" {}
		_Texture3_Tilling("Texture3_Tilling", Vector) = (1,1,0,0)
		_Noise_Max("Noise_Max", Float) = 0.3
		_Texture3_Speed("Texture3_Speed", Vector) = (-0.35,0,0,0)
		_Noise_Min("Noise_Min", Float) = 0
		_Displacement_Texture3("Displacement_Texture3", Vector) = (0,0,0,0)
		_Noise_Scale("Noise_Scale", Float) = 1
		_SmoothMin_Tex_3("SmoothMin_Tex_3", Float) = 0
		_SmoothMax_Tex_3("SmoothMax_Tex_3", Float) = 1
		_SmoothMin2_Tex_3("SmoothMin2_Tex_3", Float) = 0
		_SmoothMax2_Tex_3("SmoothMax2_Tex_3", Float) = 1
		_Deformation("Deformation", Range( 0 , 1)) = 0.0586999
		_Noise_Paint3("Noise_Paint", 2D) = "white" {}
		_Y_Noise_Speed("Y_Noise_Speed", Float) = 0.23
		_X_Noise_Speed("X_Noise_Speed", Float) = 0.38
		_MainTex("_MainTex", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (1,1,0,0)
		_H_B_SmoothMax("H_B_SmoothMax", Float) = 1
		_H_B_SmoothMin("H_B_SmoothMin", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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


			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;
			sampler2D _Noise_Paint3;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Texture1_Tilling;
			float2 _Texture1_Speed;
			float2 _Texture2_Tilling;
			float2 _Texture2_Speed;
			float2 _Displacement_Texture2;
			float2 _Vector0;
			float2 _Displacement_Texture3;
			float2 _Texture3_Tilling;
			float2 _Texture3_Speed;
			float _X_Noise_Speed;
			float _Noise_Scale;
			float _Noise_Max;
			float _Noise_Min;
			float _H_B_SmoothMax;
			float _H_B_SmoothMin;
			float _SmoothMin_Tex_3;
			float _Noise_Pan_Speed;
			float _SmoothMax2_Tex_3;
			float _SmoothMin2_Tex_3;
			float _SmoothMax_Tex_2;
			float _SmoothMin_Tex_2;
			float _Deformation;
			float _Y_Noise_Speed;
			float _SmoothMax_Tex_3;
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
			
					float2 voronoihash167( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi167( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash167( n + g );
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

				float2 appendResult33 = (float2(_X_Noise_Speed , _Y_Noise_Speed));
				float2 texCoord29 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner34 = ( 1.0 * _Time.y * appendResult33 + (texCoord29*1.0 + 0.0));
				float simplePerlin2D35 = snoise( panner34*2.39 );
				simplePerlin2D35 = simplePerlin2D35*0.5 + 0.5;
				float temp_output_41_0 = ( simplePerlin2D35 * _Deformation );
				float2 texCoord42 = IN.texCoord0.xy * _Texture1_Tilling + ( _TimeParameters.x * _Texture1_Speed );
				float2 texCoord129 = IN.texCoord0.xy * _Texture2_Tilling + ( _TimeParameters.x * _Texture2_Speed );
				float smoothstepResult57 = smoothstep( _SmoothMin_Tex_2 , _SmoothMax_Tex_2 , tex2D( _Texture_2, ( temp_output_41_0 + texCoord129 + _Displacement_Texture2 ) ).r);
				float2 texCoord134 = IN.texCoord0.xy * _Texture3_Tilling + ( _TimeParameters.x * _Texture3_Speed );
				float smoothstepResult65 = smoothstep( _SmoothMin_Tex_3 , _SmoothMax_Tex_3 , tex2D( _Texture_3, ( temp_output_41_0 + texCoord134 + _Displacement_Texture3 ) ).r);
				float smoothstepResult68 = smoothstep( _SmoothMin2_Tex_3 , _SmoothMax2_Tex_3 , smoothstepResult65);
				float2 texCoord101 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult96 = smoothstep( -1.05 , 1.88 , ( 0.0 - texCoord101.x ));
				float2 texCoord140 = IN.texCoord0.xy * _Vector0 + float2( 0,0 );
				float smoothstepResult98 = smoothstep( -0.2 , 2.4 , tex2D( _Noise_Paint3, texCoord140 ).r);
				float smoothstepResult146 = smoothstep( -1.5 , 1.88 , ( 0.0 - texCoord101.x ));
				float smoothstepResult155 = smoothstep( 0.0 , 1.0 , ( 1.0 - texCoord101.y ));
				float smoothstepResult153 = smoothstep( 0.0 , 1.0 , ( texCoord101.y - 0.0 ));
				float smoothstepResult159 = smoothstep( _H_B_SmoothMin , _H_B_SmoothMax , ( smoothstepResult155 * smoothstepResult153 ));
				float temp_output_2_0_g1 = ( ( tex2D( _Texture_1, ( temp_output_41_0 + texCoord42 ) ).r + smoothstepResult57 + smoothstepResult68 ) * ( ( ( smoothstepResult96 * 4.0 ) - smoothstepResult98 ) * ( smoothstepResult146 * 9.64 ) ) * smoothstepResult159 );
				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g2 = (float4((temp_output_2_0_g1).xxx , ( tex2D( _MainTex, uv_MainTex ).a * (temp_output_2_0_g1).x )));
				float2 temp_cast_0 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner166 = ( 1.0 * _Time.y * temp_cast_0 + ase_positionWS.xy);
				float time167 = panner166.x;
				float2 voronoiSmoothId167 = 0;
				float voronoiSmooth167 = 0.0;
				float2 coords167 = ase_positionWS.xy * _Noise_Scale;
				float2 id167 = 0;
				float2 uv167 = 0;
				float fade167 = 0.5;
				float voroi167 = 0;
				float rest167 = 0;
				for( int it167 = 0; it167 <2; it167++ ){
				voroi167 += fade167 * voronoi167( coords167, time167, id167, uv167, voronoiSmooth167,voronoiSmoothId167 );
				rest167 += fade167;
				coords167 *= 2;
				fade167 *= 0.5;
				}//Voronoi167
				voroi167 /= rest167;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi167);
				Gradient gradient170 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord171 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient172 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( appendResult4_g2 * ( ( smoothstepResult174 * SampleGradient( gradient170, texCoord171.x ) ) + SampleGradient( gradient172, texCoord171.x ) ) * _HDR );

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


			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;
			sampler2D _Noise_Paint3;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Texture1_Tilling;
			float2 _Texture1_Speed;
			float2 _Texture2_Tilling;
			float2 _Texture2_Speed;
			float2 _Displacement_Texture2;
			float2 _Vector0;
			float2 _Displacement_Texture3;
			float2 _Texture3_Tilling;
			float2 _Texture3_Speed;
			float _X_Noise_Speed;
			float _Noise_Scale;
			float _Noise_Max;
			float _Noise_Min;
			float _H_B_SmoothMax;
			float _H_B_SmoothMin;
			float _SmoothMin_Tex_3;
			float _Noise_Pan_Speed;
			float _SmoothMax2_Tex_3;
			float _SmoothMin2_Tex_3;
			float _SmoothMax_Tex_2;
			float _SmoothMin_Tex_2;
			float _Deformation;
			float _Y_Noise_Speed;
			float _SmoothMax_Tex_3;
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
			
					float2 voronoihash167( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi167( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash167( n + g );
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

				float2 appendResult33 = (float2(_X_Noise_Speed , _Y_Noise_Speed));
				float2 texCoord29 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner34 = ( 1.0 * _Time.y * appendResult33 + (texCoord29*1.0 + 0.0));
				float simplePerlin2D35 = snoise( panner34*2.39 );
				simplePerlin2D35 = simplePerlin2D35*0.5 + 0.5;
				float temp_output_41_0 = ( simplePerlin2D35 * _Deformation );
				float2 texCoord42 = IN.texCoord0.xy * _Texture1_Tilling + ( _TimeParameters.x * _Texture1_Speed );
				float2 texCoord129 = IN.texCoord0.xy * _Texture2_Tilling + ( _TimeParameters.x * _Texture2_Speed );
				float smoothstepResult57 = smoothstep( _SmoothMin_Tex_2 , _SmoothMax_Tex_2 , tex2D( _Texture_2, ( temp_output_41_0 + texCoord129 + _Displacement_Texture2 ) ).r);
				float2 texCoord134 = IN.texCoord0.xy * _Texture3_Tilling + ( _TimeParameters.x * _Texture3_Speed );
				float smoothstepResult65 = smoothstep( _SmoothMin_Tex_3 , _SmoothMax_Tex_3 , tex2D( _Texture_3, ( temp_output_41_0 + texCoord134 + _Displacement_Texture3 ) ).r);
				float smoothstepResult68 = smoothstep( _SmoothMin2_Tex_3 , _SmoothMax2_Tex_3 , smoothstepResult65);
				float2 texCoord101 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult96 = smoothstep( -1.05 , 1.88 , ( 0.0 - texCoord101.x ));
				float2 texCoord140 = IN.texCoord0.xy * _Vector0 + float2( 0,0 );
				float smoothstepResult98 = smoothstep( -0.2 , 2.4 , tex2D( _Noise_Paint3, texCoord140 ).r);
				float smoothstepResult146 = smoothstep( -1.5 , 1.88 , ( 0.0 - texCoord101.x ));
				float smoothstepResult155 = smoothstep( 0.0 , 1.0 , ( 1.0 - texCoord101.y ));
				float smoothstepResult153 = smoothstep( 0.0 , 1.0 , ( texCoord101.y - 0.0 ));
				float smoothstepResult159 = smoothstep( _H_B_SmoothMin , _H_B_SmoothMax , ( smoothstepResult155 * smoothstepResult153 ));
				float temp_output_2_0_g1 = ( ( tex2D( _Texture_1, ( temp_output_41_0 + texCoord42 ) ).r + smoothstepResult57 + smoothstepResult68 ) * ( ( ( smoothstepResult96 * 4.0 ) - smoothstepResult98 ) * ( smoothstepResult146 * 9.64 ) ) * smoothstepResult159 );
				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g2 = (float4((temp_output_2_0_g1).xxx , ( tex2D( _MainTex, uv_MainTex ).a * (temp_output_2_0_g1).x )));
				float2 temp_cast_0 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner166 = ( 1.0 * _Time.y * temp_cast_0 + ase_positionWS.xy);
				float time167 = panner166.x;
				float2 voronoiSmoothId167 = 0;
				float voronoiSmooth167 = 0.0;
				float2 coords167 = ase_positionWS.xy * _Noise_Scale;
				float2 id167 = 0;
				float2 uv167 = 0;
				float fade167 = 0.5;
				float voroi167 = 0;
				float rest167 = 0;
				for( int it167 = 0; it167 <2; it167++ ){
				voroi167 += fade167 * voronoi167( coords167, time167, id167, uv167, voronoiSmooth167,voronoiSmoothId167 );
				rest167 += fade167;
				coords167 *= 2;
				fade167 *= 0.5;
				}//Voronoi167
				voroi167 /= rest167;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi167);
				Gradient gradient170 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord171 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient172 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( appendResult4_g2 * ( ( smoothstepResult174 * SampleGradient( gradient170, texCoord171.x ) ) + SampleGradient( gradient172, texCoord171.x ) ) * _HDR );

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


			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;
			sampler2D _Noise_Paint3;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Texture1_Tilling;
			float2 _Texture1_Speed;
			float2 _Texture2_Tilling;
			float2 _Texture2_Speed;
			float2 _Displacement_Texture2;
			float2 _Vector0;
			float2 _Displacement_Texture3;
			float2 _Texture3_Tilling;
			float2 _Texture3_Speed;
			float _X_Noise_Speed;
			float _Noise_Scale;
			float _Noise_Max;
			float _Noise_Min;
			float _H_B_SmoothMax;
			float _H_B_SmoothMin;
			float _SmoothMin_Tex_3;
			float _Noise_Pan_Speed;
			float _SmoothMax2_Tex_3;
			float _SmoothMin2_Tex_3;
			float _SmoothMax_Tex_2;
			float _SmoothMin_Tex_2;
			float _Deformation;
			float _Y_Noise_Speed;
			float _SmoothMax_Tex_3;
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
			
					float2 voronoihash167( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi167( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash167( n + g );
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
				float2 appendResult33 = (float2(_X_Noise_Speed , _Y_Noise_Speed));
				float2 texCoord29 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner34 = ( 1.0 * _Time.y * appendResult33 + (texCoord29*1.0 + 0.0));
				float simplePerlin2D35 = snoise( panner34*2.39 );
				simplePerlin2D35 = simplePerlin2D35*0.5 + 0.5;
				float temp_output_41_0 = ( simplePerlin2D35 * _Deformation );
				float2 texCoord42 = IN.ase_texcoord.xy * _Texture1_Tilling + ( _TimeParameters.x * _Texture1_Speed );
				float2 texCoord129 = IN.ase_texcoord.xy * _Texture2_Tilling + ( _TimeParameters.x * _Texture2_Speed );
				float smoothstepResult57 = smoothstep( _SmoothMin_Tex_2 , _SmoothMax_Tex_2 , tex2D( _Texture_2, ( temp_output_41_0 + texCoord129 + _Displacement_Texture2 ) ).r);
				float2 texCoord134 = IN.ase_texcoord.xy * _Texture3_Tilling + ( _TimeParameters.x * _Texture3_Speed );
				float smoothstepResult65 = smoothstep( _SmoothMin_Tex_3 , _SmoothMax_Tex_3 , tex2D( _Texture_3, ( temp_output_41_0 + texCoord134 + _Displacement_Texture3 ) ).r);
				float smoothstepResult68 = smoothstep( _SmoothMin2_Tex_3 , _SmoothMax2_Tex_3 , smoothstepResult65);
				float2 texCoord101 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult96 = smoothstep( -1.05 , 1.88 , ( 0.0 - texCoord101.x ));
				float2 texCoord140 = IN.ase_texcoord.xy * _Vector0 + float2( 0,0 );
				float smoothstepResult98 = smoothstep( -0.2 , 2.4 , tex2D( _Noise_Paint3, texCoord140 ).r);
				float smoothstepResult146 = smoothstep( -1.5 , 1.88 , ( 0.0 - texCoord101.x ));
				float smoothstepResult155 = smoothstep( 0.0 , 1.0 , ( 1.0 - texCoord101.y ));
				float smoothstepResult153 = smoothstep( 0.0 , 1.0 , ( texCoord101.y - 0.0 ));
				float smoothstepResult159 = smoothstep( _H_B_SmoothMin , _H_B_SmoothMax , ( smoothstepResult155 * smoothstepResult153 ));
				float temp_output_2_0_g1 = ( ( tex2D( _Texture_1, ( temp_output_41_0 + texCoord42 ) ).r + smoothstepResult57 + smoothstepResult68 ) * ( ( ( smoothstepResult96 * 4.0 ) - smoothstepResult98 ) * ( smoothstepResult146 * 9.64 ) ) * smoothstepResult159 );
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g2 = (float4((temp_output_2_0_g1).xxx , ( tex2D( _MainTex, uv_MainTex ).a * (temp_output_2_0_g1).x )));
				float2 temp_cast_0 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner166 = ( 1.0 * _Time.y * temp_cast_0 + ase_positionWS.xy);
				float time167 = panner166.x;
				float2 voronoiSmoothId167 = 0;
				float voronoiSmooth167 = 0.0;
				float2 coords167 = ase_positionWS.xy * _Noise_Scale;
				float2 id167 = 0;
				float2 uv167 = 0;
				float fade167 = 0.5;
				float voroi167 = 0;
				float rest167 = 0;
				for( int it167 = 0; it167 <2; it167++ ){
				voroi167 += fade167 * voronoi167( coords167, time167, id167, uv167, voronoiSmooth167,voronoiSmoothId167 );
				rest167 += fade167;
				coords167 *= 2;
				fade167 *= 0.5;
				}//Voronoi167
				voroi167 /= rest167;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi167);
				Gradient gradient170 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord171 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient172 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( appendResult4_g2 * ( ( smoothstepResult174 * SampleGradient( gradient170, texCoord171.x ) ) + SampleGradient( gradient172, texCoord171.x ) ) * _HDR );

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


			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;
			sampler2D _Noise_Paint3;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Texture1_Tilling;
			float2 _Texture1_Speed;
			float2 _Texture2_Tilling;
			float2 _Texture2_Speed;
			float2 _Displacement_Texture2;
			float2 _Vector0;
			float2 _Displacement_Texture3;
			float2 _Texture3_Tilling;
			float2 _Texture3_Speed;
			float _X_Noise_Speed;
			float _Noise_Scale;
			float _Noise_Max;
			float _Noise_Min;
			float _H_B_SmoothMax;
			float _H_B_SmoothMin;
			float _SmoothMin_Tex_3;
			float _Noise_Pan_Speed;
			float _SmoothMax2_Tex_3;
			float _SmoothMin2_Tex_3;
			float _SmoothMax_Tex_2;
			float _SmoothMin_Tex_2;
			float _Deformation;
			float _Y_Noise_Speed;
			float _SmoothMax_Tex_3;
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
			
					float2 voronoihash167( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi167( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash167( n + g );
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
				float2 appendResult33 = (float2(_X_Noise_Speed , _Y_Noise_Speed));
				float2 texCoord29 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner34 = ( 1.0 * _Time.y * appendResult33 + (texCoord29*1.0 + 0.0));
				float simplePerlin2D35 = snoise( panner34*2.39 );
				simplePerlin2D35 = simplePerlin2D35*0.5 + 0.5;
				float temp_output_41_0 = ( simplePerlin2D35 * _Deformation );
				float2 texCoord42 = IN.ase_texcoord.xy * _Texture1_Tilling + ( _TimeParameters.x * _Texture1_Speed );
				float2 texCoord129 = IN.ase_texcoord.xy * _Texture2_Tilling + ( _TimeParameters.x * _Texture2_Speed );
				float smoothstepResult57 = smoothstep( _SmoothMin_Tex_2 , _SmoothMax_Tex_2 , tex2D( _Texture_2, ( temp_output_41_0 + texCoord129 + _Displacement_Texture2 ) ).r);
				float2 texCoord134 = IN.ase_texcoord.xy * _Texture3_Tilling + ( _TimeParameters.x * _Texture3_Speed );
				float smoothstepResult65 = smoothstep( _SmoothMin_Tex_3 , _SmoothMax_Tex_3 , tex2D( _Texture_3, ( temp_output_41_0 + texCoord134 + _Displacement_Texture3 ) ).r);
				float smoothstepResult68 = smoothstep( _SmoothMin2_Tex_3 , _SmoothMax2_Tex_3 , smoothstepResult65);
				float2 texCoord101 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult96 = smoothstep( -1.05 , 1.88 , ( 0.0 - texCoord101.x ));
				float2 texCoord140 = IN.ase_texcoord.xy * _Vector0 + float2( 0,0 );
				float smoothstepResult98 = smoothstep( -0.2 , 2.4 , tex2D( _Noise_Paint3, texCoord140 ).r);
				float smoothstepResult146 = smoothstep( -1.5 , 1.88 , ( 0.0 - texCoord101.x ));
				float smoothstepResult155 = smoothstep( 0.0 , 1.0 , ( 1.0 - texCoord101.y ));
				float smoothstepResult153 = smoothstep( 0.0 , 1.0 , ( texCoord101.y - 0.0 ));
				float smoothstepResult159 = smoothstep( _H_B_SmoothMin , _H_B_SmoothMax , ( smoothstepResult155 * smoothstepResult153 ));
				float temp_output_2_0_g1 = ( ( tex2D( _Texture_1, ( temp_output_41_0 + texCoord42 ) ).r + smoothstepResult57 + smoothstepResult68 ) * ( ( ( smoothstepResult96 * 4.0 ) - smoothstepResult98 ) * ( smoothstepResult146 * 9.64 ) ) * smoothstepResult159 );
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g2 = (float4((temp_output_2_0_g1).xxx , ( tex2D( _MainTex, uv_MainTex ).a * (temp_output_2_0_g1).x )));
				float2 temp_cast_0 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner166 = ( 1.0 * _Time.y * temp_cast_0 + ase_positionWS.xy);
				float time167 = panner166.x;
				float2 voronoiSmoothId167 = 0;
				float voronoiSmooth167 = 0.0;
				float2 coords167 = ase_positionWS.xy * _Noise_Scale;
				float2 id167 = 0;
				float2 uv167 = 0;
				float fade167 = 0.5;
				float voroi167 = 0;
				float rest167 = 0;
				for( int it167 = 0; it167 <2; it167++ ){
				voroi167 += fade167 * voronoi167( coords167, time167, id167, uv167, voronoiSmooth167,voronoiSmoothId167 );
				rest167 += fade167;
				coords167 *= 2;
				fade167 *= 0.5;
				}//Voronoi167
				voroi167 /= rest167;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi167);
				Gradient gradient170 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord171 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient172 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( appendResult4_g2 * ( ( smoothstepResult174 * SampleGradient( gradient170, texCoord171.x ) ) + SampleGradient( gradient172, texCoord171.x ) ) * _HDR );
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-2000,-656;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1840,-320;Inherit;False;Property;_Y_Noise_Speed;Y_Noise_Speed;24;0;Create;True;0;0;0;False;0;False;0.23;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1856,-400;Inherit;False;Property;_X_Noise_Speed;X_Noise_Speed;25;0;Create;True;0;0;0;False;0;False;0.38;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-1600,-400;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;32;-1648,-576;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;34;-1360,-576;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.06,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;130;-1552,528;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;131;-1600,608;Inherit;False;Property;_Texture3_Speed;Texture3_Speed;14;0;Create;True;0;0;0;False;0;False;-0.35,0;-0.1,0.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;35;-1088,-576;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.39;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1344,576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;125;-1600,144;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;126;-1648,224;Inherit;False;Property;_Texture2_Speed;Texture2_Speed;6;0;Create;True;0;0;0;False;0;False;-0.35,0;-0.12,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;133;-1280,432;Inherit;False;Property;_Texture3_Tilling;Texture3_Tilling;12;0;Create;True;0;0;0;False;0;False;1,1;0.22,0.86;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;38;-1104,-336;Inherit;False;Property;_Deformation;Deformation;22;0;Create;True;0;0;0;False;0;False;0.0586999;0.0586999;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1440,-112;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-688,-512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-832,720;Inherit;False;Property;_Displacement_Texture3;Displacement_Texture3;16;0;Create;True;0;0;0;False;0;False;0,0;0,0.04;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;134;-928,528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1392,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;128;-1216,96;Inherit;False;Property;_Texture2_Tilling;Texture2_Tilling;5;0;Create;True;0;0;0;False;0;False;1,1;0.4,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;37;-1488,-32;Inherit;False;Property;_Texture1_Speed;Texture1_Speed;3;0;Create;True;0;0;0;False;0;False;-0.35,0;-0.19,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-1824,-1312;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;141;-1392,-1280;Inherit;False;Property;_Vector0;Vector 0;27;0;Create;True;0;0;0;False;0;False;1,1;1.51,0.87;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1232,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-560,368;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-976,144;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;55;-992,304;Inherit;False;Property;_Displacement_Texture2;Displacement_Texture2;7;0;Create;True;0;0;0;False;0;False;0,0;1.36,0.69;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;40;-1152,-208;Inherit;False;Property;_Texture1_Tilling;Texture1_Tilling;2;0;Create;True;0;0;0;False;0;False;1,1;0.63,0.67;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;-1152,-1296;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-832,-1712;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-848,-128;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-544,16;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;64;-368,352;Inherit;True;Property;_Texture_3;Texture_3;11;0;Create;True;0;0;0;False;0;False;-1;9b7109b2444673b4eb4182147c7e5b86;9b7109b2444673b4eb4182147c7e5b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;66;-320,560;Inherit;False;Property;_SmoothMin_Tex_3;SmoothMin_Tex_3;18;0;Create;True;0;0;0;False;0;False;0;-0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-304,640;Inherit;False;Property;_SmoothMax_Tex_3;SmoothMax_Tex_3;19;0;Create;True;0;0;0;False;0;False;1;1.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;145;-896,-976;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;96;-560,-1712;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-1.05;False;2;FLOAT;1.88;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;-800,-2112;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;154;-784,-2416;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;95;-848,-1328;Inherit;True;Property;_Noise_Paint3;Noise_Paint;23;0;Create;True;0;0;0;False;0;False;-1;9b7109b2444673b4eb4182147c7e5b86;9b7109b2444673b4eb4182147c7e5b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-496,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;65;288,416;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;336,672;Inherit;False;Property;_SmoothMin2_Tex_3;SmoothMin2_Tex_3;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;352,752;Inherit;False;Property;_SmoothMax2_Tex_3;SmoothMax2_Tex_3;21;0;Create;True;0;0;0;False;0;False;1;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-336,-112;Inherit;True;Property;_Texture_2;Texture_2;4;0;Create;True;0;0;0;False;0;False;-1;9b7109b2444673b4eb4182147c7e5b86;9b7109b2444673b4eb4182147c7e5b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;58;-288,96;Inherit;False;Property;_SmoothMin_Tex_2;SmoothMin_Tex_2;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-288,176;Inherit;False;Property;_SmoothMax_Tex_2;SmoothMax_Tex_2;10;0;Create;True;0;0;0;False;0;False;1;1.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;98;-384,-1296;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;2.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;146;-576,-992;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-1.5;False;2;FLOAT;1.88;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-288,-1712;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;155;-480,-2416;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;153;-480,-2112;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;162;608,880;Inherit;False;2379;965;Color;15;177;176;175;174;173;172;171;170;169;168;167;166;165;164;163;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;640,416;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;120;-320,-480;Inherit;True;Property;_Texture_1;Texture_1;1;0;Create;True;0;0;0;False;0;False;-1;9b7109b2444673b4eb4182147c7e5b86;9b7109b2444673b4eb4182147c7e5b86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;57;384,-48;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;48,-1392;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-208,-976;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;9.64;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-96,-2224;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-48,-1984;Inherit;False;Property;_H_B_SmoothMin;H_B_SmoothMin;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-48,-1904;Inherit;True;Property;_H_B_SmoothMax;H_B_SmoothMax;28;0;Create;True;0;0;0;False;0;False;1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;832,1184;Inherit;False;Property;_Noise_Pan_Speed;Noise_Pan_Speed;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;164;656,944;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;72;880,-80;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;544,-992;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;159;336,-2208;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;1072,1376;Inherit;False;Property;_Noise_Scale;Noise_Scale;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;166;1104,1072;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;1216,-672;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;167;1424,1008;Inherit;True;0;0;1;0;2;True;4;False;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;168;1488,1328;Inherit;False;Property;_Noise_Min;Noise_Min;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;1520,1424;Inherit;False;Property;_Noise_Max;Noise_Max;13;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;170;1744,1392;Inherit;False;0;2;3;1,0.9910967,0.2877358,0;0.9921569,0.9803922,0.6745098,1;1,0;1,0.4721294;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;171;1760,1536;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;816,-416;Inherit;True;Property;_MainTex;_MainTex;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GradientNode;172;1776,1744;Inherit;False;0;2;3;0.990566,0.7145106,0.1915717,0;0.9921569,0.7137255,0.1921569,1;1,0;1,0.4721294;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;173;2032,1344;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;174;1840,992;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;122;1872,-48;Inherit;False;Alpha Split;-1;;1;07dab7960105b86429ac8eebd729ed6d;0;1;2;FLOAT;0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.GradientSampleNode;175;2048,1632;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;2336,960;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;2128,-160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;2752,1200;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;149;2304,208;Inherit;False;Property;_HDR;HDR;0;0;Create;True;0;0;0;False;0;False;0;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;124;2352,-16;Inherit;False;Alpha Merge;-1;;2;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;2736,48;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3440,-16;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;17;SH_Door;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;33;0;31;0
WireConnection;33;1;48;0
WireConnection;32;0;29;0
WireConnection;34;0;32;0
WireConnection;34;2;33;0
WireConnection;35;0;34;0
WireConnection;132;0;130;0
WireConnection;132;1;131;0
WireConnection;41;0;35;0
WireConnection;41;1;38;0
WireConnection;134;0;133;0
WireConnection;134;1;132;0
WireConnection;127;0;125;0
WireConnection;127;1;126;0
WireConnection;39;0;36;0
WireConnection;39;1;37;0
WireConnection;62;0;41;0
WireConnection;62;1;134;0
WireConnection;62;2;63;0
WireConnection;129;0;128;0
WireConnection;129;1;127;0
WireConnection;140;0;141;0
WireConnection;94;1;101;1
WireConnection;42;0;40;0
WireConnection;42;1;39;0
WireConnection;53;0;41;0
WireConnection;53;1;129;0
WireConnection;53;2;55;0
WireConnection;64;1;62;0
WireConnection;145;1;101;1
WireConnection;96;0;94;0
WireConnection;151;0;101;2
WireConnection;154;1;101;2
WireConnection;95;1;140;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;65;0;64;1
WireConnection;65;1;66;0
WireConnection;65;2;67;0
WireConnection;51;1;53;0
WireConnection;98;0;95;1
WireConnection;146;0;145;0
WireConnection;97;0;96;0
WireConnection;155;0;154;0
WireConnection;153;0;151;0
WireConnection;68;0;65;0
WireConnection;68;1;70;0
WireConnection;68;2;69;0
WireConnection;120;1;43;0
WireConnection;57;0;51;1
WireConnection;57;1;58;0
WireConnection;57;2;59;0
WireConnection;99;0;97;0
WireConnection;99;1;98;0
WireConnection;147;0;146;0
WireConnection;157;0;155;0
WireConnection;157;1;153;0
WireConnection;72;0;120;1
WireConnection;72;1;57;0
WireConnection;72;2;68;0
WireConnection;148;0;99;0
WireConnection;148;1;147;0
WireConnection;159;0;157;0
WireConnection;159;1;160;0
WireConnection;159;2;161;0
WireConnection;166;0;164;0
WireConnection;166;2;163;0
WireConnection;142;0;72;0
WireConnection;142;1;148;0
WireConnection;142;2;159;0
WireConnection;167;0;164;0
WireConnection;167;1;166;0
WireConnection;167;2;165;0
WireConnection;173;0;170;0
WireConnection;173;1;171;0
WireConnection;174;0;167;0
WireConnection;174;1;168;0
WireConnection;174;2;169;0
WireConnection;122;2;142;0
WireConnection;175;0;172;0
WireConnection;175;1;171;0
WireConnection;176;0;174;0
WireConnection;176;1;173;0
WireConnection;123;0;46;4
WireConnection;123;1;122;6
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;124;2;122;0
WireConnection;124;3;123;0
WireConnection;150;0;124;0
WireConnection;150;1;177;0
WireConnection;150;2;149;0
WireConnection;0;1;150;0
ASEEND*/
//CHKSM=32C33A9DF9E1D4DF7DB691B9AD27149117AD6DCC