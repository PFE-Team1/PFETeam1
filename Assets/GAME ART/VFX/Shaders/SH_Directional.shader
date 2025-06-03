// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Directional"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		_Vitesse("Vitesse", Vector) = (1,0,0,0)
		_Deformation_Arrow("Deformation_Arrow", Range( 0 , 1)) = 0.1413043
		_Velocite_Mouvement("Velocite_Mouvement", Vector) = (1.45,0,0,0)
		_Courbe("Courbe", Range( 0 , 1)) = 0.087
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Arrow_Y("Arrow_Y", Float) = 1.07
		_Arrow_X("Arrow_X", Float) = 1.17
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_MainTex("_MainTex", 2D) = "white" {}
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


			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _Sampler60108;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Velocite_Mouvement;
			float2 _Vitesse;
			float _Courbe;
			float _Arrow_X;
			float _Arrow_Y;
			float _Deformation_Arrow;
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
			
					float2 voronoihash109( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi109( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash109( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
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

				float2 texCoord22 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float simplePerlin2D27 = snoise( ( texCoord22 + ( _Velocite_Mouvement * _TimeParameters.x ) ) );
				simplePerlin2D27 = simplePerlin2D27*0.5 + 0.5;
				float2 texCoord10 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult78 = (float2(1.38 , 1.0));
				float4 tex2DNode57 = tex2D( _TextureSample0, ( ( simplePerlin2D27 * _Courbe ) + ( (texCoord10*appendResult78 + 0.0) + ( _Vitesse * _TimeParameters.x ) ) ) );
				float4 appendResult123 = (float4(tex2DNode57.rgb , tex2DNode57.r));
				float2 texCoord66 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult73 = smoothstep( 0.15 , 0.63 , ( ( texCoord66.x - 0.0 ) * step( ( texCoord66.x - 0.5 ) , 1.14 ) ));
				float smoothstepResult136 = smoothstep( 0.02 , 0.4 , ( ( 0.73 - texCoord66.x ) * step( -1.15 , ( -0.55 - texCoord66.x ) ) ));
				float4 temp_output_68_0 = ( appendResult123 * smoothstepResult73 * smoothstepResult136 );
				float2 texCoord141 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult151 = smoothstep( 0.42 , 0.65 , ( ( texCoord141.x - -0.03 ) * step( ( texCoord141.x - 0.18 ) , 1.35 ) ));
				float2 texCoord88 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult90 = (float2(_Arrow_X , _Arrow_Y));
				float time109 = 0.0;
				float2 voronoiSmoothId109 = 0;
				float2 temp_output_1_0_g8 = float2( 1,1 );
				float2 texCoord80_g8 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g8 = (float2(( (temp_output_1_0_g8).x * texCoord80_g8.x ) , ( texCoord80_g8.y * (temp_output_1_0_g8).y )));
				float2 temp_output_11_0_g8 = float2( 0,0 );
				float2 texCoord81_g8 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g8 = ( ( (temp_output_11_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g8);
				float2 panner19_g8 = ( ( _TimeParameters.x * (temp_output_11_0_g8).y ) * float2( 0,1 ) + texCoord81_g8);
				float2 appendResult24_g8 = (float2((panner18_g8).x , (panner19_g8).y));
				float2 temp_output_47_0_g8 = float2( 0,-0.2 );
				float2 texCoord78_g8 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g8 = ( texCoord78_g8 - float2( 1,1 ) );
				float2 appendResult39_g8 = (float2(frac( ( atan2( (temp_output_31_0_g8).x , (temp_output_31_0_g8).y ) / TWO_PI ) ) , length( temp_output_31_0_g8 )));
				float2 panner54_g8 = ( ( (temp_output_47_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g8);
				float2 panner55_g8 = ( ( _TimeParameters.x * (temp_output_47_0_g8).y ) * float2( 0,1 ) + appendResult39_g8);
				float2 appendResult58_g8 = (float2((panner54_g8).x , (panner55_g8).y));
				float2 coords109 = ( ( (tex2D( _Sampler60108, ( appendResult10_g8 + appendResult24_g8 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g8 ) ) * 4.0;
				float2 id109 = 0;
				float2 uv109 = 0;
				float fade109 = 0.5;
				float voroi109 = 0;
				float rest109 = 0;
				for( int it109 = 0; it109 <2; it109++ ){
				voroi109 += fade109 * voronoi109( coords109, time109, id109, uv109, 0,voronoiSmoothId109 );
				rest109 += fade109;
				coords109 *= 2;
				fade109 *= 0.5;
				}//Voronoi109
				voroi109 /= rest109;
				float smoothstepResult110 = smoothstep( 0.0 , 1.0 , voroi109);
				float4 tex2DNode86 = tex2D( _TextureSample1, ( texCoord88 + (float2( 0,0 )*0.0 + appendResult90) + ( smoothstepResult110 * _Deformation_Arrow ) ) );
				float4 appendResult124 = (float4(tex2DNode86.rgb , tex2DNode86.r));
				float4 temp_output_87_0 = ( ( temp_output_68_0 + temp_output_68_0 + temp_output_68_0 ) + ( smoothstepResult151 * appendResult124 ) );
				Gradient gradient157 = NewGradient( 0, 2, 2, float4( 0.9943689, 1, 0.6367924, 0.2247349 ), float4( 1, 0.5329688, 0, 0.8031434 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord186 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float4 appendResult117 = (float4(( temp_output_87_0 * SampleGradient( gradient157, texCoord186.x ) ).rgb , temp_output_87_0.r));
				float4 temp_output_2_0_g9 = appendResult117;
				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g9).rgb , ( tex2D( _MainTex, uv_MainTex ) * (temp_output_2_0_g9).a ).r));
				
				float4 Color = appendResult4_g10;

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


			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _Sampler60108;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Velocite_Mouvement;
			float2 _Vitesse;
			float _Courbe;
			float _Arrow_X;
			float _Arrow_Y;
			float _Deformation_Arrow;
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
			
					float2 voronoihash109( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi109( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash109( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
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

				float2 texCoord22 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float simplePerlin2D27 = snoise( ( texCoord22 + ( _Velocite_Mouvement * _TimeParameters.x ) ) );
				simplePerlin2D27 = simplePerlin2D27*0.5 + 0.5;
				float2 texCoord10 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult78 = (float2(1.38 , 1.0));
				float4 tex2DNode57 = tex2D( _TextureSample0, ( ( simplePerlin2D27 * _Courbe ) + ( (texCoord10*appendResult78 + 0.0) + ( _Vitesse * _TimeParameters.x ) ) ) );
				float4 appendResult123 = (float4(tex2DNode57.rgb , tex2DNode57.r));
				float2 texCoord66 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult73 = smoothstep( 0.15 , 0.63 , ( ( texCoord66.x - 0.0 ) * step( ( texCoord66.x - 0.5 ) , 1.14 ) ));
				float smoothstepResult136 = smoothstep( 0.02 , 0.4 , ( ( 0.73 - texCoord66.x ) * step( -1.15 , ( -0.55 - texCoord66.x ) ) ));
				float4 temp_output_68_0 = ( appendResult123 * smoothstepResult73 * smoothstepResult136 );
				float2 texCoord141 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult151 = smoothstep( 0.42 , 0.65 , ( ( texCoord141.x - -0.03 ) * step( ( texCoord141.x - 0.18 ) , 1.35 ) ));
				float2 texCoord88 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult90 = (float2(_Arrow_X , _Arrow_Y));
				float time109 = 0.0;
				float2 voronoiSmoothId109 = 0;
				float2 temp_output_1_0_g8 = float2( 1,1 );
				float2 texCoord80_g8 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g8 = (float2(( (temp_output_1_0_g8).x * texCoord80_g8.x ) , ( texCoord80_g8.y * (temp_output_1_0_g8).y )));
				float2 temp_output_11_0_g8 = float2( 0,0 );
				float2 texCoord81_g8 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g8 = ( ( (temp_output_11_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g8);
				float2 panner19_g8 = ( ( _TimeParameters.x * (temp_output_11_0_g8).y ) * float2( 0,1 ) + texCoord81_g8);
				float2 appendResult24_g8 = (float2((panner18_g8).x , (panner19_g8).y));
				float2 temp_output_47_0_g8 = float2( 0,-0.2 );
				float2 texCoord78_g8 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g8 = ( texCoord78_g8 - float2( 1,1 ) );
				float2 appendResult39_g8 = (float2(frac( ( atan2( (temp_output_31_0_g8).x , (temp_output_31_0_g8).y ) / TWO_PI ) ) , length( temp_output_31_0_g8 )));
				float2 panner54_g8 = ( ( (temp_output_47_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g8);
				float2 panner55_g8 = ( ( _TimeParameters.x * (temp_output_47_0_g8).y ) * float2( 0,1 ) + appendResult39_g8);
				float2 appendResult58_g8 = (float2((panner54_g8).x , (panner55_g8).y));
				float2 coords109 = ( ( (tex2D( _Sampler60108, ( appendResult10_g8 + appendResult24_g8 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g8 ) ) * 4.0;
				float2 id109 = 0;
				float2 uv109 = 0;
				float fade109 = 0.5;
				float voroi109 = 0;
				float rest109 = 0;
				for( int it109 = 0; it109 <2; it109++ ){
				voroi109 += fade109 * voronoi109( coords109, time109, id109, uv109, 0,voronoiSmoothId109 );
				rest109 += fade109;
				coords109 *= 2;
				fade109 *= 0.5;
				}//Voronoi109
				voroi109 /= rest109;
				float smoothstepResult110 = smoothstep( 0.0 , 1.0 , voroi109);
				float4 tex2DNode86 = tex2D( _TextureSample1, ( texCoord88 + (float2( 0,0 )*0.0 + appendResult90) + ( smoothstepResult110 * _Deformation_Arrow ) ) );
				float4 appendResult124 = (float4(tex2DNode86.rgb , tex2DNode86.r));
				float4 temp_output_87_0 = ( ( temp_output_68_0 + temp_output_68_0 + temp_output_68_0 ) + ( smoothstepResult151 * appendResult124 ) );
				Gradient gradient157 = NewGradient( 0, 2, 2, float4( 0.9943689, 1, 0.6367924, 0.2247349 ), float4( 1, 0.5329688, 0, 0.8031434 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord186 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float4 appendResult117 = (float4(( temp_output_87_0 * SampleGradient( gradient157, texCoord186.x ) ).rgb , temp_output_87_0.r));
				float4 temp_output_2_0_g9 = appendResult117;
				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g9).rgb , ( tex2D( _MainTex, uv_MainTex ) * (temp_output_2_0_g9).a ).r));
				
				float4 Color = appendResult4_g10;

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


			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _Sampler60108;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Velocite_Mouvement;
			float2 _Vitesse;
			float _Courbe;
			float _Arrow_X;
			float _Arrow_Y;
			float _Deformation_Arrow;
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
			
					float2 voronoihash109( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi109( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash109( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
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

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
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
				float2 texCoord22 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float simplePerlin2D27 = snoise( ( texCoord22 + ( _Velocite_Mouvement * _TimeParameters.x ) ) );
				simplePerlin2D27 = simplePerlin2D27*0.5 + 0.5;
				float2 texCoord10 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult78 = (float2(1.38 , 1.0));
				float4 tex2DNode57 = tex2D( _TextureSample0, ( ( simplePerlin2D27 * _Courbe ) + ( (texCoord10*appendResult78 + 0.0) + ( _Vitesse * _TimeParameters.x ) ) ) );
				float4 appendResult123 = (float4(tex2DNode57.rgb , tex2DNode57.r));
				float2 texCoord66 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult73 = smoothstep( 0.15 , 0.63 , ( ( texCoord66.x - 0.0 ) * step( ( texCoord66.x - 0.5 ) , 1.14 ) ));
				float smoothstepResult136 = smoothstep( 0.02 , 0.4 , ( ( 0.73 - texCoord66.x ) * step( -1.15 , ( -0.55 - texCoord66.x ) ) ));
				float4 temp_output_68_0 = ( appendResult123 * smoothstepResult73 * smoothstepResult136 );
				float2 texCoord141 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult151 = smoothstep( 0.42 , 0.65 , ( ( texCoord141.x - -0.03 ) * step( ( texCoord141.x - 0.18 ) , 1.35 ) ));
				float2 texCoord88 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult90 = (float2(_Arrow_X , _Arrow_Y));
				float time109 = 0.0;
				float2 voronoiSmoothId109 = 0;
				float2 temp_output_1_0_g8 = float2( 1,1 );
				float2 texCoord80_g8 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g8 = (float2(( (temp_output_1_0_g8).x * texCoord80_g8.x ) , ( texCoord80_g8.y * (temp_output_1_0_g8).y )));
				float2 temp_output_11_0_g8 = float2( 0,0 );
				float2 texCoord81_g8 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g8 = ( ( (temp_output_11_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g8);
				float2 panner19_g8 = ( ( _TimeParameters.x * (temp_output_11_0_g8).y ) * float2( 0,1 ) + texCoord81_g8);
				float2 appendResult24_g8 = (float2((panner18_g8).x , (panner19_g8).y));
				float2 temp_output_47_0_g8 = float2( 0,-0.2 );
				float2 texCoord78_g8 = IN.ase_texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g8 = ( texCoord78_g8 - float2( 1,1 ) );
				float2 appendResult39_g8 = (float2(frac( ( atan2( (temp_output_31_0_g8).x , (temp_output_31_0_g8).y ) / TWO_PI ) ) , length( temp_output_31_0_g8 )));
				float2 panner54_g8 = ( ( (temp_output_47_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g8);
				float2 panner55_g8 = ( ( _TimeParameters.x * (temp_output_47_0_g8).y ) * float2( 0,1 ) + appendResult39_g8);
				float2 appendResult58_g8 = (float2((panner54_g8).x , (panner55_g8).y));
				float2 coords109 = ( ( (tex2D( _Sampler60108, ( appendResult10_g8 + appendResult24_g8 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g8 ) ) * 4.0;
				float2 id109 = 0;
				float2 uv109 = 0;
				float fade109 = 0.5;
				float voroi109 = 0;
				float rest109 = 0;
				for( int it109 = 0; it109 <2; it109++ ){
				voroi109 += fade109 * voronoi109( coords109, time109, id109, uv109, 0,voronoiSmoothId109 );
				rest109 += fade109;
				coords109 *= 2;
				fade109 *= 0.5;
				}//Voronoi109
				voroi109 /= rest109;
				float smoothstepResult110 = smoothstep( 0.0 , 1.0 , voroi109);
				float4 tex2DNode86 = tex2D( _TextureSample1, ( texCoord88 + (float2( 0,0 )*0.0 + appendResult90) + ( smoothstepResult110 * _Deformation_Arrow ) ) );
				float4 appendResult124 = (float4(tex2DNode86.rgb , tex2DNode86.r));
				float4 temp_output_87_0 = ( ( temp_output_68_0 + temp_output_68_0 + temp_output_68_0 ) + ( smoothstepResult151 * appendResult124 ) );
				Gradient gradient157 = NewGradient( 0, 2, 2, float4( 0.9943689, 1, 0.6367924, 0.2247349 ), float4( 1, 0.5329688, 0, 0.8031434 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord186 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 appendResult117 = (float4(( temp_output_87_0 * SampleGradient( gradient157, texCoord186.x ) ).rgb , temp_output_87_0.r));
				float4 temp_output_2_0_g9 = appendResult117;
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g9).rgb , ( tex2D( _MainTex, uv_MainTex ) * (temp_output_2_0_g9).a ).r));
				
				float4 Color = appendResult4_g10;

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


			sampler2D _TextureSample0;
			sampler2D _TextureSample1;
			sampler2D _Sampler60108;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float2 _Velocite_Mouvement;
			float2 _Vitesse;
			float _Courbe;
			float _Arrow_X;
			float _Arrow_Y;
			float _Deformation_Arrow;
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
			
					float2 voronoihash109( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi109( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash109( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
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

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
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
				float2 texCoord22 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float simplePerlin2D27 = snoise( ( texCoord22 + ( _Velocite_Mouvement * _TimeParameters.x ) ) );
				simplePerlin2D27 = simplePerlin2D27*0.5 + 0.5;
				float2 texCoord10 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult78 = (float2(1.38 , 1.0));
				float4 tex2DNode57 = tex2D( _TextureSample0, ( ( simplePerlin2D27 * _Courbe ) + ( (texCoord10*appendResult78 + 0.0) + ( _Vitesse * _TimeParameters.x ) ) ) );
				float4 appendResult123 = (float4(tex2DNode57.rgb , tex2DNode57.r));
				float2 texCoord66 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult73 = smoothstep( 0.15 , 0.63 , ( ( texCoord66.x - 0.0 ) * step( ( texCoord66.x - 0.5 ) , 1.14 ) ));
				float smoothstepResult136 = smoothstep( 0.02 , 0.4 , ( ( 0.73 - texCoord66.x ) * step( -1.15 , ( -0.55 - texCoord66.x ) ) ));
				float4 temp_output_68_0 = ( appendResult123 * smoothstepResult73 * smoothstepResult136 );
				float2 texCoord141 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult151 = smoothstep( 0.42 , 0.65 , ( ( texCoord141.x - -0.03 ) * step( ( texCoord141.x - 0.18 ) , 1.35 ) ));
				float2 texCoord88 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult90 = (float2(_Arrow_X , _Arrow_Y));
				float time109 = 0.0;
				float2 voronoiSmoothId109 = 0;
				float2 temp_output_1_0_g8 = float2( 1,1 );
				float2 texCoord80_g8 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g8 = (float2(( (temp_output_1_0_g8).x * texCoord80_g8.x ) , ( texCoord80_g8.y * (temp_output_1_0_g8).y )));
				float2 temp_output_11_0_g8 = float2( 0,0 );
				float2 texCoord81_g8 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g8 = ( ( (temp_output_11_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g8);
				float2 panner19_g8 = ( ( _TimeParameters.x * (temp_output_11_0_g8).y ) * float2( 0,1 ) + texCoord81_g8);
				float2 appendResult24_g8 = (float2((panner18_g8).x , (panner19_g8).y));
				float2 temp_output_47_0_g8 = float2( 0,-0.2 );
				float2 texCoord78_g8 = IN.ase_texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g8 = ( texCoord78_g8 - float2( 1,1 ) );
				float2 appendResult39_g8 = (float2(frac( ( atan2( (temp_output_31_0_g8).x , (temp_output_31_0_g8).y ) / TWO_PI ) ) , length( temp_output_31_0_g8 )));
				float2 panner54_g8 = ( ( (temp_output_47_0_g8).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g8);
				float2 panner55_g8 = ( ( _TimeParameters.x * (temp_output_47_0_g8).y ) * float2( 0,1 ) + appendResult39_g8);
				float2 appendResult58_g8 = (float2((panner54_g8).x , (panner55_g8).y));
				float2 coords109 = ( ( (tex2D( _Sampler60108, ( appendResult10_g8 + appendResult24_g8 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g8 ) ) * 4.0;
				float2 id109 = 0;
				float2 uv109 = 0;
				float fade109 = 0.5;
				float voroi109 = 0;
				float rest109 = 0;
				for( int it109 = 0; it109 <2; it109++ ){
				voroi109 += fade109 * voronoi109( coords109, time109, id109, uv109, 0,voronoiSmoothId109 );
				rest109 += fade109;
				coords109 *= 2;
				fade109 *= 0.5;
				}//Voronoi109
				voroi109 /= rest109;
				float smoothstepResult110 = smoothstep( 0.0 , 1.0 , voroi109);
				float4 tex2DNode86 = tex2D( _TextureSample1, ( texCoord88 + (float2( 0,0 )*0.0 + appendResult90) + ( smoothstepResult110 * _Deformation_Arrow ) ) );
				float4 appendResult124 = (float4(tex2DNode86.rgb , tex2DNode86.r));
				float4 temp_output_87_0 = ( ( temp_output_68_0 + temp_output_68_0 + temp_output_68_0 ) + ( smoothstepResult151 * appendResult124 ) );
				Gradient gradient157 = NewGradient( 0, 2, 2, float4( 0.9943689, 1, 0.6367924, 0.2247349 ), float4( 1, 0.5329688, 0, 0.8031434 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord186 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 appendResult117 = (float4(( temp_output_87_0 * SampleGradient( gradient157, texCoord186.x ) ).rgb , temp_output_87_0.r));
				float4 temp_output_2_0_g9 = appendResult117;
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g9).rgb , ( tex2D( _MainTex, uv_MainTex ) * (temp_output_2_0_g9).a ).r));
				
				float4 Color = appendResult4_g10;
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
Node;AmplifyShaderEditor.CommentaryNode;31;-2640,-512;Inherit;False;1012;435;Mouvement;8;22;25;24;26;23;27;29;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-2592,-192;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;25;-2624,-336;Inherit;False;Property;_Velocite_Mouvement;Velocite_Mouvement;3;0;Create;True;0;0;0;False;0;False;1.45,0;1.45,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;30;-2192,-48;Inherit;False;580;435;Scrolling;5;17;13;12;37;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2352,-288;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2608,-464;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-2656,208;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2640,96;Inherit;False;Constant;_Float1;Float 0;2;0;Create;True;0;0;0;False;0;False;1.38;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2208,-416;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2448,0;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;13;-2080,272;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-2144,144;Inherit;False;Property;_Vitesse;Vitesse;1;0;Create;True;0;0;0;False;0;False;1,0;0.32,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;78;-2464,128;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;108;-2048,-800;Inherit;False;RadialUVDistortion;-1;;8;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler60108;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;0,-0.2;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-2080,-416;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1904,144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;77;-2128,16;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2128,-288;Inherit;False;Property;_Courbe;Courbe;4;0;Create;True;0;0;0;False;0;False;0.087;0.035;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-1792,608;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;109;-1536,-880;Inherit;True;0;0;1;0;2;True;4;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;91;-1344,-976;Inherit;False;Property;_Arrow_Y;Arrow_Y;6;0;Create;True;0;0;0;False;0;False;1.07;1.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1360,-1056;Inherit;False;Property;_Arrow_X;Arrow_X;7;0;Create;True;0;0;0;False;0;False;1.17;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1808,-416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-1744,32;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;133;-1552,1328;Inherit;True;2;0;FLOAT;-0.55;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;110;-1232,-848;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;90;-1168,-1040;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1504,-512;Inherit;False;Property;_Deformation_Arrow;Deformation_Arrow;2;0;Create;True;0;0;0;False;0;False;0.1413043;0.056;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;141;-928,-1744;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;69;-1472,848;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1536,-144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-880,-800;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-944,-1280;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;89;-928,-1088;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;148;-608,-1632;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;70;-1232,784;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-1472,624;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;132;-1552,1104;Inherit;True;2;0;FLOAT;0.73;False;1;FLOAT;0.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;134;-1312,1264;Inherit;True;2;0;FLOAT;-1.15;False;1;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-1376,-160;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;e8e7cebc1a9b9cf4190b043f2b832f3c;9db3605b9fed9474d9fd656c54494536;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-656,-1120;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;150;-384,-1632;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-992,640;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;147;-560,-1872;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-1072,1120;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;-832,-80;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;86;-384,-1104;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;ba2517464c1841a4c888dd889242e36c;863cfe6b1cdaa5c488fc36778bb20542;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;73;-768,640;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.63;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-128,-1808;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;136;-848,1120;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.02;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-208,480;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;124;16,-912;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;151;96,-1792;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.42;False;2;FLOAT;0.65;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;32,192;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;368,-1520;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;186;384,352;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;157;592,272;Inherit;False;0;2;2;0.9943689,1,0.6367924,0.2247349;1,0.5329688,0,0.8031434;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;1056,-240;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;158;864,272;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.7;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;1248,16;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;117;1312,-256;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;114;1504,-272;Inherit;False;Alpha Split;-1;;9;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.SamplerNode;122;1216,-768;Inherit;True;Property;_MainTex;_MainTex;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;85;-1538,190;Inherit;False;894;336;Exemple;3;45;82;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;1760,-384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-1488,240;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;8d3c32ca9126fcb4d8efb458fbbac36d;8d3c32ca9126fcb4d8efb458fbbac36d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-1152,256;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;83;-896,272;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.17;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;116;1936,-288;Inherit;False;Alpha Merge;-1;;10;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;118;2240,-288;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;SH_Directional;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;119;1184,-256;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;120;1184,-256;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;121;1184,-256;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
WireConnection;24;0;25;0
WireConnection;24;1;26;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;78;0;80;0
WireConnection;78;1;79;0
WireConnection;27;0;23;0
WireConnection;12;0;17;0
WireConnection;12;1;13;0
WireConnection;77;0;10;0
WireConnection;77;1;78;0
WireConnection;109;0;108;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;37;0;77;0
WireConnection;37;1;12;0
WireConnection;133;1;66;1
WireConnection;110;0;109;0
WireConnection;90;0;92;0
WireConnection;90;1;91;0
WireConnection;69;0;66;1
WireConnection;39;0;29;0
WireConnection;39;1;37;0
WireConnection;113;0;110;0
WireConnection;113;1;111;0
WireConnection;89;2;90;0
WireConnection;148;0;141;1
WireConnection;70;0;69;0
WireConnection;67;0;66;1
WireConnection;132;1;66;1
WireConnection;134;1;133;0
WireConnection;57;1;39;0
WireConnection;93;0;88;0
WireConnection;93;1;89;0
WireConnection;93;2;113;0
WireConnection;150;0;148;0
WireConnection;71;0;67;0
WireConnection;71;1;70;0
WireConnection;147;0;141;1
WireConnection;135;0;132;0
WireConnection;135;1;134;0
WireConnection;123;0;57;5
WireConnection;123;3;57;1
WireConnection;86;1;93;0
WireConnection;73;0;71;0
WireConnection;149;0;147;0
WireConnection;149;1;150;0
WireConnection;136;0;135;0
WireConnection;68;0;123;0
WireConnection;68;1;73;0
WireConnection;68;2;136;0
WireConnection;124;0;86;5
WireConnection;124;3;86;1
WireConnection;151;0;149;0
WireConnection;140;0;68;0
WireConnection;140;1;68;0
WireConnection;140;2;68;0
WireConnection;152;0;151;0
WireConnection;152;1;124;0
WireConnection;87;0;140;0
WireConnection;87;1;152;0
WireConnection;158;0;157;0
WireConnection;158;1;186;1
WireConnection;155;0;87;0
WireConnection;155;1;158;0
WireConnection;117;0;155;0
WireConnection;117;3;87;0
WireConnection;114;2;117;0
WireConnection;115;0;122;0
WireConnection;115;1;114;6
WireConnection;82;0;57;1
WireConnection;82;1;45;1
WireConnection;83;0;82;0
WireConnection;116;2;114;0
WireConnection;116;3;115;0
WireConnection;118;1;116;0
ASEEND*/
//CHKSM=D5EDD19B39FAB87A9AD986D35FF2C25970AC7805