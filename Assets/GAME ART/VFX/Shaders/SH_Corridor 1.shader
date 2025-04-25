// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Corridor"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		_Deformation("Deformation", Range( 0 , 1)) = 0.05245707
		_Speed_HB("Speed_HB", Float) = 0.23
		_TextureCanvas("Texture Canvas", 2D) = "white" {}
		_Speed_XY("Speed_XY", Float) = 0.38
		_TextureSample3("Texture Sample 0", 2D) = "white" {}
		_Trail_Speed("Trail_Speed", Vector) = (0.96,0,0,0)
		_TextureSample4("Texture Sample 0", 2D) = "white" {}
		_Tilling("Tilling", Vector) = (1.85,1,0,0)
		_Noise_Pan_Speed("Noise_Pan_Speed", Float) = 1
		_Float0("Float 0", Range( 0 , 1)) = 0.04
		_Noise_Max("Noise_Max", Float) = 0.3
		_Noise_Min("Noise_Min", Float) = 0
		_Noise_Scale("Noise_Scale", Float) = 1
		_TimeScale("TimeScale", Range( -1 , 1)) = 1

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


			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureCanvas;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tilling;
			float2 _Trail_Speed;
			float _Float0;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _TimeScale;
			float _Noise_Min;
			float _Noise_Max;
			float _Noise_Scale;
			float _Noise_Pan_Speed;
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
			
					float2 voronoihash166( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi166( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash166( n + g );
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

				float2 _Vector1 = float2(0,0.12);
				float2 texCoord144 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult145 = (float2(1.59 , 1.9));
				float2 appendResult146 = (float2(0.01 , 0.0));
				float2 panner142 = ( 1.0 * _Time.y * _Vector1 + (texCoord144*appendResult145 + appendResult146));
				float2 panner139 = ( 1.0 * _Time.y * _Vector1 + (( 1.0 - texCoord144 )*appendResult145 + appendResult146));
				float smoothstepResult136 = smoothstep( 0.0 , 0.96 , ( tex2D( _TextureSample3, panner142 ).r + tex2D( _TextureSample4, panner139 ).r ));
				float smoothstepResult151 = smoothstep( -0.11 , 1.0 , ( 1.0 - smoothstepResult136 ));
				float2 texCoord113 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult114 = (float2(-( _Float0 / 2.0 ) , 0.0));
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float temp_output_119_0 = ( 0.5 - ( (texCoord113*1.0 + appendResult114) + ( _Float0 * simplePerlin2D46 ) ).x );
				float smoothstepResult121 = smoothstep( 0.24 , 0.0 , ( temp_output_119_0 * temp_output_119_0 ));
				float mulTime106 = _TimeParameters.x * _TimeScale;
				float2 texCoord49 = IN.texCoord0.xy * _Tilling + ( mulTime106 * _Trail_Speed );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 temp_cast_1 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner165 = ( 1.0 * _Time.y * temp_cast_1 + ase_positionWS.xy);
				float time166 = panner165.x;
				float2 voronoiSmoothId166 = 0;
				float voronoiSmooth166 = 0.0;
				float2 coords166 = ase_positionWS.xy * _Noise_Scale;
				float2 id166 = 0;
				float2 uv166 = 0;
				float fade166 = 0.5;
				float voroi166 = 0;
				float rest166 = 0;
				for( int it166 = 0; it166 <2; it166++ ){
				voroi166 += fade166 * voronoi166( coords166, time166, id166, uv166, voronoiSmooth166,voronoiSmoothId166 );
				rest166 += fade166;
				coords166 *= 2;
				fade166 *= 0.5;
				}//Voronoi166
				voroi166 /= rest166;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi166);
				Gradient gradient169 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord170 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient171 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( ( ( smoothstepResult151 * smoothstepResult121 ) * appendResult52 ) * ( ( smoothstepResult174 * SampleGradient( gradient169, texCoord170.x ) ) + SampleGradient( gradient171, texCoord170.x ) ) );

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


			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureCanvas;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tilling;
			float2 _Trail_Speed;
			float _Float0;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _TimeScale;
			float _Noise_Min;
			float _Noise_Max;
			float _Noise_Scale;
			float _Noise_Pan_Speed;
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
			
					float2 voronoihash166( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi166( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash166( n + g );
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

				float2 _Vector1 = float2(0,0.12);
				float2 texCoord144 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult145 = (float2(1.59 , 1.9));
				float2 appendResult146 = (float2(0.01 , 0.0));
				float2 panner142 = ( 1.0 * _Time.y * _Vector1 + (texCoord144*appendResult145 + appendResult146));
				float2 panner139 = ( 1.0 * _Time.y * _Vector1 + (( 1.0 - texCoord144 )*appendResult145 + appendResult146));
				float smoothstepResult136 = smoothstep( 0.0 , 0.96 , ( tex2D( _TextureSample3, panner142 ).r + tex2D( _TextureSample4, panner139 ).r ));
				float smoothstepResult151 = smoothstep( -0.11 , 1.0 , ( 1.0 - smoothstepResult136 ));
				float2 texCoord113 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult114 = (float2(-( _Float0 / 2.0 ) , 0.0));
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float temp_output_119_0 = ( 0.5 - ( (texCoord113*1.0 + appendResult114) + ( _Float0 * simplePerlin2D46 ) ).x );
				float smoothstepResult121 = smoothstep( 0.24 , 0.0 , ( temp_output_119_0 * temp_output_119_0 ));
				float mulTime106 = _TimeParameters.x * _TimeScale;
				float2 texCoord49 = IN.texCoord0.xy * _Tilling + ( mulTime106 * _Trail_Speed );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 temp_cast_1 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 panner165 = ( 1.0 * _Time.y * temp_cast_1 + ase_positionWS.xy);
				float time166 = panner165.x;
				float2 voronoiSmoothId166 = 0;
				float voronoiSmooth166 = 0.0;
				float2 coords166 = ase_positionWS.xy * _Noise_Scale;
				float2 id166 = 0;
				float2 uv166 = 0;
				float fade166 = 0.5;
				float voroi166 = 0;
				float rest166 = 0;
				for( int it166 = 0; it166 <2; it166++ ){
				voroi166 += fade166 * voronoi166( coords166, time166, id166, uv166, voronoiSmooth166,voronoiSmoothId166 );
				rest166 += fade166;
				coords166 *= 2;
				fade166 *= 0.5;
				}//Voronoi166
				voroi166 /= rest166;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi166);
				Gradient gradient169 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord170 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient171 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( ( ( smoothstepResult151 * smoothstepResult121 ) * appendResult52 ) * ( ( smoothstepResult174 * SampleGradient( gradient169, texCoord170.x ) ) + SampleGradient( gradient171, texCoord170.x ) ) );

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


			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureCanvas;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tilling;
			float2 _Trail_Speed;
			float _Float0;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _TimeScale;
			float _Noise_Min;
			float _Noise_Max;
			float _Noise_Scale;
			float _Noise_Pan_Speed;
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
			
					float2 voronoihash166( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi166( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash166( n + g );
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
				float2 _Vector1 = float2(0,0.12);
				float2 texCoord144 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult145 = (float2(1.59 , 1.9));
				float2 appendResult146 = (float2(0.01 , 0.0));
				float2 panner142 = ( 1.0 * _Time.y * _Vector1 + (texCoord144*appendResult145 + appendResult146));
				float2 panner139 = ( 1.0 * _Time.y * _Vector1 + (( 1.0 - texCoord144 )*appendResult145 + appendResult146));
				float smoothstepResult136 = smoothstep( 0.0 , 0.96 , ( tex2D( _TextureSample3, panner142 ).r + tex2D( _TextureSample4, panner139 ).r ));
				float smoothstepResult151 = smoothstep( -0.11 , 1.0 , ( 1.0 - smoothstepResult136 ));
				float2 texCoord113 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult114 = (float2(-( _Float0 / 2.0 ) , 0.0));
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float temp_output_119_0 = ( 0.5 - ( (texCoord113*1.0 + appendResult114) + ( _Float0 * simplePerlin2D46 ) ).x );
				float smoothstepResult121 = smoothstep( 0.24 , 0.0 , ( temp_output_119_0 * temp_output_119_0 ));
				float mulTime106 = _TimeParameters.x * _TimeScale;
				float2 texCoord49 = IN.ase_texcoord.xy * _Tilling + ( mulTime106 * _Trail_Speed );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 temp_cast_1 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner165 = ( 1.0 * _Time.y * temp_cast_1 + ase_positionWS.xy);
				float time166 = panner165.x;
				float2 voronoiSmoothId166 = 0;
				float voronoiSmooth166 = 0.0;
				float2 coords166 = ase_positionWS.xy * _Noise_Scale;
				float2 id166 = 0;
				float2 uv166 = 0;
				float fade166 = 0.5;
				float voroi166 = 0;
				float rest166 = 0;
				for( int it166 = 0; it166 <2; it166++ ){
				voroi166 += fade166 * voronoi166( coords166, time166, id166, uv166, voronoiSmooth166,voronoiSmoothId166 );
				rest166 += fade166;
				coords166 *= 2;
				fade166 *= 0.5;
				}//Voronoi166
				voroi166 /= rest166;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi166);
				Gradient gradient169 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord170 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient171 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( ( ( smoothstepResult151 * smoothstepResult121 ) * appendResult52 ) * ( ( smoothstepResult174 * SampleGradient( gradient169, texCoord170.x ) ) + SampleGradient( gradient171, texCoord170.x ) ) );

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


			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureCanvas;
			CBUFFER_START( UnityPerMaterial )
			float2 _Tilling;
			float2 _Trail_Speed;
			float _Float0;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _TimeScale;
			float _Noise_Min;
			float _Noise_Max;
			float _Noise_Scale;
			float _Noise_Pan_Speed;
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
			
					float2 voronoihash166( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi166( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash166( n + g );
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
				float2 _Vector1 = float2(0,0.12);
				float2 texCoord144 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult145 = (float2(1.59 , 1.9));
				float2 appendResult146 = (float2(0.01 , 0.0));
				float2 panner142 = ( 1.0 * _Time.y * _Vector1 + (texCoord144*appendResult145 + appendResult146));
				float2 panner139 = ( 1.0 * _Time.y * _Vector1 + (( 1.0 - texCoord144 )*appendResult145 + appendResult146));
				float smoothstepResult136 = smoothstep( 0.0 , 0.96 , ( tex2D( _TextureSample3, panner142 ).r + tex2D( _TextureSample4, panner139 ).r ));
				float smoothstepResult151 = smoothstep( -0.11 , 1.0 , ( 1.0 - smoothstepResult136 ));
				float2 texCoord113 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult114 = (float2(-( _Float0 / 2.0 ) , 0.0));
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float temp_output_119_0 = ( 0.5 - ( (texCoord113*1.0 + appendResult114) + ( _Float0 * simplePerlin2D46 ) ).x );
				float smoothstepResult121 = smoothstep( 0.24 , 0.0 , ( temp_output_119_0 * temp_output_119_0 ));
				float mulTime106 = _TimeParameters.x * _TimeScale;
				float2 texCoord49 = IN.ase_texcoord.xy * _Tilling + ( mulTime106 * _Trail_Speed );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 temp_cast_1 = (_Noise_Pan_Speed).xx;
				float3 ase_positionWS = IN.ase_texcoord1.xyz;
				float2 panner165 = ( 1.0 * _Time.y * temp_cast_1 + ase_positionWS.xy);
				float time166 = panner165.x;
				float2 voronoiSmoothId166 = 0;
				float voronoiSmooth166 = 0.0;
				float2 coords166 = ase_positionWS.xy * _Noise_Scale;
				float2 id166 = 0;
				float2 uv166 = 0;
				float fade166 = 0.5;
				float voroi166 = 0;
				float rest166 = 0;
				for( int it166 = 0; it166 <2; it166++ ){
				voroi166 += fade166 * voronoi166( coords166, time166, id166, uv166, voronoiSmooth166,voronoiSmoothId166 );
				rest166 += fade166;
				coords166 *= 2;
				fade166 *= 0.5;
				}//Voronoi166
				voroi166 /= rest166;
				float smoothstepResult174 = smoothstep( _Noise_Min , _Noise_Max , voroi166);
				Gradient gradient169 = NewGradient( 0, 2, 3, float4( 1, 0.9910967, 0.2877358, 0 ), float4( 0.9921569, 0.9803922, 0.6745098, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				float2 texCoord170 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				Gradient gradient171 = NewGradient( 0, 2, 3, float4( 0.990566, 0.7145106, 0.1915717, 0 ), float4( 0.9921569, 0.7137255, 0.1921569, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 0.4721294 ), float2( 1, 1 ), 0, 0, 0, 0, 0 );
				
				float4 Color = ( ( ( smoothstepResult151 * smoothstepResult121 ) * appendResult52 ) * ( ( smoothstepResult174 * SampleGradient( gradient169, texCoord170.x ) ) + SampleGradient( gradient171, texCoord170.x ) ) );
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-2144,-992;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;-2000,-736;Inherit;False;Property;_Speed_XY;Speed_XY;3;0;Create;True;0;0;0;False;0;False;0.38;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-1664,-1120;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.04;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2000,-640;Inherit;False;Property;_Speed_HB;Speed_HB;1;0;Create;True;0;0;0;False;0;False;0.23;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;43;-1792,-912;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1744,-736;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;111;-1312,-1200;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-2480,-1552;Inherit;False;Constant;_Float3;Float 2;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-2496,-1616;Inherit;False;Constant;_Float4;Float 1;10;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-2480,-1760;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;1.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;144;-2272,-2000;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-2464,-1872;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;1.59;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;45;-1504,-912;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.06,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;112;-1184,-1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;146;-2320,-1600;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;134;-1936,-1776;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;145;-2272,-1824;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;141;-1968,-1536;Inherit;False;Constant;_Vector1;Vector 1;11;0;Create;True;0;0;0;False;0;False;0,0.12;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;143;-1712,-2000;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;133;-1728,-1728;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-1216,-1408;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;114;-1008,-1248;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;-1232,-912;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.39;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-768,-1136;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;139;-1488,-1712;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;142;-1456,-1984;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;116;-832,-1408;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-2000,-384;Inherit;False;Property;_TimeScale;TimeScale;13;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;132;-1280,-1712;Inherit;True;Property;_TextureSample4;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;55ffaf31a043cb1458409983fc6cfe74;55ffaf31a043cb1458409983fc6cfe74;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;131;-1232,-2000;Inherit;True;Property;_TextureSample3;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;55ffaf31a043cb1458409983fc6cfe74;55ffaf31a043cb1458409983fc6cfe74;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-608,-1392;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;177;-1312,0;Inherit;False;2379;965;Color;18;162;163;164;165;166;167;168;169;170;171;172;173;174;175;176;3;2;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;108;-1712,-288;Inherit;False;Property;_Trail_Speed;Trail_Speed;5;0;Create;True;0;0;0;False;0;False;0.96,0;0.36,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;106;-1632,-384;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;109;-1664,-528;Inherit;False;Property;_Tilling;Tilling;7;0;Create;True;0;0;0;False;0;False;1.85,1;1.2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;118;-368,-1360;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-848,-1936;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1088,304;Inherit;False;Property;_Noise_Pan_Speed;Noise_Pan_Speed;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;164;-1264,64;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;47;-1232,-624;Inherit;False;Property;_Deformation;Deformation;0;0;Create;True;0;0;0;False;0;False;0.05245707;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1392,-368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;119;-224,-1344;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;136;-592,-1920;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.96;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-848,496;Inherit;False;Property;_Noise_Scale;Noise_Scale;12;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;165;-816,192;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-960,-784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1088,-464;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;148;-288,-1872;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;16,-1312;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;166;-496,128;Inherit;True;0;0;1;0;2;True;4;False;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;167;-432,448;Inherit;False;Property;_Noise_Min;Noise_Min;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-400,544;Inherit;False;Property;_Noise_Max;Noise_Max;10;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;169;-176,512;Inherit;False;0;2;3;1,0.9910967,0.2877358,0;0.9921569,0.9803922,0.6745098,1;1,0;1,0.4721294;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-160,656;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-768,-736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;57;-704,-352;Inherit;True;Property;_TextureCanvas;Texture Canvas;2;0;Create;True;0;0;0;False;0;False;6e52658e86b59bb4994e9d4e7632b30a;6e52658e86b59bb4994e9d4e7632b30a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;51;-624,-752;Inherit;True;Property;_TextureSample2;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;57;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;151;-64,-2016;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.11;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;171;-144,864;Inherit;False;0;2;3;0.990566,0.7145106,0.1915717,0;0.9921569,0.7137255,0.1921569,1;1,0;1,0.4721294;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;173;112,464;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;174;-80,112;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;121;176,-1392;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.24;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-208,-688;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;172;128,752;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;480,80;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;432,-1392;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;832,320;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;448,-896;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;1360,-784;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1664,-912;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;SH_Corridor;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;43;0;41;0
WireConnection;44;0;103;0
WireConnection;44;1;42;0
WireConnection;111;0;110;0
WireConnection;45;0;43;0
WireConnection;45;2;44;0
WireConnection;112;0;111;0
WireConnection;146;0;147;0
WireConnection;146;1;137;0
WireConnection;134;0;144;0
WireConnection;145;0;138;0
WireConnection;145;1;140;0
WireConnection;143;0;144;0
WireConnection;143;1;145;0
WireConnection;143;2;146;0
WireConnection;133;0;134;0
WireConnection;133;1;145;0
WireConnection;133;2;146;0
WireConnection;114;0;112;0
WireConnection;46;0;45;0
WireConnection;115;0;110;0
WireConnection;115;1;46;0
WireConnection;139;0;133;0
WireConnection;139;2;141;0
WireConnection;142;0;143;0
WireConnection;142;2;141;0
WireConnection;116;0;113;0
WireConnection;116;2;114;0
WireConnection;132;1;139;0
WireConnection;131;1;142;0
WireConnection;117;0;116;0
WireConnection;117;1;115;0
WireConnection;106;0;179;0
WireConnection;118;0;117;0
WireConnection;135;0;131;1
WireConnection;135;1;132;1
WireConnection;105;0;106;0
WireConnection;105;1;108;0
WireConnection;119;1;118;0
WireConnection;136;0;135;0
WireConnection;165;0;164;0
WireConnection;165;2;162;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;49;0;109;0
WireConnection;49;1;105;0
WireConnection;148;0;136;0
WireConnection;120;0;119;0
WireConnection;120;1;119;0
WireConnection;166;0;164;0
WireConnection;166;1;165;0
WireConnection;166;2;163;0
WireConnection;182;0;48;0
WireConnection;182;1;49;0
WireConnection;51;0;57;0
WireConnection;51;1;182;0
WireConnection;151;0;148;0
WireConnection;173;0;169;0
WireConnection;173;1;170;0
WireConnection;174;0;166;0
WireConnection;174;1;167;0
WireConnection;174;2;168;0
WireConnection;121;0;120;0
WireConnection;52;0;51;5
WireConnection;52;3;51;1
WireConnection;172;0;171;0
WireConnection;172;1;170;0
WireConnection;175;0;174;0
WireConnection;175;1;173;0
WireConnection;152;0;151;0
WireConnection;152;1;121;0
WireConnection;176;0;175;0
WireConnection;176;1;172;0
WireConnection;154;0;152;0
WireConnection;154;1;52;0
WireConnection;159;0;154;0
WireConnection;159;1;176;0
WireConnection;0;1;159;0
ASEEND*/
//CHKSM=E7B27B4A260FF95EFE9688E2177FC381E9565BD7