// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Wall"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		_Deformation("Deformation", Range( 0 , 1)) = 0.1413043
		_G_Line_Mask("G_Line_Mask", Range( 0 , 1)) = 0.12
		_Disolve_Cursor2("Disolve_Cursor", Float) = 0.37
		_D_Line_Mask("D_Line_Mask", Range( 0 , 1)) = 0
		_Noise_Scale1("Noise_Scale", Float) = 4.35
		_G_Degrade("G_Degrade", Range( 0 , 1)) = 0.3
		_Dissolve("Dissolve", 2D) = "white" {}
		_D_Degrade("D_Degrade", Range( 0 , 1)) = 0.3
		_TexMain("_TexMain", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_HDR("HDR", Float) = 2.47
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


			sampler2D _TextureSample1;
			sampler2D _Sampler6010;
			sampler2D _TexMain;
			sampler2D _Dissolve;
			CBUFFER_START( UnityPerMaterial )
			float4 _TexMain_ST;
			float _G_Line_Mask;
			float _G_Degrade;
			float _Deformation;
			float _HDR;
			float _D_Line_Mask;
			float _D_Degrade;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			
					float2 voronoihash11( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi11( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash11( n + g );
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
				float smoothstepResult34 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord22.x - -0.12 ) * step( ( texCoord22.x - 1.24 ) , 0.15 ) ));
				Gradient gradient52 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord14 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float time11 = 0.0;
				float2 voronoiSmoothId11 = 0;
				float2 temp_output_1_0_g6 = float2( 1,1 );
				float2 texCoord80_g6 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g6 = (float2(( (temp_output_1_0_g6).x * texCoord80_g6.x ) , ( texCoord80_g6.y * (temp_output_1_0_g6).y )));
				float2 temp_output_11_0_g6 = float2( 0,0 );
				float2 texCoord81_g6 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g6 = ( ( (temp_output_11_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g6);
				float2 panner19_g6 = ( ( _TimeParameters.x * (temp_output_11_0_g6).y ) * float2( 0,1 ) + texCoord81_g6);
				float2 appendResult24_g6 = (float2((panner18_g6).x , (panner19_g6).y));
				float2 temp_output_47_0_g6 = float2( 0,-0.2 );
				float2 texCoord78_g6 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g6 = ( texCoord78_g6 - float2( 1,1 ) );
				float2 appendResult39_g6 = (float2(frac( ( atan2( (temp_output_31_0_g6).x , (temp_output_31_0_g6).y ) / TWO_PI ) ) , length( temp_output_31_0_g6 )));
				float2 panner54_g6 = ( ( (temp_output_47_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g6);
				float2 panner55_g6 = ( ( _TimeParameters.x * (temp_output_47_0_g6).y ) * float2( 0,1 ) + appendResult39_g6);
				float2 appendResult58_g6 = (float2((panner54_g6).x , (panner55_g6).y));
				float2 coords11 = ( ( (tex2D( _Sampler6010, ( appendResult10_g6 + appendResult24_g6 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g6 ) ) * 4.0;
				float2 id11 = 0;
				float2 uv11 = 0;
				float fade11 = 0.5;
				float voroi11 = 0;
				float rest11 = 0;
				for( int it11 = 0; it11 <2; it11++ ){
				voroi11 += fade11 * voronoi11( coords11, time11, id11, uv11, 0,voronoiSmoothId11 );
				rest11 += fade11;
				coords11 *= 2;
				fade11 *= 0.5;
				}//Voronoi11
				voroi11 /= rest11;
				float smoothstepResult13 = smoothstep( 0.0 , 1.0 , voroi11);
				float4 tex2DNode45 = tex2D( _TextureSample1, ( texCoord14 + ( smoothstepResult13 * _Deformation ) ) );
				float4 appendResult55 = (float4(( SampleGradient( gradient52, tex2DNode45.r ) * _HDR ).rgb , 0.0));
				float4 appendResult47 = (float4(( appendResult55 * tex2DNode45 ).rgb , tex2DNode45.r));
				float4 temp_output_2_0_g7 = appendResult47;
				float2 uv_TexMain = IN.texCoord0.xy * _TexMain_ST.xy + _TexMain_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g7).rgb , ( tex2D( _TexMain, uv_TexMain ).r * (temp_output_2_0_g7).a )));
				float4 temp_output_43_0 = appendResult4_g10;
				float2 texCoord21 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord21.x ) * step( ( -0.29 - texCoord21.x ) , 0.15 ) ));
				float2 temp_cast_3 = (_Noise_Scale1).xx;
				float2 texCoord63 = IN.texCoord0.xy * temp_cast_3 + float2( 0,0 );
				float2 temp_output_34_0_g9 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g9 = temp_output_34_0_g9;
				float2 appendResult50_g9 = (float2(( 1.0 * ( length( temp_output_34_0_g9 ) * 2.0 ) ) , ( ( atan2( break39_g9.x , break39_g9.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				
				float4 Color = ( ( smoothstepResult34 * temp_output_43_0 ) * ( smoothstepResult35 * temp_output_43_0 ) * step( ( 1.0 - ( tex2D( _Dissolve, texCoord63 ).r + 0.0 ) ) , ( appendResult50_g9.x + _Disolve_Cursor2 ) ) );

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


			sampler2D _TextureSample1;
			sampler2D _Sampler6010;
			sampler2D _TexMain;
			sampler2D _Dissolve;
			CBUFFER_START( UnityPerMaterial )
			float4 _TexMain_ST;
			float _G_Line_Mask;
			float _G_Degrade;
			float _Deformation;
			float _HDR;
			float _D_Line_Mask;
			float _D_Degrade;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			
					float2 voronoihash11( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi11( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash11( n + g );
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
				float smoothstepResult34 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord22.x - -0.12 ) * step( ( texCoord22.x - 1.24 ) , 0.15 ) ));
				Gradient gradient52 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord14 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float time11 = 0.0;
				float2 voronoiSmoothId11 = 0;
				float2 temp_output_1_0_g6 = float2( 1,1 );
				float2 texCoord80_g6 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g6 = (float2(( (temp_output_1_0_g6).x * texCoord80_g6.x ) , ( texCoord80_g6.y * (temp_output_1_0_g6).y )));
				float2 temp_output_11_0_g6 = float2( 0,0 );
				float2 texCoord81_g6 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g6 = ( ( (temp_output_11_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g6);
				float2 panner19_g6 = ( ( _TimeParameters.x * (temp_output_11_0_g6).y ) * float2( 0,1 ) + texCoord81_g6);
				float2 appendResult24_g6 = (float2((panner18_g6).x , (panner19_g6).y));
				float2 temp_output_47_0_g6 = float2( 0,-0.2 );
				float2 texCoord78_g6 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g6 = ( texCoord78_g6 - float2( 1,1 ) );
				float2 appendResult39_g6 = (float2(frac( ( atan2( (temp_output_31_0_g6).x , (temp_output_31_0_g6).y ) / TWO_PI ) ) , length( temp_output_31_0_g6 )));
				float2 panner54_g6 = ( ( (temp_output_47_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g6);
				float2 panner55_g6 = ( ( _TimeParameters.x * (temp_output_47_0_g6).y ) * float2( 0,1 ) + appendResult39_g6);
				float2 appendResult58_g6 = (float2((panner54_g6).x , (panner55_g6).y));
				float2 coords11 = ( ( (tex2D( _Sampler6010, ( appendResult10_g6 + appendResult24_g6 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g6 ) ) * 4.0;
				float2 id11 = 0;
				float2 uv11 = 0;
				float fade11 = 0.5;
				float voroi11 = 0;
				float rest11 = 0;
				for( int it11 = 0; it11 <2; it11++ ){
				voroi11 += fade11 * voronoi11( coords11, time11, id11, uv11, 0,voronoiSmoothId11 );
				rest11 += fade11;
				coords11 *= 2;
				fade11 *= 0.5;
				}//Voronoi11
				voroi11 /= rest11;
				float smoothstepResult13 = smoothstep( 0.0 , 1.0 , voroi11);
				float4 tex2DNode45 = tex2D( _TextureSample1, ( texCoord14 + ( smoothstepResult13 * _Deformation ) ) );
				float4 appendResult55 = (float4(( SampleGradient( gradient52, tex2DNode45.r ) * _HDR ).rgb , 0.0));
				float4 appendResult47 = (float4(( appendResult55 * tex2DNode45 ).rgb , tex2DNode45.r));
				float4 temp_output_2_0_g7 = appendResult47;
				float2 uv_TexMain = IN.texCoord0.xy * _TexMain_ST.xy + _TexMain_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g7).rgb , ( tex2D( _TexMain, uv_TexMain ).r * (temp_output_2_0_g7).a )));
				float4 temp_output_43_0 = appendResult4_g10;
				float2 texCoord21 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord21.x ) * step( ( -0.29 - texCoord21.x ) , 0.15 ) ));
				float2 temp_cast_3 = (_Noise_Scale1).xx;
				float2 texCoord63 = IN.texCoord0.xy * temp_cast_3 + float2( 0,0 );
				float2 temp_output_34_0_g9 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g9 = temp_output_34_0_g9;
				float2 appendResult50_g9 = (float2(( 1.0 * ( length( temp_output_34_0_g9 ) * 2.0 ) ) , ( ( atan2( break39_g9.x , break39_g9.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				
				float4 Color = ( ( smoothstepResult34 * temp_output_43_0 ) * ( smoothstepResult35 * temp_output_43_0 ) * step( ( 1.0 - ( tex2D( _Dissolve, texCoord63 ).r + 0.0 ) ) , ( appendResult50_g9.x + _Disolve_Cursor2 ) ) );

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


			sampler2D _TextureSample1;
			sampler2D _Sampler6010;
			sampler2D _TexMain;
			sampler2D _Dissolve;
			CBUFFER_START( UnityPerMaterial )
			float4 _TexMain_ST;
			float _G_Line_Mask;
			float _G_Degrade;
			float _Deformation;
			float _HDR;
			float _D_Line_Mask;
			float _D_Degrade;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            int _ObjectId;
            int _PassValue;

			
					float2 voronoihash11( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi11( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash11( n + g );
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
				float smoothstepResult34 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord22.x - -0.12 ) * step( ( texCoord22.x - 1.24 ) , 0.15 ) ));
				Gradient gradient52 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord14 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float time11 = 0.0;
				float2 voronoiSmoothId11 = 0;
				float2 temp_output_1_0_g6 = float2( 1,1 );
				float2 texCoord80_g6 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g6 = (float2(( (temp_output_1_0_g6).x * texCoord80_g6.x ) , ( texCoord80_g6.y * (temp_output_1_0_g6).y )));
				float2 temp_output_11_0_g6 = float2( 0,0 );
				float2 texCoord81_g6 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g6 = ( ( (temp_output_11_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g6);
				float2 panner19_g6 = ( ( _TimeParameters.x * (temp_output_11_0_g6).y ) * float2( 0,1 ) + texCoord81_g6);
				float2 appendResult24_g6 = (float2((panner18_g6).x , (panner19_g6).y));
				float2 temp_output_47_0_g6 = float2( 0,-0.2 );
				float2 texCoord78_g6 = IN.ase_texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g6 = ( texCoord78_g6 - float2( 1,1 ) );
				float2 appendResult39_g6 = (float2(frac( ( atan2( (temp_output_31_0_g6).x , (temp_output_31_0_g6).y ) / TWO_PI ) ) , length( temp_output_31_0_g6 )));
				float2 panner54_g6 = ( ( (temp_output_47_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g6);
				float2 panner55_g6 = ( ( _TimeParameters.x * (temp_output_47_0_g6).y ) * float2( 0,1 ) + appendResult39_g6);
				float2 appendResult58_g6 = (float2((panner54_g6).x , (panner55_g6).y));
				float2 coords11 = ( ( (tex2D( _Sampler6010, ( appendResult10_g6 + appendResult24_g6 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g6 ) ) * 4.0;
				float2 id11 = 0;
				float2 uv11 = 0;
				float fade11 = 0.5;
				float voroi11 = 0;
				float rest11 = 0;
				for( int it11 = 0; it11 <2; it11++ ){
				voroi11 += fade11 * voronoi11( coords11, time11, id11, uv11, 0,voronoiSmoothId11 );
				rest11 += fade11;
				coords11 *= 2;
				fade11 *= 0.5;
				}//Voronoi11
				voroi11 /= rest11;
				float smoothstepResult13 = smoothstep( 0.0 , 1.0 , voroi11);
				float4 tex2DNode45 = tex2D( _TextureSample1, ( texCoord14 + ( smoothstepResult13 * _Deformation ) ) );
				float4 appendResult55 = (float4(( SampleGradient( gradient52, tex2DNode45.r ) * _HDR ).rgb , 0.0));
				float4 appendResult47 = (float4(( appendResult55 * tex2DNode45 ).rgb , tex2DNode45.r));
				float4 temp_output_2_0_g7 = appendResult47;
				float2 uv_TexMain = IN.ase_texcoord.xy * _TexMain_ST.xy + _TexMain_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g7).rgb , ( tex2D( _TexMain, uv_TexMain ).r * (temp_output_2_0_g7).a )));
				float4 temp_output_43_0 = appendResult4_g10;
				float2 texCoord21 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord21.x ) * step( ( -0.29 - texCoord21.x ) , 0.15 ) ));
				float2 temp_cast_3 = (_Noise_Scale1).xx;
				float2 texCoord63 = IN.ase_texcoord.xy * temp_cast_3 + float2( 0,0 );
				float2 temp_output_34_0_g9 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g9 = temp_output_34_0_g9;
				float2 appendResult50_g9 = (float2(( 1.0 * ( length( temp_output_34_0_g9 ) * 2.0 ) ) , ( ( atan2( break39_g9.x , break39_g9.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				
				float4 Color = ( ( smoothstepResult34 * temp_output_43_0 ) * ( smoothstepResult35 * temp_output_43_0 ) * step( ( 1.0 - ( tex2D( _Dissolve, texCoord63 ).r + 0.0 ) ) , ( appendResult50_g9.x + _Disolve_Cursor2 ) ) );

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


			sampler2D _TextureSample1;
			sampler2D _Sampler6010;
			sampler2D _TexMain;
			sampler2D _Dissolve;
			CBUFFER_START( UnityPerMaterial )
			float4 _TexMain_ST;
			float _G_Line_Mask;
			float _G_Degrade;
			float _Deformation;
			float _HDR;
			float _D_Line_Mask;
			float _D_Degrade;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			
					float2 voronoihash11( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi11( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash11( n + g );
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
				float smoothstepResult34 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord22.x - -0.12 ) * step( ( texCoord22.x - 1.24 ) , 0.15 ) ));
				Gradient gradient52 = NewGradient( 0, 7, 2, float4( 1, 0.9177689, 0.5801887, 0.07490654 ), float4( 1, 0.6212161, 0.1273585, 0.2264744 ), float4( 1, 0.8959579, 0.5562341, 0.3083696 ), float4( 1, 0.6196079, 0.1254902, 0.4337987 ), float4( 1, 0.9254902, 0.6196079, 0.6550546 ), float4( 1, 0.6196079, 0.1254902, 0.9198596 ), float4( 1, 0.9242194, 0.6179246, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float2 texCoord14 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float time11 = 0.0;
				float2 voronoiSmoothId11 = 0;
				float2 temp_output_1_0_g6 = float2( 1,1 );
				float2 texCoord80_g6 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g6 = (float2(( (temp_output_1_0_g6).x * texCoord80_g6.x ) , ( texCoord80_g6.y * (temp_output_1_0_g6).y )));
				float2 temp_output_11_0_g6 = float2( 0,0 );
				float2 texCoord81_g6 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g6 = ( ( (temp_output_11_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g6);
				float2 panner19_g6 = ( ( _TimeParameters.x * (temp_output_11_0_g6).y ) * float2( 0,1 ) + texCoord81_g6);
				float2 appendResult24_g6 = (float2((panner18_g6).x , (panner19_g6).y));
				float2 temp_output_47_0_g6 = float2( 0,-0.2 );
				float2 texCoord78_g6 = IN.ase_texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g6 = ( texCoord78_g6 - float2( 1,1 ) );
				float2 appendResult39_g6 = (float2(frac( ( atan2( (temp_output_31_0_g6).x , (temp_output_31_0_g6).y ) / TWO_PI ) ) , length( temp_output_31_0_g6 )));
				float2 panner54_g6 = ( ( (temp_output_47_0_g6).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g6);
				float2 panner55_g6 = ( ( _TimeParameters.x * (temp_output_47_0_g6).y ) * float2( 0,1 ) + appendResult39_g6);
				float2 appendResult58_g6 = (float2((panner54_g6).x , (panner55_g6).y));
				float2 coords11 = ( ( (tex2D( _Sampler6010, ( appendResult10_g6 + appendResult24_g6 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g6 ) ) * 4.0;
				float2 id11 = 0;
				float2 uv11 = 0;
				float fade11 = 0.5;
				float voroi11 = 0;
				float rest11 = 0;
				for( int it11 = 0; it11 <2; it11++ ){
				voroi11 += fade11 * voronoi11( coords11, time11, id11, uv11, 0,voronoiSmoothId11 );
				rest11 += fade11;
				coords11 *= 2;
				fade11 *= 0.5;
				}//Voronoi11
				voroi11 /= rest11;
				float smoothstepResult13 = smoothstep( 0.0 , 1.0 , voroi11);
				float4 tex2DNode45 = tex2D( _TextureSample1, ( texCoord14 + ( smoothstepResult13 * _Deformation ) ) );
				float4 appendResult55 = (float4(( SampleGradient( gradient52, tex2DNode45.r ) * _HDR ).rgb , 0.0));
				float4 appendResult47 = (float4(( appendResult55 * tex2DNode45 ).rgb , tex2DNode45.r));
				float4 temp_output_2_0_g7 = appendResult47;
				float2 uv_TexMain = IN.ase_texcoord.xy * _TexMain_ST.xy + _TexMain_ST.zw;
				float4 appendResult4_g10 = (float4((temp_output_2_0_g7).rgb , ( tex2D( _TexMain, uv_TexMain ).r * (temp_output_2_0_g7).a )));
				float4 temp_output_43_0 = appendResult4_g10;
				float2 texCoord21 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord21.x ) * step( ( -0.29 - texCoord21.x ) , 0.15 ) ));
				float2 temp_cast_3 = (_Noise_Scale1).xx;
				float2 texCoord63 = IN.ase_texcoord.xy * temp_cast_3 + float2( 0,0 );
				float2 temp_output_34_0_g9 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g9 = temp_output_34_0_g9;
				float2 appendResult50_g9 = (float2(( 1.0 * ( length( temp_output_34_0_g9 ) * 2.0 ) ) , ( ( atan2( break39_g9.x , break39_g9.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				
				float4 Color = ( ( smoothstepResult34 * temp_output_43_0 ) * ( smoothstepResult35 * temp_output_43_0 ) * step( ( 1.0 - ( tex2D( _Dissolve, texCoord63 ).r + 0.0 ) ) , ( appendResult50_g9.x + _Disolve_Cursor2 ) ) );
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
Node;AmplifyShaderEditor.FunctionNode;10;-3616,896;Inherit;False;RadialUVDistortion;-1;;6;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6010;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;0,-0.2;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;11;-3104,816;Inherit;True;0;0;1;0;2;True;4;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-2800,848;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3072,1184;Inherit;False;Property;_Deformation;Deformation;0;0;Create;True;0;0;0;False;0;False;0.1413043;0.052;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2560,704;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2432,864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2208,736;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GradientNode;52;-2672,-320;Inherit;False;0;7;2;1,0.9177689,0.5801887,0.07490654;1,0.6212161,0.1273585,0.2264744;1,0.8959579,0.5562341,0.3083696;1,0.6196079,0.1254902,0.4337987;1,0.9254902,0.6196079,0.6550546;1,0.6196079,0.1254902,0.9198596;1,0.9242194,0.6179246,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SamplerNode;45;-2080,496;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;ef9a37625c1075b46b81f5cee659f4bb;ef9a37625c1075b46b81f5cee659f4bb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GradientSampleNode;53;-2224,-272;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-2032,0;Inherit;False;Property;_HDR;HDR;10;0;Create;True;0;0;0;False;0;False;2.47;1.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1776,-256;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1520,-272;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1328,160;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1904,1088;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1936,1664;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-1952,2352;Inherit;False;Property;_Noise_Scale1;Noise_Scale;4;0;Create;True;0;0;0;False;0;False;4.35;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1152,512;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-1552,1120;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;1.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-1600,1728;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-1728,2320;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;41;-960,496;Inherit;True;Alpha Split;-1;;7;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.SamplerNode;44;-1056,240;Inherit;True;Property;_TexMain;_TexMain;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1552,896;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;-0.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;27;-1312,1056;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;25;-1344,1632;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-1584,1472;Inherit;True;2;0;FLOAT;0.99;False;1;FLOAT;0.07;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-1696,2768;Inherit;True;Polar Coordinates;-1;;9;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;3;FLOAT2;0;FLOAT;55;FLOAT;56
Node;AmplifyShaderEditor.SamplerNode;65;-1440,2400;Inherit;True;Property;_Dissolve;Dissolve;6;0;Create;True;0;0;0;False;0;False;-1;None;babe5b65a5abcae47aba08de105876bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-704,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1072,912;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1088,1248;Inherit;False;Property;_G_Degrade;G_Degrade;5;0;Create;True;0;0;0;False;0;False;0.3;0.253;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1088,1152;Inherit;False;Property;_G_Line_Mask;G_Line_Mask;1;0;Create;True;0;0;0;False;0;False;0.12;0.046;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1104,1488;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1152,1760;Inherit;False;Property;_D_Line_Mask;D_Line_Mask;3;0;Create;True;0;0;0;False;0;False;0;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1152,1888;Inherit;False;Property;_D_Degrade;D_Degrade;7;0;Create;True;0;0;0;False;0;False;0.3;0.041;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1200,3072;Inherit;False;Property;_Disolve_Cursor2;Disolve_Cursor;2;0;Create;True;0;0;0;False;0;False;0.37;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;67;-1264,2816;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1088,2448;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;43;-528,480;Inherit;True;Alpha Merge;-1;;10;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-704,1008;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;35;-800,1488;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-976,2816;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-752,2720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-304,1488;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-240,976;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;71;-496,2720;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;64,1184;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;49;-720,496;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;50;-720,496;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;51;-720,496;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;48;352,1056;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;SH_Wall;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;11;0;10;0
WireConnection;13;0;11;0
WireConnection;15;0;13;0
WireConnection;15;1;12;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;45;1;17;0
WireConnection;53;0;52;0
WireConnection;53;1;45;0
WireConnection;54;0;53;0
WireConnection;54;1;62;0
WireConnection;55;0;54;0
WireConnection;56;0;55;0
WireConnection;56;1;45;0
WireConnection;47;0;56;0
WireConnection;47;3;45;1
WireConnection;24;0;22;1
WireConnection;23;1;21;1
WireConnection;63;0;72;0
WireConnection;41;2;47;0
WireConnection;28;0;22;1
WireConnection;27;0;24;0
WireConnection;25;0;23;0
WireConnection;26;1;21;1
WireConnection;65;1;63;0
WireConnection;42;0;44;1
WireConnection;42;1;41;6
WireConnection;30;0;28;0
WireConnection;30;1;27;0
WireConnection;29;0;26;0
WireConnection;29;1;25;0
WireConnection;67;0;64;0
WireConnection;68;0;65;1
WireConnection;43;2;41;0
WireConnection;43;3;42;0
WireConnection;34;0;30;0
WireConnection;34;1;33;0
WireConnection;34;2;32;0
WireConnection;35;0;29;0
WireConnection;35;1;31;0
WireConnection;35;2;20;0
WireConnection;69;0;67;0
WireConnection;69;1;66;0
WireConnection;70;0;68;0
WireConnection;39;0;35;0
WireConnection;39;1;43;0
WireConnection;38;0;34;0
WireConnection;38;1;43;0
WireConnection;71;0;70;0
WireConnection;71;1;69;0
WireConnection;40;0;38;0
WireConnection;40;1;39;0
WireConnection;40;2;71;0
WireConnection;48;1;40;0
ASEEND*/
//CHKSM=CBB8B7E7300E77C99D8DECE4DEC5117E2243973A