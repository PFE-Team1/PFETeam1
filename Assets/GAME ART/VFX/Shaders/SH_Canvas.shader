// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Canvas"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Scale("Scale", Float) = 0
		_TextureSample3("Texture Sample 2", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_G_Line_Mask("G_Line_Mask", Range( 0 , 1)) = 0.12
		_D_Line_Mask("D_Line_Mask", Range( 0 , 1)) = 0
		_B_Line_Mask("B_Line_Mask", Range( 0 , 1)) = 0
		_H_Line_Mask("H_Line_Mask", Range( 0 , 1)) = 0
		_G_Degrade("G_Degrade", Range( 0 , 1)) = 0.3
		_D_Degrade("D_Degrade", Range( 0 , 1)) = 0.3
		_B_Degrade("B_Degrade", Range( 0 , 1)) = 0.27
		_H_Degrade("H_Degrade", Range( 0 , 1)) = 0.24
		_Cadre_Tex("Cadre_Tex", 2D) = "white" {}
		_Float0("Float 0", Range( 0 , 1)) = 0.1413043
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
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

			

			sampler2D _TextureSample2;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6032;
			sampler2D _Cadre_Tex;
			sampler2D _Sampler6056;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Scale;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			float _Float0;
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

					float2 voronoihash57( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi57( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash57( n + g );
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

				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 texCoord7 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult33 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord7.x - -0.12 ) * step( ( texCoord7.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.texCoord0.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.texCoord0.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord4 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult34 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord4.x ) * step( ( -0.29 - texCoord4.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.texCoord0.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord5 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord5.y - 0.02 ) * step( ( texCoord5.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.texCoord0.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord6 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult36 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.97 - texCoord6.y ) * step( ( -0.29 - texCoord6.y ) , 0.15 ) ));
				float2 temp_output_1_0_g3 = float2( 1,1 );
				float2 texCoord80_g3 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g3 = (float2(( (temp_output_1_0_g3).x * texCoord80_g3.x ) , ( texCoord80_g3.y * (temp_output_1_0_g3).y )));
				float2 temp_output_11_0_g3 = float2( 0,0 );
				float2 texCoord81_g3 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g3 = ( ( (temp_output_11_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g3);
				float2 panner19_g3 = ( ( _TimeParameters.x * (temp_output_11_0_g3).y ) * float2( 0,1 ) + texCoord81_g3);
				float2 appendResult24_g3 = (float2((panner18_g3).x , (panner19_g3).y));
				float2 temp_output_47_0_g3 = float2( 0,-0.06 );
				float2 texCoord78_g3 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g3 = ( texCoord78_g3 - float2( 1,1 ) );
				float2 appendResult39_g3 = (float2(frac( ( atan2( (temp_output_31_0_g3).x , (temp_output_31_0_g3).y ) / TWO_PI ) ) , length( temp_output_31_0_g3 )));
				float2 panner54_g3 = ( ( (temp_output_47_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g3);
				float2 panner55_g3 = ( ( _TimeParameters.x * (temp_output_47_0_g3).y ) * float2( 0,1 ) + appendResult39_g3);
				float2 appendResult58_g3 = (float2((panner54_g3).x , (panner55_g3).y));
				float4 tex2DNode46 = tex2D( _TextureSample1, ( ( (tex2D( _Sampler6032, ( appendResult10_g3 + appendResult24_g3 ) )).rg * 1.0 ) + ( float2( 1,0.23 ) * appendResult58_g3 ) ) );
				float4 appendResult63 = (float4(tex2DNode46.rgb , tex2DNode46.r));
				float2 texCoord58 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float time57 = 0.0;
				float2 voronoiSmoothId57 = 0;
				float2 temp_output_1_0_g2 = float2( 1,1 );
				float2 texCoord80_g2 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * texCoord80_g2.x ) , ( texCoord80_g2.y * (temp_output_1_0_g2).y )));
				float2 temp_output_11_0_g2 = float2( 0,0 );
				float2 texCoord81_g2 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g2);
				float2 panner19_g2 = ( ( _TimeParameters.x * (temp_output_11_0_g2).y ) * float2( 0,1 ) + texCoord81_g2);
				float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
				float2 temp_output_47_0_g2 = float2( 0,-0.2 );
				float2 texCoord78_g2 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g2 = ( texCoord78_g2 - float2( 1,1 ) );
				float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / TWO_PI ) ) , length( temp_output_31_0_g2 )));
				float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g2);
				float2 panner55_g2 = ( ( _TimeParameters.x * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
				float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
				float2 coords57 = ( ( (tex2D( _Sampler6056, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) ) * 4.0;
				float2 id57 = 0;
				float2 uv57 = 0;
				float fade57 = 0.5;
				float voroi57 = 0;
				float rest57 = 0;
				for( int it57 = 0; it57 <2; it57++ ){
				voroi57 += fade57 * voronoi57( coords57, time57, id57, uv57, 0,voronoiSmoothId57 );
				rest57 += fade57;
				coords57 *= 2;
				fade57 *= 0.5;
				}//Voronoi57
				voroi57 /= rest57;
				float smoothstepResult62 = smoothstep( 0.0 , 1.0 , voroi57);
				float4 temp_output_2_0_g4 = ( 1.0 - saturate( ( ( ( smoothstepResult33 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult34 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult35 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult36 ) ) + ( appendResult63 * tex2D( _Cadre_Tex, ( texCoord58 + ( smoothstepResult62 * _Float0 ) ) ).r ) ) ) );
				float4 appendResult4_g5 = (float4(tex2D( _TextureSample2, ( ase_positionWS * _Scale ).xy ).rgb , (temp_output_2_0_g4).a));
				
				float4 Color = appendResult4_g5;

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

			

			sampler2D _TextureSample2;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6032;
			sampler2D _Cadre_Tex;
			sampler2D _Sampler6056;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Scale;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			float _Float0;
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

					float2 voronoihash57( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi57( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash57( n + g );
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

				float3 ase_positionWS = IN.ase_texcoord3.xyz;
				float2 texCoord7 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult33 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord7.x - -0.12 ) * step( ( texCoord7.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.texCoord0.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.texCoord0.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord4 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult34 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord4.x ) * step( ( -0.29 - texCoord4.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.texCoord0.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord5 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord5.y - 0.02 ) * step( ( texCoord5.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.texCoord0.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord6 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult36 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.97 - texCoord6.y ) * step( ( -0.29 - texCoord6.y ) , 0.15 ) ));
				float2 temp_output_1_0_g3 = float2( 1,1 );
				float2 texCoord80_g3 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g3 = (float2(( (temp_output_1_0_g3).x * texCoord80_g3.x ) , ( texCoord80_g3.y * (temp_output_1_0_g3).y )));
				float2 temp_output_11_0_g3 = float2( 0,0 );
				float2 texCoord81_g3 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g3 = ( ( (temp_output_11_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g3);
				float2 panner19_g3 = ( ( _TimeParameters.x * (temp_output_11_0_g3).y ) * float2( 0,1 ) + texCoord81_g3);
				float2 appendResult24_g3 = (float2((panner18_g3).x , (panner19_g3).y));
				float2 temp_output_47_0_g3 = float2( 0,-0.06 );
				float2 texCoord78_g3 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g3 = ( texCoord78_g3 - float2( 1,1 ) );
				float2 appendResult39_g3 = (float2(frac( ( atan2( (temp_output_31_0_g3).x , (temp_output_31_0_g3).y ) / TWO_PI ) ) , length( temp_output_31_0_g3 )));
				float2 panner54_g3 = ( ( (temp_output_47_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g3);
				float2 panner55_g3 = ( ( _TimeParameters.x * (temp_output_47_0_g3).y ) * float2( 0,1 ) + appendResult39_g3);
				float2 appendResult58_g3 = (float2((panner54_g3).x , (panner55_g3).y));
				float4 tex2DNode46 = tex2D( _TextureSample1, ( ( (tex2D( _Sampler6032, ( appendResult10_g3 + appendResult24_g3 ) )).rg * 1.0 ) + ( float2( 1,0.23 ) * appendResult58_g3 ) ) );
				float4 appendResult63 = (float4(tex2DNode46.rgb , tex2DNode46.r));
				float2 texCoord58 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float time57 = 0.0;
				float2 voronoiSmoothId57 = 0;
				float2 temp_output_1_0_g2 = float2( 1,1 );
				float2 texCoord80_g2 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * texCoord80_g2.x ) , ( texCoord80_g2.y * (temp_output_1_0_g2).y )));
				float2 temp_output_11_0_g2 = float2( 0,0 );
				float2 texCoord81_g2 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g2);
				float2 panner19_g2 = ( ( _TimeParameters.x * (temp_output_11_0_g2).y ) * float2( 0,1 ) + texCoord81_g2);
				float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
				float2 temp_output_47_0_g2 = float2( 0,-0.2 );
				float2 texCoord78_g2 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g2 = ( texCoord78_g2 - float2( 1,1 ) );
				float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / TWO_PI ) ) , length( temp_output_31_0_g2 )));
				float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g2);
				float2 panner55_g2 = ( ( _TimeParameters.x * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
				float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
				float2 coords57 = ( ( (tex2D( _Sampler6056, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) ) * 4.0;
				float2 id57 = 0;
				float2 uv57 = 0;
				float fade57 = 0.5;
				float voroi57 = 0;
				float rest57 = 0;
				for( int it57 = 0; it57 <2; it57++ ){
				voroi57 += fade57 * voronoi57( coords57, time57, id57, uv57, 0,voronoiSmoothId57 );
				rest57 += fade57;
				coords57 *= 2;
				fade57 *= 0.5;
				}//Voronoi57
				voroi57 /= rest57;
				float smoothstepResult62 = smoothstep( 0.0 , 1.0 , voroi57);
				float4 temp_output_2_0_g4 = ( 1.0 - saturate( ( ( ( smoothstepResult33 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult34 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult35 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult36 ) ) + ( appendResult63 * tex2D( _Cadre_Tex, ( texCoord58 + ( smoothstepResult62 * _Float0 ) ) ).r ) ) ) );
				float4 appendResult4_g5 = (float4(tex2D( _TextureSample2, ( ase_positionWS * _Scale ).xy ).rgb , (temp_output_2_0_g4).a));
				
				float4 Color = appendResult4_g5;

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

			

			sampler2D _TextureSample2;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6032;
			sampler2D _Cadre_Tex;
			sampler2D _Sampler6056;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Scale;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			float _Float0;
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

					float2 voronoihash57( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi57( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash57( n + g );
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
			

			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_positionWS = TransformObjectToWorld( ( v.positionOS ).xyz );
				o.ase_texcoord.xyz = ase_positionWS;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.zw = 0;
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
				float3 ase_positionWS = IN.ase_texcoord.xyz;
				float2 texCoord7 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult33 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord7.x - -0.12 ) * step( ( texCoord7.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.ase_texcoord1.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.ase_texcoord1.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord4 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult34 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord4.x ) * step( ( -0.29 - texCoord4.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.ase_texcoord1.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord5 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord5.y - 0.02 ) * step( ( texCoord5.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.ase_texcoord1.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord6 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult36 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.97 - texCoord6.y ) * step( ( -0.29 - texCoord6.y ) , 0.15 ) ));
				float2 temp_output_1_0_g3 = float2( 1,1 );
				float2 texCoord80_g3 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g3 = (float2(( (temp_output_1_0_g3).x * texCoord80_g3.x ) , ( texCoord80_g3.y * (temp_output_1_0_g3).y )));
				float2 temp_output_11_0_g3 = float2( 0,0 );
				float2 texCoord81_g3 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g3 = ( ( (temp_output_11_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g3);
				float2 panner19_g3 = ( ( _TimeParameters.x * (temp_output_11_0_g3).y ) * float2( 0,1 ) + texCoord81_g3);
				float2 appendResult24_g3 = (float2((panner18_g3).x , (panner19_g3).y));
				float2 temp_output_47_0_g3 = float2( 0,-0.06 );
				float2 texCoord78_g3 = IN.ase_texcoord1.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g3 = ( texCoord78_g3 - float2( 1,1 ) );
				float2 appendResult39_g3 = (float2(frac( ( atan2( (temp_output_31_0_g3).x , (temp_output_31_0_g3).y ) / TWO_PI ) ) , length( temp_output_31_0_g3 )));
				float2 panner54_g3 = ( ( (temp_output_47_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g3);
				float2 panner55_g3 = ( ( _TimeParameters.x * (temp_output_47_0_g3).y ) * float2( 0,1 ) + appendResult39_g3);
				float2 appendResult58_g3 = (float2((panner54_g3).x , (panner55_g3).y));
				float4 tex2DNode46 = tex2D( _TextureSample1, ( ( (tex2D( _Sampler6032, ( appendResult10_g3 + appendResult24_g3 ) )).rg * 1.0 ) + ( float2( 1,0.23 ) * appendResult58_g3 ) ) );
				float4 appendResult63 = (float4(tex2DNode46.rgb , tex2DNode46.r));
				float2 texCoord58 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float time57 = 0.0;
				float2 voronoiSmoothId57 = 0;
				float2 temp_output_1_0_g2 = float2( 1,1 );
				float2 texCoord80_g2 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * texCoord80_g2.x ) , ( texCoord80_g2.y * (temp_output_1_0_g2).y )));
				float2 temp_output_11_0_g2 = float2( 0,0 );
				float2 texCoord81_g2 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g2);
				float2 panner19_g2 = ( ( _TimeParameters.x * (temp_output_11_0_g2).y ) * float2( 0,1 ) + texCoord81_g2);
				float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
				float2 temp_output_47_0_g2 = float2( 0,-0.2 );
				float2 texCoord78_g2 = IN.ase_texcoord1.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g2 = ( texCoord78_g2 - float2( 1,1 ) );
				float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / TWO_PI ) ) , length( temp_output_31_0_g2 )));
				float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g2);
				float2 panner55_g2 = ( ( _TimeParameters.x * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
				float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
				float2 coords57 = ( ( (tex2D( _Sampler6056, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) ) * 4.0;
				float2 id57 = 0;
				float2 uv57 = 0;
				float fade57 = 0.5;
				float voroi57 = 0;
				float rest57 = 0;
				for( int it57 = 0; it57 <2; it57++ ){
				voroi57 += fade57 * voronoi57( coords57, time57, id57, uv57, 0,voronoiSmoothId57 );
				rest57 += fade57;
				coords57 *= 2;
				fade57 *= 0.5;
				}//Voronoi57
				voroi57 /= rest57;
				float smoothstepResult62 = smoothstep( 0.0 , 1.0 , voroi57);
				float4 temp_output_2_0_g4 = ( 1.0 - saturate( ( ( ( smoothstepResult33 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult34 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult35 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult36 ) ) + ( appendResult63 * tex2D( _Cadre_Tex, ( texCoord58 + ( smoothstepResult62 * _Float0 ) ) ).r ) ) ) );
				float4 appendResult4_g5 = (float4(tex2D( _TextureSample2, ( ase_positionWS * _Scale ).xy ).rgb , (temp_output_2_0_g4).a));
				
				float4 Color = appendResult4_g5;

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

        	

			sampler2D _TextureSample2;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6032;
			sampler2D _Cadre_Tex;
			sampler2D _Sampler6056;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Scale;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			float _Float0;
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

					float2 voronoihash57( float2 p )
					{
						p = p - 4 * floor( p / 4 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi57( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash57( n + g );
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
			

			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_positionWS = TransformObjectToWorld( ( v.positionOS ).xyz );
				o.ase_texcoord.xyz = ase_positionWS;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.zw = 0;
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
				float3 ase_positionWS = IN.ase_texcoord.xyz;
				float2 texCoord7 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult33 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord7.x - -0.12 ) * step( ( texCoord7.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.ase_texcoord1.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.ase_texcoord1.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord4 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult34 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 0.99 - texCoord4.x ) * step( ( -0.29 - texCoord4.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.ase_texcoord1.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord5 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult35 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord5.y - 0.02 ) * step( ( texCoord5.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.ase_texcoord1.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord6 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult36 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.97 - texCoord6.y ) * step( ( -0.29 - texCoord6.y ) , 0.15 ) ));
				float2 temp_output_1_0_g3 = float2( 1,1 );
				float2 texCoord80_g3 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g3 = (float2(( (temp_output_1_0_g3).x * texCoord80_g3.x ) , ( texCoord80_g3.y * (temp_output_1_0_g3).y )));
				float2 temp_output_11_0_g3 = float2( 0,0 );
				float2 texCoord81_g3 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g3 = ( ( (temp_output_11_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g3);
				float2 panner19_g3 = ( ( _TimeParameters.x * (temp_output_11_0_g3).y ) * float2( 0,1 ) + texCoord81_g3);
				float2 appendResult24_g3 = (float2((panner18_g3).x , (panner19_g3).y));
				float2 temp_output_47_0_g3 = float2( 0,-0.06 );
				float2 texCoord78_g3 = IN.ase_texcoord1.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g3 = ( texCoord78_g3 - float2( 1,1 ) );
				float2 appendResult39_g3 = (float2(frac( ( atan2( (temp_output_31_0_g3).x , (temp_output_31_0_g3).y ) / TWO_PI ) ) , length( temp_output_31_0_g3 )));
				float2 panner54_g3 = ( ( (temp_output_47_0_g3).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g3);
				float2 panner55_g3 = ( ( _TimeParameters.x * (temp_output_47_0_g3).y ) * float2( 0,1 ) + appendResult39_g3);
				float2 appendResult58_g3 = (float2((panner54_g3).x , (panner55_g3).y));
				float4 tex2DNode46 = tex2D( _TextureSample1, ( ( (tex2D( _Sampler6032, ( appendResult10_g3 + appendResult24_g3 ) )).rg * 1.0 ) + ( float2( 1,0.23 ) * appendResult58_g3 ) ) );
				float4 appendResult63 = (float4(tex2DNode46.rgb , tex2DNode46.r));
				float2 texCoord58 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float time57 = 0.0;
				float2 voronoiSmoothId57 = 0;
				float2 temp_output_1_0_g2 = float2( 1,1 );
				float2 texCoord80_g2 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * texCoord80_g2.x ) , ( texCoord80_g2.y * (temp_output_1_0_g2).y )));
				float2 temp_output_11_0_g2 = float2( 0,0 );
				float2 texCoord81_g2 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g2);
				float2 panner19_g2 = ( ( _TimeParameters.x * (temp_output_11_0_g2).y ) * float2( 0,1 ) + texCoord81_g2);
				float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
				float2 temp_output_47_0_g2 = float2( 0,-0.2 );
				float2 texCoord78_g2 = IN.ase_texcoord1.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g2 = ( texCoord78_g2 - float2( 1,1 ) );
				float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / TWO_PI ) ) , length( temp_output_31_0_g2 )));
				float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g2);
				float2 panner55_g2 = ( ( _TimeParameters.x * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
				float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
				float2 coords57 = ( ( (tex2D( _Sampler6056, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) ) * 4.0;
				float2 id57 = 0;
				float2 uv57 = 0;
				float fade57 = 0.5;
				float voroi57 = 0;
				float rest57 = 0;
				for( int it57 = 0; it57 <2; it57++ ){
				voroi57 += fade57 * voronoi57( coords57, time57, id57, uv57, 0,voronoiSmoothId57 );
				rest57 += fade57;
				coords57 *= 2;
				fade57 *= 0.5;
				}//Voronoi57
				voroi57 /= rest57;
				float smoothstepResult62 = smoothstep( 0.0 , 1.0 , voroi57);
				float4 temp_output_2_0_g4 = ( 1.0 - saturate( ( ( ( smoothstepResult33 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult34 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult35 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult36 ) ) + ( appendResult63 * tex2D( _Cadre_Tex, ( texCoord58 + ( smoothstepResult62 * _Float0 ) ) ).r ) ) ) );
				float4 appendResult4_g5 = (float4(tex2D( _TextureSample2, ( ase_positionWS * _Scale ).xy ).rgb , (temp_output_2_0_g4).a));
				
				float4 Color = appendResult4_g5;
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3472,480;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-3616,1216;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-3472,1920;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-3600,-448;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;56;-1552,1152;Inherit;False;RadialUVDistortion;-1;;2;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6056;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;0,-0.2;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-3136,544;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-3248,-416;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;1.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-3264,1248;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;1.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-3120,1952;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;1.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;57;-1040,1072;Inherit;True;0;0;1;0;2;True;4;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StepOpNode;12;-2880,448;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-3120,288;Inherit;True;2;0;FLOAT;0.99;False;1;FLOAT;0.07;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;14;-3008,-480;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-3248,-640;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;-0.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;16;-3024,1184;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-3264,1024;Inherit;True;2;0;FLOAT;1.09;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;18;-2880,1888;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-3120,1728;Inherit;True;2;0;FLOAT;0.97;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1008,1440;Inherit;False;Property;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;0.1413043;0.108;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-736,1104;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2640,304;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2768,-624;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2640,1744;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2784,1040;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2688,576;Inherit;False;Property;_D_Line_Mask;D_Line_Mask;7;0;Create;True;0;0;0;False;0;False;0;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2800,1296;Inherit;False;Property;_B_Line_Mask;B_Line_Mask;8;0;Create;True;0;0;0;False;0;False;0;0.017;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2608,2032;Inherit;False;Property;_H_Line_Mask;H_Line_Mask;9;0;Create;True;0;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2784,-288;Inherit;False;Property;_G_Degrade;G_Degrade;10;0;Create;True;0;0;0;False;0;False;0.3;0.253;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2784,-384;Inherit;False;Property;_G_Line_Mask;G_Line_Mask;6;0;Create;True;0;0;0;False;0;False;0.12;0.046;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2656,704;Inherit;False;Property;_D_Degrade;D_Degrade;11;0;Create;True;0;0;0;False;0;False;0.3;0.041;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2752,1392;Inherit;False;Property;_B_Degrade;B_Degrade;12;0;Create;True;0;0;0;False;0;False;0.27;0.043;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2592,2128;Inherit;False;Property;_H_Degrade;H_Degrade;13;0;Create;True;0;0;0;False;0;False;0.24;0.037;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1344,928;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-368,1120;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;32;-1936,-992;Inherit;False;RadialUVDistortion;-1;;3;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6032;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,0.23;False;47;FLOAT2;0,-0.06;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-2400,-528;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-2336,304;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;35;-2464,1056;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-2352,1744;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-2368,-192;Inherit;True;Property;_TextureSample3;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;64b64a13914f6614cb0a7492f581388d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;39;-2368,64;Inherit;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;64b64a13914f6614cb0a7492f581388d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;40;-2400,832;Inherit;True;Property;_TextureSample5;Texture Sample 5;4;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;64b64a13914f6614cb0a7492f581388d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;41;-2480,1536;Inherit;True;Property;_TextureSample6;Texture Sample 6;5;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;64b64a13914f6614cb0a7492f581388d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode;37;-704,672;Inherit;True;Property;_Cadre_Tex;Cadre_Tex;14;0;Create;True;0;0;0;False;0;False;61ac4bb5c5276264580c988b076dcd09;64b64a13914f6614cb0a7492f581388d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-480,960;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-1472,-592;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;9a2e1e543103aaa44a58c847f43f3ab5;9a2e1e543103aaa44a58c847f43f3ab5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-2048,-480;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2016,912;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2016,1728;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-336,672;Inherit;True;Property;_TextureSample7;Texture Sample 7;1;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.DynamicAppendNode;63;-576,-416;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2016,288;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1552,272;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-32,-176;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;320,-32;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;51;544,-64;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;73;-277.8261,-623.3734;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;75;-229.8261,-463.3734;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;69;752,-80;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-5.826111,-607.3734;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;64;928,32;Inherit;False;Alpha Split;-1;;4;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.SamplerNode;71;144,-608;Inherit;True;Property;_TextureSample2;Texture Sample 2;16;0;Create;True;0;0;0;False;0;False;-1;9257a0e62aa991d4f89193231efdd048;9257a0e62aa991d4f89193231efdd048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;65;1072,-80;Inherit;False;Alpha Merge;-1;;5;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1280,-80;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;SH_Canvas;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;8;1;4;1
WireConnection;9;0;7;1
WireConnection;10;0;5;2
WireConnection;11;1;6;2
WireConnection;57;0;56;0
WireConnection;12;0;8;0
WireConnection;13;1;4;1
WireConnection;14;0;9;0
WireConnection;15;0;7;1
WireConnection;16;0;10;0
WireConnection;17;0;5;2
WireConnection;18;0;11;0
WireConnection;19;1;6;2
WireConnection;62;0;57;0
WireConnection;20;0;13;0
WireConnection;20;1;12;0
WireConnection;21;0;15;0
WireConnection;21;1;14;0
WireConnection;22;0;19;0
WireConnection;22;1;18;0
WireConnection;23;0;17;0
WireConnection;23;1;16;0
WireConnection;60;0;62;0
WireConnection;60;1;61;0
WireConnection;33;0;21;0
WireConnection;33;1;28;0
WireConnection;33;2;27;0
WireConnection;34;0;20;0
WireConnection;34;1;24;0
WireConnection;34;2;29;0
WireConnection;35;0;23;0
WireConnection;35;1;25;0
WireConnection;35;2;30;0
WireConnection;36;0;22;0
WireConnection;36;1;26;0
WireConnection;36;2;31;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;46;1;32;0
WireConnection;42;0;33;0
WireConnection;42;1;38;1
WireConnection;44;0;40;1
WireConnection;44;1;35;0
WireConnection;45;0;41;1
WireConnection;45;1;36;0
WireConnection;47;0;37;0
WireConnection;47;1;59;0
WireConnection;63;0;46;5
WireConnection;63;3;46;1
WireConnection;43;0;39;1
WireConnection;43;1;34;0
WireConnection;48;0;42;0
WireConnection;48;1;43;0
WireConnection;48;2;44;0
WireConnection;48;3;45;0
WireConnection;49;0;63;0
WireConnection;49;1;47;1
WireConnection;50;0;48;0
WireConnection;50;1;49;0
WireConnection;51;0;50;0
WireConnection;69;0;51;0
WireConnection;74;0;73;0
WireConnection;74;1;75;0
WireConnection;64;2;69;0
WireConnection;71;1;74;0
WireConnection;65;2;71;5
WireConnection;65;3;64;6
WireConnection;0;1;65;0
ASEEND*/
//CHKSM=908FCFD3EAF8C7B92019F7B5A9AEB1EFFD572569