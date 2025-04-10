// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Camera_Cadre"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample7("Texture Sample 7", 2D) = "white" {}
		_TextureSample3("Texture Sample 2", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_G_Line_Mask("G_Line_Mask", Range( 0 , 1)) = 0.12
		_D_Line_Mask("D_Line_Mask", Range( 0 , 1)) = 0
		_B_Line_Mask("B_Line_Mask", Range( 0 , 1)) = 0
		_H_Line_Mask("H_Line_Mask", Range( 0 , 1)) = 0
		_G_Dégrade("G_Dégrade", Range( 0 , 1)) = 0.3
		_D_Dégrade("D_Dégrade", Range( 0 , 1)) = 0.3
		_B_Dégrade("B_Dégrade", Range( 0 , 1)) = 0.27
		_H_Dégrade("H_Dégrade", Range( 0 , 1)) = 0.24
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

			

			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6011;
			sampler2D _TextureSample7;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float4 _TextureSample7_ST;
			float _G_Line_Mask;
			float _G_Dégrade;
			float _D_Line_Mask;
			float _D_Dégrade;
			float _B_Line_Mask;
			float _B_Dégrade;
			float _H_Line_Mask;
			float _H_Dégrade;
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

				float2 texCoord79 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _G_Line_Mask , _G_Dégrade , ( ( texCoord79.x - -0.12 ) * step( ( texCoord79.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.texCoord0.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.texCoord0.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord91 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult92 = smoothstep( _D_Line_Mask , _D_Dégrade , ( ( 0.99 - texCoord91.x ) * step( ( -0.29 - texCoord91.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.texCoord0.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord96 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult102 = smoothstep( _B_Line_Mask , _B_Dégrade , ( ( texCoord96.y - 0.02 ) * step( ( texCoord96.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.texCoord0.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord104 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult109 = smoothstep( _H_Line_Mask , _H_Dégrade , ( ( 0.97 - texCoord104.y ) * step( ( -0.29 - texCoord104.y ) , 0.15 ) ));
				float2 temp_output_1_0_g1 = float2( 1,1 );
				float2 texCoord80_g1 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g1 = (float2(( (temp_output_1_0_g1).x * texCoord80_g1.x ) , ( texCoord80_g1.y * (temp_output_1_0_g1).y )));
				float2 temp_output_11_0_g1 = float2( 0,0 );
				float2 texCoord81_g1 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g1 = ( ( (temp_output_11_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g1);
				float2 panner19_g1 = ( ( _TimeParameters.x * (temp_output_11_0_g1).y ) * float2( 0,1 ) + texCoord81_g1);
				float2 appendResult24_g1 = (float2((panner18_g1).x , (panner19_g1).y));
				float2 temp_output_47_0_g1 = float2( 0,-0.06 );
				float2 texCoord78_g1 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g1 = ( texCoord78_g1 - float2( 1,1 ) );
				float2 appendResult39_g1 = (float2(frac( ( atan2( (temp_output_31_0_g1).x , (temp_output_31_0_g1).y ) / TWO_PI ) ) , length( temp_output_31_0_g1 )));
				float2 panner54_g1 = ( ( (temp_output_47_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g1);
				float2 panner55_g1 = ( ( _TimeParameters.x * (temp_output_47_0_g1).y ) * float2( 0,1 ) + appendResult39_g1);
				float2 appendResult58_g1 = (float2((panner54_g1).x , (panner55_g1).y));
				float2 uv_TextureSample7 = IN.texCoord0.xy * _TextureSample7_ST.xy + _TextureSample7_ST.zw;
				
				float4 Color = saturate( ( ( ( smoothstepResult78 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult92 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult102 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult109 ) ) + ( tex2D( _TextureSample1, ( ( (tex2D( _Sampler6011, ( appendResult10_g1 + appendResult24_g1 ) )).rg * 1.0 ) + ( float2( -1.36,0.35 ) * appendResult58_g1 ) ) ) * tex2D( _TextureSample7, uv_TextureSample7 ).r ) ) );

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

			

			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6011;
			sampler2D _TextureSample7;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float4 _TextureSample7_ST;
			float _G_Line_Mask;
			float _G_Dégrade;
			float _D_Line_Mask;
			float _D_Dégrade;
			float _B_Line_Mask;
			float _B_Dégrade;
			float _H_Line_Mask;
			float _H_Dégrade;
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

				float2 texCoord79 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _G_Line_Mask , _G_Dégrade , ( ( texCoord79.x - -0.12 ) * step( ( texCoord79.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.texCoord0.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.texCoord0.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord91 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult92 = smoothstep( _D_Line_Mask , _D_Dégrade , ( ( 0.99 - texCoord91.x ) * step( ( -0.29 - texCoord91.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.texCoord0.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord96 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult102 = smoothstep( _B_Line_Mask , _B_Dégrade , ( ( texCoord96.y - 0.02 ) * step( ( texCoord96.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.texCoord0.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord104 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult109 = smoothstep( _H_Line_Mask , _H_Dégrade , ( ( 0.97 - texCoord104.y ) * step( ( -0.29 - texCoord104.y ) , 0.15 ) ));
				float2 temp_output_1_0_g1 = float2( 1,1 );
				float2 texCoord80_g1 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g1 = (float2(( (temp_output_1_0_g1).x * texCoord80_g1.x ) , ( texCoord80_g1.y * (temp_output_1_0_g1).y )));
				float2 temp_output_11_0_g1 = float2( 0,0 );
				float2 texCoord81_g1 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g1 = ( ( (temp_output_11_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g1);
				float2 panner19_g1 = ( ( _TimeParameters.x * (temp_output_11_0_g1).y ) * float2( 0,1 ) + texCoord81_g1);
				float2 appendResult24_g1 = (float2((panner18_g1).x , (panner19_g1).y));
				float2 temp_output_47_0_g1 = float2( 0,-0.06 );
				float2 texCoord78_g1 = IN.texCoord0.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g1 = ( texCoord78_g1 - float2( 1,1 ) );
				float2 appendResult39_g1 = (float2(frac( ( atan2( (temp_output_31_0_g1).x , (temp_output_31_0_g1).y ) / TWO_PI ) ) , length( temp_output_31_0_g1 )));
				float2 panner54_g1 = ( ( (temp_output_47_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g1);
				float2 panner55_g1 = ( ( _TimeParameters.x * (temp_output_47_0_g1).y ) * float2( 0,1 ) + appendResult39_g1);
				float2 appendResult58_g1 = (float2((panner54_g1).x , (panner55_g1).y));
				float2 uv_TextureSample7 = IN.texCoord0.xy * _TextureSample7_ST.xy + _TextureSample7_ST.zw;
				
				float4 Color = saturate( ( ( ( smoothstepResult78 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult92 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult102 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult109 ) ) + ( tex2D( _TextureSample1, ( ( (tex2D( _Sampler6011, ( appendResult10_g1 + appendResult24_g1 ) )).rg * 1.0 ) + ( float2( -1.36,0.35 ) * appendResult58_g1 ) ) ) * tex2D( _TextureSample7, uv_TextureSample7 ).r ) ) );

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

			

			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6011;
			sampler2D _TextureSample7;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float4 _TextureSample7_ST;
			float _G_Line_Mask;
			float _G_Dégrade;
			float _D_Line_Mask;
			float _D_Dégrade;
			float _B_Line_Mask;
			float _B_Dégrade;
			float _H_Line_Mask;
			float _H_Dégrade;
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
				float2 texCoord79 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _G_Line_Mask , _G_Dégrade , ( ( texCoord79.x - -0.12 ) * step( ( texCoord79.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.ase_texcoord.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.ase_texcoord.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord91 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult92 = smoothstep( _D_Line_Mask , _D_Dégrade , ( ( 0.99 - texCoord91.x ) * step( ( -0.29 - texCoord91.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.ase_texcoord.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord96 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult102 = smoothstep( _B_Line_Mask , _B_Dégrade , ( ( texCoord96.y - 0.02 ) * step( ( texCoord96.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.ase_texcoord.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord104 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult109 = smoothstep( _H_Line_Mask , _H_Dégrade , ( ( 0.97 - texCoord104.y ) * step( ( -0.29 - texCoord104.y ) , 0.15 ) ));
				float2 temp_output_1_0_g1 = float2( 1,1 );
				float2 texCoord80_g1 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g1 = (float2(( (temp_output_1_0_g1).x * texCoord80_g1.x ) , ( texCoord80_g1.y * (temp_output_1_0_g1).y )));
				float2 temp_output_11_0_g1 = float2( 0,0 );
				float2 texCoord81_g1 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g1 = ( ( (temp_output_11_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g1);
				float2 panner19_g1 = ( ( _TimeParameters.x * (temp_output_11_0_g1).y ) * float2( 0,1 ) + texCoord81_g1);
				float2 appendResult24_g1 = (float2((panner18_g1).x , (panner19_g1).y));
				float2 temp_output_47_0_g1 = float2( 0,-0.06 );
				float2 texCoord78_g1 = IN.ase_texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g1 = ( texCoord78_g1 - float2( 1,1 ) );
				float2 appendResult39_g1 = (float2(frac( ( atan2( (temp_output_31_0_g1).x , (temp_output_31_0_g1).y ) / TWO_PI ) ) , length( temp_output_31_0_g1 )));
				float2 panner54_g1 = ( ( (temp_output_47_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g1);
				float2 panner55_g1 = ( ( _TimeParameters.x * (temp_output_47_0_g1).y ) * float2( 0,1 ) + appendResult39_g1);
				float2 appendResult58_g1 = (float2((panner54_g1).x , (panner55_g1).y));
				float2 uv_TextureSample7 = IN.ase_texcoord.xy * _TextureSample7_ST.xy + _TextureSample7_ST.zw;
				
				float4 Color = saturate( ( ( ( smoothstepResult78 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult92 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult102 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult109 ) ) + ( tex2D( _TextureSample1, ( ( (tex2D( _Sampler6011, ( appendResult10_g1 + appendResult24_g1 ) )).rg * 1.0 ) + ( float2( -1.36,0.35 ) * appendResult58_g1 ) ) ) * tex2D( _TextureSample7, uv_TextureSample7 ).r ) ) );

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

        	

			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			sampler2D _TextureSample1;
			sampler2D _Sampler6011;
			sampler2D _TextureSample7;
			CBUFFER_START( UnityPerMaterial )
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float4 _TextureSample7_ST;
			float _G_Line_Mask;
			float _G_Dégrade;
			float _D_Line_Mask;
			float _D_Dégrade;
			float _B_Line_Mask;
			float _B_Dégrade;
			float _H_Line_Mask;
			float _H_Dégrade;
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
				float2 texCoord79 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _G_Line_Mask , _G_Dégrade , ( ( texCoord79.x - -0.12 ) * step( ( texCoord79.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.ase_texcoord.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.ase_texcoord.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord91 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult92 = smoothstep( _D_Line_Mask , _D_Dégrade , ( ( 0.99 - texCoord91.x ) * step( ( -0.29 - texCoord91.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.ase_texcoord.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord96 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult102 = smoothstep( _B_Line_Mask , _B_Dégrade , ( ( texCoord96.y - 0.02 ) * step( ( texCoord96.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.ase_texcoord.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord104 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult109 = smoothstep( _H_Line_Mask , _H_Dégrade , ( ( 0.97 - texCoord104.y ) * step( ( -0.29 - texCoord104.y ) , 0.15 ) ));
				float2 temp_output_1_0_g1 = float2( 1,1 );
				float2 texCoord80_g1 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult10_g1 = (float2(( (temp_output_1_0_g1).x * texCoord80_g1.x ) , ( texCoord80_g1.y * (temp_output_1_0_g1).y )));
				float2 temp_output_11_0_g1 = float2( 0,0 );
				float2 texCoord81_g1 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner18_g1 = ( ( (temp_output_11_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + texCoord81_g1);
				float2 panner19_g1 = ( ( _TimeParameters.x * (temp_output_11_0_g1).y ) * float2( 0,1 ) + texCoord81_g1);
				float2 appendResult24_g1 = (float2((panner18_g1).x , (panner19_g1).y));
				float2 temp_output_47_0_g1 = float2( 0,-0.06 );
				float2 texCoord78_g1 = IN.ase_texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_31_0_g1 = ( texCoord78_g1 - float2( 1,1 ) );
				float2 appendResult39_g1 = (float2(frac( ( atan2( (temp_output_31_0_g1).x , (temp_output_31_0_g1).y ) / TWO_PI ) ) , length( temp_output_31_0_g1 )));
				float2 panner54_g1 = ( ( (temp_output_47_0_g1).x * _TimeParameters.x ) * float2( 1,0 ) + appendResult39_g1);
				float2 panner55_g1 = ( ( _TimeParameters.x * (temp_output_47_0_g1).y ) * float2( 0,1 ) + appendResult39_g1);
				float2 appendResult58_g1 = (float2((panner54_g1).x , (panner55_g1).y));
				float2 uv_TextureSample7 = IN.ase_texcoord.xy * _TextureSample7_ST.xy + _TextureSample7_ST.zw;
				
				float4 Color = saturate( ( ( ( smoothstepResult78 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult92 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult102 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult109 ) ) + ( tex2D( _TextureSample1, ( ( (tex2D( _Sampler6011, ( appendResult10_g1 + appendResult24_g1 ) )).rg * 1.0 ) + ( float2( -1.36,0.35 ) * appendResult58_g1 ) ) ) * tex2D( _TextureSample7, uv_TextureSample7 ).r ) ) );
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-3184,768;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-3328,1504;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-3184,2208;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-3312,-160;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-2848,832;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-2960,-128;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;1.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;-2976,1536;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;1.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;-2832,2240;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;1.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;89;-2592,736;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;86;-2832,576;Inherit;True;2;0;FLOAT;0.99;False;1;FLOAT;0.07;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;83;-2720,-192;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;80;-2960,-352;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;-0.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;95;-2736,1472;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;100;-2976,1312;Inherit;True;2;0;FLOAT;1.09;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;103;-2592,2176;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;-2832,2016;Inherit;True;2;0;FLOAT;0.97;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2352,592;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2480,-336;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-2352,2032;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-2496,1328;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-2496,-96;Inherit;False;Property;_G_Line_Mask;G_Line_Mask;6;0;Create;True;0;0;0;False;0;False;0.12;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-2400,864;Inherit;False;Property;_D_Line_Mask;D_Line_Mask;7;0;Create;True;0;0;0;False;0;False;0;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2512,1584;Inherit;False;Property;_B_Line_Mask;B_Line_Mask;8;0;Create;True;0;0;0;False;0;False;0;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-2320,2320;Inherit;False;Property;_H_Line_Mask;H_Line_Mask;9;0;Create;True;0;0;0;False;0;False;0;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-2496,0;Inherit;False;Property;_G_Dégrade;G_Dégrade;10;0;Create;True;0;0;0;False;0;False;0.3;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2368,992;Inherit;False;Property;_D_Dégrade;D_Dégrade;11;0;Create;True;0;0;0;False;0;False;0.3;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2464,1680;Inherit;False;Property;_B_Dégrade;B_Dégrade;12;0;Create;True;0;0;0;False;0;False;0.27;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-2304,2416;Inherit;False;Property;_H_Dégrade;H_Dégrade;13;0;Create;True;0;0;0;False;0;False;0.24;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-1664,-688;Inherit;False;RadialUVDistortion;-1;;1;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6011;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;-1.36,0.35;False;47;FLOAT2;0,-0.06;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;78;-2112,-240;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;92;-2048,592;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;102;-2176,1344;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;109;-2064,2032;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-2080,96;Inherit;True;Property;_TextureSample3;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;94;-2080,352;Inherit;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;98;-2112,1120;Inherit;True;Property;_TextureSample5;Texture Sample 5;4;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;110;-2192,1824;Inherit;True;Property;_TextureSample6;Texture Sample 6;5;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1760,-192;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1728,576;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1728,1200;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1728,2016;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-1184,-304;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;317b2cf63fb0ae146ae58fd3af61f4c3;317b2cf63fb0ae146ae58fd3af61f4c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;51;-1008,832;Inherit;True;Property;_TextureSample7;Texture Sample 7;1;0;Create;True;0;0;0;False;0;False;-1;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1264,560;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-608,720;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;122;-5328,-128;Inherit;False;1182;1648;Exemple;12;15;17;16;20;18;48;49;50;46;47;24;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-224,288;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;22;64,256;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-5184,752;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;17;-4896,752;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;16;-4624,752;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;-4384,544;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.14;False;2;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;18;-4416,768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.23;False;2;FLOAT;-0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;48;-4704,1264;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;49;-4432,1248;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.23;False;2;FLOAT;-0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;-4432,992;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.14;False;2;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-5264,1264;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;47;-4976,1264;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;24;-4608,0;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.1;False;2;FLOAT;0.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;14;-4960,-80;Inherit;True;0;0;1;0;1;True;4;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;26;448,48;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;27;448,48;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;28;448,48;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;25;416,224;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;Camera_Cadre;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;88;1;91;1
WireConnection;82;0;79;1
WireConnection;99;0;96;2
WireConnection;106;1;104;2
WireConnection;89;0;88;0
WireConnection;86;1;91;1
WireConnection;83;0;82;0
WireConnection;80;0;79;1
WireConnection;95;0;99;0
WireConnection;100;0;96;2
WireConnection;103;0;106;0
WireConnection;107;1;104;2
WireConnection;87;0;86;0
WireConnection;87;1;89;0
WireConnection;81;0;80;0
WireConnection;81;1;83;0
WireConnection;108;0;107;0
WireConnection;108;1;103;0
WireConnection;101;0;100;0
WireConnection;101;1;95;0
WireConnection;78;0;81;0
WireConnection;78;1;114;0
WireConnection;78;2;115;0
WireConnection;92;0;87;0
WireConnection;92;1;117;0
WireConnection;92;2;116;0
WireConnection;102;0;101;0
WireConnection;102;1;118;0
WireConnection;102;2;119;0
WireConnection;109;0;108;0
WireConnection;109;1;121;0
WireConnection;109;2;120;0
WireConnection;85;0;78;0
WireConnection;85;1;77;1
WireConnection;93;0;94;1
WireConnection;93;1;92;0
WireConnection;97;0;98;1
WireConnection;97;1;102;0
WireConnection;105;0;110;1
WireConnection;105;1;109;0
WireConnection;29;1;11;0
WireConnection;112;0;85;0
WireConnection;112;1;93;0
WireConnection;112;2;97;0
WireConnection;112;3;105;0
WireConnection;19;0;29;0
WireConnection;19;1;51;1
WireConnection;21;0;112;0
WireConnection;21;1;19;0
WireConnection;22;0;21;0
WireConnection;17;0;15;0
WireConnection;16;0;17;0
WireConnection;16;1;17;0
WireConnection;20;0;16;0
WireConnection;18;0;16;0
WireConnection;48;0;47;0
WireConnection;48;1;47;0
WireConnection;49;0;48;0
WireConnection;50;0;48;0
WireConnection;47;0;46;0
WireConnection;24;0;14;0
WireConnection;25;1;22;0
ASEEND*/
//CHKSM=E51F201D98488F905A32272DEEAF296FB66CCDB1